import 'package:flutter/material.dart';

class SignUpHeaderText extends StatelessWidget {
  const SignUpHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sign up now',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}