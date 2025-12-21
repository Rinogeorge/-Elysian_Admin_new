import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?   ',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Log in',
            style: TextStyle(
              color: Color(0xFF4A7FD9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
