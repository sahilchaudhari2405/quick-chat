import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import '../main.dart';
import 'Scan_User.dart';
import 'generate_code_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    double scanAreaSize =
        mq.width * 0.8; // Define a square area with 80% of the screen width

    return Scaffold(
      appBar: AppBar(
        title: FadeInLeft(
            duration: Duration(milliseconds: 1000),
            child: const Text('Scan QR Code')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => GenerateCodePage()));
            },
            icon: FadeInRight(
              duration: Duration(milliseconds: 1200),
              child: Icon(
                Icons.qr_code,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: FadeIn(
          duration: Duration(milliseconds: 1200),
          child: Container(
            width: scanAreaSize,
            height: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                returnImage: true,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;

                if (barcodes.isNotEmpty) {
                  final String barcodeValue =
                      barcodes.first.rawValue ?? 'No value';
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(barcodeValue),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }

                if (image != null && barcodes.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => scan_user(
                              image: image,
                              name: barcodes.first.rawValue!,
                            )),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
