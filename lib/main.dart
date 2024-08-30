import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Customer/customer_homescreen.dart';
import 'package:swiftshare_one/Owner/owner_homescreen.dart';
import 'package:swiftshare_one/pages/app_start.dart';
import 'Vehicle Details/vehicle_info.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirestoreService firestoreService = FirestoreService();
  await firestoreService.addVehicleDetailsToFirestore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getUserRole(User user) async {
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection('customers')
        .doc(user.uid)
        .get();

    if (customerSnapshot.exists) {
      return 'customer';
    }

    DocumentSnapshot ownerSnapshot = await FirebaseFirestore.instance
        .collection('owners')
        .doc(user.uid)
        .get();

    if (ownerSnapshot.exists) {
      return 'owner';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            if (user != null) {
              return FutureBuilder<String?>(
                future: _getUserRole(user),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (roleSnapshot.hasData) {
                    final roleNotifier =
                        ValueNotifier<String?>(roleSnapshot.data);
                    return ValueListenableBuilder<String?>(
                      valueListenable: roleNotifier,
                      builder: (context, role, _) {
                        if (role == 'customer') {
                          return const CustomerHomeScreen();
                        } else if (role == 'owner') {
                          return const OwnerHomeScreen();
                        } else {
                          return const EntryScreen();
                        }
                      },
                    );
                  } else {
                    return const EntryScreen();
                  }
                },
              );
            } else {
              return const EntryScreen();
            }
          } else {
            return const EntryScreen();
          }
        },
      ),
    );
  }
}
