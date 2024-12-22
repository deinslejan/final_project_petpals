import 'package:flutter/material.dart';
import 'package:petpals/pages/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_state.dart';
import 'pages/chatPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Make sure to provide the correct options
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          if (appState.loggedIn) {
            return ChatPage(); // If logged in, show ChatPage
          } else {
            return SplashScreen(); // If not logged in, show LandingPage
          }
        },
      ),
    );
  }
}