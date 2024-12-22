import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  ApplicationState() {
    _initializeFirebaseAuth();
  }

  Future<void> _initializeFirebaseAuth() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Listen for auth state changes
      FirebaseAuth.instance.authStateChanges().listen((user) {
        _loggedIn = user != null; // If user is not null, user is logged in
        notifyListeners(); // Notify listeners that the state has changed
      });

      // Set the initial auth state
      User? user = FirebaseAuth.instance.currentUser;
      _loggedIn = user != null;
      notifyListeners(); // Notify listeners after setting the initial state

    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  // Method to log out
  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}