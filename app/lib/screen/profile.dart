import 'dart:io';
import 'dart:typed_data';
import '../server/methods/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'auth/login.dart';
import 'package:animate_do/animate_do.dart';
import '../model/profile.dart';

class Profile_Info extends StatefulWidget {
  @override
  State<Profile_Info> createState() => _Profile_InfoState();
}

class _Profile_InfoState extends State<Profile_Info> {
  Profile? _profile;
  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool _isEditing = false;
  bool _showLogoutButton = true;
  @override
  void initState() {
    super.initState();
    profileInfo();
  }

  Future<void> profileInfo() async {
    final storage = FlutterSecureStorage();
    final _profileData = await storage.read(key: 'profile');
    if (_profileData != null) {
      setState(() {
        _profile = Profile.fromJson(_profileData);
      });
      print('data: $_profileData');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: (_profile != null)
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: mq.height * .38,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/background.png'),
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
                              bottom: 0,
                              left: mq.width * .3,
                              child: FadeInUp(
                                duration: Duration(milliseconds: 1600),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 0),
                                  child: Stack(
                                    children: [
                                      ClipOval(
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            'http://10.0.2.2:3000${_profile!.image}',
                                            fit: BoxFit.cover,
                                            width: mq.width * 0.4,
                                            height: mq.width * 0.4,
                                          )),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * .055),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                                duration: Duration(milliseconds: 1800),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            "ID: ${_profile!.userId}",
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
                                            "Email: ${_profile!.email}",
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
                                          child: (_isEditing)
                                              ? TextFormField(
                                                  controller: _nameController,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Name",
                                                      hintStyle: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                )
                                              : Text(
                                                  "Name: ${_profile!.name}",
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                          child: (_isEditing)
                                              ? TextFormField(
                                                  controller: _nameController,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Bio",
                                                      hintStyle: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
                                                )
                                              : Text(
                                                  "Bio: ${_profile!.bio}",
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                  setState(() {
                                    _isEditing = !_isEditing;
                                    if (!_isEditing) {
                                      _showLogoutButton = true;
                                    }
                                  });
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
                                      _isEditing ? ' Save' : ' Edit',
                                      style: TextStyle(color: Colors.white),
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
                )
              : CircularProgressIndicator()),
      floatingActionButton: Visibility(
        visible: _showLogoutButton,
        child: Padding(
          padding: EdgeInsets.only(bottom: mq.height * .025),
          child: FloatingActionButton.extended(
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              await Logout().logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => login_screen()));
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ),
    );
  }
}
