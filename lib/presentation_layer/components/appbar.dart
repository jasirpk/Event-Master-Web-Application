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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            'assets/images/Screenshot 2024-05-22 205021.png',
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.1,
            fit: BoxFit.contain,
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
