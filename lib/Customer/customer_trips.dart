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
  bool showCurrentTrips = true;
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
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('My Trips'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerHomeScreen(),
                ),
                (route) => false);
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
          Row(
            children: [
              Expanded(
                child: _buildTabButton(
                    'Current Trip', Colors.blue, showCurrentTrips),
              ),
              Expanded(
                child: _buildTabButton(
                    'Upcoming Trips', Colors.green, !showCurrentTrips),
              ),
            ],
          ),
          Expanded(
            child: showCurrentTrips
                ? _buildTripList(currentTrips, Colors.blue)
                : _buildTripList(upcomingTrips, Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showCurrentTrips = title == 'Current Trip';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? color : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTripList(List<Map<String, dynamic>> trips, Color color) {
    return trips.isNotEmpty
        ? ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) =>
                buildTripCard(context, trips[index], color),
          )
        : Center(
            child: Text(
              'No ${showCurrentTrips ? 'current' : 'upcoming'} trips!',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          );
  }

  Widget buildTripCard(
      BuildContext context, Map<String, dynamic> booking, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: ${booking['bookingID']}',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              'Model: ${booking['modelName']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today, 'Pickup',
                '${booking['pickupDate'].day}/${booking['pickupDate'].month}/${booking['pickupDate'].year}'),
            _buildInfoRow(Icons.access_time, 'Pickup Time',
                booking['pickupTime'].format(context)),
            _buildInfoRow(Icons.calendar_today, 'Return',
                '${booking['returnDate'].day}/${booking['returnDate'].month}/${booking['returnDate'].year}'),
            _buildInfoRow(Icons.access_time, 'Return Time',
                booking['returnTime'].format(context)),
            _buildInfoRow(Icons.person, 'Owner', booking['ownerName']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
