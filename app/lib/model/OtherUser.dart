import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtherUser {
  String userId;
  String name;
  String image;
  String bio;

  OtherUser({
    required this.userId,
    required this.name,
    required this.image,
    required this.bio,
  });

  // Serialize profile object to JSON string
  String toJson() {
    return json.encode({
      'user_id': userId,
      'name': name,
      'profile_picture': image,
      'bio': bio,
    });
  }

  // Deserialize JSON string to profile object
  factory OtherUser.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return OtherUser(
      userId: data['user_id'],
      name: data['name'],
      image: data['profile_picture'],
      bio: data['bio'],
    );
  }

  // Save profile to secure storage
  Future<void> save() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'UserContacts', value: toJson());
  }

  // Read profile from secure storage
  static Future<OtherUser?> load() async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'UserContacts');
    if (jsonString != null) {
      return OtherUser.fromJson(jsonString);
    }
    return null;
  }

  Future<void> updateField(String key, String value) async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'UserContacts');
    if (jsonString != null) {
      Map<String, dynamic> data = json.decode(jsonString);
      data[key] = value;
      await storage.write(key: 'UserContacts', value: json.encode(data));
    }
  }
}
