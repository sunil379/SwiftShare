// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Booking {
  final String id;
  final String customerName;
  final String vehicleName;
  final DateTime bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.customerName,
    required this.vehicleName,
    required this.bookingDate,
    required this.status,
  });

  factory Booking.fromMap(Map<String, dynamic> data) {
    return Booking(
      id: data['id'] ?? '',
      customerName: data['customerName'] ?? '',
      vehicleName: data['vehicleName'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      status: data['status'] ?? '',
    );
  }
}

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  _OwnerBookingsScreenState createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String ownerName;

  @override
  void initState() {
    super.initState();
    _fetchOwnerName();
  }

  Future<void> _fetchOwnerName() async {
    var ownerDoc =
        await _firestore.collection('owners').doc(_auth.currentUser!.uid).get();
    setState(() {
      ownerName =
          ownerDoc['name']; // assuming the field storing owner's name is 'name'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      // ignore: unnecessary_null_comparison
      body: ownerName == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('customers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                List<Booking> ownerBookings = [];

                for (var customerDoc in snapshot.data!.docs) {
                  var bookingsCollection =
                      customerDoc.reference.collection('bookings');

                  bookingsCollection
                      .where('vehicleOwner', isEqualTo: ownerName)
                      .get()
                      .then((querySnapshot) {
                    for (var bookingDoc in querySnapshot.docs) {
                      var bookingData = bookingDoc.data();
                      var booking = Booking.fromMap(bookingData);
                      setState(() {
                        ownerBookings.add(booking);
                      });
                    }
                  });
                }

                if (ownerBookings.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  itemCount: ownerBookings.length,
                  itemBuilder: (context, index) {
                    var booking = ownerBookings[index];
                    return ListTile(
                      title: Text('Booking ID: ${booking.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer: ${booking.customerName}'),
                          Text('Vehicle: ${booking.vehicleName}'),
                          Text('Date: ${booking.bookingDate.toLocal()}'),
                        ],
                      ),
                      trailing: Text('Status: ${booking.status}'),
                      onTap: () {
                        // Navigate to booking details page
                        // You can implement this later
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
