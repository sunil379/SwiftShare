// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Customer/customer_trips.dart';
import 'package:swiftshare_one/Customer/customervehicleinfo.dart';
import 'package:swiftshare_one/Customer/navigation_drawer.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          // Handle Home button tap
          break;
        case 1:
          // Handle Explore button tap
          // Navigate to Explore screen or perform relevant action
          break;
        case 2:
          // Handle Trips button tap
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyTripsPage()));
          // Navigate to Trips screen or perform relevant action
          break;
        case 3:
          // Handle Account button tap
          // Navigate to Account screen or perform relevant action
          break;
      }
    });
  }

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
          .collection('customers')
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

  void _selectLocation(String? newValue) {
    setState(() {
      _selectedLocation = newValue ?? 'Select Location';
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      // Handle selected date
      print('Selected date : $picked');
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Handle selected date
      print('Selected time: $picked');
    }
  }

  void _submitReview() {
    // Implement review submission
    print('Review submitted');
  }

  void _navigateToCarInfoPage(
      String carName,
      String carImage,
      String carRating,
      String carRenter,
      String carSeats,
      String carAC,
      String carSafetyRating,
      String carAddress,
      String carFuelInfo,
      String carPrice,
      List<String> carFeatures) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarInfoPage(
          carName: carName,
          carImage: carImage,
          carRating: carRating,
          carRenter: carRenter,
          carSeats: carSeats,
          carAC: carAC,
          carSafetyRating: carSafetyRating,
          carAddress: carAddress,
          carFuelInfo: carFuelInfo,
          carPrice: carPrice,
          carFeatures: carFeatures,
          onSelectLocation: () {
            _selectLocation(_selectedLocation);
          },
          onSelectDate: () {
            _selectDate(context);
          },
          onSelectTime: () {
            _selectTime(context);
          },
        ),
      ),
    );
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
              'assets/images/customer/Customer Add 1.png',
              'assets/images/customer/Customer Add 2.png',
              'assets/images/customer/Customer Add 3.png',
              'assets/images/customer/Customer Add 4.png'
            ].map((String imageUrl) {
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    20.0), // Adjust the border radius as needed
                border: Border.all(
                  color: Colors.black, // Adjust the border color as needed
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search Vehicle",
                    border:
                        InputBorder.none, // Remove the default TextField border
                    suffixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (String value) {},
                ),
              ),
            ),
          ),
          _buildVehicleItem(context, 'Vehicle 1', 'Price 1',
              'assets/images/customer/Customer Add 1.png'),
          _buildVehicleItem(context, 'Vehicle 2', 'Price 2',
              'assets/images/customer/Customer Add 2.png'),
          _buildVehicleItem(context, 'Vehicle 3', 'Price 3',
              'assets/images/customer/Customer Add 3.png'),
        ],
      ),
      drawer: NavigationDrawers(
        initialUserName: _userName,
        initialEmail: _email,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue, // Set background color to blue
        selectedItemColor: Colors.white, // Set item color to white
        unselectedItemColor: Colors.white, // Set item color to white
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
            backgroundColor: Colors.black,
          ),
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

  Widget _buildVehicleItem(
      BuildContext context, String name, String price, String imageUrl) {
    return GestureDetector(
      onTap: () {
        _navigateToCarInfoPage(
            name,
            imageUrl,
            '4.5', // Placeholder for car rating
            'John Doe', // Placeholder for car renter
            '4', // Placeholder for car seats
            'Yes', // Placeholder for car AC
            '5', // Placeholder for car safety rating
            '123 Street, City', // Placeholder for car address
            'Petrol, 20 kmpl', // Placeholder for car fuel info
            '\$50 per day', // Placeholder for car price
            ['Bluetooth', 'GPS', 'USB'] // Placeholder for car features
            );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              frameBuilder: (BuildContext context, Widget child, int? frame,
                  bool wasSynchronouslyLoaded) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 6.0,
                    ),
                  ),
                  child: child,
                );
              },
            ),
            ListTile(
              title: Text(name),
              subtitle: Text(price),
              trailing: TextButton(
                onPressed: () {
                  _submitReview();
                },
                child: const Text(
                  'Rent Now',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
