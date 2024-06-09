import 'dart:typed_data';

import 'package:app/model/ChatModel.dart';

import '../main.dart';
import 'auth/login.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  ProfileEditScreen({required this.info});
  ChatModel info;
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _image;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.info.name);
    _bioController = TextEditingController(text: widget.info.currentMessage);
    _emailController = TextEditingController(text: "johndoe@example.com");
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

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
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
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: mq.height * .025),
              TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: mq.height * .025),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: mq.height * .03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(201, 109, 255, 170)),
                  ),
                  onPressed: () {
                    // Handle save action
                    // You can access the values with _nameController.text, _bioController.text, _emailController.text
                  },
                  child: Padding(
                    padding: EdgeInsets.all(mq.height * .02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          ' Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: mq.height * .025),
            child: FloatingActionButton.extended(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                Navigator.pop(context);

                Navigator.pop(context);

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => login_screen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            )));
  }
}
