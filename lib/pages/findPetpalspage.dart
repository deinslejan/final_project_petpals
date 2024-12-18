import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';
import 'petProfile.dart';

class FindPetpals extends StatefulWidget {
  const FindPetpals({super.key});

  @override
  State<FindPetpals> createState() => _FindPetpalsState();
}

class _FindPetpalsState extends State<FindPetpals> {
  final List<Map<String, dynamic>> _sampleUsers = [
    {
      "name": "KKUMA",
      "breed": "Coton de Tulear",
      "location": "España, Manila",
      "image": "images/kkuma.png"
    },
    {
      "name": "BOKKEU",
      "breed": "Bichon Frise",
      "location": "España, Manila",
      "image": "images/bokkeu.png"
    },
    {
      "name": "SAPPHIRE",
      "breed": "Turkish Angora",
      "location": "BGC, Taguig",
      "image": "images/sapphire.png"
    },
    {
      "name": "BAM BOO",
      "breed": "Amazon Parrot",
      "location": "Litex, Quezon City",
      "image": "images/bamboo.png"
    },
    {
      "name": "MR. DARCY",
      "breed": "Hamster",
      "location": "España, Manila",
      "image": "images/darcy.png"
    },
    {
      "name": "ALVIN",
      "breed": "Hamster",
      "location": "Baguio",
      "image": "images/alvin.png"
    },
    {
      "name": "ALASTOR",
      "breed": "Siberian Husky",
      "location": "Tagaytay",
      "image": "images/alastor.png"
    },
    {
      "name": "CAPT. SPARROW",
      "breed": "Amazon Parrot",
      "location": "Bulakan, Bulacan",
      "image": "images/sparrow.png"
    },
    {
      "name": "SIMBA",
      "breed": "Persian Cat",
      "location": "Silang, Cavite",
      "image": "images/simba.png"
    },
  ];

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    _foundUsers = _sampleUsers; // Initialize with all pets
    super.initState();
  }

  // Filtering function
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _sampleUsers; // Show all pets if no keyword
    } else {
      results = _sampleUsers.where((user) {
        String userName = user["name"].toLowerCase().trim();
        String keyword = enteredKeyword.toLowerCase().trim();
        return userName.startsWith(keyword); // Match if the name starts with the entered keyword
      }).toList();
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
                        hintText: 'Search for Pet Breeders',
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
        body: _foundUsers.isNotEmpty
            ? ListView.separated(
          itemBuilder: (context, index) {
            final pet = _foundUsers[index];
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
                  backgroundImage: AssetImage(pet['image']),
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