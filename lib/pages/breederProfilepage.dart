import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(PetBreederProfile());

class PetBreederProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFF9E5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFCA4F),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'PET-BREEDER',
            style: GoogleFonts.jost(
              fontWeight: FontWeight.bold,
              fontSize: 20,  // Adjusted for clarity
              color: Colors.black,  // Adjust text color for contrast
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture & Name
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('images/petBreeders/mj.png'), // Replace with your image
                    ),
                    SizedBox(height: 10),
                    Text(
                      'MJ',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider( // Divider between MJ and BIO
                      thickness: 1,
                      color: Colors.grey[400],
                      indent: 40,
                      endIndent: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Bio Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BIO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BebasNeue',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "I'm MJ, a dog enthusiast. My two furry friends bring so much joy to my life, and I'm eager to help you find your perfect canine companion. Let's connect and discuss your furry family goals! I assure you'll have the best tail-wagging experience!",
                      style: GoogleFonts.jost(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Details Section
              _buildSectionTitle('DETAILS'),
              _buildDetailsItem('Username:', 'mj_ilde'),
              _buildDetailsItem('Full name:', 'Maeve Jean Ildefonso'),
              _buildDetailsItem('Location:', 'BGC, Taguig'),
              _buildDetailsItem('Pronouns:', 'She/Her'),
              _buildDetailsItem('Breed/s:', 'Toy Poodle'),
              SizedBox(height: 20),

              // Contact Section
              _buildSectionTitle('CONTACTS'),
              _buildDetailsItem('Cellphone Number:', '0917-345-1879'),
              _buildDetailsItem('Landline:', '4439430'),
              _buildDetailsItem('Facebook:', 'MJ Ildefonso'),
              _buildDetailsItem('Instagram:', '@mjilde'),
              _buildDetailsItem('Twitter:', '@maeveilde'),
              SizedBox(height: 20),

              // Ratings & Comments Section
              _buildSectionTitle('RATINGS & COMMENTS'),
              // Overall Rating
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      '5/5',
                      style: GoogleFonts.jost(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Comments
              _buildComment(
                username: '@karinayuu',
                comment:
                'MJ is absolutely amazing! She helped me find the perfect furry companion. My new puppy is so sweet and well-adjusted. Highly recommend!! Bonus points ang cute pa niya. ❤️🐾',
                imagePath: 'images/karina.jpg',
                rating: 5,
              ),
              _buildComment(
                username: '@anton_lee',
                comment:
                "MJ is the best! She's always available to answer questions and offer advice. My puppy is thriving, and I'm so grateful for MJ's expertise and kindness. 10/10 would recommend.",
                imagePath: 'images/anton.jpg',
                rating: 5,
              ),
              _buildComment(
                username: '@shiningning',
                comment:
                'Nalito ako sino yung puppy sa kanilang tatlo but she’s a 10/10 for me!',
                imagePath: 'images/ningning.jpg',
                rating: 5,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'BebasNeue',
        ),
      ),
    );
  }

  Widget _buildDetailsItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontFamily: 'BebasNeue',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.jost(fontSize: 14, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment({
    required String username,
    required String comment,
    required String imagePath,
    required int rating,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(imagePath), // User's profile picture
              ),
              SizedBox(width: 15),
              // Comment Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          username,
                          style: GoogleFonts.jost(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            rating,
                                (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Comment Text
                    Text(
                      comment,
                      style: GoogleFonts.jost(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}