import 'dart:typed_data';

import '../main.dart';
import 'package:flutter/material.dart';

class scan_user extends StatefulWidget {
  late Uint8List image;
  late String name;
  scan_user({super.key, required this.image, required this.name});

  @override
  State<scan_user> createState() => _scan_userState();
}

class _scan_userState extends State<scan_user> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.memory(widget.image),
            Text(widget.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                          'Connect',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
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
                          ' Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
