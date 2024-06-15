import 'dart:convert';
import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import '../model/ChatModel.dart';
import '../model/profile.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../main.dart';
import 'auth/login.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class init_profile extends StatefulWidget {
  init_profile({
    required this.info,
  });

  final profileData info;

  @override
  State<init_profile> createState() => _init_profileState();
}

class _init_profileState extends State<init_profile> {
  File? _image;
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.info.name);
    _bioController = TextEditingController(text: widget.info.bio);
  }

  String? _profileImageUrl;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      final editedImageBytes = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(image: imageBytes),
        ),
      );
      if (editedImageBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp_image.png');
        await tempFile.writeAsBytes(editedImageBytes);
        setState(() {
          _image = tempFile;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final uri =
        Uri.parse('http://10.0.2.2:3000/profile/${widget.info.User_id}');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = widget.info.User_id;
    request.fields['email'] = widget.info.email;
    request.fields['user_name'] = _nameController.text;
    request.fields['bio'] = _bioController.text;

    if (_image != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profile_picture', _image!.path));
    }
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final Map<String, dynamic> responseJson = json.decode(responseData.body);
      print('Profile updated: $responseJson');

      setState(() {
        _profileImageUrl = responseJson['profile_picture_url'];
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'User',
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => login_screen()));
          },
          text: 'update data',
          confirmBtnColor: Colors.green,
        );
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'User',
        text: 'user not update data',
        confirmBtnColor: Colors.red,
      );
    }
    // var response = await request.send();
    // if (response.statusCode == 200) {
    //   var responseData = await response.stream.bytesToString();
    //   var jsonResponse = jsonDecode(responseData);
    //   print(jsonResponse);
    //
    // } else {
    //   print('Failed to save profile');
    // }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: mq.height * .30,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 150,
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
                        height: 100,
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
                        height: 100,
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
                                margin: EdgeInsets.only(top: mq.height * .15),
                                child: Center(
                                  child: Text(
                                    "Profile Update",
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
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 0),
                        child: Stack(
                          children: [
                            ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                      width: mq.width * 0.4,
                                      height: mq.width * 0.4,
                                    )
                                  : (_profileImageUrl != null &&
                                          _profileImageUrl!.isNotEmpty)
                                      ? Image.network(
                                          _profileImageUrl!,
                                          fit: BoxFit.cover,
                                          width: mq.width * 0.4,
                                          height: mq.width * 0.4,
                                        )
                                      : Image.asset(
                                          widget.info.icon,
                                          fit: BoxFit.cover,
                                          width: mq.width * 0.4,
                                          height: mq.width * 0.4,
                                        ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: mq.width * .25,
                              child: MaterialButton(
                                color: Colors.white,
                                shape: CircleBorder(),
                                onPressed: () {
                                  _pickImage();
                                },
                                child: Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInRight(
                                  duration: Duration(milliseconds: 1900),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color.fromRGBO(
                                                    143, 148, 251, 1)))),
                                    child: Text(
                                      "ID: ${widget.info.User_id}",
                                      style: TextStyle(fontSize: 20),
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
                                    child: Text(
                                      "Email: ${widget.info.email}",
                                      style: TextStyle(fontSize: 20),
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
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Name",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ),
                                FadeInLeft(
                                  duration: Duration(milliseconds: 1900),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _bioController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Bio",
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
                            _saveProfile();
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
                                "Set Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
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
