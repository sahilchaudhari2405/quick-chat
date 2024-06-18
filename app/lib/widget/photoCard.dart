import 'dart:io';

import '../main.dart';
import '../model/messageModel.dart';
import 'package:flutter/material.dart';

class Photocard extends StatelessWidget {
  Photocard({
    required this.message,
    required this.time,
    required this.file,
  });
  Messagemodel message;
  File file;
  String time;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: mq.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: Color(0xFFDCF8C6),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 60, top: 5, bottom: 20, left: 10),
                child: Column(
                  children: [
                    Container(
                      child: Image.file(file),
                    ),
                    Visibility(
                      visible: message.message.isNotEmpty,
                      child: Text(
                        message.message,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
