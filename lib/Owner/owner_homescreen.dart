import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Owner/owner_account.dart';
import 'package:swiftshare_one/Owner/owner_earnings.dart';
import 'package:swiftshare_one/Owner/owner_notification.dart';
import 'package:swiftshare_one/Owner/navigation_drawer.dart';
import '../pages/settings_page.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _selectedIndex = 0;
  int _currentCarouselIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          // Handle Home button tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OwnerHomeScreen(),
            ),
          );
          break;
        case 1:
          // Handle Booking button tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountDetailsScreen(),
            ),
          );
          break;
        case 2:
          // Handle Earning button tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OwnerEarningsWidget(),
            ),
          );
          break;
        case 3:
          // Handle Account button tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountDetailsScreen(),
            ),
          );
          break;
      }
    });
  }

  // String _selectedLocation = 'Select Location';
  late String _userName = '';
  late String _email = '';
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    User? currentUser = user.currentUser;
    if (currentUser != null) {
      // Use current user's UID to fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'];
          _email = userDoc['email'];
        });
      }
    }
  }

  Widget _promotionbanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'This Festive Season\nYour Car is in Higher Demand\nYou Can Earn 400% Higher',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _shareButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text('Share Your Car with One-Click!',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _dateSelector() {
    return const Column(
      children: [
        Text('Share for next 6 days'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('14th Feb, Wed'),
            Icon(Icons.arrow_right),
            Text('20th Feb, Tue'),
          ],
        ),
        Text('151 Hrs'),
        SizedBox(height: 20),
        Text('Share for next 4 days'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('18th Feb, Wed'),
            Icon(Icons.arrow_right),
            Text('22nd Feb, Tue'),
          ],
        ),
        Text('94 Hrs'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<String> cities = [
    //   'Nagpur',
    //   'Mumbai',
    //   'Delhi',
    //   'Bangalore',
    //   'Chennai',
    //   'Kolkata',
    //   'Hyderabad',
    // ];
    List<String> carouselItems = [
      'assets/images/owner/Owner Add 1.png',
      'assets/images/owner/Owner Add 2.png',
      'assets/images/owner/Owner Add 3.png',
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey.shade900,
        title: Row(
          children: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 30,
                  ),
                  color: Colors.white,
                );
              },
            ),
            const Text(
              'SwiftShare',
              style: TextStyle(
                color: Color.fromARGB(255, 200, 2, 75),
                fontWeight: FontWeight.bold,
              ),
            ),
            // _buildLocationDropdown(cities), // Custom dropdown for location
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              color: Colors.white,
            )
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 4.0),
          CarouselSlider(
            items: carouselItems.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 10.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Image.asset(
                          imageUrl,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ));
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
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
          ),
          _promotionbanner(),
          _shareButton(),
          _dateSelector(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: carouselItems.map((imageUrl) {
              int index = carouselItems.indexOf(imageUrl);
              return Container(
                width: 10.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 2.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == index
                      ? Colors.black
                      : Colors.grey.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8.0),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8), // Adjust horizontal margin here
            child: Divider(
              thickness: 2.0, // Adjust the thickness of the line
              color: Colors.black, // Set the color of the line
            ),
          ),
        ],
      ),
      drawer: NavigationDrawers(
        initialUserName: _userName,
        initialEmail: _email,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Set item color to white
        unselectedItemColor: Colors.white, // Set item color to white
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_rounded),
            label: 'Booking',
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Earnings',
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: Colors.lightBlue,
          ),
        ],
      ),
    );
  }

  // Custom Dropdown Button for Location
  // Widget _buildLocationDropdown(List<String> cities) {
  //   return DropdownButton<String>(
  //     value: _selectedLocation,
  //     items: [
  //       const DropdownMenuItem<String>(
  //         value: 'Select Location',
  //         child: Text('Select Location'),
  //       ),
  //       ...cities.map((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value),
  //         );
  //       }),
  //     ],
  //     onChanged: (String? newValue) {
  //       setState(() {
  //         _selectedLocation = newValue!;
  //       });
  //     },
  //     hint: const Text('Select Location'),
  //   );
  // }
}
