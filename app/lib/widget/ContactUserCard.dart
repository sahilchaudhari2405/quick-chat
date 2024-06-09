import 'package:app/model/ChatModel.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screen/chatScreen.dart';

class ContactUserCard extends StatelessWidget {
  ContactUserCard({required this.contact, required this.UserInfo});
  ChatModel contact;
  ChatModel UserInfo;
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
          backgroundImage: AssetImage('assets/images/aai.JPG'),
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          contact.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Expanded(
          child: Text(contact.currentMessage,
              maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true),
        ),
      ),
    );
  }
}
