import 'package:elysian_admin/features/auth/logic/bloc/bottom_navigation/bloc/botton_nav_bloc.dart';
import 'package:elysian_admin/presentation/screens/profile/profile.dart';
import 'package:elysian_admin/presentation/screens/login/login.dart';
import 'package:elysian_admin/presentation/widgets/bottom_navigation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is authenticated, go to home
        if (snapshot.hasData && snapshot.data != null) {
          return MainNavigationScreen(bloc: NavigationBloc());
        }

        // If user is not authenticated, go to login
        return const LoginScreen();
      },
    );
  }
}
