import 'package:event_master_web/common/style.dart';
import 'package:flutter/material.dart';

class AuthBottomText extends StatelessWidget {
  final VoidCallback onpressed;
  final String text;
  final String subText;
  const AuthBottomText(
      {super.key,
      required this.onpressed,
      required this.text,
      required this.subText});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 16, fontFamily: 'JacquesFracois'),
        ),
        SizedBox(width: 4),
        InkWell(
          onTap: onpressed,
          child: Text(
            subText,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.022,
                color: myColor,
                fontFamily: 'JacquesFracois'),
          ),
        ),
      ],
    );
  }
}
