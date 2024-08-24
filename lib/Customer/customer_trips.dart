// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/customer_homescreen.dart';

class MyTripsPage extends StatefulWidget {
  final List<Map<String, dynamic>> bookingStack;
  final bool isAfterNewBooking;
  const MyTripsPage(
      {super.key, required this.bookingStack, this.isAfterNewBooking = false});

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  List<Map<String, dynamic>> currentTrips = [];
  List<Map<String, dynamic>> upcomingTrips = [];

  @override
  void initState() {
    super.initState();
    _filterTrips();
  }

  void _filterTrips() {
    DateTime now = DateTime.now();
    setState(() {
      currentTrips = widget.bookingStack.where((booking) {
        return booking['pickupDate'].isBefore(now) &&
            booking['returnDate'].isAfter(now);
      }).toList();

      upcomingTrips = widget.bookingStack.where((booking) {
        return booking['pickupDate'].isAfter(now);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Trips'),
        leading: GestureDetector(
          onTap: () {
            if (widget.isAfterNewBooking) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerHomeScreen(),
                  ),
                  (route) => false);
            } else {
              Navigator.pop(context);
            }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Current Trips Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Trip',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  currentTrips.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            key: const PageStorageKey<String>('currentTrips'),
                            itemCount: currentTrips.length,
                            itemBuilder: (context, index) {
                              final booking = currentTrips[index];
                              return buildTripCard(context, booking);
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No current trip!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            // Upcoming Trips Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Trips',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  upcomingTrips.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            key: const PageStorageKey<String>('upcomingTrips'),
                            itemCount: upcomingTrips.length,
                            itemBuilder: (context, index) {
                              final booking = upcomingTrips[index];
                              return buildTripCard(context, booking);
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No upcoming trip!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build each trip card
  Widget buildTripCard(BuildContext context, Map<String, dynamic> booking) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Model: ${booking['modelName']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Pickup Date: ${booking['pickupDate'].day}/${booking['pickupDate'].month}/${booking['pickupDate'].year}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Pickup Time: ${booking['pickupTime'].format(context)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Return Date: ${booking['returnDate'].day}/${booking['returnDate'].month}/${booking['returnDate'].year}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Return Time: ${booking['returnTime'].format(context)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Owner Name: ${booking['ownerName']}',
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
