import 'package:flutter/material.dart';
import 'package:petpals/pages/landingpage.dart';
import 'package:petpals/pages/loginpage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLandingPage = true;

  void togglePages() {
    setState(() {
      showLandingPage = !showLandingPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLandingPage) {
      return LandingPage();
    } else {
      return LoginPage();
    }
  }
}