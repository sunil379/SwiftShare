// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swiftshare_one/Customer/customer_account.dart';
import 'package:swiftshare_one/Customer/customer_login.dart';
import 'package:swiftshare_one/Customer/customer_rateapp.dart';
import 'package:swiftshare_one/Customer/customer_refer_earn.dart';

class NavigationDrawers extends StatefulWidget {
  final String initialUserName;
  final String initialEmail;

  const NavigationDrawers({
    super.key,
    required this.initialEmail,
    required this.initialUserName,
  });

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawers> {
  late String userName;
  late String email;

  @override
  void initState() {
    super.initState();
    userName = widget.initialUserName;
    email = widget.initialEmail;
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CustomerLoginScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 300, // Adjust the height as needed
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/image-9.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Colors.purple,
            ),
            title: const Text(
              'My Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountDetailsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.yellow,
            ),
            title: const Text(
              'About Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Colors.deepOrange,
            ),
            title: const Text(
              'Refer & Earn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReferAndEarnScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.star_outline_sharp,
              color: Colors.blue,
            ),
            title: const Text(
              'Rate App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RateApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _signOut();
            },
          ),
        ],
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            width: 400,
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/rectangle-7.png'),
                  width: 150,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Text(
                  'SWIFTSHARE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 500,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                child: Text(
                  "SwiftShare is a platform designed to simplify and streamline the process of renting various types of vehicles. With a diverse fleet of bikes, scooters, cars, and e-vehicles.\n\n SwiftShare ensures a seamless experience from browsing required vehicles to quick reservation. Offering flexible rental options ranging from hourly, weekly to monthly durations.\n\n SwiftShare caters to both locals and tourists, offering a convenient and eco-friendly alternative to traditional transportation methods.",
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
