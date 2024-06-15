import 'dart:io';

import 'package:app/model/profile.dart';
import 'package:app/screen/initial_QR_generate.dart';
import 'package:app/screen/search_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth/login.dart';
import 'profile.dart';
import 'temp/data.dart';
import '../server/methods/logout.dart';
import '../widget/ContactUserCard.dart';
import '../widget/RecentCard.dart';
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

// <<<<<<< Updated upstream
//   Future<void> _pickImage(ImageSource source, bool option) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//   final MobileScannerController controller = MobileScannerController(
//       // required options for the scanner
//       );
//   // Future<void> _pickImage(ImageSource source, bool option) async {
//   //   final pickedFile = await ImagePicker().pickImage(source: source);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //     });
//   //     if (pickedFile != null) {
//   //       final File imageFile = File(pickedFile.path);

//   //       final barcode =
//   //           await MobileScannerPlatform.instance.analyzeImage(imageFile!.path);

//   //       String? result;
//   //       setState(() {
//   //         result = barcode.raw;
//   //       });
//   //     }
//   //   }
//   // }
  void initState() {
    super.initState();
    profileInfo();
  }

  String user_id = '';
  String name = '';
  Future<void> profileInfo() async {
    final storage = FlutterSecureStorage();
    final _profileData = await storage.read(key: 'profile');
    if (_profileData != null) {
      setState(
        () {
          Profile info = Profile.fromJson(_profileData);
          user_id = info.userId;
          name = info.name;
        },
      );
    }
  }

  void search() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserSearchScreen(
            user_id: user_id,
          ),
        ),
      ); // Call your ca
    });
  }

  void showCustomAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                color: Colors.green,
                size: 70,
              ),
              SizedBox(width: 10),
              Text(
                'Scan QR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Select an option to scan',
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanCodePage(),
                  ),
                ); // Call your camera function
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => ()));
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> QR() async {
  //   setState(() {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => InitialQRGenerator(
  //           qrData: user_id,
  //           name: name,
  //            false,
  //         ),
  //       ),
  //     );
  //   });
  // }

  void ScanQR() {
    showCustomAlertDialog(context);
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
