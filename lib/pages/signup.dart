import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginpage.dart';
import 'findPetpalspage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for text fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Checkbox states
  bool isPetOwner = false;
  bool isPetSitter = false;
  bool isPetBreeder = false;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  void signUp() {
    if (_formKey.currentState!.validate()) {
      // Navigation to FindPetpals page after successful validation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FindPetpals(), // Navigate to FindPetpals page
        ),
      );
    } else {
      print("Validation Failed");
    }
  }

  // Helper function for TextFormField styling
  InputDecoration inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.jost(
        color: Colors.black,
        fontSize: 16,
      ),
      hintText: hint,
      hintStyle: GoogleFonts.jost(
        color: Colors.grey.shade400,
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey, // Light grey border when inactive
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.black, // Thicker black border when focused
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFCA4F), // Yellow header
        title: Align(
          alignment: Alignment.centerLeft, // Align text to the left
          child: Text(
            "SIGN UP",
            style: const TextStyle(
              fontFamily: 'BebasNeue', // Custom Bebas Neue font
              fontSize: 32, // Adjust font size
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Logo
                Center(
                  child: Image.asset(
                    'images/name_logo.png', // Replace with your image path
                    height: 100,
                  ),
                ),

                const SizedBox(height: 20),

                // First Name
                TextFormField(
                  controller: firstNameController,
                  decoration: inputDecoration("First Name", "First Name"),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your first name'
                      : null,
                ),
                const SizedBox(height: 10),

                // Last Name
                TextFormField(
                  controller: lastNameController,
                  decoration: inputDecoration("Last Name", "Last Name"),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your last name'
                      : null,
                ),
                const SizedBox(height: 10),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: inputDecoration("Email", "example@gmail.com"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: inputDecoration("Password", "******"),
                  validator: (value) => value == null || value.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 10),

                // Confirm Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: inputDecoration("Confirm Password", "******"),
                  validator: (value) => value != passwordController.text
                      ? 'Passwords do not match'
                      : null,
                ),
                const SizedBox(height: 20),

                // Role Selection
                Text(
                  "I am a/an...",
                  style: GoogleFonts.jost(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isPetOwner,
                      onChanged: (bool? value) {
                        setState(() {
                          isPetOwner = value ?? false;
                        });
                      },
                    ),
                    Text("Pet Owner", style: GoogleFonts.jost()),
                    Checkbox(
                      value: isPetSitter,
                      onChanged: (bool? value) {
                        setState(() {
                          isPetSitter = value ?? false;
                        });
                      },
                    ),
                    Text("Pet Sitter", style: GoogleFonts.jost()),
                    Checkbox(
                      value: isPetBreeder,
                      onChanged: (bool? value) {
                        setState(() {
                          isPetBreeder = value ?? false;
                        });
                      },
                    ),
                    Text("Pet Breeder", style: GoogleFonts.jost()),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign Up Button
                Center(
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.jost(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Navigate to Login Page
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Already have an account?",
                      style: GoogleFonts.jost(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}