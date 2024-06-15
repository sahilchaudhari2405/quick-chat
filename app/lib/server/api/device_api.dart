import '../../model/device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<Map<String, String>> getDeviceInfo(BuildContext context) async {
    String deviceType;
    String deviceId;
    Device _device;
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceType = 'android';
        deviceId = androidInfo.id;
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceType = 'iphone';
        deviceId = iosInfo.name;
      } else if (Theme.of(context).platform == TargetPlatform.macOS) {
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceType = 'macbook';
        deviceId = macOsInfo.computerName;
      } else if (Theme.of(context).platform == TargetPlatform.windows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceType = 'windows';
        deviceId = windowsInfo.deviceId;
      } else {
        // Assuming web is also supported
        deviceType = 'website';
        deviceId = 'web-${DateTime.now().millisecondsSinceEpoch}';
      }
      _device = Device(deviceId: deviceId, type: deviceType);
      await _device.save();
      return {'deviceType': deviceType, 'deviceId': deviceId};
    } catch (e) {
      throw Exception('Failed to get device info: $e');
    }
  }
}
