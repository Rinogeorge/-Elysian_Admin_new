import 'package:flutter/material.dart';

class InclusionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const InclusionItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
