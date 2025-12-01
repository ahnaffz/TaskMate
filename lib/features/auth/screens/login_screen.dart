import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/user_provider.dart';
import '../../dashboard/screens/home_dashboard.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Sign in", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextFormField(controller: emailController, decoration: InputDecoration(hintText: "Email", filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 10),
              TextFormField(obscureText: true, decoration: InputDecoration(hintText: "Password", filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if(emailController.text.isNotEmpty) {
                    ref.read(userProvider.notifier).setUserName(emailController.text.split('@')[0]);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
                },
                child: const Text("Sign In"),
              ),
              const SizedBox(height: 20),
              OutlinedButton(onPressed: () {}, child: const Text("Continue with Google")),
              const SizedBox(height: 20),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), child: const Text("Don't have an account? Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}