import '../../model/profile.dart';
import '../../server/api/_api_services_auth.dart';
import 'package:quickalert/quickalert.dart';
import '../initial_QR_generate.dart';

import '../../main.dart';
import 'login.dart';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  String _message = '';
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ApiService_auth _apiService = ApiService_auth();
  Future<void> _handleSignup() async {
    final String userId = _userIdController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;

    try {
      await _apiService.register(userId, password, email);
      setState(() {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'User',
          text: 'user created successful',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InitialQRGenerator(
                  qrData: _emailController.text,
                  name: _userIdController.text,
                ),
              ),
            );
          },
        );
      });
    } catch (e) {
      setState(() {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'User',
          text: 'user not created $e',
          confirmBtnColor: Colors.red,
        );
        print(e);
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
                  height: mq.height * .40,
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => login_screen(),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: mq.height * .02),
                                child: Center(
                                  child: Text(
                                    "SignUp",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .055),
                  child: Column(
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
                                          hintText: "User Name",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  duration: Duration(milliseconds: 1900),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color.fromRGBO(
                                                    143, 148, 251, 1)))),
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ),
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
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  duration: Duration(milliseconds: 1900),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Re-enter Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: GestureDetector(
                          onTap: () {
                            _handleSignup();
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
                                "SignUp",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                  "Already have an account? ",
                                  style: TextStyle(
                                      color: Color.fromARGB(193, 46, 46, 46),
                                      fontWeight: FontWeight.bold),
                                )),
                            FadeInRight(
                                duration: Duration(milliseconds: 2500),
                                child: Text(
                                  "SignIn",
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1)),
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
