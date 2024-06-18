import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Sendimage extends StatefulWidget {
  const Sendimage({super.key});

  @override
  State<Sendimage> createState() => _SendimageState();
}

class _SendimageState extends State<Sendimage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Container(
          height: mq.height / 2.6,
          width: mq.width / 1.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green[300]),
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
