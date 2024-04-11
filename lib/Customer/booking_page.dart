// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatefulWidget {
  final String carName;
  final String carRating;
  final String carRenter;
  final String model;
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
    required this.model,
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
  bool _locationButtonClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                )),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ),
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
              'Owner Name : ${widget.carRenter}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price : ${widget.carPrice}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Address : ${widget.carAddress}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Google Maps with the address
                _openGoogleMaps(widget.carAddress);
              },
              child: const Text('See Location'),
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
              onPressed: _locationButtonClicked ? _confirmBooking : null,
              child: const Text('Confirm Booking'),
            ),
            const SizedBox(height: 16),
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
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate back to the previous screen or any other action
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to open Google Maps with a specific address
  // Function to open Google Maps with a specific address
  Future<void> _openGoogleMaps(String address) async {
    // Encode the address for the URL
    final encodedAddress = Uri.encodeComponent(address);
    // Create the Google Maps URL with the encoded address
    final url =
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    // Launch the URL
    if (await canLaunch(url)) {
      await launch(url);
      setState(() {
        _locationButtonClicked = true;
      });
    } else {
      throw 'Could not launch $url';
    }
  }
}
