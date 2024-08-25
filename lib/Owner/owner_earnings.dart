// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OwnerEarningsWidget extends StatefulWidget {
  const OwnerEarningsWidget({super.key});

  @override
  _OwnerEarningsWidgetState createState() => _OwnerEarningsWidgetState();
}

class _OwnerEarningsWidgetState extends State<OwnerEarningsWidget> {
  final OwnerEarnings ownerEarnings = OwnerEarnings();
  int _totalEarnings = 0;

  @override
  void initState() {
    super.initState();
    _fetchOwnerEarnings();
  }

  Future<void> _fetchOwnerEarnings() async {
    int earnings = await ownerEarnings.getOwnerEarnings(context);
    setState(() {
      _totalEarnings = earnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Earnings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Earnings: Rs $_totalEarnings',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class OwnerEarnings {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getOwnerEarnings(BuildContext context) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final String ownerId = currentUser.displayName ?? '';
      int totalEarnings = 0;

      // Fetch all bookings where the current user is the vehicle owner
      QuerySnapshot bookingsSnapshot = await _firestore
          .collectionGroup('bookings')
          .where('vehicleOwner', isEqualTo: ownerId)
          .get();

      for (var doc in bookingsSnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        int total = bookingData['total'] ?? 0;
        totalEarnings += total;
      }

      return totalEarnings;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error calculating owner earnings: $e'),
          // duration: const Duration(seconds: 3),
        ),
      );
      return 0;
    }
  }
}
