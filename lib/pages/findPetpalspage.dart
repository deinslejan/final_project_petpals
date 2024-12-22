import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Firebase Firestore
import 'petProfile.dart';

class FindPetpals extends StatefulWidget {
  const FindPetpals({super.key});

  @override
  State<FindPetpals> createState() => _FindPetpalsState();
}

class _FindPetpalsState extends State<FindPetpals> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _foundPets = [];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }
// Declare a list to hold the original pets list (unfiltered)
  List<Map<String, dynamic>> allPets = [];

// Fetch pets from Firestore
  Future<void> _fetchPets() async {
    List<Map<String, dynamic>> results = [];
    try {
      // Fetch all users
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot petsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('pets')
            .get();

        for (var petDoc in petsSnapshot.docs) {
          var petData = petDoc.data() as Map<String, dynamic>;

          // Add pet details to results
          results.add({
            "name": petData['name'] ?? 'Unknown Pet',
            "breed": petData['breed'] ?? 'Unknown Breed',
            "location": petData['location'] ?? 'Unknown Location',
            "image": petData['image'] ?? 'images/default.png',
          });
        }
      }
    } catch (e) {
      print("Error fetching pets: $e");
    }

    // Store the full list of pets in allPets and update foundPets for display
    setState(() {
      allPets = results;  // Store the full list
      _foundPets = allPets;  // Display all pets initially
    });
  }

// Filtering function
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];

    // If the entered keyword is empty, show all pets
    if (enteredKeyword.isEmpty) {
      results = allPets; // Restore the original list of pets
    } else {
      // Filter the list based on the entered keyword
      results = allPets.where((pet) {
        String petName = pet["name"].toLowerCase().trim();
        String keyword = enteredKeyword.toLowerCase().trim();
        return petName.startsWith(keyword); // Match if the name starts with the entered keyword
      }).toList();
    }

    // Update the found pets list and notify the UI
    setState(() {
      _foundPets = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.jostTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFFFF9E5),
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: const Color(0xFFFFCA4F),
          title: Container(
            height: 50,
            width: 390,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        hintText: 'Search for Pet Pals',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: HamburgerMenu(),
        body: _foundPets.isNotEmpty
            ? ListView.separated(
          itemBuilder: (context, index) {
            final pet = _foundPets[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfilePage(),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(pet['image']),
                  radius: 30,
                ),
                title: Text(
                  pet['name'],
                  style: const TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Location: ${pet['location']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(thickness: 0.5);
          },
          itemCount: _foundPets.length,
        )
            : const Center(
          child: Text(
            'No results found',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}