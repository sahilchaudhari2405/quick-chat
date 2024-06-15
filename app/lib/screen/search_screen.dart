import 'dart:ui';

import 'package:app/screen/chatScreen.dart';
import 'package:app/screen/temp/data.dart';
import 'package:app/widget/ContactUserCard.dart';

import '../server/api/OtherUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import '../model/OtherUser.dart'; // Assuming OtherUser.dart is defined in this path

class UserSearchScreen extends StatefulWidget {
  final String user_id;

  UserSearchScreen({required this.user_id});

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<OtherUser> _results = [];
  bool isLoaded = false;
  late Size mq;
  OtherUserService _otherUserService = OtherUserService();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future<void> _searchUsers(String query, String currentUserId) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/search'),
        headers: {
          'name': query,
          'id': currentUserId,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<OtherUser> users = data
            .map((user) => OtherUser(
                  name: user['name'] ?? '',
                  userId: user['user_id'] ?? '',
                  image: user['profile_picture'] ?? '',
                  bio: user['bio'] ?? '',
                ))
            .toList();

        setState(() {
          _results = users;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _results.clear();
        });
      }
    } catch (e) {
      print('Error searching users: $e');
      // Handle error
    }
  }

  Future<void> _ConnectWithUser(OtherUser user) async {
    List<OtherUser> loadedList = await OtherUser.loadList();
    for (int i = 0; i < loadedList.length; i++) {
      print(loadedList[i].toJson());
    }
    String response = await _otherUserService.saveUser(user, widget.user_id);
    print(loadedList.length);
    print(response);
  }

  Future<void> _showUserDetailsModal(OtherUser user) async {
    final isExist = await OtherUser.addUser(user);
    String buttonLeft = 'Cancel';
    String buttonRight = 'Connect';

    if (isExist) {
      buttonRight = 'Chat';
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.image != null
                      ? NetworkImage('http://10.0.2.2:3000${user.image}')
                      : AssetImage('assets/images/image.png') as ImageProvider,
                ),
                SizedBox(height: 20),
                Text(
                  user.userId,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 10),
                Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                      },
                      child: Text(
                        buttonLeft,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent),
                      onPressed: () {
                        if (!isExist) {
                          _ConnectWithUser(user);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatPage(
                                contact: chatData[0],
                                UserInfo: chatData[0],
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        buttonRight,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Shimmer Loader",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Container(
                child: TextField(
                  onChanged: (value) {
                    _searchUsers(value, widget.user_id);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _controller.clear();
                        _searchUsers('', widget.user_id);
                      },
                    ),
                  ),
                  controller: _controller,
                ),
              ),
              (_results != null && isLoaded)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final myUser = _results[index];
                        return GestureDetector(
                          onTap: () {
                            _showUserDetailsModal(myUser);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: mq.height * .01, horizontal: 10),
                            child: getDataItems(myUser),
                          ),
                        );
                      },
                    )
                  : myShimmerLoader(),
            ],
          ),
        ],
      ),
    );
  }

  Widget getDataItems(OtherUser myUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('http://10.0.2.2:3000${myUser.image}'),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              myUser.userId,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(myUser.name, style: TextStyle(fontWeight: FontWeight.w300)),
          ],
        )
      ],
    );
  }

  Widget myShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(height: 20, color: Colors.white),
                SizedBox(height: 10),
                Container(height: 15, width: 80, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }
}
