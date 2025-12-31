import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final String? errorText;
  final String? value;

  const CustomTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.maxLines = 1,
    this.errorText,
    this.value,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _controller.text) {
      // Only update if the value is different to avoid cursor jumps
      // Note: checking against _controller.text prevents overriding partial typing
      // However, if the external state change truly conflicts with local, local is overwritten
      // Ideally, the external state IS the local state + debouncing
      // For simple forms, assuming the state updates immediately on change:
      // If we typed 'A', bloc has 'A', we get 'A' back. 'A' == 'A', no update.
      // If we are initialized, bloc has 'Name', we have '', update to 'Name'.
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              color:
                  widget.errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              hintText: widget.label,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
