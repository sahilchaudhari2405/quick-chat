import 'package:camera/camera.dart';

import 'screen/splash_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

late bool them = false;
late Size mq;
late String mode;
List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  final storage = new FlutterSecureStorage();
  final RefreshToken = await storage.read(key: 'refreshToken');
  runApp(MyApp(token: (RefreshToken != null) ? RefreshToken : ''));
}

class MyApp extends StatelessWidget {
  final token;
  MyApp({required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: (them) ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(token: token),
    );
  }
}
