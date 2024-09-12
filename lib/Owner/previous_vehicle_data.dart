// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'vehicle_controller.dart';

class PreviousVehicleData {
  static Future<void> showPreviousData(
      BuildContext context, String ownerId) async {
    Get.find<VehicleController>();
    final firestore = FirebaseFirestore.instance;
    final ownerRef = firestore.collection('owners').doc(ownerId);
    final vehicleTypes = ['Car', 'Bike', 'Scooty', 'Electric Vehicle'];

    try {
      Map<String, List<Map<String, dynamic>>> vehicleData = {};

      for (String vehicleType in vehicleTypes) {
        final vehicleTypeCollection =
            await ownerRef.collection(vehicleType).get();
        vehicleData[vehicleType] = [];

        for (var vehicleModelDoc in vehicleTypeCollection.docs) {
          final vehicleDetails = vehicleModelDoc.data();
          vehicleData[vehicleType]!.add({
            'modelName': vehicleModelDoc.id,
            ...Map.fromEntries(
                vehicleDetails.entries.where((e) => e.key != 'modelName')),
          });
        }
      }

      final List<String> orderedKeys = [
        'modelName',
        'vehicle_renter',
        'vehicle_price',
        'vehicle_address',
        'vehicle_rating',
        'vehicle_fuelInfo',
        'vehicle_ac',
        'vehicle_safetyRating',
        'vehicle_seats',
        'vehicle_features',
      ];

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Previous Vehicle Details',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
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
          body: ListView.builder(
            itemCount: vehicleTypes.length,
            itemBuilder: (context, index) {
              String vehicleType = vehicleTypes[index];
              List<Map<String, dynamic>> vehicles =
                  vehicleData[vehicleType] ?? [];
              return ExpansionTile(
                title: Text(vehicleType,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                children: vehicles
                    .map((vehicle) => Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: orderedKeys
                                  .where((key) => vehicle.containsKey(key))
                                  .map((key) {
                                String displayKey = _getDisplayName(key);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text('$displayKey: ${vehicle[key]}',
                                      style: const TextStyle(fontSize: 16)),
                                );
                              }).toList(),
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching vehicle details: $error"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static String _getDisplayName(String key) {
    Map<String, String> displayNames = {
      'modelName': 'Model',
      'vehicle_renter': 'Owner',
      'vehicle_rating': 'Rating',
      'vehicle_price': 'Price',
      'vehicle_address': 'Address',
      'vehicle_fuelInfo': 'Fuel Info',
      'vehicle_ac': 'AC',
      'vehicle_safetyRating': 'Safety Rating',
      'vehicle_seats': 'Seats',
      'vehicle_features': 'Features',
    };

    return displayNames[key] ?? GetStringUtils(key.split('_').last).capitalize!;
  }
}

extension StringExtension on String {
  String? get capitalize {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}
