import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;
  final String? errorText;

  const CustomDropdownField({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    required this.items,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              hint: Text(label, style: TextStyle(color: Colors.grey.shade500)),
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.blueAccent,
              ),
              onChanged: onChanged,
              items: items,
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
