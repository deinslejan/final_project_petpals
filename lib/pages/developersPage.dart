import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hamburger_menu.dart';  // Make sure to import the HamburgerMenu widget

class DeveloperPage extends StatefulWidget {
  @override
  _DeveloperPageState createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  String _selectedSource = "ALL";

  final List<Map<String, String>> _youtubeSources = [
    {"title": "Flutter for Beginners", "link": "https://youtube.com/example1"},
    {"title": "State Management", "link": "https://youtube.com/example2"},
  ];

  final List<Map<String, String>> _websiteSources = [
    {"title": "Official Flutter Docs", "link": "https://flutter.dev"},
    {"title": "Dart Language", "link": "https://dart.dev"},
  ];

  List<Map<String, String>> _filteredSources = [];

  @override
  void initState() {
    super.initState();
    _filterSources(); // Initialize with "ALL"
  }

  void _filterSources() {
    if (_selectedSource == "ALL") {
      _filteredSources = [..._youtubeSources, ..._websiteSources];
    } else if (_selectedSource == "YOUTUBE") {
      _filteredSources = _youtubeSources;
    } else if (_selectedSource == "WEBSITES") {
      _filteredSources = _websiteSources;
    }
    setState(() {});
  }

  Widget _buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedSource = label;
          _filterSources();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
        _selectedSource == label ? Colors.black : Colors.grey[400],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
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
          backgroundColor: Colors.amber,
          title: Text(
            'PETPAL DEVELOPERS',
            style: GoogleFonts.jost(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: HamburgerMenu(),  // Integrate the HamburgerMenu here
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const DeveloperCard(
              name: 'Alejandra Kristina B. Juico',
              imagePath: 'images/petSitters/lejan.png',
            ),
            const DeveloperCard(
              name: 'Bea Andrea P. Gamilong',
              imagePath: 'images/petSitters/bea.png',
            ),
            const DeveloperCard(
              name: 'Jamie Danielle E. Jalandoni',
              imagePath: 'images/petSitters/jamie.png',
            ),
            const SizedBox(height: 20),
            const Text(
              'Sources:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton("ALL"),
                const SizedBox(width: 10),
                _buildFilterButton("YOUTUBE"),
                const SizedBox(width: 10),
                _buildFilterButton("WEBSITES"),
              ],
            ),
            const SizedBox(height: 20),
            ..._filteredSources.map((source) {
              return ListTile(
                title: Text(source["title"] ?? ""),
                subtitle: Text(source["link"] ?? ""),
                onTap: () {
                  // Add link functionality (e.g., open in browser)
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const DeveloperCard({
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}