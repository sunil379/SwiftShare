import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/customervehicleinfo.dart';

class AllImagesScreen extends StatelessWidget {
  final String name;
  final List<String> imageUrls;

  const AllImagesScreen({
    super.key,
    required this.name,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Images'),
      ),
      body: ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateToCarInfoPage(
                context,
                name,
                imageUrls,
                '4.5', // Placeholder for car rating
                'John Doe', // Placeholder for car renter
                '4', // Placeholder for car seats
                'Yes', // Placeholder for car AC
                '5', // Placeholder for car safety rating
                '123 Street, City', // Placeholder for car address
                'Petrol, 20 kmpl', // Placeholder for car fuel info
                '\$50 per day', // Placeholder for car price
                ['Bluetooth', 'GPS', 'USB'],
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200, // Set desired height for each image
                child: Image.asset(
                  imageUrls[index],
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
      String carSeats,
      String carAC,
      String carSafetyRating,
      String carAddress,
      String carFuelInfo,
      String carPrice,
      List<String> carFeatures) {
    // Replace this with your navigation logic to CarInfoPage
    // Pass the necessary parameters to CarInfoPage
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
        ),
      ),
    );
  }
}
