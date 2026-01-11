import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mashroom/features/auth/screens/login_signup_onboard_screen.dart';
import 'package:mashroom/features/home/screens/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has user data, then they're already signed in
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const LoginSignupOnboard();
          }
          return const MainScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
