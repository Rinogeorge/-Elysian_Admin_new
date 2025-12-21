import 'package:elysian_admin/presentation/screens/forgot_password/forgot_password.dart';

import 'package:flutter/material.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            ),
          );
        },
        child: const Text(
          'Forget Password?',
          style: TextStyle(color: Color(0xFF4A7FD9), fontSize: 14),
        ),
      ),
    );
  }
}
