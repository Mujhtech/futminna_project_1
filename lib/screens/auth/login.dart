import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/extension/screen.dart';
import 'package:futminna_project_1/repositories/connectivity.dart';
import 'package:futminna_project_1/screens/auth/register.dart';
import 'package:futminna_project_1/screens/home.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final auth = ref.watch(authControllerProvider);
      final connect = ref.watch(connectivityController);
      return WillPopScope(
        onWillPop: () async => !auth.loading,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      if (auth.loading) {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Text(
                      'Don’t have an account?',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Commons.primaryColor),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign In',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Welcome, sign in to continue',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (String? e) {
                            RegExp regex = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                            if (e!.isEmpty) {
                              return 'Email Address Field is required';
                            } else if (!regex.hasMatch(e)) {
                              return 'Email address is not valid';
                            }
                            return null;
                          },
                          controller: email,
                          cursorColor: Commons.primaryColor,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            enabledBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            focusedBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            focusedErrorBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            hintText: 'Email Address',
                            hintStyle:
                                const TextStyle(color: Color(0xFFAAAAAA)),
                            errorBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.red),
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            filled: true,
                          ),
                          autocorrect: false,
                          autofocus: false,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (p) {
                            if (p!.isEmpty) {
                              return 'Password Field is required';
                            }
                            return null;
                          },
                          controller: password,
                          cursorColor: Commons.primaryColor,
                          keyboardType: TextInputType.visiblePassword,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            enabledBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            focusedBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            focusedErrorBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            hintText: 'Password',
                            hintStyle:
                                const TextStyle(color: Color(0xFFAAAAAA)),
                            errorBorder:
                                Theme.of(context).inputDecorationTheme.border,
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.red),
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            filled: true,
                          ),
                          autocorrect: false,
                          autofocus: false,
                          obscureText: true,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                if (auth.loading)
                  const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Commons.primaryColor)),
                    ),
                  )
                else
                  Column(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (!connect.connectivityStatus) {
                            const snackBar = SnackBar(
                                content: Text('No internet connection'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (!await auth.signIn(
                              email.text.trim(), password.text.trim())) {
                            final snackBar =
                                SnackBar(content: Text(auth.error!));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false);
                        },
                        elevation: 0,
                        color: Commons.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: context.screenWidth(1),
                          height: 53,
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Commons.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          )),
        ),
      );
    });
  }
}
