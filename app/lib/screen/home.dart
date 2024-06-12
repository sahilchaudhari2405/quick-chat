import 'dart:io';

import 'package:app/screen/auth/login.dart';
import 'package:app/screen/profile.dart';
import 'package:app/screen/temp/data.dart';
import 'package:app/server/methods/logout.dart';
import 'package:app/widget/ContactUserCard.dart';
import 'package:app/widget/RecentCard.dart';
import 'package:flutter/widgets.dart';
import 'scan_code_page.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class mainpage extends StatefulWidget {
  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  File? _image;

  Future<void> _pickImage(ImageSource source, bool option) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          title: Text(
            "chats",
            style: TextStyle(color: Colors.white),
          ),
          bottomOpacity: 1.0,
          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.qr_code_scanner),
              onSelected: (value) {
                // Handle menu actions here
                if (value == 'camara') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ScanCodePage()));
                } else if (value == 'Gallery') {
                  setState(() {});
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Gallery', 'camara'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase(),
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                // Handle menu actions here
                if (value == 'settings') {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Profile_Info()));
                    ;
                  });
                } else if (value == 'logout') {
                  // await storage.deleteAll();
                  await Logout().logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => login_screen()));
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Settings', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase(),
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.chat_sharp,
                color: Colors.white,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.contacts_sharp,
                color: Colors.white,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
            )
          ]),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: chatData.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    RecentCard(
                      contact: chatData[index],
                      UserInfo: chatData[0],
                    ),
                    Divider(
                      indent: mq.width * .03,
                      endIndent: mq.width * .03,
                    ),
                  ],
                );
              },
            ),
            ListView.builder(
              itemCount: 20,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ContactUserCard(
                      contact: chatData[index],
                      UserInfo: chatData[0],
                    ),
                    Divider(
                      indent: mq.width * .02,
                      endIndent: mq.width * .02,
                    ),
                  ],
                );
              },
            ),
            Container(
              color: Colors.amber,
            )
          ],
        ),
      ),
    );
  }
}
