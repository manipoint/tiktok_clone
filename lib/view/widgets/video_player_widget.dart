import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        
      });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: backgroundColor),
      child: VideoPlayer(videoPlayerController),
    );
  }
}
