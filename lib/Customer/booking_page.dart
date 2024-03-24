// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/maps.dart';

class BookingPage extends StatefulWidget {
  final String carName;
  final String carRating;
  final String carRenter;
  final String carSeats;
  final String carAC;
  final String carSafetyRating;
  final String carAddress;
  final String carFuelInfo;
  final String carPrice;
  final List<String> carFeatures;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const BookingPage({
    super.key,
    required this.carName,
    required this.carRating,
    required this.carRenter,
    required this.carSeats,
    required this.carAC,
    required this.carSafetyRating,
    required this.carAddress,
    required this.carFuelInfo,
    required this.carPrice,
    required this.carFeatures,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        actions: [
          IconButton(
              onPressed: () {
                _showMaps();
              },
              icon: const Icon(Icons.map))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details for ${widget.carName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pickup Date: ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pickup Time: ${widget.selectedTime.format(context)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Renter Name: ${widget.carRenter}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${widget.carPrice}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Payment Option: Cash on Delivery',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _confirmBooking,
              child: const Text('Confirm Booking'),
            ),
            const SizedBox(height: 16),
            // Integrate Maps widget here
            const Maps(),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    // Implement booking functionality here
    // For example, you can show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmation'),
        content: Text('You have successfully booked ${widget.carName}'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate back to the previous screen or any other action
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMaps() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Maps()),
    );
  }
}
