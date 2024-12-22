import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
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
  final usernameController = TextEditingController();  // New username controller
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Checkbox states
  bool isPetOwner = false;
  bool isPetSitter = false;
  bool isPetBreeder = false;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Firebase Authentication instance

  // State to handle obscure text for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Sign Up function to store data in Firestore and Firebase Authentication
  void signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if email or username already exists in Firestore
        bool emailExists = await _checkIfEmailExists();
        bool usernameExists = await _checkIfUsernameExists();

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email is already in use')),
          );
          return;
        }

        if (usernameExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username is already taken')),
          );
          return;
        }

        // Create user with Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Firestore data structure
        Map<String, dynamic> userData = {
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'username': usernameController.text.trim(), // Store username in Firestore
          'isPetOwner': isPetOwner,
          'isPetSitter': isPetSitter,
          'isPetBreeder': isPetBreeder,
          'createdAt': Timestamp.now(), // Add timestamp for when the user signed up
        };

        // Save user data in Firestore with the user ID
        await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

        // Navigate to the LoginPage after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle Firebase authentication errors
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email is already in use')),
          );
        } else if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password is too weak')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      } catch (e) {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      print("Validation Failed");
    }
  }

  // Helper function to check if the email already exists
  Future<bool> _checkIfEmailExists() async {
    final querySnapshot = await _firestore.collection('users').where('email', isEqualTo: emailController.text.trim()).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Helper function to check if the username already exists
  Future<bool> _checkIfUsernameExists() async {
    final querySnapshot = await _firestore.collection('users').where('username', isEqualTo: usernameController.text.trim()).get();
    return querySnapshot.docs.isNotEmpty;
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
        automaticallyImplyLeading: false, // Remove the back button
        backgroundColor: const Color(0xFFFFCA4F),
        title: Text(
          "SIGN UP",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
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
                Center(
                  child: Image.asset(
                    'images/name_logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: firstNameController,
                  decoration: inputDecoration("First Name", "First Name"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your first name' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: lastNameController,
                  decoration: inputDecoration("Last Name", "Last Name"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your last name' : null,
                ),
                const SizedBox(height: 10),
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
                // Username field
                TextFormField(
                  controller: usernameController,  // Username controller
                  decoration: inputDecoration("Username", "Choose a username"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your username' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: inputDecoration("Password", "******").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: inputDecoration("Confirm Password", "******").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) =>
                  value != passwordController.text ? 'Passwords do not match' : null,
                ),
                const SizedBox(height: 20),
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
                Center(
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
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