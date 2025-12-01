import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {'image': 'assets/images/onboarding1.png', 'title': 'Manage tugas mu dengan mudah', 'desc': 'Atur jadwalmu agar lebih produktif'},
    {'image': 'assets/images/onboarding2.png', 'title': 'Dapatkan pengingat setiap saat tepat waktu', 'desc': 'Jangan lewatkan deadline penting'},
    {'image': 'assets/images/onboarding3.png', 'title': 'Tingkatkan produktivitas', 'desc': 'Capai targetmu setiap hari'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(_pages[index]['image']!, height: 300, errorBuilder: (c,o,s) => Icon(Icons.image, size: 100, color: Colors.white)),
                      const SizedBox(height: 40),
                      Text(_pages[index]['title']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 20),
                      Text(_pages[index]['desc']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => Container(margin: const EdgeInsets.all(4), width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == index ? Colors.white : Colors.grey))),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text("Skip", style: TextStyle(color: Colors.white))),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == 2) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                      } else {
                        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryColor),
                    child: Text(_currentPage == 2 ? "Get Started" : "Next"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}