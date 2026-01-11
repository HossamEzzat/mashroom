import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/onboardingmodel.dart';
import '../../auth/screens/login_signup_onboard_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Stack to put the decoration BEHIND the content
      body: Stack(
        children: [
          // 1. Decorative Background Layer
          const BackgroundDecorations(),

          // 2. Main Content Layer
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (v) => setState(() => currentIndex = v),
                    itemCount: pOnBording.length,
                    itemBuilder: (context, index) => _buildPageContent(index),
                  ),
                ),
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Sub-components ---

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginSignupOnboard()),
            ),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    bool isActive = currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 500),
            scale: isActive ? 1.0 : 0.7,
            child: Image.asset(pOnBording[index].image, height: 300),
          ),
          const SizedBox(height: 40),
          Text(
            pOnBording[index].title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Elevate your experience with our premium features.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pOnBording.length, (i) => _buildDot(i)),
          ),
          const SizedBox(height: 30),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
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

  Widget _buildNextButton() {
    double progress = (currentIndex + 1) / pOnBording.length;
    return GestureDetector(
      onTap: () {
        if (currentIndex == pOnBording.length - 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginSignupOnboard()),
          );
        } else {
          controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 85,
            height: 85,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Color(0xffb65ec4)),
            ),
          ),
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              color: Color(0xffb65ec4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Background Decoration Widgets ---

class BackgroundDecorations extends StatelessWidget {
  const BackgroundDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFFFBFBFD)), // Base off-white color
        // Top Left Blob
        Positioned(
          top: -100,
          left: -50,
          child: _BlurredCircle(
            color: const Color(0xffb65ec4).withOpacity(0.15),
            size: 300,
          ),
        ),

        // Bottom Right Blob
        Positioned(
          bottom: -50,
          right: -80,
          child: _BlurredCircle(
            color: const Color(0xffb65ec4).withOpacity(0.1),
            size: 250,
          ),
        ),
      ],
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurredCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
