import 'screen/splash_screen.dart';

import 'package:flutter/material.dart';

late bool them = false;
late Size mq;
late String mode;
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: (them) ? ThemeData.dark() : ThemeData.light(),
      home: splash_screen(),
    );
  }
}
