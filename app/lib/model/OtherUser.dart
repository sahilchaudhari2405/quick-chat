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

  // Serialize profile object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'profile_picture': image,
      'bio': bio,
    };
  }

  // Deserialize JSON map to profile object
  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      userId: json['user_id'],
      name: json['name'],
      image: json['profile_picture'],
      bio: json['bio'],
    );
  }

  // Save list of profiles to secure storage
  static Future<void> saveList(List<OtherUser> userList) async {
    final storage = FlutterSecureStorage();
    final List<Map<String, dynamic>> userJsonList =
        userList.map((user) => user.toJson()).toList();
    final jsonString = json.encode(userJsonList);
    await storage.write(key: 'UserContacts', value: jsonString);
  }

  // Read list of profiles from secure storage
  static Future<List<OtherUser>> loadList() async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'UserContacts');
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => OtherUser.fromJson(json)).toList();
    }
    return [];
  }

  // Add a user to the list and save it
  static Future<bool> addUser(OtherUser newUser) async {
    List<OtherUser> userList = await loadList();

    if (userList != null && userList.isNotEmpty) {
      bool userExists = userList.any((user) => user.userId == newUser.userId);
      if (userExists) {
        return true;
      }
    }
    userList.add(newUser);

    // Save the updated list
    await saveList(userList);
    return false;
  }

  Future<void> updateField(String key, String value) async {
    final storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: 'UserContacts');
    if (jsonString != null) {
      List<dynamic> jsonList = json.decode(jsonString);
      final index =
          jsonList.indexWhere((userJson) => userJson['user_id'] == this.userId);
      if (index != -1) {
        jsonList[index][key] = value;
        await storage.write(key: 'UserContacts', value: json.encode(jsonList));
      }
    }
  }
}
