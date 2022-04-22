import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';

class CustomIcon extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 30,
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          width: 38,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(250, 45, 108, 1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          width: 38,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(32, 211, 234, 0.98),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const Center(
          child:  Icon(Icons.add,color: backgroundColor,size: 20,),
        )
      ]),
    );
  }
}
