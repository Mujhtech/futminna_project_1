import 'package:flutter/material.dart';
import 'package:futminna_project_1/controllers/dynamic_link.dart';
import 'package:futminna_project_1/screens/auth/home.dart';
import 'package:futminna_project_1/screens/auth/reset.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DynamicState extends StatelessWidget {
  const DynamicState({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final dy = ref.watch(dynamicLinkProvider);
        if (dy.pendingData != null) {
          if (dy.isPasswordReset()) {
            return const ResetPasswordScreen();
          }
          return Container();
        } else {
          return const AuthHomeScreen();
        }
      },
    );
  }
}
