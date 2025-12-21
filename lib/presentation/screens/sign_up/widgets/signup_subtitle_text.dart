import 'package:flutter/material.dart';

class SignUpSubtitleText extends StatelessWidget {
  const SignUpSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Please fill the details and create account',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }
}