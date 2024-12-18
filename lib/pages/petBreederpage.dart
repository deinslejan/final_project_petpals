import 'package:flutter/material.dart';

class PetBreeders extends StatefulWidget {
  const PetBreeders({super.key});

  @override
  State<PetBreeders> createState() => _PetBreeders();
}

class _PetBreeders extends State<PetBreeders> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar( // Move AppBar inside Scaffold
          toolbarHeight: 80,
          backgroundColor: const Color(0xFFFFCA4F),
          title: Padding(
            padding: const EdgeInsets.only(top: 20), // Adjust top padding if needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items on both ends
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black, size: 30), // Larger black hamburger icon
                  onPressed: () {
                    // Action for the hamburger menu
                  },
                ),
                const Text(
                  "PET BREEDER",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
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
