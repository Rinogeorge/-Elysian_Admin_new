import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
