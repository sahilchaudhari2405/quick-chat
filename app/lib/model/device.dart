import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Device {
  String deviceId;
  String type;

  Device({
    required this.deviceId,
    required this.type,
  });

  // Serialize device object to JSON string
  String toJson() {
    return json.encode({
      'deviceId': deviceId,
      'type': type,
    });
  }

  // Deserialize JSON string to device object
  factory Device.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return Device(
      deviceId: data['deviceId'],
      type: data['type'],
    );
  }

  // Save device to secure storage
  Future<void> save() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'device', value: toJson());
  }

  // Read device from secure storage
  static Future<Device?> load() async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'device');
    if (jsonString != null) {
      return Device.fromJson(jsonString);
    }
    return null;
  }
}
