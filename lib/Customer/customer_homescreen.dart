// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Customer/all_images_screen.dart';
import 'package:swiftshare_one/Customer/customer_account.dart';
import 'package:swiftshare_one/Customer/customer_notification.dart';
import 'package:swiftshare_one/Customer/customer_trips.dart';
import 'package:swiftshare_one/Customer/customervehicleinfo.dart';
import 'package:swiftshare_one/Customer/navigation_drawer.dart';
import 'package:swiftshare_one/pages/settings_page.dart';
import 'package:swiftshare_one/Vehicle%20Details/vehicle_details.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
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
              builder: (context) => const CustomerHomeScreen(),
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
              builder: (context) => const MyTripsPage(
                bookingStack: [],
              ),
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
          .collection('customers')
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

  void _navigateToVehicleInfoPage(
    List<String> vehicleimageUrls,
    String vehicleName,
    VehicleDetails vehicleDetails,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleInfoPage(
          vehicleName: vehicleName,
          vehicleImageUrls: vehicleimageUrls,
          vehicleDetails: vehicleDetails,
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
    List<String> carouselItems = [
      'assets/images/customer/Customer Add 1.png',
      'assets/images/customer/Customer Add 2.png',
      'assets/images/customer/Customer Add 3.png',
      'assets/images/customer/Customer Add 4.png',
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
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8), // Adjust horizontal margin here
            child: Divider(
              thickness: 2.0, // Adjust the thickness of the line
              color: Colors.black, // Set the color of the line
            ),
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
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8), // Adjust horizontal margin here
            child: Divider(
              thickness: 2.0, // Adjust the thickness of the line
              color: Colors.black, // Set the color of the line
            ),
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
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8), // Adjust horizontal margin here
            child: Divider(
              thickness: 2.0, // Adjust the thickness of the line
              color: Colors.black, // Set the color of the line
            ),
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

  Widget _buildVehicleItem(
    BuildContext context,
    String name,
    List<String> imageUrls,
  ) {
    // Placeholder vehicle details for each image
    Map<String, List<VehicleDetails>> details = VehicleData.initialDetailsMap;

    // Fetch initial details based on the category name
    List<VehicleDetails> initialDetails = details[name] ?? [];

    // Function to build the image widget
    Widget buildImageWidget(
        String imageUrl, String name, VehicleDetails details) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            _navigateToVehicleInfoPage(
                [imageUrl],
                name,
                VehicleDetails(
                  vehicle_rating: details.vehicle_rating,
                  vehicle_renter: details.vehicle_renter,
                  vehicle_model: details.vehicle_model,
                  vehicle_seats: details.vehicle_seats,
                  vehicle_ac: details.vehicle_ac,
                  vehicle_safetyRating: details.vehicle_safetyRating,
                  vehicle_address: details.vehicle_address,
                  vehicle_fuelInfo: details.vehicle_fuelInfo,
                  vehicle_price: details.vehicle_price,
                  vehicle_features: details.vehicle_features,
                  vehicle_type: details.vehicle_type,
                ));
          },
          child: SizedBox(
            width: 360,
            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imageUrl,
                        height: 220,
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
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        alignment: Alignment.center,
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () {
                            _navigateToVehicleInfoPage(
                              [imageUrl],
                              name,
                              details,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Rent Now",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        ],
      ),
    );
  }
}
