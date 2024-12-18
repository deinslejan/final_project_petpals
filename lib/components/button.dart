import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final double width; // Add width parameter
  final double height; // Add height parameter
  final Color backgroundColor; // Background color
  final Color textColor; // Text color
  final double fontSize; // Font size

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width = double.infinity, // Default width to fill the parent
    this.height = 50.0, // Default height
    this.backgroundColor = Colors.white, // Default background color
    this.textColor = Colors.black, // Default text color
    this.fontSize = 15.0, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280, // Use width parameter
        height: 65, // Use height parameter
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 3, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor, // Use text color parameter
              fontWeight: FontWeight.bold,
              fontSize: fontSize, // Use font size parameter
            ),
          ),
        ),
      ),
    );
  }
}
