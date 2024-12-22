import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addPetPage.dart';
import 'editPetPage.dart';
import 'userPictures.dart'; // Import EditPetPage

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _currentPronouns = 'She/Her'; // Default pronouns

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Load user data
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _emailController.text = currentUser.email ?? ''; // Using Firebase Auth email
          _usernameController.text = userData['username'] ?? '';
          _locationController.text = userData['location'] ?? '';
          _currentPronouns = userData['pronouns'] ?? 'She/Her';
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'username': _usernameController.text,
        'location': _locationController.text,
        'pronouns': _currentPronouns,
      });

      // Show a success message or navigate back after saving
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully!'),
      ));

      // Optionally, navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    String userEmail = currentUser?.email ?? '';
    final profileImagePath = AssetManager.getProfileImage(userEmail);

    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'EDIT ACCOUNT',
          style: GoogleFonts.jost(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    AssetImage(profileImagePath)
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // First Name Field
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Last Name Field
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Editable username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixText: '@',
                hintText: FirebaseAuth.instance.currentUser?.displayName ?? 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: FirebaseAuth.instance.currentUser?.email ?? 'Your Email',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Prevent editing of email
            ),
            SizedBox(height: 16),
            // Location Field
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Pronouns Section
            Text(
              'Pronouns',
              style: GoogleFonts.jost(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('She/Her', style: GoogleFonts.jost()),
                    leading: Radio<String>(
                      value: 'She/Her',
                      groupValue: _currentPronouns,
                      onChanged: (value) {
                        setState(() {
                          _currentPronouns = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('He/Him', style: GoogleFonts.jost()),
                    leading: Radio<String>(
                      value: 'He/Him',
                      groupValue: _currentPronouns,
                      onChanged: (value) {
                        setState(() {
                          _currentPronouns = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Other', style: GoogleFonts.jost()),
                    leading: Radio<String>(
                      value: 'Other',
                      groupValue: _currentPronouns,
                      onChanged: (value) {
                        setState(() {
                          _currentPronouns = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YOUR PETS',
                  style: GoogleFonts.jost(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPetPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Colors.purple.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
            SizedBox(height: 16),
            // StreamBuilder to display pet data in real-time
            StreamBuilder<QuerySnapshot>(
              stream: currentUser != null
                  ? _firestore
                  .collection('users')
                  .doc(currentUser.uid)
                  .collection('pets')
                  .snapshots()
                  : Stream.empty(), // Ensure a valid empty stream if user is null
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text(
                    'No pets available.',
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey),
                  );
                }

                final pets = snapshot.data!.docs;
                return Column(
                  children: pets.map((pet) {
                    final petData = pet.data() as Map<String, dynamic>;
                    return PetCard(
                      name: petData['name'] ?? 'Unknown',
                      type: petData['type'] ?? 'Unknown',
                      gender: petData['gender'] ?? 'Unknown',
                      petId: pet.id, // Pass petId here
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16),
            // Confirm Changes Button
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'CONFIRM CHANGES',
                style: GoogleFonts.bebasNeue(fontSize: 18),
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
  final String petId; // Add petId to identify the pet

  PetCard({
    required this.name,
    required this.type,
    required this.gender,
    required this.petId,
  });

  String getPetImage(String petName) {
    // Example logic for getting pet image. You can customize this.
    // Replace with your logic for fetching pet images based on pet name or other attributes.
    return petProfilePictures.entries
        .firstWhere(
          (entry) => entry.value['name'] == petName,
      orElse: () => const MapEntry('', {'image': 'images/default.png'}),
    )
        .value['image'] ?? 'images/default.png';
  }

  @override
  Widget build(BuildContext context) {
    String petImage = getPetImage(name); // Get the pet image based on the name

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(petImage), // Display pet image here
        ),
        title: Text(name, style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: $type'),
            Text('Gender: $gender'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            // Fetch the pet details from Firestore using the petId
            try {
              var petDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('pets')
                  .doc(petId)
                  .get();

              if (petDoc.exists) {
                // Fetch data from Firestore document
                var petData = petDoc.data()!;
                String initialName = petData['name'] ?? '';
                String initialBreed = petData['breed'] ?? '';
                String initialType = petData['type'] ?? '';
                String initialGender = petData['gender'] ?? '';
                String initialDescription = petData['description'] ?? '';

                // Navigate to EditPetPage with all necessary parameters
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPetPage(
                          petId: petId,
                          initialName: initialName,
                          initialBreed: initialBreed,
                          initialType: initialType,
                          initialGender: initialGender,
                          initialDescription: initialDescription,
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pet not found!')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error fetching pet data: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}

class AssetManager {
  static const String defaultProfileImage = 'assets/profile_placeholder.png';

  static String getProfileImage(String email) {
    return userProfilePictures[email]?['image'] ?? defaultProfileImage;
  }
}