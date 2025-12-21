import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController? controller;

  const EmailInputField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          // Prevent spaces in email
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: const InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
