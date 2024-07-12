import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    required this.screenHeight,
    required this.suggestText,
    required this.text,
    required this.size,
  });

  final double screenHeight;
  final String suggestText;
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
          text: suggestText,
          style: TextStyle(
            color: Colors.white70,
            letterSpacing: 1,
            fontSize: screenHeight * 0.024,
          ),
        ),
        TextSpan(text: ' '),
        TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontSize: size,
          ),
        )
      ])),
    );
  }
}
