import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
          ),
          child: Center(
            child: Image.asset(
              'assets/elysian_logo.png',
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Elysian',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A7FD9),
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}