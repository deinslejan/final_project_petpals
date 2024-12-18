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

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    _foundUsers = sitters;
    super.initState();
  }

  // Filtering function
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = sitters;
    } else {
      results = sitters
          .where((user) => user["name"]
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
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
            toolbarHeight: 80,
          backgroundColor: const Color(0xFFFFCA4F),
          title: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
        ),
        body: _foundUsers.isNotEmpty
            ? ListView.separated(
          itemCount: _foundUsers.length,
          itemBuilder: (context, index) {
            return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                backgroundImage: AssetImage(_foundUsers[index]['image']),
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
            _foundUsers[index]['location'],
            style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            ),
            ),
            trailing: SizedBox(
            width: 100, // Constrain the width of the star rating
            child: StarRating(rating: _foundUsers[index]['rating']),
            ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(thickness: 0.5);
          },
        )
            : const Center(
          child: Text('No results found'),
        ),
      ),
    );
  }
}