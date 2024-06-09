import 'package:app/main.dart';
import 'package:app/model/messageModel.dart';
import 'package:flutter/material.dart';

class Ownsmscard extends StatefulWidget {
  Ownsmscard({required this.message,required this.time});
  Messagemodel message;
  String time;
  @override
  State<Ownsmscard> createState() => _OwnsmscardState();
}

class _OwnsmscardState extends State<Ownsmscard> {
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
                child: Text(
                  widget.message.message,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      widget.time,
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
