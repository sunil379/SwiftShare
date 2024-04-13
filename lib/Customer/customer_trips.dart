// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyTripsPage extends StatefulWidget {
  final String? modelName;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;
  final String? ownerName;

  const MyTripsPage({
    super.key,
    this.modelName,
    this.pickupDate,
    this.pickupTime,
    this.ownerName,
  });

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Current Trip'),
        leading: GestureDetector(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
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
        child: widget.modelName != null &&
                widget.pickupDate != null &&
                widget.pickupTime != null &&
                widget.ownerName != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model: ${widget.modelName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pickup Date: ${widget.pickupDate!.day}/${widget.pickupDate!.month}/${widget.pickupDate!.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pickup Time: ${widget.pickupTime!.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Owner Name: ${widget.ownerName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : const Center(
                child: Text(
                  'No trips yet!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
