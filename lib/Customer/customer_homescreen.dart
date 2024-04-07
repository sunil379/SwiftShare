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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerHomeScreen(),
            ),
          );
          break;
        case 1:
          // Handle Explore button tap
          // Navigate to Explore screen or perform relevant action
          break;
        case 2:
          // Handle Trips button tap
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyTripsPage(),
            ),
          );
          // Navigate to Trips screen or perform relevant action
          break;
        case 3:
          // Handle Account button tap
          // Navigate to Account screen or perform relevant action
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
      String model,
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
          model: model,
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
    // List<String> cities = [
    //   'Nagpur',
    //   'Mumbai',
    //   'Delhi',
    //   'Bangalore',
    //   'Chennai',
    //   'Kolkata',
    //   'Hyderabad',
    // ];

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
                  icon: const Icon(Icons.menu_rounded),
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
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
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
          const SizedBox(height: 7.0),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20), // Adjust horizontal margin here
            child: Divider(
              thickness: 1.5, // Adjust the thickness of the line
              color: Colors.black, // Set the color of the line
            ),
          ),
          _buildVehicleItem(
            context,
            'Car',
            [
              'assets/images/cars/c1.jpeg',
              'assets/images/cars/n1.jpeg',
              'assets/images/cars/t1.jpeg',
              'assets/images/cars/x1.jpeg',
            ],
          ),
          _buildVehicleItem(
            context,
            'Bike',
            [
              'assets/images/bikes/l1.jpg',
              'assets/images/bikes/h1.jpg',
              'assets/images/bikes/sp1.jpg',
            ],
          ),
          _buildVehicleItem(
            context,
            'Scooty',
            [
              'assets/images/scooty/a1.jpg',
              'assets/images/scooty/p1.jpg',
              'assets/images/scooty/a3.jpg',
              'assets/images/scooty/a4.jpeg',
            ],
          ),
          _buildVehicleItem(
            context,
            'Electric Vehicle',
            [
              'assets/images/ev/tesla_1.png',
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
          address: '1600 Amphitheatre Parkway, Mountain View, CA',
          fuelInfo: 'Petrol, 20 kmpl',
          price: 'Rs 50 per day',
          features: ['Bluetooth', 'GPS', 'USB'],
          model: 'Honda City',
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Abhijit Banerjee',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: 'Rs 40 per day',
          features: ['Bluetooth', 'USB'],
          model: 'Tata Nexon',
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Rohit Sharma',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: 'Rs 40 per day',
          features: ['Bluetooth', 'USB'],
          model: 'Mahaindra Thar',
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Raj Verma',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: 'Rs 40 per day',
          features: ['Bluetooth', 'USB'],
          model: 'Mahindra XUV',
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
          price: 'Rs 40 per day',
          features: ['Bluetooth', 'USB'],
          model: 'Livo',
        ),
        VehicleDetails(
          rating: '4.0',
          renter: 'Jane Doe',
          seats: '2',
          ac: 'Yes',
          safetyRating: '4',
          address: '456 Street, City',
          fuelInfo: 'Diesel, 15 kmpl',
          price: 'Rs 40 per day',
          features: ['Bluetooth', 'USB'],
          model: 'Splendor',
        ),
        VehicleDetails(
          rating: '4.8',
          renter: 'John Smith',
          seats: '5',
          ac: 'Yes',
          safetyRating: '5',
          address: '789 Avenue, Town',
          fuelInfo: 'Petrol, 25 kmpl',
          price: 'Rs 60 per day',
          features: ['Bluetooth', 'GPS', 'USB', 'Sunroof'],
          model: 'SP125',
        ),
        VehicleDetails(
          rating: '4.2',
          renter: 'Emily Johnson',
          seats: '4',
          ac: 'Yes',
          safetyRating: '4',
          address: '321 Boulevard, City',
          fuelInfo: 'Diesel, 18 kmpl',
          price: 'Rs 45 per day',
          features: ['Bluetooth', 'USB', 'Parking Sensors'],
          model: '',
        ),
      ],
      'Scooty': [
        VehicleDetails(
          rating: '4.5',
          renter: 'Alex Brown',
          seats: '2',
          ac: 'No',
          safetyRating: '4',
          address: '987 Road, Village',
          fuelInfo: 'Petrol, 30 kmpl',
          price: 'Rs 30 per day',
          features: ['Bluetooth', 'USB', 'Helmet Included'],
          model: 'Activa 2020',
        ),
        VehicleDetails(
          rating: '4.3',
          renter: 'Sophia Garcia',
          seats: '2',
          ac: 'No',
          safetyRating: '4',
          address: '654 Lane, Suburb',
          fuelInfo: 'Petrol, 25 kmpl',
          price: 'Rs 35 per day',
          features: ['Bluetooth', 'USB', 'Phone Mount'],
          model: 'Pleasure',
        ),
        VehicleDetails(
          rating: '4.4',
          renter: 'Olivia Martinez',
          seats: '1',
          ac: 'No',
          safetyRating: '4',
          address: '456 Avenue, Park',
          fuelInfo: 'Electric, 50 kmpl',
          price: 'Rs 20 per day',
          features: ['Bluetooth', 'USB', 'Locking Mechanism'],
          model: 'Activa 2018',
        ),
        VehicleDetails(
          rating: '4.7',
          renter: 'Michael Miller',
          seats: '1',
          ac: 'No',
          safetyRating: '4',
          address: '123 Street, Downtown',
          fuelInfo: 'Electric, 60 kmpl',
          price: 'Rs 25 per day',
          features: ['Bluetooth', 'USB', 'Portable Charger'],
          model: 'Activa 2019',
        ),
      ],
      'Electric Vehicle': [
        VehicleDetails(
          rating: '4.6',
          renter: 'William Taylor',
          seats: '4',
          ac: 'Yes',
          safetyRating: '5',
          address: '789 Boulevard, Lake',
          fuelInfo: 'Electric, 300 km range',
          price: 'Rs 80 per day',
          features: ['Bluetooth', 'USB', 'Autopilot'],
          model: 'Tesla',
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
              details.model,
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
            child: Row(
              children: [
                Container(
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
                      )),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
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
