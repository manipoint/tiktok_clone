import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';

class AddVideoPage extends StatelessWidget {
  const AddVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => mediaController.selectVideo(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: buttonColor),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
