import 'package:flutter/material.dart';
import '../../auth/screens/loginscreen.dart';
import '../../auth/screens/login_signup_onboard_screen.dart';
import '../../../models/onboardingmodel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController controller;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOut));

    controller.addListener(() {
      _animationController.forward(from: 0); // Reset animation on page change
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (currentIndex < pOnBording.length - 1)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
                _animationController.forward(from: 0); // Restart animation
              },
              itemCount: pOnBording.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SlideTransition(
                      position: _slideAnimation, // Animate rising effect
                      child: Image.asset(
                        pOnBording[index].image,
                        height: 300, // Adjust height for better layout
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _slideAnimation, // Apply same animation to text
                      child: Text(
                        pOnBording[index].title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pOnBording.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 4),
                          width: index == currentIndex ? 18 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index == currentIndex
                                ? Color(0xffb65ec4)
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              if (currentIndex == (pOnBording.length - 1)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginSignupOnboard()),
                );
              } else {
                await controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
            child: const CircleAvatar(
              backgroundColor: Color(0xffb65ec4),
              radius: 50,
              child: Icon(Icons.arrow_forward, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
