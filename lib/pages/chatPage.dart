import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userPictures.dart';  // Import the user profile pictures map
import 'chats.dart';  // Import the ChatScreen

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
    List<Map<String, dynamic>> results = [];

    // Handle PETPALS and ALL filter separately
    if (role == "PETPALS" || role == "ALL") {
      // Fetch pets directly for PETPALS and add them to the ALL filter as well
      try {
        QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

        for (var userDoc in usersSnapshot.docs) {
          // Skip the current logged-in user by checking the email
          if ((userDoc.data() as Map<String, dynamic>)['email'] == _currentUser?.email) continue;

          // Fetch pets subcollection for each user
          QuerySnapshot petsSnapshot = await _firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('pets')
              .get();

          for (var petDoc in petsSnapshot.docs) {
            var petData = petDoc.data() as Map<String, dynamic>;

            // Add the pet details to the results
            results.add({
              "name": petData['name'] ?? 'Unknown Pet',
              "image": 'images/pet_default_image.png', // You can change the image path here for pets
              "location": petData['location'] ?? 'Unknown Location',
            });
          }
        }
      } catch (e) {
        print("Error fetching pets: $e");
      }
    }

    // Handle SITTERS and BREEDERS logic
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Skip the current logged-in user by checking the email
        if (data['email'] == _currentUser?.email) continue;

        // Combine firstName and lastName for the full name
        String userName = (data['firstName'] ?? '') + ' ' + (data['lastName'] ?? '');

        // Check the user's email against the userProfilePictures map to get the image
        String userEmail = data['email'];
        String userImage = userProfilePictures[userEmail]?['image'] ?? 'images/default.png';

        // Filter based on the role
        bool isPetBreeder = data['isPetBreeder'] ?? false;
        bool isPetSitter = data['isPetSitter'] ?? false;

        if ((role == "ALL") ||
            (role == "BREEDERS" && isPetBreeder) ||
            (role == "SITTERS" && isPetSitter)) {
          results.add({
            "name": userName.trim().isEmpty ? 'Unknown Name' : userName.trim(),
            "location": data['location'] ?? "Unknown Location",
            "image": userImage,
            "isBreeder": isPetBreeder,
            "isSitter": isPetSitter,
          });
        }
      }
    } catch (e) {
      print("Error fetching users: $e");
    }

    setState(() {
      _selectedRole = role;
      _foundUsers = results;
    });
  }

  void _runFilter(String query) {
    List<Map<String, dynamic>> results = [];

    // If query is empty, reapply the filter based on the selected role
    if (query.isEmpty) {
      _filterByRole(_selectedRole);  // Reapply the role-based filter when search is empty
    } else {
      // Perform filtering by name, ensuring the name starts with the query
      results = _foundUsers.where((user) {
        String userName = user["name"]?.toLowerCase().trim() ?? ""; // Safely handle null
        String keyword = query.toLowerCase().trim();

        // Ensure search starts with the keyword (case-insensitive)
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
        backgroundColor: const Color(0xFFFFF9E5),
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
                        hintText: 'Search for your Pals',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
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
                  return GestureDetector(
                    onTap: () {
                      // Redirect to ChatScreen when a user is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userName: _foundUsers[index]['name'],
                            userImage: _foundUsers[index]['image'],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(_foundUsers[index]['image']),
                        radius: 30,
                      ),
                      title: Text(
                        _foundUsers[index]['name'],
                        style: const TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Location: ${_foundUsers[index]['location']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                const Divider(thickness: 0.5),
                itemCount: _foundUsers.length,
              )
                  : const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}