import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/controllers/dynamic_link.dart';
import 'package:futminna_project_1/repositories/share.dart';
import 'package:futminna_project_1/screens/splash.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  final dynamicLink = FirebaseDynamicLinks.instance;

  final dynamicLinkData = await dynamicLink.getInitialLink();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      pendingLinkDataProvider.overrideWithValue(dynamicLinkData)
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(dynamicLinkProvider);
      ref.watch(authControllerProvider);
      return GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Service Finder',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              unselectedWidgetColor: Commons.primaryColor,
              scaffoldBackgroundColor: Colors.white,
              inputDecorationTheme: const InputDecorationTheme(
                fillColor: Color(0xFFFFFFFF),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white),
              textTheme: TextTheme(
                headline1: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Color(0xFF1B2124), fontSize: 32)),
                headline2: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Color(0xFF1B2124), fontSize: 24)),
                bodyText1: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Color(0xFF1B2124), fontSize: 16)),
                bodyText2: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Color(0xFF1B2124), fontSize: 12)),
              )),
          home: const SplashScreen(),
        ),
      );
    });
  }
}
