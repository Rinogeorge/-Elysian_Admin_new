import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.black38,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}