import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String peerUid;
  final String peerAvatar;
  final String peerName;

  const ChatPage({
    Key? key,
    required this.peerUid,
    required this.peerAvatar,
    required this.peerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Chat page")),
    );
  }
}
