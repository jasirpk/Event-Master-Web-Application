import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  const AppBarWidget(
      {super.key, required this.onPressed, required this.buttonText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: AppBar(
        leading: ClipOval(
          child: Image.asset(
            'assets/images/Screenshot 2024-05-22 205021.png',
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          'Event Master',
          style: TextStyle(
            fontFamily: 'JacquesFracois',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.teal),
            ),
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
