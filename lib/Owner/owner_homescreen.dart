import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/owner/navigation_drawer.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});
  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  String _selectedLocation = 'Select Location';
  late String _userName = '';
  late String _email = '';
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Use current user's UID to fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'];
          _email = userDoc['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> cities = [
      'Nagpur',
      'Mumbai',
      'Delhi',
      'Bangalore',
      'Chennai',
      'Kolkata',
      'Hyderabad',
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu_rounded),
              );
            }),
            _buildLocationDropdown(cities), // Custom dropdown for location
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            )
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          CarouselSlider(
            items: const [
              'assets/images/owner/Owner Add 1.png',
              'assets/images/owner/Owner Add 2.png',
              'assets/images/owner/Owner Add 3.png',
              'assets/images/owner/Owner Add 4.png'
            ].map((String imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
        ],
      ),
      drawer: NavigationDrawers(
        initialUserName: _userName,
        initialEmail: _email,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  // Custom Dropdown Button for Location
  Widget _buildLocationDropdown(List<String> cities) {
    return DropdownButton<String>(
      value: _selectedLocation,
      items: [
        const DropdownMenuItem<String>(
          value: 'Select Location',
          child: Text('Select Location'),
        ),
        ...cities.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _selectedLocation = newValue!;
        });
      },
      hint: const Text('Select Location'),
    );
  }
}
