import '../server/methods/logout.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../main.dart';
import 'home.dart';
import 'welcome.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key, required this.token});
  final String token;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(Duration(milliseconds: 1500));

    if (widget.token.isNotEmpty && !JwtDecoder.isExpired(widget.token)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => mainpage(),
        ),
      );
    } else {
      if (widget.token.isNotEmpty && JwtDecoder.isExpired(widget.token)) {
        // Perform the logout operation if the token is expired
        await _logout();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        ),
      );
    }
  }

  Future<void> _logout() async {
    Logout logout = Logout();
    await logout.logout();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
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
    );
  }
}
