import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futminna_project_1/repositories/share.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Truck Locator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          unselectedWidgetColor: Commons.primaryColor,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Color(0xFFFFFFFF),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.white),
          textTheme: const TextTheme(
              headline1: TextStyle(color: Color(0xFF1B2124), fontSize: 32),
              headline2: TextStyle(color: Color(0xFF1B2124), fontSize: 24),
              bodyText1: TextStyle(color: Color(0xFF1B2124), fontSize: 16),
              bodyText2: TextStyle(color: Color(0xFF1B2124), fontSize: 14))),
      home: const SplashScreen(),
    );
  }
}
