import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/images/logo.png',
          height: 60,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Elysian',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: Color(0xFF4A7FD9),
                fontStyle: FontStyle.italic,
              ),
            );
          },
        ),
      ],
    );
  }
}
