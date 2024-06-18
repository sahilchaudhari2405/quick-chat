import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Reciverimage extends StatefulWidget {
  const Reciverimage({super.key});

  @override
  State<Reciverimage> createState() => _ReciverimageState();
}

class _ReciverimageState extends State<Reciverimage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Container(
          height: mq.height / 2.6,
          width: mq.width / 1.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.grey[400]),
          child: Card(
            margin: EdgeInsets.all(3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }
}
