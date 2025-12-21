import 'package:elysian_admin/features/auth/logic/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/login/login_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/profile/profile_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/signup/signup_bloc.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_bloc.dart';
import 'package:elysian_admin/firebase_options.dart';
import 'package:elysian_admin/injection_container.dart' as di;
import 'package:elysian_admin/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const ElysianApp());
}

class ElysianApp extends StatelessWidget {
  const ElysianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginBloc>()),
        BlocProvider(create: (_) => di.sl<SignupBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
        BlocProvider(create: (_) => di.sl<ForgotPasswordBloc>()),
        BlocProvider(create: (_) => di.sl<CategoryBloc>()),
      ],
      child: MaterialApp(
        title: 'Elysian_Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
        home: const SplashScreen(),
      ),
    );
  }
}
