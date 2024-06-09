import '../main.dart';
import 'auth/signup.dart';
import 'home.dart';
import 'welcome.dart';
import '../widget/welcome_button.dart';
import 'package:flutter/material.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
      });
    });
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: mq.height * .15,
              width: mq.width * .5,
              right: mq.width * .25,
              child: Image.asset('assets/images/chat.png'),
            ),
            Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                "Chat App ⚡",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: .5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
