// hamburgerMenu.dart
import 'package:flutter/material.dart';
import 'package:petpals/pages/yourAccount.dart';
import 'chatPage.dart';
import 'findPetBreederspage.dart';
import 'findPetSitterspage.dart';
import 'developersPage.dart';  // Import the DeveloperPage
import 'package:provider/provider.dart';  // Import provider for accessing ApplicationState
import '../app_state.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'findPetpalspage.dart';
import 'loginpage.dart';
import 'userPictures.dart'; // Import the user_profiles.dart file to fetch the profile picture

class HamburgerMenu extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      // If no user is logged in, show default data
      return const Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Guest', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text('Please log in'),
              currentAccountPicture: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_placeholder.png'), // Default image
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFFCA4F),
              ),
            ),
            // Other ListTiles for unauthenticated users (you can adjust as per your app's need)
          ],
        ),
      );
    }

    // If the user is logged in, show their info
    String userEmail = currentUser.email ?? '';
    Map<String, dynamic> userProfile = userProfilePictures[userEmail] ?? {'image': 'assets/profile_placeholder.png', 'rating': 0.0};
    String profileImagePath = userProfile['image'] ?? 'assets/profile_placeholder.png';

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DocumentSnapshot>(  // Fetch user details from Firestore
            future: _firestore.collection('users').doc(currentUser.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  accountName: const Text('Loading...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  accountEmail: const Text('Please wait...'),
                  currentAccountPicture: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(profileImagePath), // Default image while loading
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFCA4F), // Header background
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return UserAccountsDrawerHeader(
                  accountName: const Text('Error', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  accountEmail: const Text('User data not found'),
                  currentAccountPicture: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(profileImagePath), // Default image in case of error
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFCA4F), // Header background
                  ),
                );
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String firstName = userData['firstName'] ?? 'First Name';
              String lastName = userData['lastName'] ?? 'Last Name';
              String fullName = '$firstName $lastName'; // Concatenate firstName and lastName
              String username = userData['username'] ?? 'No username'; // Get the username from Firestore
              String usernameWithAt = '@$username'; // Prepend '@' to the username

              return UserAccountsDrawerHeader(
                accountName: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                accountEmail: Text(usernameWithAt), // Display the username with '@'
                currentAccountPicture: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(profileImagePath), // Default image if not available
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCA4F), // Header background
                ),
              );
            },
          ),
          // ListTiles for authenticated users
          ListTile(
            title: const Text('MY ACCOUNT'),
            leading: const Icon(Icons.account_circle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourAccountPage()),
              );
            },
          ),
          ListTile(
            title: const Text('MY PALS'),
            leading: const Icon(Icons.pets),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          ),
          ListTile(
            title: const Text('FIND PALS'),
            leading: const Icon(Icons.search),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FindPetpals()),
              );
            },
          ),
          ListTile(
            title: const Text('FIND BREEDERS'),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindPetBreeders()),
              );
            },
          ),
          ListTile(
            title: const Text('FIND PET-SITTERS'),
            leading: const Icon(Icons.home_repair_service),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FindPetSitters()),
              );
            },
          ),
          ListTile(
            title: const Text('DEVELOPERS'),  // New item added for Developers Page
            leading: const Icon(Icons.code),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeveloperPage()),  // Navigate to DeveloperPage
              );
            },
          ),
          const Spacer(),
          ListTile(
            title: const Text(
              'LOG OUT',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              // Call logOut method from ApplicationState
              final appState = Provider.of<ApplicationState>(context, listen: false);
              appState.logOut();  // This will log out the user

              // Navigate to LandingPage after logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false, // This will remove all previous routes
              );
            },
          ),
        ],
      ),
    );
  }
}