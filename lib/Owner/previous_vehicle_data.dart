// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousVehicleData {
  static Future<void> showPreviousData(
      BuildContext context, String ownerId) async {
    final ownerRef =
        FirebaseFirestore.instance.collection('owners').doc(ownerId);
    final vehicleTypes = ['Car', 'Bike', 'Scooty', 'Electric Vehicle'];

    try {
      Map<String, List<Map<String, dynamic>>> vehicleData = {};

      for (String vehicleType in vehicleTypes) {
        final querySnapshot = await ownerRef.collection(vehicleType).get();
        vehicleData[vehicleType] =
            querySnapshot.docs.map((doc) => doc.data()).toList();
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Previous Vehicle Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: vehicleTypes.length,
                    itemBuilder: (context, index) {
                      String vehicleType = vehicleTypes[index];
                      List<Map<String, dynamic>> vehicles =
                          vehicleData[vehicleType] ?? [];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicleType,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: vehicles.length,
                                  itemBuilder: (context, idx) {
                                    Map<String, dynamic> vehicle =
                                        vehicles[idx];
                                    return Text(
                                        '${vehicle['vehicleModel']} - ${vehicle['vehiclePrice']}');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (error) {
      print("Error fetching vehicle details: $error");
    }
  }
}
