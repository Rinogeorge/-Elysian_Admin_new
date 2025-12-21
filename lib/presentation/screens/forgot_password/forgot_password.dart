import 'package:elysian_admin/features/auth/logic/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/forgot_password/forgot_password_event.dart';
import 'package:elysian_admin/features/auth/logic/bloc/forgot_password/forgot_password_state.dart';
import 'package:elysian_admin/presentation/screens/login/widget/sign_in_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        } else if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Back Button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                  const Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  const Text(
                    'Enter your email account to reset your password',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),
                  // Email Input Field with Icon
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black38,
                          size: 20,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Sign In Button (Reset Password)
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      return SignInButton(
                        isLoading: state is ForgotPasswordLoading,
                        onPressed: () {
                          context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordSubmitted(
                              email: emailController.text.trim(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
