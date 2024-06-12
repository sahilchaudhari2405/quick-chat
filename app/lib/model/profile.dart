import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile {
  String userId;
  String name;
  String email;
  String image;
  String bio;
  bool isactive;
  Profile({
    required this.userId,
    required this.name,
    required this.email,
    required this.image,
    required this.bio,
    required this.isactive,
  });

  // Serialize profile object to JSON string
  String toJson() {
    return json.encode({
      'user_id': userId,
      'name': name,
      'email': email,
      'profile_picture': image,
      'bio': bio,
      'isactive': isactive,
    });
  }

  // Deserialize JSON string to profile object
  factory Profile.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return Profile(
      userId: data['user_id'],
      name: data['name'],
      email: data['email'],
      image: data['profile_picture'],
      bio: data['bio'],
      isactive: data['isactive'],
    );
  }

  // Save profile to secure storage
  Future<void> save() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'profile', value: toJson());
  }

  // Read profile from secure storage
  static Future<Profile?> load() async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'profile');
    if (jsonString != null) {
      return Profile.fromJson(jsonString);
    }
    return null;
  }

  Future<void> updateField(String key, String value) async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'profile');
    if (jsonString != null) {
      Map<String, dynamic> data = json.decode(jsonString);
      data[key] = value;
      await storage.write(key: 'profile', value: json.encode(data));
    }
  }
}

class profileData {
  String User_id;
  String name;
  String email;
  String icon;
  String bio;
  profileData({
    required this.User_id,
    this.name = '',
    required this.email,
    this.icon = 'assets/images/google.png',
    this.bio = 'busy',
  });
}
