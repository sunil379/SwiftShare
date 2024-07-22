import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Customer/customer_account.dart';
import 'package:swiftshare_one/Customer/customer_notification.dart';
import 'package:swiftshare_one/Customer/customer_trips.dart';
import 'package:swiftshare_one/Owner/navigation_drawer.dart';
import 'package:swiftshare_one/Customer/settings_page.dart';

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
        // case 1:
        //   // Handle Explore button tap
        //   // Navigate to Explore screen or perform relevant action
        //   break;
        case 1:
          // Handle Trips button tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyTripsPage(),
            ),
          );
          // Navigate to Trips screen or perform relevant action
          break;
        case 2:
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(
          //           20.0), // Adjust the border radius as needed
          //       border: Border.all(
          //         color: Colors.black, // Adjust the border color as needed
          //         width: 2.0, // Adjust the border width as needed
          //       ),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: TextField(
          //         decoration: InputDecoration(
          //           hintText: 'Search Vehicle',
          //           hintStyle: const TextStyle(fontSize: 16),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(15),
          //             borderSide: const BorderSide(
          //               width: 0,
          //               style: BorderStyle.none,
          //             ),
          //           ),
          //           filled: true,
          //           fillColor: Colors.grey[100],
          //           contentPadding: const EdgeInsets.only(
          //             left: 30,
          //           ),
          //           suffixIcon: const Padding(
          //             padding: EdgeInsets.only(right: 24.0, left: 16.0),
          //             child: Icon(
          //               Icons.search,
          //               color: Colors.black,
          //               size: 24,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
        backgroundColor: Colors.lightBlue, // Set background color to blue
        selectedItemColor: Colors.black, // Set item color to white
        unselectedItemColor: Colors.white, // Set item color to white
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.explore),
          //   label: 'Explore',
          //   backgroundColor: Colors.black,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Trips',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: Colors.black,
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
