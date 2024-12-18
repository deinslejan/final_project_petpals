import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.pink[200],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'images/kkuma.png',
                      fit: BoxFit.cover,
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.pinkAccent.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 10,
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          Text(
                            'KKUMA',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Bebas Neue',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'COTTON DE TULEAR',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '🐾Fluffy and fabulous!🐾',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Location: Makati City\nPronouns: She/Her\nLikes: Cuddles, chasing her tail, going on walks, playing with toys, belly rubs\nDislikes: Loud noises, being left alone for too long, bath time',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OWNER DETAILS',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Bebas Neue',
                                ),
                              ),
                              Text(
                                'Name: Seungcheol Choi',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Username: @sound_of_coups',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Location: España, Manila',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Pronouns: He/Him',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('images/seungcheol.jpg'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFECE6F0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Send me a message!',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
