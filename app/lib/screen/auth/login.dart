import 'package:app/server/api/OtherUser.dart';

import '../../main.dart';
import '../../model/ChatModel.dart';
import '../../model/device.dart';
import 'signup.dart';
import '../temp/data.dart';
import '../../server/api/_api_services_auth.dart';
import '../../server/api/device_api.dart';
import '../../server/api/get_profile.dart';
import '../../server/methods/login_function.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../home.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class login_screen extends StatefulWidget {
  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService_auth _apiService = ApiService_auth();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  String _deviceType = '';
  String _deviceId = '';
  String _message = '';
  final login_check_data_input check_data = login_check_data_input();
  GetProfile? getProfile;
  @override
  Future<void> _fetchDeviceInfo() async {
    try {
      final deviceInfo = await _deviceInfoService.getDeviceInfo(context);
      setState(() async {
        _deviceType = deviceInfo['deviceType']!;
        _deviceId = deviceInfo['deviceId']!;
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to get device info: $e';
      });
    }
  }

  Future<void> getdata(String id) async {
    final GetProfile getProfile = GetProfile();
    await getProfile.getProfile(id);
  }

Future<void> _handleLogin() async {
  final String userId = _userIdController.text;
  final String password = _passwordController.text;
  try {
    await _fetchDeviceInfo();
    await _apiService.login(userId, password);

    print(userId);
    await _apiService.handleDeviceLogin(userId, _deviceId, _deviceType);
    await getdata(userId);
    
    String getUserResponse = await OtherUserService().getUser(userId);
    
    setState(() {
      if (getUserResponse == 'success' ||getUserResponse == 'New User'  ) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'User',
          text: 'Login Successful',
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => mainpage(),
              ),
            );
          },
          confirmBtnColor: Colors.green,
        );
      } 
    });
  } catch (e) {
    setState(() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'User',
        text: 'Login failed: ${e.toString()}',
        confirmBtnColor: Colors.red,
      );
    });
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1300),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                FadeInLeft(
                                  duration: Duration(milliseconds: 1900),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color.fromRGBO(
                                                    143, 148, 251, 1)))),
                                    child: TextFormField(
                                      controller: _userIdController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email or user_name",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  duration: Duration(milliseconds: 1900),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInRight(
                          duration: Duration(milliseconds: 1900),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: GestureDetector(
                            onTap: () {
                              _handleLogin();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ])),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FadeInLeft(
                                duration: Duration(milliseconds: 2000),
                                child: Text(
                                  "Don't have a account? ",
                                  style: TextStyle(
                                      color: Color.fromARGB(193, 46, 46, 46),
                                      fontWeight: FontWeight.bold),
                                )),
                            FadeInRight(
                                duration: Duration(milliseconds: 2500),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Signup(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "SignUp",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(143, 148, 251, 1)),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
