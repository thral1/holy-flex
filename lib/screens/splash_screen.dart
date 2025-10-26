import 'dart:async';

import 'package:flutter/material.dart';

import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(milliseconds: 3000);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, _goToDashboard);
  }

  void _goToDashboard() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset('assets/images/home_splash.png'),
              ),
            ),
          ),
          // CBS Logo overlay at the top
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/cbs_logo.png',
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
