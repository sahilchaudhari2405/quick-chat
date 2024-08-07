import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService_auth {
  
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> register(String userId, String password, String email) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/signup'),
      body:
          jsonEncode({'user_id': userId, 'password': password, 'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print('success');
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> UpdateUser(String userId, String email) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/signup'),
      body: jsonEncode({'user_id': userId, 'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print('success');
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> login(String userId, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/login'),
      body: jsonEncode({'user_id': userId, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('successful login');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> handleDeviceLogin(
      String userId, String deviceId, String deviceType) async {
    final url = Uri.parse('http://10.0.2.2:3000/device');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'device_id': deviceId,
        'type': deviceType,
      }),
    );

    if (response.statusCode != 200) {
      final responseBody = jsonDecode(response.body);
      throw Exception('Error: ${responseBody['message']}');
    } else if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody['accessToken'];
      final refreshToken = responseBody['refreshToken'];

      // Store tokens
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);
    }
  }
}
