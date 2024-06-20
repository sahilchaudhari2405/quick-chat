import 'dart:io';
import 'dart:typed_data';

import 'package:app/model/messageModel.dart';
import 'package:app/screen/chatScreen.dart';
import 'package:app/server/methods/saveImageLocally.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:path_provider/path_provider.dart';

class GallaryViewPicture extends StatefulWidget {
  final List<XFile> images;

  GallaryViewPicture({required this.images, required this.onDataReceived});
  final Function(List<Messagemodel>) onDataReceived;
  @override
  State<GallaryViewPicture> createState() => _GallaryViewPictureState();
}

class _GallaryViewPictureState extends State<GallaryViewPicture> {
  int selectedIndex = 0;
  PageController _pageController = PageController();
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              Icons.crop_rotate,
              size: 27,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.emoji_emotions_outlined,
              size: 27,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.title,
              size: 27,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 27,
            ),
            onPressed: () async {
              File originalFile = File(widget.images[selectedIndex].path);
              File tempFile = originalFile;

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProImageEditor.file(
                    originalFile,
                    callbacks: ProImageEditorCallbacks(
                      onImageEditingComplete: (Uint8List bytes) async {
                        // Save edited bytes to a temporary file
                        File editedFile = await _saveBytesToFile(bytes);
                        setState(() {
                          tempFile = editedFile;
                        });
                        Navigator.pop(context, tempFile);
                      },
                    ),
                  ),
                ),
              );

              if (tempFile != null && tempFile.path != originalFile.path) {
                setState(() {
                  widget.images[selectedIndex] = XFile(tempFile.path);
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Image.file(
                    File(widget.images[index].path),
                    fit: BoxFit.contain,
                    key: ValueKey(widget.images[index].path),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add Caption....",
                    prefixIcon: Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 27,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        List<Messagemodel> data = [];
                        for (XFile it in widget.images) {
                          String path = await ImageStore()
                              .saveImageLocally(File(it.path));
                          data.add(Messagemodel(
                              message: _controller.text,
                              data: path,
                              way: "source",
                              type: 'images',
                              time:
                                  DateTime.now().toString().substring(10, 16)));
                        }
                        setState(() {
                          widget.onDataReceived(data);
                        });
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _saveBytesToFile(Uint8List bytes) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = 'temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    File tempFile = File('$tempPath/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }
}
