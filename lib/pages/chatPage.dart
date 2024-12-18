import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageFilter();
}

class _ChatPageFilter extends State<ChatPage> {
  // Data for each category
  final List<Map<String, dynamic>> _petPals = [
    {
      "name": "KKUMA",
      "location": "España, Manila",
      "image": "images/kkuma.png"
    },
    {
      "name": "BOKKEU",
      "location": "España, Manila",
      "image": "images/bokkeu.png"
    },
    {
      "name": "SAPPHIRE",
      "location": "BGC, Taguig",
      "image": "images/sapphire.png"
    },
    {
      "name": "BAM BOO",
      "location": "Litex, Quezon City",
      "image": "images/bamboo.png"
    },
    {
      "name": "MR. DARCY",
      "location": "España, Manila",
      "image": "images/darcy.png"
    },
    {"name": "ALVIN", "location": "Baguio", "image": "images/alvin.png"},
    {"name": "ALASTOR", "location": "Tagaytay", "image": "images/alastor.png"},
    {
      "name": "CAPT. SPARROW",
      "location": "Bulakan, Bulacan",
      "image": "images/sparrow.png"
    },
    {
      "name": "SIMBA",
      "location": "Silang, Cavite",
      "image": "images/simba.png"
    },
  ];

  final List<Map<String, dynamic>> _petBreeders = [
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

  final List<Map<String, dynamic>> _petSitters = [
    {
      "name": "MIGOY",
      "location": "Bulacan",
      "image": "images/petSitters/mingyu.png"
    },
    {
      "name": "BASTI",
      "location": "España, Manila",
      "image": "images/petSitters/jeno.png"
    },
    {
      "name": "LEJAN",
      "location": "Novaliches, Quezon City",
      "image": "images/petSitters/lejan.png"
    },
    {
      "name": "JAMIE",
      "location": "Makati City",
      "image": "images/petSitters/jamie.png"
    },
    {
      "name": "JELO",
      "location": "España, Manila",
      "image": "images/petSitters/jeonghan.png"
    },
    {
      "name": "BEA",
      "location": "San Jose del Monte, Bulacan",
      "image": "images/petSitters/bea.png"
    },
    {
      "name": "HANBIN",
      "location": "Valenzuela",
      "image": "images/petSitters/haobin1.png"
    },
    {
      "name": "HAO",
      "location": "Valenzuela",
      "image": "images/petSitters/haobin2.png"
    },
  ];

  List<Map<String, dynamic>> _foundUsers = [];
  String _selectedRole = "ALL";

  @override
  void initState() {
    _filterByRole("ALL");
    super.initState();
  }

  void _filterByRole(String role) {
    List<Map<String, dynamic>> results;
    switch (role) {
      case "PETPALS":
        results = _petPals;
        break;
      case "BREEDERS":
        results = _petBreeders;
        break;
      case "SITTERS":
        results = _petSitters;
        break;
      default:
        results = [..._petPals, ..._petBreeders, ..._petSitters];
    }

    setState(() {
      _selectedRole = role;
      _foundUsers = results;
    });
  }

  void _runFilter(String query) {
    List<Map<String, dynamic>> results = [];

    if (query.isEmpty) {
      // If search is empty, reset the filter
      _filterByRole(_selectedRole);
    } else {
      // Select the active list based on the current role
      List<Map<String, dynamic>> activeList;

      switch (_selectedRole) {
        case "PETPALS":
          activeList = _petPals;
          break;
        case "BREEDERS":
          activeList = _petBreeders;
          break;
        case "SITTERS":
          activeList = _petSitters;
          break;
        default:
          activeList = [..._petPals, ..._petBreeders, ..._petSitters];
      }

      // Filter users where the name starts with the search keyword
      results = activeList.where((user) {
        String userName =
            user["name"]?.toLowerCase().trim() ?? ""; // Safely handle null
        String keyword = query.toLowerCase().trim();
        print('Comparing: "$userName" starts with "$keyword"'); // Debugging log
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
      theme: ThemeData(
          textTheme: GoogleFonts.jostTextTheme()), // Apply the Jost font
      home: Scaffold(
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
                      onChanged: (value) =>
                          _runFilter(value), // Search function
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
                      // Placeholder for search button functionality
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
                            style: const TextStyle(fontSize: 16),
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
            ),
          ],
        ),
      ),
    );
  }
}
