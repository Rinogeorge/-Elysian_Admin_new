import 'package:elysian_admin/presentation/screens/sign_up/widgets/sign_up.dart';
import 'package:flutter/material.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?   ",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          },
          child: const Text(
            'Sign up',
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
