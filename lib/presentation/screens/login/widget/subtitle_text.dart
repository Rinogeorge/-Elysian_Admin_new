import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Just a few quick things to get started',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    );
  }
}