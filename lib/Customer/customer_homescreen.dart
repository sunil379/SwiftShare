// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Customer/all_images_screen.dart';
import 'package:swiftshare_one/Customer/customer_trips.dart';
import 'package:swiftshare_one/Customer/customervehicleinfo.dart';
import 'package:swiftshare_one/Customer/navigation_drawer.dart';
import 'package:swiftshare_one/Customer/vehicle_details.dart';

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
      List<String> imageUrls,
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
          carImageUrls: imageUrls,
          carRating: carRating,
          carRenter: carRenter,
          carSeats: carSeats,
          carAC: carAC,
          carSafetyRating: carSafetyRating,
          carAddress: carAddress,
          carFuelInfo: carFuelInfo,
          carPrice: carPrice,
          carFeatures: carFeatures,
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
                  decoration: InputDecoration(
                    hintText: 'Search Vehicle',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.only(
                      left: 30,
                    ),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 24.0, left: 16.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildVehicleItem(
            context,
            'Car',
            [
              'assets/images/customer/acura_0.png',
              'assets/images/customer/honda_0.png',
              'assets/images/customer/camaro_0.png',
              'assets/images/customer/citroen_0.png',
            ],
          ),
          _buildVehicleItem(
            context,
            'Bike',
            [
              'assets/images/customer/acura_0.png',
              'assets/images/customer/honda_0.png',
              'assets/images/customer/camaro_0.png',
              'assets/images/customer/citroen_0.png',
            ],
          ),
          _buildVehicleItem(
            context,
            'Scooty',
            [
              'assets/images/customer/acura_0.png',
              'assets/images/customer/honda_0.png',
              'assets/images/customer/camaro_0.png',
              'assets/images/customer/citroen_0.png',
            ],
          ),
          _buildVehicleItem(
            context,
            'Electric Vehicle',
            [
              'assets/images/customer/acura_0.png',
              'assets/images/customer/honda_0.png',
              'assets/images/customer/camaro_0.png',
              'assets/images/customer/citroen_0.png',
            ],
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
      BuildContext context, String name, List<String> imageUrls) {
    // Placeholder vehicle details for each image
    Map<String, List<VehicleDetails>> initialDetailsMap = {
      'Car': [
        VehicleDetails(
          rating: '4.5',
          renter: 'Jay Sharma',
          seats: '4',
          ac: 'Yes',
          safetyRating: '5',
          address: '123 Street, City',
          fuelInfo: 'Petrol, 20 kmpl',
          price: '\$50 per day',
          features: ['Bluetooth', 'GPS', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Abhijit Banerjee',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Rohit Sharma',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Raj Verma',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
      ],
      'Bike': [
        VehicleDetails(
          rating: '4.0',
          renter: 'Dev Raj',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doer',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'James Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
      ],
      'Scooty': [
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
      ],
      'Electric Vehicle': [
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: '\$40 per day',
          features: ['Bluetooth', 'USB'],
        ),
      ] // Add details for other images as needed
    };

    // Fetch initial details based on the category name
    List<VehicleDetails> initialDetails = initialDetailsMap[name] ?? [];
    // Function to build the image widget
    Widget buildImageWidget(
        String imageUrl, String name, VehicleDetails details) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            _navigateToCarInfoPage(
              name,
              [imageUrl],
              details.rating,
              details.renter,
              details.seats,
              details.ac,
              details.safetyRating,
              details.address,
              details.fuelInfo,
              details.price,
              details.features,
            );
          },
          child: SizedBox(
            width: 360,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imageUrl,
                    height: 200,
                    width: 350,
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool wasSynchronouslyLoaded) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 4.0,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // List to hold all widgets (images + "See all" button if necessary)
    List<Widget> widgetsToShow = [];

    // Build widgets for initial 2 images
    List<Widget> initialImages =
        imageUrls.take(2).toList().asMap().entries.map((entry) {
      int index = entry.key;
      String imageUrl = entry.value;
      if (index < initialDetails.length) {
        return buildImageWidget(imageUrl, name, initialDetails[index]);
      } else {
        return Container(); // Return an empty container if no initial detail is available for this index
      }
    }).toList();

    // Add initial images to the list of widgets to show
    widgetsToShow.addAll(initialImages);

    if (imageUrls.length > 2) {
      widgetsToShow.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllImagesScreen(
                    name: name,
                    imageUrls: imageUrls,
                    vehicleDetails: initialDetails,
                  ),
                ),
              );
            },
            child: const Text(
              '> See all',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widgetsToShow,
            ),
          ),
          ListTile(
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
    );
  }
}
