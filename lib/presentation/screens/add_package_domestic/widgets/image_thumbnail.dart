import 'package:flutter/material.dart';

class ImageThumbnail extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const ImageThumbnail({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: NetworkImage('https://via.placeholder.com/80x60'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}