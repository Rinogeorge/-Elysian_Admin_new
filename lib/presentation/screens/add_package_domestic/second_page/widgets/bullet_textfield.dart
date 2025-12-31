import 'package:flutter/material.dart';

class BulletTextField extends StatefulWidget {
  final String? hintText;
  final String? value;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onRemove;

  const BulletTextField({
    super.key,
    this.hintText,
    this.value,
    this.onSubmitted,
    this.onChanged,
    this.onRemove,
  });

  @override
  State<BulletTextField> createState() => _BulletTextFieldState();
}

class _BulletTextFieldState extends State<BulletTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant BulletTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            controller: _controller,
            maxLines: null,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              if (value.endsWith('\n')) {
                if (widget.onSubmitted != null) {
                  final newValue = value.replaceAll('\n', '');
                  _controller.text = newValue;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: newValue.length),
                  );
                  widget.onSubmitted!(newValue);
                }
              } else {
                widget.onChanged?.call(value);
              }
            },
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        if (widget.onRemove != null)
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 16,
          ),
      ],
    );
  }
}
