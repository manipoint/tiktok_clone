import 'package:flutter/material.dart';

class CircleWidget extends StatefulWidget {
  final Widget child;
  const CircleWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    controller.forward();
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: widget.child,
    );
  }
}
