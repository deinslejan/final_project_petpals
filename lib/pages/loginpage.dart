import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/textfield.dart';
import 'findPetpalspage.dart';
import 'introduction.dart'; // Import the Introduction page here

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  void login() {
    if (_formKey.currentState!.validate()) {
      // Perform login logic here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FindPetpals(),
        ),
      );
    } else {
      print("Validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFFFFCA4F),
          title: const Padding(
            padding: EdgeInsets.only(left: 5, top: 30),
            child: Text(
              "LOG IN",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey, // Attach the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Logo text
                Image.asset('images/merge.png', width: 300, height: 300),

                // Welcome back
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Email:",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 5),
                MyTextField(
                  controller: emailController,
                  hintText: 'Enter Email',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation regex
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Password
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Password:",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 5),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Login
                GestureDetector(
                  onTap: login,
                  child: Container(
                    width: 200, // Full width
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6), // Light purple
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black, // Text color
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign-up link
                GestureDetector(
                  onTap: () {
                    // Navigate to Introduction Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetPalsApp(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}