import 'package:elysian_admin/core/utils/validators.dart';
import 'package:elysian_admin/features/auth/logic/bloc/login/login_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/login/login_event.dart';
import 'package:elysian_admin/features/auth/logic/bloc/login/login_state.dart';
import 'package:elysian_admin/presentation/screens/profile/profile.dart';
import 'package:elysian_admin/presentation/screens/login/Divider_with_text.dart';
import 'package:elysian_admin/presentation/screens/login/widget/email_inputfield.dart';
import 'package:elysian_admin/presentation/screens/login/widget/forgot_password_link.dart';
import 'package:elysian_admin/presentation/screens/login/widget/logo_selection.dart';
import 'package:elysian_admin/presentation/screens/login/widget/password_inputfield.dart';
import 'package:elysian_admin/presentation/screens/login/widget/sign_in_button.dart';
import 'package:elysian_admin/presentation/screens/login/widget/sign_up_prompt.dart';
import 'package:elysian_admin/presentation/screens/login/widget/subtitle_text.dart';
import 'package:elysian_admin/presentation/screens/login/widget/topindicator.dart';
import 'package:elysian_admin/presentation/screens/login/widget/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        } else if (state is LoginFailure) {
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
                  const TopIndicator(),
                  const SizedBox(height: 40),
                  const LogoSection(),
                  const SizedBox(height: 40),
                  const WelcomeText(),
                  const SizedBox(height: 8),
                  const SubtitleText(),
                  const SizedBox(height: 40),
                  EmailInputField(controller: emailController),
                  const SizedBox(height: 16),
                  PasswordInputField(controller: passwordController),
                  const SizedBox(height: 8),
                  const ForgotPasswordLink(),
                  const SizedBox(height: 32),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return SignInButton(
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          // Validate inputs
                          final validationErrors = Validators.validateLogin(
                            email: email,
                            password: password,
                          );

                          // Check if there are any validation errors
                          final emailError = validationErrors['email'];
                          final passwordError = validationErrors['password'];

                          if (emailError != null || passwordError != null) {
                            // Show first error found
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  emailError ??
                                      passwordError ??
                                      'Please fix the errors',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // If validation passes, proceed with login
                          context.read<LoginBloc>().add(
                            LoginSubmitted(email: email, password: password),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const SignUpPrompt(),
                  const SizedBox(height: 24),
                  const DividerWithText(),
                  const SizedBox(height: 24),

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
