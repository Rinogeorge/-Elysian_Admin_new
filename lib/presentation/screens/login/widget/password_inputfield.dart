import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordInputField extends StatelessWidget {
  final TextEditingController? controller;

  const PasswordInputField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        inputFormatters: [
          // Prevent spaces in password
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.black38,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
