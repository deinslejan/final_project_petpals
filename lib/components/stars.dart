import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating; // The number of stars (out of 5) to be filled
  final int maxRating; // Maximum number of stars
  final double size; // Size of the stars

  const StarRating({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : Colors.grey,
          size: size,
        );
      }),
    );
  }
}
