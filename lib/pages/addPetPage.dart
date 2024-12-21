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

  // Function to add a pet to the current user's document
  Future<void> _addPetToUser() async {
    // Get the current user
    User? user = _auth.currentUser;
    if (user == null) {
      // If no user is logged in, show an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to add a pet.')),
      );
      return;
    }

    // Create a new pet document
    Map<String, dynamic> petData = {
      'name': petNameController.text,
      'breed': breedController.text,
      'type': selectedType == 'Other' ? otherTypeController.text : selectedType,
      'gender': selectedGender,
      'description': descriptionController.text,
      'createdAt': Timestamp.now(), // Timestamp for when the pet was added
    };

    // Save the pet in the Firestore under the user's document
    try {
      await _firestore.collection('users').doc(user.uid).collection('pets').add(petData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet added successfully!')),
      );
      // Optionally, clear the form after submission
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                  Positioned(
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
            SizedBox(height: 20),
            TextField(
              controller: petNameController,
              decoration: InputDecoration(
                labelText: 'Pet Name',
                labelStyle: GoogleFonts.jost(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: breedController,
              decoration: InputDecoration(
                labelText: 'Breed',
                labelStyle: GoogleFonts.jost(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
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
                              selectedType = value as String?;
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
                              selectedType = value as String?;
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
                              selectedType = value as String?;
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
                      border: OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
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
                          selectedGender = value as String?;
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
                          selectedGender = value as String?;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.jost(),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Handle form submission
                if (petNameController.text.isEmpty || breedController.text.isEmpty || selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all required fields.')),
                  );
                } else if (selectedType == 'Other' && otherTypeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please specify the pet type.')),
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