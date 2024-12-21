import 'package:flutter/material.dart';
import 'package:petpals/pages/yourAccount.dart';
import 'chatPage.dart';
import 'findPetBreederspage.dart';
import 'findPetSitterspage.dart';
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
      return Drawer(
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
                color: Colors.amber, // Header background
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
    double userRating = userProfile['rating'] ?? 0.0;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DocumentSnapshot>(  // Fetch user details from Firestore
            future: _firestore.collection('users').doc(currentUser.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  accountName: Text('Loading...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  accountEmail: Text('Please wait...'),
                  currentAccountPicture: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(profileImagePath), // Default image while loading
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber, // Header background
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return UserAccountsDrawerHeader(
                  accountName: Text('Error', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  accountEmail: Text('User data not found'),
                  currentAccountPicture: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(profileImagePath), // Default image in case of error
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber, // Header background
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
                accountName: Text(fullName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                accountEmail: Text(usernameWithAt), // Display the username with '@'
                currentAccountPicture: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(profileImagePath), // Default image if not available
                ),
                decoration: BoxDecoration(
                  color: Colors.amber, // Header background
                ),
              );
            },
          ),
          // ListTiles for authenticated users
          ListTile(
            title: Text('MY ACCOUNT'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YourAccountPage()),
              );
            },
          ),
          ListTile(
            title: Text('MY PALS'),
            leading: Icon(Icons.pets),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
          ListTile(
            title: Text('FIND PALS'),
            leading: Icon(Icons.search),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindPetpals()),
              );
            },
          ),
          ListTile(
            title: Text('FIND BREEDERS'),
            leading: Icon(Icons.people),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindPetBreeders()),
              );
            },
          ),
          ListTile(
            title: Text('FIND PET-SITTERS'),
            leading: Icon(Icons.home_repair_service),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindPetSitters()),
              );
            },
          ),
          Spacer(),
          ListTile(
            title: Text(
              'LOG OUT',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.logout, color: Colors.red),
            onTap: () {
              // Call logOut method from ApplicationState
              final appState = Provider.of<ApplicationState>(context, listen: false);
              appState.logOut();  // This will log out the user

              // Navigate to LandingPage after logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false, // This will remove all previous routes
              );
            },
          ),
        ],
      ),
    );
  }
}