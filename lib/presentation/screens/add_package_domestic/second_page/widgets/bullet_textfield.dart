import 'package:flutter/material.dart';

class BulletTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onRemove;

  const BulletTextField({
    super.key,
    this.hintText,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 8),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLines: null,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              if (value.endsWith('\n')) {
                if (onSubmitted != null) {
                  final newValue = value.replaceAll('\n', '');
                  controller?.text = newValue;
                  controller?.selection = TextSelection.fromPosition(
                    TextPosition(offset: newValue.length),
                  );
                  onSubmitted!(newValue);
                }
              } else {
                onChanged?.call(value);
              }
            },
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 16,
          ),
      ],
    );
  }
}
