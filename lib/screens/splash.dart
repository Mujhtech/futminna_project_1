import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_truck_locator/ui/on_boarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 250,
              child: Image.asset(
                'assets/images/Ellipse-1.png',
                width: 200,
                height: 200,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Food-Truck.png',
                  width: 250,
                  height: 250,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              right: 250,
              child: SizedBox(
                child: Image.asset(
                  'assets/images/Ellipse-2.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 320,
              ),
              Center(
                child: Text(
                  'Food Truck\nLocator',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontWeight: FontWeight.w900, fontSize: 32),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
