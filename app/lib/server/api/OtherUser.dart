import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/OtherUser.dart';

class OtherUserService {
  Future<String> saveUser(OtherUser user, String profileUser) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/user/contacts'),
      body: jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json', 'id': profileUser},
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
}
