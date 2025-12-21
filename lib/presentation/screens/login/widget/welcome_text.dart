import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Hello there!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}