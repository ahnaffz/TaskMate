import 'package:taskmate_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF000020),
              Color(0xFF080F48),
            ],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            "TaskMate",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
