import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addPetPage.dart';
import 'editProfile.dart';
import 'hamburger_menu.dart';
import 'userPictures.dart'; // Import the updated userProfilePictures.dart

class YourAccountPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  YourAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user from FirebaseAuth
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      // If no user is logged in, show a message
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            'YOUR ACCOUNT',
            style: GoogleFonts.jost(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: const Center(child: Text('No user is logged in')),
      );
    }

    // Get the user's email from the FirebaseAuth instance
    String userEmail = currentUser.email ?? '';

    // Get the profile picture and rating from userProfiles.dart using the email
    Map<String, dynamic> userProfile = userProfilePictures[userEmail] ?? {'image': 'assets/profile_placeholder.png', 'rating': 0.0};

    final profileImagePath = AssetManager.getProfileImage(userEmail);
    double userRating = userProfile['rating'] ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFCA4F),
        title: Text(
          'YOUR ACCOUNT',
          style: GoogleFonts.jost(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: HamburgerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Profile picture and rating section
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(profileImagePath), // Use the profile image fetched from userProfiles.dart
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Rating display
            Text(
              'Rating: ${userRating.toStringAsFixed(1)} ★',
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 16),
            // Fetch User Details from Firebase
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text(
                    'No user data found',
                    style: GoogleFonts.jost(fontSize: 14),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                // Extract user roles
                List<String> roles = [];
                if (userData['isPetBreeder'] == true) roles.add('Pet Breeder');
                if (userData['isPetOwner'] == true) roles.add('Pet Owner');
                if (userData['isPetSitter'] == true) roles.add('Pet Sitter');

                // Get location and gender, or show "Not added yet"
                String locationText = userData['location'] ?? 'Not added yet';
                String genderText = userData['pronouns'] ?? 'Not added yet';

                return Column(
                  children: [
                    Text(
                      '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}',
                      style: GoogleFonts.jost(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 30, thickness: 1, color: Colors.grey.shade400),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DETAILS',
                        style: GoogleFonts.jost(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username: @${userData['username'] ?? 'N/A'}',
                            style: GoogleFonts.jost(fontSize: 14),
                          ),
                          Text(
                            'Email: ${userData['email'] ?? 'N/A'}',
                            style: GoogleFonts.jost(fontSize: 14),
                          ),
                          Text(
                            'Roles: ${roles.isNotEmpty ? roles.join(', ') : 'N/A'}',
                            style: GoogleFonts.jost(fontSize: 14),
                          ),
                          Text(
                            'Location: $locationText',
                            style: GoogleFonts.jost(fontSize: 14),
                          ),
                          Text(
                            'Pronouns: $genderText',
                            style: GoogleFonts.jost(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Divider(height: 30, thickness: 1, color: Colors.grey.shade400),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YOUR PETS',
                  style: GoogleFonts.jost(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPetPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Colors.purple.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Add More',
                    style: GoogleFonts.jost(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Fetch Pets from Firebase
            StreamBuilder<QuerySnapshot>(
              stream: currentUser != null
                  ? _firestore.collection('users').doc(currentUser.uid).collection('pets').snapshots()
                  : const Stream.empty(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text(
                    'No pets available.',
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey),
                  );
                }

                final pets = snapshot.data!.docs;
                List<Map<String, dynamic>> petList = [];

                for (var pet in pets) {
                  final petData = pet.data() as Map<String, dynamic>;
                  final petName = petData['name'] ?? 'Unknown Pet';

                  // Apply the same logic to resolve pet image based on pet name
                  String petImage = petProfilePictures.entries
                      .firstWhere(
                        (entry) => entry.value['name'] == petName,
                    orElse: () => const MapEntry('', {'image': 'assets/pet_placeholder.png'}), // Default image if no match is found
                  )
                      .value['image'] ?? 'assets/pet_placeholder.png';

                  // Add pet details to list
                  petList.add({
                    "name": petName,
                    "type": petData['type'] ?? 'Unknown Type',
                    "gender": petData['gender'] ?? 'Unknown Gender',
                    "image": petImage,
                  });
                }

                // Now map the pets to PetCard widget
                return Column(
                  children: petList.map((pet) {
                    return PetCard(
                      name: pet['name'],
                      type: pet['type'],
                      gender: pet['gender'],
                      image: pet['image'], // Use resolved pet image
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'EDIT PROFILE',
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final String name;
  final String type;
  final String gender;
  final String image; // Path to the local asset image

  const PetCard({
    super.key,
    required this.name,
    required this.type,
    required this.gender,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundImage: AssetImage(image),
          radius: 30,
          onBackgroundImageError: (_, __) {
            print('Failed to load image: $image');
          },
        ),
        title: Text(name, style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: $type'),
            Text('Gender: $gender'),
          ],
        ),
      ),
    );
  }
}

class AssetManager {
  static const String defaultProfileImage = 'assets/profile_placeholder.png';
  static const String defaultPetImage = 'assets/pet_placeholder.png';

  static String getProfileImage(String email) {
    return userProfilePictures[email]?['image'] ?? defaultProfileImage;
  }
}