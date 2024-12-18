import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpals/components/stars.dart';

class FindPetSitters extends StatefulWidget {
  const FindPetSitters({super.key});

  @override
  State<FindPetSitters> createState() => _FindPetSittersState();
}

class _FindPetSittersState extends State<FindPetSitters> {
  final List<Map<String, dynamic>> sitters = [
    {
      "name": "MIGOY",
      "location": "San Jose del Monte, Bulacan",
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
      "location": "San Jose del Monte, Bulacan",
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

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    _foundUsers = sitters; // Initialize with all sitters
    super.initState();
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
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.grey),
                  onPressed: () {
                    // Placeholder for menu action
                  },
                ),
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
                  onPressed: () {
                    // Placeholder for search button
                  },
                ),
              ],
            ),
          ),
        ),
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
              trailing: StarRating(rating: _foundUsers[index]['rating']),
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
