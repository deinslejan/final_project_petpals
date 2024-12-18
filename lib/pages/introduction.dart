import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginpage.dart'; // Import the LoginPage file

void main() {
  runApp(PetPalsApp());
}

class PetPalsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: PetPalsScreen(),
        ),
      ),
    );
  }
}

class PetPalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Header Section
        Container(
          color: Color(0xFFFFCA4F), // Header Color
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "WHAT IS ",
                style: TextStyle(
                  fontFamily: 'BebasNeue', // Apply Bebas Neue font
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              // Logo Text as Image
              Image.asset(
                'images/name_logo.png', // Path to name_logo.png
                height: 24, // Adjust size
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Logo with Shadow
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Rounded edges
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 5), // Offset in X and Y direction
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'images/logo.png', // Path to logo.png
              height: 200, // Adjust the size as needed
              width: 200,
              fit: BoxFit.cover, // Ensures the image covers the area without distortion
            ),
          ),
        ),
        SizedBox(height: 20),
        // Description Text with Jost Font
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "PetPals · Your furry friend’s social network. Connect with pet owners in your area, find reliable sitters and breeders, and arrange playdates. Create detailed profiles for your pets, chat with other owners, and share reviews.",
            textAlign: TextAlign.justify, // Justify text alignment
            style: GoogleFonts.jost(
              fontSize: 16,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 30), // Increased spacing between description and Sign Up button
        // Sign Up Button
        ElevatedButton(
          onPressed: () {
            // TODO: Add navigation or action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Sign Up Now!",
            style: GoogleFonts.jost(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        // Bottom Text as a button
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: Text(
            "Already have an account?",
            style: GoogleFonts.jost(
              fontSize: 14,
              color: Colors.black,
              decoration: TextDecoration.underline, // Add underline to emphasize clickable text
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}