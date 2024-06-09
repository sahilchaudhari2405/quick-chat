import 'package:app/model/ChatModel.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screen/chatScreen.dart';

class RecentCard extends StatefulWidget {
  RecentCard({required this.contact, required this.UserInfo});
  ChatModel contact;
  ChatModel UserInfo;

  @override
  State<RecentCard> createState() => _RecentCardState();
}

class _RecentCardState extends State<RecentCard> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatPage(
                    contact: widget.contact,
                    UserInfo: widget.UserInfo,
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
          widget.contact.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.done_all),
            SizedBox(
              width: mq.width * .01,
            ),
            Expanded(
              child: Text(widget.contact.currentMessage,
                  maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true),
            ),
          ],
        ),
        trailing: Text(widget.contact.time),
      ),
    );
  }
}
