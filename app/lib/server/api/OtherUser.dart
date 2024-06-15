import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/OtherUser.dart';

class OtherUserService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<String> saveUser(OtherUser user, String profileUser) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/contacts'),
      body: jsonEncode(user.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'id': profileUser,
      },
    );

    if (response.statusCode == 201) {
      // Successfully added the contact
      return jsonDecode(response.body)['message'];
    } else if (response.statusCode == 400) {
      // Contact already exists
      return jsonDecode(response.body)['message'];
    } else {
      // Handle other status codes or unexpected errors
      throw Exception('Failed to save user: ${response.reasonPhrase}');
    }
  }

  Future<String> getUser(String profileUser) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/contacts'),
      headers: {
        'Content-Type': 'application/json',
        'id': profileUser,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        return 'No users found';
      }

      List<OtherUser> users = data.map((user) {
        return OtherUser(
          name: user['name'] ?? '',
          userId: user['contact_id'] ?? '',
          image: user['profile_picture'] ?? '',
          bio: user['bio'] ?? '',
        );
      }).toList();

      await OtherUser.saveList(users);
      return 'success';
    } else if (response.statusCode == 404) {
      return 'New User';
    } else {
      // Handle other status codes or unexpected errors
      throw Exception('Failed to get users: ${response.reasonPhrase}');
    }
  }
}
