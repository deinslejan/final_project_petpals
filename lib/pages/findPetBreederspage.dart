import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';

class FindPetBreeders extends StatefulWidget {
  const FindPetBreeders({super.key});

  @override
  State<FindPetBreeders> createState() => _FindPetBreedersState();
}

class _FindPetBreedersState extends State<FindPetBreeders> {
  final List<Map<String, dynamic>> _sampleUsers = [
    {
      "name": "DIEGO",
      "location": "Makati City",
      "image": "images/petBreeders/diego.png"
    },
    {
      "name": "MJ",
      "location": "BGC, Taguig",
      "image": "images/petBreeders/mj.png"
    },
    {
      "name": "MARK",
      "location": "Baguio City",
      "image": "images/petBreeders/mark.png"
    },
    {
      "name": "SAMUEL",
      "location": "Jaro, Iloilo",
      "image": "images/petBreeders/samuel.png"
    },
    {
      "name": "BEYONCE",
      "location": "España, Manila",
      "image": "images/petBreeders/beyonce.png"
    },
    {
      "name": "JAMES",
      "location": "Poblacion, Makati",
      "image": "images/alvin.png"
    },
    {
      "name": "GISELLE",
      "location": "Taft Ave, Manila",
      "image": "images/petBreeders/giselle.png"
    },
    {
      "name": "CHARLIE",
      "location": "España, Manila",
      "image": "images/petBreeders/charlie.png"
    },
  ];

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    _foundUsers = _sampleUsers;
    super.initState();
  }

  // Filtering function
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _sampleUsers; // Show all pets if no keyword
    } else {
      results = _sampleUsers
          .where((user) => user["name"]
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList(); // Filter by name
    }
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.jostTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 80, // Increase the AppBar height
          backgroundColor: const Color(0xFFFFCA4F),
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items
                children: [
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
                      // Placeholder for search button
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: HamburgerMenu(), // Add HamburgerMenu as drawer content
        body: _foundUsers.isNotEmpty
            ? ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                AssetImage(_foundUsers[index]['image']),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(thickness: 0.5);
          },
          itemCount: _foundUsers.length,
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