import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(PetSitterProfile());

class PetSitterProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber[600],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Aligns text to the right
            children: [
              Text(
                'PET SITTER',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 24,
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
            ],
          ),
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
                      backgroundImage: AssetImage('images/petSitters/mingyu.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'MIGOY',
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
                      "Hello! I’m Migoy, your trusted pet-sitter and unofficial animal whisperer! 🐾 Need someone to walk your dog, cuddle your cat, or make sure your hamster doesn’t escape? Ako na bahala! I make grumpy cats purr and lazy dogs fetch. Trust me, I’m practically part dog myself – loyal, playful, and always excited to see you! 🐶✨",
                      style: GoogleFonts.jost(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Details Section
              _buildSectionTitle('DETAILS'),
              _buildDetailsItem('Username:', '@siMiguelto'),
              _buildDetailsItem('Full name:', 'Miguel dela Cruz'),
              _buildDetailsItem('Location:', 'San Jose del Monte, Bulacan'),
              _buildDetailsItem('Pronouns:', 'He/Him'),
              SizedBox(height: 20),

              // Contact Section
              _buildSectionTitle('CONTACTS'),
              _buildDetailsItem('Cellphone Number:', '0939-178-3684'),
              _buildDetailsItem('Landline:', '4430162'),
              _buildDetailsItem('Facebook:', 'Migoy Dela Cruz'),
              _buildDetailsItem('Instagram:', '@iamMiggy'),
              _buildDetailsItem('Twitter:', '@siMiguelto'),
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
                username: '@imNayeon',
                comment:
                "Migoy is the best pet-sitter we've ever had! Our dog, Max, absolutely loves him. We were amazed at how quickly Migoy built a bond with Max, and it was clear that he genuinely cares about animals. Thank you, Migoy, for being so reliable and fun. We highly recommend his services to any pet parent! 🐶❤️",
                imagePath: 'images/nayeon.jpg',
                rating: 5,
              ),
              _buildComment(
                username: '@w0nw00',
                comment:
                "Migoy took care of my cat, Luna, like she was his own. Luna is usually shy, pero kay Migoy, super lambing niya! He sent me updates and photos, kaya I felt at ease kahit malayo ako. Talagang maalaga at maasikaso. Parang ang sarap tuloy mag-paalaga sa kanya. Eme 🐱💕",
                imagePath: 'images/wonwoo.jpg',
                rating: 5,
              ),
              _buildComment(
                username: '@alsnadjk',
                comment:
                'Cute na, maalaga pa. Highly recommended! Rawr',
                imagePath: 'images/faceless.jpg',
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