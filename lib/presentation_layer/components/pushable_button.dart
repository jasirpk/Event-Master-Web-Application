import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';

class pushableButton_Widget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const pushableButton_Widget(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return PushableButton(
      onPressed: onPressed,
      hslColor: HSLColor.fromColor(Colors.teal),
      shadow: BoxShadow(
        color: Colors.tealAccent,
        offset: Offset(0, 4),
        blurRadius: 10,
      ),
      height: 60,
      elevation: 8,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
