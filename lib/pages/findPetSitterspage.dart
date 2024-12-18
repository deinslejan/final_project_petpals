import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpals/components/stars.dart';
import 'package:petpals/pages/hamburger_menu.dart'; // Import your HamburgerMenu.

class FindPetSitters extends StatefulWidget {
  const FindPetSitters({super.key});

  @override
  State<FindPetSitters> createState() => _FindPetSittersState();
}

class _FindPetSittersState extends State<FindPetSitters> {
  final List<Map<String, dynamic>> sitters = [
    {
      "name": "MIGOY",
      "location": "CSJDM, Bulacan",
      "rating": 5,
      "image": "images/petSitters/mingyu.png"
    },
    {
      "name": "BASTI",
      "location": "España, Manila",
      "rating": 4,
      "image": "images/petSitters/jeno.png"
    },
    {
      "name": "LEJAN",
      "location": "Novaliches, Quezon City",
      "rating": 3,
      "image": "images/petSitters/lejan.png"
    },
    {
      "name": "JAMIE",
      "location": "Makati City",
      "rating": 2,
      "image": "images/petSitters/jamie.png"
    },
    {
      "name": "JELO",
      "location": "España, Manila",
      "rating": 1,
      "image": "images/petSitters/jeonghan.png"
    },
    {
      "name": "BEA",
      "location": "CSJDM, Bulacan",
      "rating": 0,
      "image": "images/petSitters/bea.png"
    },
    {
      "name": "HANBIN",
      "location": "Valenzuela",
      "rating": 0,
      "image": "images/petSitters/haobin1.png"
    },
    {
      "name": "HAO",
      "location": "Valenzuela",
      "rating": 0,
      "image": "images/petSitters/haobin2.png"
    },
  ];

  // Filtered users list.
  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    super.initState();
    _foundUsers = sitters; // Initially display all sitters.
  }

  // Filtering function
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    print('Entered Keyword: "$enteredKeyword"'); // Debugging the entered keyword

    if (enteredKeyword.isEmpty) {
      results = sitters; // Show all pets if no keyword
    } else {
      results = sitters
          .where((user) {
        String userName = user["name"].toLowerCase().trim(); // Trimmed user name
        String keyword = enteredKeyword.toLowerCase().trim(); // Trimmed entered keyword
        print('Comparing: "$userName" starts with "$keyword"'); // Debugging the comparison
        return userName.startsWith(keyword); // Match if the name starts with the entered keyword
      })
          .toList(); // Filter by name starting with entered keyword
    }
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.jostTextTheme(), // Use Google Fonts for consistent styling.
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
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
                  Expanded(
                    child: TextField(
                      onChanged: _runFilter,
                      decoration: const InputDecoration(
                        hintText: 'Search for Pet Sitters',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
        drawer: HamburgerMenu(), // Replace with the HamburgerMenu widget.
        body: _foundUsers.isNotEmpty
            ? ListView.separated(
          itemCount: _foundUsers.length,
          itemBuilder: (context, index) {
            final user = _foundUsers[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundImage: AssetImage(user['image']),
                radius: 30,
              ),
              title: Text(
                user['name'],
                style: const TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user['location'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: SizedBox(
                width: 100, // Constrain the width of the star rating.
                child: StarRating(rating: user['rating']),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            thickness: 0.5,
          ),
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