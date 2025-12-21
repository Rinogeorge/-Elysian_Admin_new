import 'package:flutter/material.dart';

class CategoryInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  final String? errorText;

  const CategoryInputSection({
    super.key,
    required this.controller,
    required this.onAdd,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border:
                errorText != null
                    ? Border.all(color: Colors.red, width: 1)
                    : null,
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter Category name',
              hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF90EE90),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Add',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
