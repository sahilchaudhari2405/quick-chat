import 'dart:convert';

import 'package:app/model/profile.dart';
import 'package:http/http.dart' as http;

class GetProfile {
  Future<void> getProfile(String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/profile/$id'),
      );
      print(id);
      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> responseData = json.decode(response.body);
        Profile profile = Profile(
            userId: responseData['user_id'],
            name: responseData['name'],
            email: responseData['email'],
            image: responseData['profile_picture'],
            bio: responseData['bio'],
            isactive: responseData['is_active']);
        await profile.save();
        print(profile.toJson());
      } else {
        print('Failed to get profile: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error getting profile: $error');
      return null;
    }
  }
}
