import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiktok_clone/const/constants.dart';
import 'package:tiktok_clone/view/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmPage extends StatefulWidget {
  final String videoPath;
  final File videoFile;
  const ConfirmPage(
      {Key? key, required this.videoPath, required this.videoFile})
      : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile);
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: VideoPlayer(controller),
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          controller: mediaController.songController,
                          labelText: "Song Name",
                          icon: Icons.music_note,
                          isObscure: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          controller: mediaController.captionController,
                          labelText: "Caption",
                          icon: Icons.closed_caption,
                          isObscure: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          mediaController.uploadVideo(
                              mediaController.songController.text,
                              mediaController.captionController.text,
                              widget.videoPath);
                        },
                        child: const Text(
                          'Share!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
    );
  }
}
