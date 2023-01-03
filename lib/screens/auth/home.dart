import 'package:flutter/material.dart';

import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/screens/auth/login.dart';
import 'package:futminna_project_1/screens/home.dart';
import 'package:futminna_project_1/screens/splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthHomeScreen extends StatelessWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final user = ref.watch(authControllerProvider);
        switch (user.status) {
          case Status.unauthenticated:
            return const LoginScreen();
          case Status.authenticating:
            return const SplashScreen();
          case Status.authenticated:
            return const HomeScreen();
          case Status.uninitialized:
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
