import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userPictures.dart';  // Import the user profile pictures map

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageFilter();
}

class _ChatPageFilter extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _foundUsers = [];
  String _selectedRole = "ALL";
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _filterByRole("ALL");
  }

  Future<void> _filterByRole(String role) async {
    // Get users from Firestore
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Map<String, dynamic>> results = [];

    // Ensure current user is properly fetched
    String currentUserEmail = _currentUser?.email ?? ''; // Use email instead of UID
    print("Current user email: $currentUserEmail");

    // Iterate over the users and filter based on role
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Debugging: print the user data
      print("User data: ${data.toString()}");

      // Skip the current logged-in user by checking the email
      if (data['email'] == currentUserEmail) {
        print("Skipping current user with email: ${data['email']}");
        continue; // Skip the current user
      }

      bool isPetBreeder = data['isPetBreeder'] ?? false;
      bool isPetSitter = data['isPetSitter'] ?? false;

      // Combine firstName and lastName for the full name
      String userName = (data['firstName'] ?? '') + ' ' + (data['lastName'] ?? '') ?? 'Unknown Name';
      print("User Name: $userName");

      // Check the user's email against the userProfilePictures map to get the image and rating
      String userEmail = data['email'];
      String userImage = userProfilePictures[userEmail]?['image'] ?? 'images/default.png'; // Default image if not found
      double userRating = userProfilePictures[userEmail]?['rating'] ?? 0.0; // Default rating if not found

      // Filter based on the selected role
      if ((role == "ALL") ||
          (role == "BREEDERS" && isPetBreeder) ||
          (role == "SITTERS" && isPetSitter)) {
        results.add({
          "name": userName.trim().isEmpty ? 'Unknown Name' : userName.trim(), // Handle null/empty name
          "location": data['location'] ?? "Unknown Location", // Handle null values for location
          "image": userImage, // Use the matched image or default
          "rating": userRating, // Add rating to the result
        });
      }
    }

    setState(() {
      _selectedRole = role;
      _foundUsers = results;
    });
  }

  void _runFilter(String query) {
    List<Map<String, dynamic>> results = [];

    if (query.isEmpty) {
      _filterByRole(_selectedRole);
    } else {
      results = _foundUsers.where((user) {
        String userName =
            user["name"]?.toLowerCase().trim() ?? ""; // Safely handle null
        String keyword = query.toLowerCase().trim();
        return userName.startsWith(keyword);
      }).toList();

      setState(() {
        _foundUsers = results;
      });
    }
  }

  Widget _buildFilterButton(String role, String label) {
    return ElevatedButton(
      onPressed: () => _filterByRole(role),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedRole == role ? Colors.black : Colors.grey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.jostTextTheme()),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80, // Increase AppBar height
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
                        hintText: 'Search for Pet Breeders',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      // Placeholder for search button functionality
                    },
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
        drawer: HamburgerMenu(), // Sidebar menu
        body: Column(
          children: [
            // Role Filter Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterButton("ALL", "ALL"),
                  _buildFilterButton("PETPALS", "PETPALS"),
                  _buildFilterButton("SITTERS", "SITTERS"),
                  _buildFilterButton("BREEDERS", "BREEDERS"),
                ],
              ),
            ),
            const Divider(thickness: 1),

            // List of Filtered and Searched Users
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_foundUsers[index]['image']),
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
                        // Display rating if available
                        Text(
                          _foundUsers[index]['rating'].toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        Icon(
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
                  );
                },
                separatorBuilder: (context, index) => const Divider(thickness: 0.5),
                itemCount: _foundUsers.length,
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