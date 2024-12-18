import 'package:flutter/material.dart';
import 'package:petpals/pages/chatPage.dart';
import 'package:petpals/pages/findPetBreederspage.dart';
import 'package:petpals/pages/findPetpalspage.dart';
import 'package:petpals/services/auth/login_or_reg.dart';
import 'pages/landingpage.dart';
import 'pages/findPetBreederspage.dart';
import 'pages/findPetSitterspage.dart';
import 'pages/petBreederpage.dart';
import 'pages/petSitterpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
