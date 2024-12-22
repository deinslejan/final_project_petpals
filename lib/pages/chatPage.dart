import 'package:flutter/material.dart';
import 'hamburger_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userPictures.dart';
import 'chats.dart';

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

    if (role == "PETPALS" || role == "ALL") {
      try {
        // Fetch all users
        QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

        for (var userDoc in usersSnapshot.docs) {
          // Skip the current user's pets
          if (userDoc.id == _currentUser?.uid) continue;

          // Fetch pets for this user
          QuerySnapshot petsSnapshot = await _firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('pets')
              .get();

          for (var petDoc in petsSnapshot.docs) {
            var petData = petDoc.data() as Map<String, dynamic>;

            // Check if the pet's ownerID matches the current user's username
            String ownerID = petData['ownerID'] ?? '';

            if (ownerID != _currentUser?.displayName) {
              // Get pet's image from petProfilePictures map based on the pet's name
              String petName = petData['name'] ?? 'Unknown Pet';
              String petImage = petProfilePictures.entries
                  .firstWhere(
                    (entry) => entry.value['name'] == petName,
                orElse: () => const MapEntry('', {'image': 'images/default.png'}),
              )
                  .value['image'] ?? 'images/default.png'; // Default image if no match is found

              // Add pet details to results
              results.add({
                "name": petName,
                "breed": petData['breed'] ?? 'Unknown Breed',
                "location": petData['location'] ?? 'Unknown Location',
                "image": petImage,
                "type": "Pet",
              });
            }
          }
        }
      } catch (e) {
        print("Error fetching pets: $e");
      }
    }

    // Fetch users based on the role
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Ensure the logged-in user is excluded from the users list
        if (data['email'] == _currentUser?.email) continue;

        String userEmail = data['email'];
        String userName = (data['firstName'] ?? '') + ' ' + (data['lastName'] ?? '');

        // Fetch user image from the userProfilePictures map if available
        String userImage = userProfilePictures[userEmail]?['image'] ?? 'images/default.png';

        bool isPetBreeder = data['isPetBreeder'] ?? false;
        bool isPetSitter = data['isPetSitter'] ?? false;

        if ((role == "ALL") ||
            (role == "BREEDERS" && isPetBreeder) ||
            (role == "SITTERS" && isPetSitter)) {
          results.add({
            "name": userName.trim().isEmpty ? 'Unknown Name' : userName.trim(),
            "image": userImage,
            "location": data['location'] ?? "Unknown Location",
            "isBreeder": isPetBreeder,
            "isSitter": isPetSitter,
            "type": "User",
          });
        }
      }
    } catch (e) {
      print("Error fetching users: $e");
    }

    // Update state with the filtered results
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
        String userName = user["name"]?.toLowerCase().trim() ?? "";
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
    return Scaffold(
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
                      hintText: 'Search for your Pals',
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
      drawer: HamburgerMenu(),
      body: Column(
        children: [
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
          Expanded(
            child: _foundUsers.isNotEmpty
                ? ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
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
    );
  }
}