import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';  // Import your HamburgerMenu widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sitterProfilepage.dart';
import 'userPictures.dart';  // Import the user profile pictures map

class FindPetSitters extends StatefulWidget {
  const FindPetSitters({super.key});

  @override
  State<FindPetSitters> createState() => _FindPetSittersState();
}

class _FindPetSittersState extends State<FindPetSitters> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _foundUsers = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchPetSitters();  // Fetch pet sitters when the page is loaded
  }

  // Fetch users from Firestore and filter for pet sitters
  Future<void> _fetchPetSitters() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Map<String, dynamic>> results = [];

    // Get current user's email to avoid showing them in the list
    String currentUserEmail = _currentUser?.email ?? '';
    print("Current user email: $currentUserEmail");

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Skip the current user
      if (data['email'] == currentUserEmail) continue;

      bool isPetSitter = data['isPetSitter'] ?? false;

      if (isPetSitter) {
        // Get user details
        String userName = (data['firstName'] ?? '') + ' ' + (data['lastName'] ?? '') ?? 'Unknown Name';

        // Get image and rating from the userProfilePictures map
        String userEmail = data['email'];
        String userImage = userProfilePictures[userEmail]?['image'] ?? 'images/default.png';
        double userRating = userProfilePictures[userEmail]?['rating'] ?? 0.0;

        results.add({
          "name": userName.trim().isEmpty ? 'Unknown Name' : userName.trim(),
          "location": data['location'] ?? "Unknown Location",
          "image": userImage,
          "rating": userRating,
        });
      }
    }

    setState(() {
      _foundUsers = results;
    });
  }

  // Run filter based on search input (optional, but left in case you'd like to use it)
  void _runFilter(String query) {
    List<Map<String, dynamic>> results = [];

    if (query.isEmpty) {
      _fetchPetSitters();  // Reload the full list
    } else {
      results = _foundUsers.where((user) {
        String userName = user["name"]?.toLowerCase().trim() ?? "";
        String keyword = query.toLowerCase().trim();
        return userName.startsWith(keyword);
      }).toList();

      setState(() {
        _foundUsers = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.jostTextTheme()),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        hintText: 'Search for Pet Sitters',
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
          centerTitle: true,
        ),
        drawer: HamburgerMenu(),  // Sidebar menu
        body: Column(
          children: [
            const Divider(thickness: 1),  // Divider after the search bar

            // Display Users List
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.separated(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(_foundUsers[index]['image']),
                      radius: 30,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _foundUsers[index]['name'],
                            style: const TextStyle(
                              fontFamily: 'Bebas Neue',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Display the rating
                        Text(
                          _foundUsers[index]['rating'].toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "Location: ${_foundUsers[index]['location']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      // Navigate to PetSitterProfile and pass user data excluding email
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetSitterProfile(
                            // No email is passed here
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(thickness: 0.5),
              )
                  : const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}