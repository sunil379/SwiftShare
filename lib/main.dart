import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiftshare_one/pages/app_start.dart';
import 'package:swiftshare_one/Customer/customer_homescreen.dart'; // Import your home screen file
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Waiting for Firebase Authentication to check the state
            return const CircularProgressIndicator(); // or a loading screen
          } else {
            if (snapshot.hasData) {
              // User is already logged in, navigate to HomeScreen
              return const CustomerHomeScreen();
            } else {
              // User is not logged in, navigate to EntryScreen
              return const EntryScreen();
            }
          }
        },
      ),
    );
  }
}
