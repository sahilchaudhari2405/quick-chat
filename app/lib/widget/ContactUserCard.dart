import 'package:app/model/OtherUser.dart';

import '../model/ChatModel.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screen/chatScreen.dart';

class ContactUserCard extends StatelessWidget {
  ContactUserCard(
      {required this.contact, required this.UserInfo, required this.user_info});
  ChatModel contact;
  ChatModel UserInfo;
  OtherUser user_info;
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatPage(
                    contact: contact,
                    UserInfo: UserInfo,
                  )),
        );
      },
      child: ListTile(
        minTileHeight: 0,
        leading: CircleAvatar(
          radius: mq.height * .03, // Adjust the radius as needed
          backgroundImage:
              NetworkImage('http://10.0.2.2:3000${user_info.image}'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          user_info.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Expanded(
          child: Text(user_info.bio,
              maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true),
        ),
      ),
    );
  }
}
