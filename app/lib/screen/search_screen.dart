import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import 'package:app/model/OtherUser.dart'; // Assuming OtherUser.dart is defined in this path

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<OtherUser> _results = [];
  bool isLoaded = false;
  late Size mq;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/user/search/$query'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _results = data
            .map((user) => OtherUser(
                  name: user['name'], // Access 'name' from user map
                  userId: user['user_id'], // Access 'userId' from user map
                  image:
                      user['profile_picture'], // Access 'image' from user map
                  bio: user['bio'], // Access 'bio' from user map
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _showUserDetailsModal(OtherUser user) {
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
                  backgroundImage:
                      NetworkImage('http://10.0.2.2:3000${user.image}'),
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
                        // Handle connect action
                        Navigator.pop(context); // Close the modal
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent),
                      onPressed: () {
                        Navigator.pop(context);
                        // Close the modal
                      },
                      child: Text('Connect',
                          style: TextStyle(color: Colors.white)),
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
                    _searchUsers(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _controller.clear();
                        _searchUsers('');
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
