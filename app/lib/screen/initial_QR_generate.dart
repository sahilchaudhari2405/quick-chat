import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import '../model/profile.dart';
import 'User_profile.dart';

class InitialQRGenerator extends StatefulWidget {
  final String qrData;
  final String name;
  final bool initpage;

  InitialQRGenerator({
    required this.qrData,
    required this.name,
    required this.initpage,
  });

  @override
  State<InitialQRGenerator> createState() => _InitialQRGeneratorState();
}

class _InitialQRGeneratorState extends State<InitialQRGenerator> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveQrCode() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await screenshotController.captureAndSave(
      directory.path,
      fileName: 'QR_code.png',
    );
    if (imagePath != null) {
      final result = await ImageGallerySaver.saveFile(imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['isSuccess']
              ? 'QR Code Saved!'
              : 'Failed to save QR Code'),
        ),
      );
    }
  }

  void navigateToProfilePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => init_profile(
          info: profileData(
            User_id: widget.name,
            email: widget.qrData,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    double scanAreaSize = mq.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
        actions: [
          IconButton(
            onPressed: saveQrCode,
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.qrData != null)
              Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: PrettyQr(
                    data: widget.qrData!,
                    size: scanAreaSize,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                  ),
                ),
              ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    colors: [Colors.red, Colors.blue],
                  ).createShader(rect);
                },
                child: FadeInUp(
                  child: Text(
                    "Hi ${widget.name}",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.030),
            Visibility(
              visible: widget.initpage,
              child: InkWell(
                onTap: navigateToProfilePage,
                child: Container(
                  height: 50,
                  width: mq.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(143, 148, 251, 1),
                        Color.fromRGBO(143, 148, 251, 0.6),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
