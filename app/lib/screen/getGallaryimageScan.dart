import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String? result;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(onDetect: (value) {
              print(value.raw);
            }),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Text('Result: $result')
                  : Text('Scan a QR code'),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image from Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        final barcode =
            await MobileScannerPlatform.instance.analyzeImage(imageFile.path);
        if (barcode != null) {
          setState(() {
            result = barcode.raw.toString();
          });
        } else {
          setState(() {
            result = 'No QR code found in the image.';
          });
        }
      }
    } catch (e) {
      result = 'Waiting for the barcode module to be downloaded. Please wait.';
    }
  }
}
