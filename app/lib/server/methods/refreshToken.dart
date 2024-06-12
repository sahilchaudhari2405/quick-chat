import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Refreshtoken {
  Future<bool> refreshAccessToken() async {
    try {
      final storage = FlutterSecureStorage();
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/refreshToken'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['accessToken'];
        await storage.write(key: 'accessToken', value: accessToken);
        return true;
      } else {
        print('Failed to refresh access token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error refreshing access token: ${e.toString()}');
      return false;
    }
  }
}
