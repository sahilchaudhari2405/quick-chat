import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfoService {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<Map<String, String>> getDeviceInfo(BuildContext context) async {
    String deviceType;
    String deviceId;

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceType = 'android';
        deviceId = androidInfo.id;
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceType = 'iphone';
        deviceId = iosInfo.identifierForVendor!;
      } else if (Theme.of(context).platform == TargetPlatform.macOS) {
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceType = 'macbook';
        deviceId = macOsInfo.systemGUID!;
      } else if (Theme.of(context).platform == TargetPlatform.windows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceType = 'windows';
        deviceId = windowsInfo.deviceId;
      } else {
        // Assuming web is also supported
        deviceType = 'website';
        deviceId = 'web-${DateTime.now().millisecondsSinceEpoch}';
      }

      return {'deviceType': deviceType, 'deviceId': deviceId};
    } catch (e) {
      throw Exception('Failed to get device info: $e');
    }
  }
}
