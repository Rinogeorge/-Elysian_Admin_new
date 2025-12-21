import 'package:elysian_admin/core/utils/validators.dart';
import 'package:elysian_admin/features/auth/logic/bloc/signup/signup_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/signup/signup_event.dart';
import 'package:elysian_admin/features/auth/logic/bloc/signup/signup_state.dart';
import 'package:elysian_admin/presentation/screens/profile/profile.dart';
import 'package:elysian_admin/presentation/screens/login/Divider_with_text.dart';
import 'package:elysian_admin/presentation/screens/login/widget/email_inputfield.dart';
import 'package:elysian_admin/presentation/screens/login/widget/logo_selection.dart';
import 'package:elysian_admin/presentation/screens/login/widget/password_inputfield.dart';
import 'package:elysian_admin/presentation/screens/login/widget/sign_in_button.dart';
import 'package:elysian_admin/presentation/screens/sign_up/widgets/login_prompt.dart';
import 'package:elysian_admin/presentation/screens/sign_up/widgets/name_input_field.dart';
import 'package:elysian_admin/presentation/screens/sign_up/widgets/signup_header_text.dart';
import 'package:elysian_admin/presentation/screens/sign_up/widgets/signup_subtitle_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        } else if (state is SignupFailure) {
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
                children: [
                  const SizedBox(height: 40),
                  const LogoSection(),
                  const SizedBox(height: 32),
                  const SignUpHeaderText(),
                  const SizedBox(height: 8),
                  const SignUpSubtitleText(),
                  const SizedBox(height: 32),
                  NameInputField(controller: nameController),
                  const SizedBox(height: 16),
                  EmailInputField(controller: emailController),
                  const SizedBox(height: 16),
                  PasswordInputField(controller: passwordController),
                  const SizedBox(height: 20),

                  const SizedBox(height: 24),
                  BlocBuilder<SignupBloc, SignupState>(
                    builder: (context, state) {
                      return SignInButton(
                        isLoading: state is SignupLoading,
                        onPressed: () {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          // Validate inputs
                          final validationErrors = Validators.validateSignup(
                            name: name,
                            email: email,
                            password: password,
                          );

                          // Check if there are any validation errors
                          final nameError = validationErrors['name'];
                          final emailError = validationErrors['email'];
                          final passwordError = validationErrors['password'];

                          if (nameError != null ||
                              emailError != null ||
                              passwordError != null) {
                            // Show first error found
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  nameError ??
                                      emailError ??
                                      passwordError ??
                                      'Please fix the errors',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // If validation passes, proceed with signup
                          context.read<SignupBloc>().add(
                            SignupSubmitted(
                              name: name,
                              email: email,
                              password: password,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const LoginPrompt(),
                  const SizedBox(height: 20),
                  const DividerWithText(),
                  const SizedBox(height: 20),

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
