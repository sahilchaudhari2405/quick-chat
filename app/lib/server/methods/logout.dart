import 'dart:convert';

import '../../model/device.dart';
import '../../model/profile.dart';
import '../api/device_api.dart';
import 'refreshToken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Logout {
  Future<void> logout() async {
    final storage = FlutterSecureStorage();
    Profile? profile = await Profile.load();

    final accessToken = await storage.read(key: 'accessToken');
    final _DeviceData = await storage.read(key: 'device');
    final _ProfileData = await storage.read(key: 'profile');
    Device _device = Device.fromJson(_DeviceData!);
    Profile _profile = Profile.fromJson(_ProfileData!);
    print(_device.deviceId);
    Refreshtoken _refreshtoken = Refreshtoken();
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:3000/logout'),
      body: jsonEncode({
        'user_id': _profile.userId,
        'device_id': _device.deviceId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'accessToken': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      await storage.deleteAll(); //tor
      print('User logged out successfully');
    } else if (response.statusCode == 401) {
      final token = await _refreshtoken.refreshAccessToken();
      if (token) {
        logout();
      } else {
        print('Failed to refresh token');
      }
    } else {
      print('Failed to logout: ${response.statusCode}');
    }
  }
}
