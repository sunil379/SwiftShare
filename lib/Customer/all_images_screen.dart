import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/customervehicleinfo.dart';
import 'package:swiftshare_one/Customer/vehicle_details.dart';

class AllImagesScreen extends StatelessWidget {
  final String name;
  final List<String> imageUrls;
  final List<VehicleDetails> vehicleDetails;

  const AllImagesScreen({
    super.key,
    required this.name,
    required this.imageUrls,
    required this.vehicleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('All Vehicles'),
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
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          String imageUrl = imageUrls[index];
          VehicleDetails details = vehicleDetails[index];
          return GestureDetector(
            onTap: () {
              _navigateToCarInfoPage(
                context,
                name,
                [imageUrl],
                details.rating,
                details.renter,
                details.model,
                details.seats,
                details.ac,
                details.safetyRating,
                details.address,
                details.fuelInfo,
                details.price,
                details.features,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200, // Set desired height for each image
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToCarInfoPage(
    BuildContext context,
    String carName,
    List<String> imageUrls,
    String carRating,
    String carRenter,
    String model,
    String carSeats,
    String carAC,
    String carSafetyRating,
    String carAddress,
    String carFuelInfo,
    String carPrice,
    List<String> carFeatures,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarInfoPage(
          carName: carName,
          carImageUrls: imageUrls,
          carRating: carRating,
          carRenter: carRenter,
          carSeats: carSeats,
          carAC: carAC,
          carSafetyRating: carSafetyRating,
          carAddress: carAddress,
          carFuelInfo: carFuelInfo,
          carPrice: carPrice,
          carFeatures: carFeatures,
          model: model,
        ),
      ),
    );
  }
}
