import 'dart:io';
import 'dart:math';

import 'package:app/model/OtherUser.dart';
import 'package:app/model/profile.dart';

import 'package:app/screen/auth/login.dart';

import 'package:app/screen/initial_QR_generate.dart';
import 'package:app/screen/profile.dart';
import 'package:app/screen/search_screen.dart';
import 'package:app/screen/temp/data.dart';
import 'package:app/server/methods/logout.dart';
import 'package:app/widget/ContactUserCard.dart';
import 'package:app/widget/RecentCard.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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

  final MobileScannerController controller = MobileScannerController(
      // required options for the scanner
      );
  // Future<void> _pickImage(ImageSource source, bool option) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //     if (pickedFile != null) {
  //       final File imageFile = File(pickedFile.path);

  //       final barcode =
  //           await MobileScannerPlatform.instance.analyzeImage(imageFile!.path);

  //       String? result;
  //       setState(() {
  //         result = barcode.raw;
  //       });
  //     }
  //   }
  // }
  void initState() {
    super.initState();
    profileInfo();
    listOfContact();
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
          builder: (_) => UserSearchScreen(user_id: user_id),
        ),
      ); // Call your ca
    });
  }

  Future<List<OtherUser>> listOfContact() async {
    return await OtherUser.loadList();
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
                //     context, MaterialPageRoute(builder: (_) => QRScanScreen()));
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

  Future<void> QR() async {
    await profileInfo();
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              InitialQRGenerator(qrData: user_id, name: name, initpage: false),
        ),
      );
    });
  }

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
            FutureBuilder<List<OtherUser>>(
              future: listOfContact(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ContactUserCard(
                            contact: chatData[index],
                            UserInfo: chatData[0],
                            user_info: snapshot.data![index],
                          ),
                          Divider(
                            indent: mq.width * .02,
                            endIndent: mq.width * .02,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            CircularProgressIndicator()
          ],
        ),
        floatingActionButton: AddUserButton(
          scan: ScanQR,
          QR: QR,
          search: search,
        ),
      ),
    );
  }
}

class AddUserButton extends StatelessWidget {
  AddUserButton({
    Key? key,
    required this.scan,
    required this.search,
    required this.QR,
  }) : super(key: key);

  final Function scan;
  final Function QR;
  final Function search;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.list_view,
      animatedIconTheme: IconThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 255, 163, 163),
      overlayColor: const Color.fromARGB(92, 0, 0, 0),
      overlayOpacity: 0.4,
      spaceBetweenChildren: 12,
      gradientBoxShape: BoxShape.circle,
      onOpen: () {},
      children: [
        SpeedDialChild(
          onTap: () => search(),
          child: Icon(Icons.search),
          backgroundColor: Colors.white,
          label: 'Search',
        ),
        SpeedDialChild(
          onTap: () => scan(),
          child: Icon(Icons.qr_code_scanner),
          backgroundColor: const Color.fromARGB(255, 255, 163, 163),
          label: 'Scan',
        ),
        SpeedDialChild(
          onTap: () => QR(),
          child: Icon(Icons.qr_code),
          backgroundColor: Colors.white,
          label: 'QR',
        ),
      ],
    );
  }
}
