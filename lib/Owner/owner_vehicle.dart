// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiftshare_one/Vehicle%20Details/vehicle_details.dart';
import 'package:get/get.dart';
import 'vehicle_controller.dart';

class VehicleDetailsForm extends StatefulWidget {
  final String ownerId;
  final VehicleDetails? vehicleDetails;

  const VehicleDetailsForm(
      {super.key, required this.ownerId, this.vehicleDetails});

  @override
  VehicleDetailsFormState createState() => VehicleDetailsFormState();
}

class VehicleDetailsFormState extends State<VehicleDetailsForm> {
  final VehicleController vehicleController = Get.put(VehicleController());
  final formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;

  String vehicleRating = '';
  String vehicleRenter = '';
  String vehicleModel = '';
  String vehicleSeats = '';
  String vehicleAC = '';
  String vehicleSafetyRating = '';
  String vehicleAddress = '';
  String vehicleFuelInfo = '';
  int vehiclePrice = 0;
  List<String> vehicleFeatures = [];
  String vehicleType = '';

  @override
  void initState() {
    super.initState();
    if (widget.vehicleDetails != null) {
      vehicleController.updateVehicleDetails({
        'vehicle_rating': widget.vehicleDetails!.vehicle_rating,
        'vehicle_renter': widget.vehicleDetails!.vehicle_renter,
        'vehicle_model': widget.vehicleDetails!.vehicle_model,
        'vehicle_seats': widget.vehicleDetails!.vehicle_seats,
        'vehicle_ac': widget.vehicleDetails!.vehicle_ac,
        'vehicle_safetyRating': widget.vehicleDetails!.vehicle_safetyRating,
        'vehicle_address': widget.vehicleDetails!.vehicle_address,
        'vehicle_fuelInfo': widget.vehicleDetails!.vehicle_fuelInfo,
        'vehicle_price': widget.vehicleDetails!.vehicle_price,
        'vehicle_features': widget.vehicleDetails!.vehicle_features,
      });
    }
    fetchAndShowPreviousData();
  }

  Future<void> saveVehicleDetails() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final vehicleData = {
        'vehicle_rating': vehicleController.vehicleRating.value,
        'vehicle_renter': vehicleController.vehicleRenter.value,
        'vehicle_model': vehicleController.vehicleModel.value,
        'vehicle_seats': vehicleController.vehicleSeats.value,
        'vehicle_ac': vehicleController.vehicleAC.value,
        'vehicle_safetyRating': vehicleController.vehicleSafetyRating.value,
        'vehicle_address': vehicleController.vehicleAddress.value,
        'vehicle_fuelInfo': vehicleController.vehicleFuelInfo.value,
        'vehicle_price': vehicleController.vehiclePrice.value,
        'vehicle_features': vehicleController.vehicleFeatures,
        'vehicle_type': vehicleController.vehicleType.value,
      };

      if (widget.ownerId.isNotEmpty &&
          vehicleController.vehicleType.value.isNotEmpty &&
          vehicleController.vehicleModel.value.isNotEmpty) {
        await firestore
            .collection('owners')
            .doc(widget.ownerId)
            .collection(vehicleController.vehicleType.value)
            .doc(vehicleController.vehicleModel.value)
            .set(vehicleData, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Vehicle details saved successfully')));
      } else {
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
    }
  }

  Future<void> fetchAndShowPreviousData() async {
    if (widget.ownerId.isNotEmpty &&
        vehicleType.isNotEmpty &&
        vehicleModel.isNotEmpty) {
      final updatedData = await firestore
          .collection('owners')
          .doc(widget.ownerId)
          .collection(vehicleType)
          .doc(vehicleModel)
          .get();

      if (updatedData.exists) {
        vehicleController.updateVehicleDetails(updatedData.data()!);
      }
    }
  }

  Widget buildEditableField({
    required String labelText,
    required String initialValue,
    required Function(String) onSaved,
    required IconData editIcon,
    bool isNumeric = false,
  }) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                keyboardType:
                    isNumeric ? TextInputType.number : TextInputType.text,
                onSaved: (value) {
                  onSaved(value!);
                },
              ),
            ),
            IconButton(
              icon: Icon(editIcon, color: Theme.of(context).primaryColor),
              onPressed: () {
                setState(() {
                  onSaved(controller.text);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void showPreviousData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('owners')
        .where(widget.ownerId)
        .where(vehicleType)
        .get();

    List<Map<String, dynamic>> previousVehicles = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

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
                child: ListView.builder(
                  itemCount: previousVehicles.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> vehicle = previousVehicles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle Type: ${vehicle['vehicleType']}'),
                            Text('Owner Name: ${vehicle['vehicleRenter']}'),
                            Text('Vehicle Rating: ${vehicle['vehicleRating']}'),
                            Text('Vehicle Model: ${vehicle['vehicleModel']}'),
                            Text('Vehicle Seats: ${vehicle['vehicleSeats']}'),
                            Text('Vehicle AC: ${vehicle['vehicleAC']}'),
                            Text(
                                'Vehicle Safety Rating: ${vehicle['vehicleSafetyRating']}'),
                            Text(
                                'Vehicle Address: ${vehicle['vehicleAddress']}'),
                            Text(
                                'Vehicle Fuel Info: ${vehicle['vehicleFuelInfo']}'),
                            Text('Vehicle Price: ${vehicle['vehiclePrice']}'),
                            Text(
                                'Vehicle Features: ${(vehicle['vehicleFeatures'] as List<dynamic>).join(", ")}'),
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
  }

  void resetForm() {
    vehicleController.resetVehicleDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Vehicle Details",
          style: TextStyle(
            color: Colors.blue,
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
        actions: [
          IconButton(
            tooltip: "Show Previous Data",
            icon: const Icon(Icons.visibility, color: Colors.blue, size: 22),
            onPressed: showPreviousData,
          ),
          IconButton(
            tooltip: "Add New Vehicle",
            icon: const Icon(Icons.add_circle_outline,
                color: Colors.orange, size: 22),
            onPressed: resetForm,
          ),
          IconButton(
            tooltip: "Save vehicle details",
            icon: const Icon(Icons.save_alt_rounded,
                color: Colors.green, size: 22),
            onPressed: saveVehicleDetails,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => TextFormField(
                        initialValue: vehicleController.vehicleType.value,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Type',
                          hintText:
                              'Enter Car, Bike, Scooty, or Electric Vehicle',
                          border: InputBorder.none,
                        ),
                        onChanged: (String newValue) {
                          vehicleController.vehicleType.value = newValue;
                        },
                        onSaved: (newValue) {
                          vehicleController.vehicleType.value = newValue ?? '';
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a vehicle type';
                          }
                          final allowedTypes = [
                            'Car',
                            'Bike',
                            'Scooty',
                            'Electric Vehicle'
                          ];
                          if (!allowedTypes.contains(value)) {
                            return 'Please enter one of: Car, Bike, Scooty, or Electric Vehicle';
                          }
                          return null;
                        },
                      )),
                ),
              ),
              Obx(() => buildEditableField(
                    labelText: 'Owner Name',
                    initialValue: vehicleController.vehicleRenter.value,
                    onSaved: (value) =>
                        vehicleController.vehicleRenter.value = value,
                    editIcon: Icons.person,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Rating',
                    initialValue: vehicleController.vehicleRating.value,
                    onSaved: (value) =>
                        vehicleController.vehicleRating.value = value,
                    editIcon: Icons.star,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Model',
                    initialValue: vehicleController.vehicleModel.value,
                    onSaved: (value) =>
                        vehicleController.vehicleModel.value = value,
                    editIcon: Icons.directions_car,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Seats',
                    initialValue: vehicleController.vehicleSeats.value,
                    onSaved: (value) =>
                        vehicleController.vehicleSeats.value = value,
                    editIcon: Icons.event_seat,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle AC',
                    initialValue: vehicleController.vehicleAC.value,
                    onSaved: (value) =>
                        vehicleController.vehicleAC.value = value,
                    editIcon: Icons.ac_unit,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Safety Rating',
                    initialValue: vehicleController.vehicleSafetyRating.value,
                    onSaved: (value) =>
                        vehicleController.vehicleSafetyRating.value = value,
                    editIcon: Icons.security,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Address',
                    initialValue: vehicleController.vehicleAddress.value,
                    onSaved: (value) =>
                        vehicleController.vehicleAddress.value = value,
                    editIcon: Icons.location_on,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Fuel Info',
                    initialValue: vehicleController.vehicleFuelInfo.value,
                    onSaved: (value) =>
                        vehicleController.vehicleFuelInfo.value = value,
                    editIcon: Icons.local_gas_station,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Price',
                    initialValue:
                        vehicleController.vehiclePrice.value.toString(),
                    onSaved: (value) =>
                        vehicleController.vehiclePrice.value = int.parse(value),
                    editIcon: Icons.currency_rupee,
                    isNumeric: true,
                  )),
              Obx(() => buildEditableField(
                    labelText: 'Vehicle Features (comma-separated)',
                    initialValue: vehicleController.vehicleFeatures.join(', '),
                    onSaved: (value) => vehicleController.vehicleFeatures
                        .value = value.split(',').map((e) => e.trim()).toList(),
                    editIcon: Icons.featured_play_list,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
