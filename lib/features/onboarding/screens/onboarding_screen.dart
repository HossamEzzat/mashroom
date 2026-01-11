import 'package:flutter/material.dart';

import '../../../models/onboardingmodel.dart';
import '../../auth/screens/login_signup_onboard_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Calculate progress for the circular button
  double get progress => (currentIndex + 1) / pOnBording.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginSignupOnboard()),
            ),
            child: Text(
              "Skip",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (value) => setState(() => currentIndex = value),
              itemCount: pOnBording.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image with subtle scaling
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: currentIndex == index ? 320 : 280,
                        child: Image.asset(
                          pOnBording[index].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        pOnBording[index].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Discover the best features we have to offer for your daily productivity.", // Replace with pOnBording[index].description if available
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Section: Progress Dots and Circular Button
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pOnBording.length,
                    (index) => buildDot(index),
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (currentIndex == pOnBording.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginSignupOnboard(),
                        ),
                      );
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutQuart,
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xffb65ec4),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xffb65ec4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xffb65ec4)
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
