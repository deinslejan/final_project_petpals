import 'package:flutter/material.dart';
import 'dart:async'; // For delayed navigation
import 'package:firebase_auth/firebase_auth.dart';
import 'landingpage.dart'; // Import the LandingPage or your desired initial page
import 'findPetpalspage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the fade-in animation
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();

    // Delay of 3 seconds before navigating to LandingPage or FindPetpals
    Timer(const Duration(seconds: 5), () {
      // Check if the user is logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Navigate to FindPetpals if user is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FindPetpals(),
          ),
        );
      } else {
        // Navigate to LandingPage if not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LandingPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFCA4F), // Splash background color
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'images/logo.png', // Your logo image path
            width: 300, // Logo width
            height: 300, // Logo height
            fit: BoxFit.cover, // Fit the image inside the box
          ),
        ),
      ),
    );
  }
}