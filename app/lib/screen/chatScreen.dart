import 'dart:convert';

import 'package:app/screen/CameraScreen.dart';
import 'package:app/screen/CameraView.dart';
import 'package:app/screen/gallary.dart';
import 'package:app/screen/reciverImage.dart';
import 'package:app/screen/sendimage.dart';
import 'package:app/server/methods/saveImageLocally.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import '../main.dart';
import '../model/ChatModel.dart';
import '../model/messageModel.dart';
import '../widget/ownSmsCard.dart';
import '../widget/replySmsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.contact, required this.UserInfo});
  final ChatModel contact;
  final ChatModel UserInfo;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  IO.Socket? socket;
  File? _image;
  List<Messagemodel> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool changeBotton = false;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  Future<void> SendToServer(List<Messagemodel> datas) async {
    for (Messagemodel pickedFile in datas) {
      String? image = pickedFile.data; // Ensure image path is not null
      if (image != null) {
        sendMessageData(
          pickedFile.message,
          widget.UserInfo.id,
          widget.contact.id,
          image,
          pickedFile.type,
          pickedFile.time,
        );
      } else {
        print('Error: Image path is null for Messagemodel: $pickedFile');
        // Handle the error or skip this message as per your application's logic
      }
    }
  }

  Future<void> _pickImage() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GallaryViewPicture(
            images: selectedImages,
            onDataReceived: SendToServer,
          ),
        ),
      );
    }
  }

  void connectToServer() {
    socket = IO.io('http://10.0.2.2:9000', <String, dynamic>{
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
        setState(() {
          _scrollToBottom();
        });
      });
      socket!.on('messageWithData', (data) {
        // Handle incoming private message
        print('Received message: ${data}');
        // Update UI with new message
        setState(() {
          String message = data["message"];
          String image = data["data"];
          String type = data["type"];
          String time = data["time"];
          handleReceivedData(message, image, type, time);
          _scrollToBottom();
        });
      });
      // socket!.on('messageWithData', (data) {

      // });
    });

    socket!.emit('SignIn', widget.UserInfo.id);
    socket!.on('disconnect', (_) => print('disconnected'));
  }

  void handleReceivedData(
      String message, String data, String type, String time) async {
    try {
      setState(() {
        setMessageData(type, message, data, 'destination', time);
      });
    } catch (e) {
      print('Error decoding base64 and saving file: $e');
    }
  }

  void sendMessage(String message, int sourceId, int targetId) {
    setMessage('source', message);
    socket!.emit(
      'message',
      {"message": message, "SourceId": sourceId, "targetId": targetId},
    );
  }

  void sendMessageData(String message, int sourceId, int targetId, String image,
      String type, String time) {
    setMessageData(type, message, image, "source", time);
    socket!.emit('messageWithData', {
      "message": message,
      "data": image,
      "type": type,
      "time": time,
      "way": "source",
      "SourceId": sourceId,
      "targetId": targetId
    });
  }

  void setMessage(String way, String message) {
    Messagemodel messagemodel = Messagemodel(
      type: 'message',
      message: message,
      time: DateTime.now().toString().substring(10, 16),
      way: way,
    );
    setState(() {
      messages.add(messagemodel);
    });
  }

  void setMessageData(
      String type, String message, String data, String way, String time) {
    Messagemodel messagemodel = Messagemodel(
      type: type,
      message: message,
      data: data,
      time: time,
      way: way,
    );
    setState(() {
      messages.add(messagemodel);
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
    final mq = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(
          "assets/images/whatsapp_Back.png",
          height: mq.height,
          width: mq.width,
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
                      if (messages[index].way == "source") {
                        if (messages[index].type == "images") {
                          return Sendimage(
                            path: messages[index].data,
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        }
                        return Ownsmscard(
                            message: messages[index],
                            time: messages[index].time);
                      } else {
                        if (messages[index].type == "images") {
                          return ReceiverImage(
                            path: messages[index].data,
                            message: messages[index].message,
                            time: messages[index].time,
                          );
                        }
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
                                setState(() {
                                  changeBotton = value.length > 0;
                                });
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
                                      onPressed: _pickImage,
                                      icon: Icon(Icons.attach_file),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CameraScreen(),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.camera_alt),
                                    ),
                                  ],
                                ),
                              ),
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
                                      _scrollToBottom();
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
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
