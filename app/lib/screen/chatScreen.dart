import 'package:app/main.dart';
import 'package:app/model/ChatModel.dart';
import 'package:app/model/messageModel.dart';
import 'package:app/widget/ownSmsCard.dart';
import 'package:app/widget/replySmsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  ChatPage({required this.contact, required this.UserInfo});
  ChatModel contact;
  ChatModel UserInfo;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  IO.Socket? socket;
  List<Messagemodel> messages = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool changeBotton = false;
  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();

    socket!.on('connect', (data) {
      socket!.on("message", (msg) {
        setMessage(
          "destination",
          msg["message"],
        );
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });

    // socket!.on('chat message', (msg) {
    //   setState(() {
    //     messages.add(msg);
    //   });
    // });
    socket!.emit('SignIn', widget.UserInfo.id);
    socket!.on('disconnect', (_) => print('disconnected'));
  }

  void sendMessage(String message, int s, int targetId) {
    setMessage("source", message);
    socket!.emit(
        'message', {"message": message, "SourceId": s, "targetId": targetId});
  }

  void setMessage(String type, String Message) {
    Messagemodel messagemodel = Messagemodel(
        type: type,
        message: Message,
        time: DateTime.now().toString().substring(10, 16));
    setState(() {
      messages.add(messagemodel);
    });
  }

  @override
  void dispose() {
    socket!.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          "assets/images/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Color.fromRGBO(143, 148, 251, 1),
              leadingWidth: 80,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    SizedBox(
                      width: mq.width * .01,
                    ),
                    CircleAvatar(
                      radius: mq.height * .025, // Adjust the radius as needed
                      backgroundImage: AssetImage('assets/images/image.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contact.name,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.contact.status,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: Icon(Icons.call), onPressed: () {}),
                PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("View Contact"),
                        value: "View Contact",
                      ),
                      PopupMenuItem(
                        child: Text("Media, links, and docs"),
                        value: "Media, links, and docs",
                      ),
                      PopupMenuItem(
                        child: Text("Whatsapp Web"),
                        value: "Whatsapp Web",
                      ),
                      PopupMenuItem(
                        child: Text("Search"),
                        value: "Search",
                      ),
                      PopupMenuItem(
                        child: Text("Mute Notification"),
                        value: "Mute Notification",
                      ),
                      PopupMenuItem(
                        child: Text("Wallpaper"),
                        value: "Wallpaper",
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Container(
            height: mq.height,
            width: mq.width,
            child: Column(
              children: [
                Expanded(
                  // height: mq.height - 140,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      if (messages.length == index) {
                        return SizedBox(
                          height: 60,
                        );
                      }
                      if (messages[index].type == "source") {
                        return Ownsmscard(
                            message: messages[index],
                            time: messages[index].time);
                      } else {
                        return Replysmscard(
                          message: messages[index],
                          time: messages[index].time,
                        );
                      }
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Row(
                        children: [
                          Container(
                            width: mq.width - 60,
                            child: Card(
                              margin:
                                  EdgeInsets.only(left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.length > 0) {
                                    setState(() {
                                      changeBotton = true;
                                    });
                                  } else {
                                    setState(() {
                                      changeBotton = false;
                                    });
                                  }
                                },
                                controller: _controller,
                                focusNode: _focusNode,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type a Message",
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.emoji_emotions),
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.attach_file),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.camera_alt),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: 8, right: 5, left: 2),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF128C7E),
                              radius: 25,
                              child: (changeBotton)
                                  ? IconButton(
                                      onPressed: () {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeOut);
                                        sendMessage(
                                            _controller.text,
                                            widget.UserInfo.id,
                                            widget.contact.id);
                                        _controller.clear();
                                        _focusNode.requestFocus();
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ))
                                  : IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
