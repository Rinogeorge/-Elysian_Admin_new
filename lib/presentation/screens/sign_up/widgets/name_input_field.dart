import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const NameInputField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        validator: validator,
        decoration: const InputDecoration(
          hintText: 'Enter your name',
          hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
