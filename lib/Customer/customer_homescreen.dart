import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});
  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String _selectedLocation = 'Select Location';
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu_rounded),
            ),
            _buildLocationDropdown(cities), // Custom dropdown for location
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle),
            ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search Vehicle",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (String value) {},
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Trips',
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
    return DropdownButton(
      value: _selectedLocation,
      items: cities.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
        // Implement navigation to vehicle details page
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
            ),
            ListTile(
              title: Text(name),
              subtitle: Text(price),
              trailing: TextButton(
                onPressed: () {
                  // Implement rent now functionality
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
