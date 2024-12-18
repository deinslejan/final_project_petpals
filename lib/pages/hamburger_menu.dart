import 'package:flutter/material.dart';
import 'package:petpals/pages/chatPage.dart';
import 'package:petpals/pages/findPetBreederspage.dart';
import 'package:petpals/pages/findPetSitterspage.dart';
import 'package:petpals/pages/findPetpalspage.dart';
import 'package:petpals/pages/landingpage.dart';

class HamburgerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Lejan Juico',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text('@rumaraket'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/user_photo.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.amber, // Header background
            ),
          ),
          ListTile(
            title: Text('MY ACCOUNT'),
            leading: Icon(Icons.account_circle),
            onTap: () {},
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}