import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  String? selectedType = 'Dog'; // Default selected type
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController otherTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gender selection
  String? selectedGender;
  String? userLocation; // Variable to store user's location
  String? username; // Variable to store the current user's username

  // Function to get the current user's location and username
  Future<void> _getUserDetails() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // If no user is logged in, show an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to add a pet.')),
      );
      return;
    }

    // Get the current user's details from Firestore
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userLocation = userDoc['location']; // Assuming 'location' field exists in user document
          username = userDoc['username']; // Assuming 'username' field exists in user document
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  // Function to add a pet to the current user's document
  Future<void> _addPetToUser() async {
    User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to add a pet.')),
      );
      return;
    }

    if (userLocation == null || username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to retrieve user details.')),
      );
      return;
    }

    // Pet data
    Map<String, dynamic> petData = {
      'name': petNameController.text.trim(),
      'breed': breedController.text.trim(),
      'type': selectedType == 'Other' ? otherTypeController.text.trim() : selectedType,
      'gender': selectedGender,
      'description': descriptionController.text.trim(),
      'location': userLocation,
      'ownerID': username, // Reference the current user's username
      'createdAt': Timestamp.now(),
    };

    try {
      // Add pet to the user's subcollection
      await _firestore.collection('users').doc(user.uid).collection('pets').add(petData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet added successfully!')),
      );
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding pet: $e')),
      );
    }
  }

  // Function to clear the form after submission
  void _clearForm() {
    petNameController.clear();
    breedController.clear();
    otherTypeController.clear();
    descriptionController.clear();
    setState(() {
      selectedType = 'Dog';
      selectedGender = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails(); // Get the user's details when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFCA4F),
        title: Text(
          'ADD NEW PET',
          style: GoogleFonts.jost(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: petNameController,
              decoration: InputDecoration(
                labelText: 'Pet Name',
                labelStyle: GoogleFonts.jost(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: breedController,
              decoration: InputDecoration(
                labelText: 'Breed',
                labelStyle: GoogleFonts.jost(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Type',
              style: GoogleFonts.jost(fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Dog', style: GoogleFonts.jost()),
                        leading: Radio(
                          value: 'Dog',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Cat', style: GoogleFonts.jost()),
                        leading: Radio(
                          value: 'Cat',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Other', style: GoogleFonts.jost()),
                        leading: Radio(
                          value: 'Other',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedType == 'Other')
                  TextField(
                    controller: otherTypeController,
                    decoration: InputDecoration(
                      labelText: 'Please specify',
                      labelStyle: GoogleFonts.jost(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Gender',
              style: GoogleFonts.jost(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Male', style: GoogleFonts.jost()),
                    leading: Radio(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Female', style: GoogleFonts.jost()),
                    leading: Radio(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.jost(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Handle form submission
                if (petNameController.text.isEmpty || breedController.text.isEmpty || selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required fields.')),
                  );
                } else if (selectedType == 'Other' && otherTypeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please specify the pet type.')),
                  );
                } else {
                  _addPetToUser();
                }
              },
              child: Text(
                'ADD PET',
                style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}