import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPetPage extends StatefulWidget {
  final String petId;
  final String initialName;
  final String initialBreed;
  final String initialType;
  final String initialGender;
  final String initialDescription;

  EditPetPage({
    required this.petId,
    required this.initialName,
    required this.initialBreed,
    required this.initialType,
    required this.initialGender,
    required this.initialDescription,
  });

  @override
  _EditPetPageState createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  String? selectedType;
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController otherTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gender selection
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the pet's current details
    selectedType = widget.initialType;
    petNameController.text = widget.initialName;
    breedController.text = widget.initialBreed;
    selectedGender = widget.initialGender;
    descriptionController.text = widget.initialDescription;
  }

  // Function to update the pet details in Firestore
  Future<void> _updatePetDetails() async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to edit a pet.')),
      );
      return;
    }

    // Create a map of updated pet data
    Map<String, dynamic> updatedPetData = {
      'name': petNameController.text,
      'breed': breedController.text,
      'type': selectedType == 'Other' ? otherTypeController.text : selectedType,
      'gender': selectedGender,
      'description': descriptionController.text,
      'updatedAt': Timestamp.now(), // Timestamp for when the pet was updated
    };

    try {
      // Update the pet document in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('pets')
          .doc(widget.petId)
          .update(updatedPetData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet updated successfully!')),
      );
      Navigator.pop(context); // Go back to the previous page after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating pet: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFCA4F),
        title: Text(
          'EDIT PET DETAILS',
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
                      Icons.pets,
                      size: 50,
                      color: Colors.purple,
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
                if (petNameController.text.isEmpty ||
                    breedController.text.isEmpty ||
                    selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required fields.')),
                  );
                } else if (selectedType == 'Other' && otherTypeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please specify the pet type.')),
                  );
                } else {
                  _updatePetDetails();
                }
              },
              child: Text(
                'UPDATE PET',
                style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}