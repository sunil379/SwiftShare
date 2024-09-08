import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/customervehicleinfo.dart';
import 'package:swiftshare_one/Vehicle%20Details/vehicle_details.dart';

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
        title: Text(
          "${name}s",
          style: const TextStyle(
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
              ),
            ),
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
              _navigateToVehicleInfoPage(
                context,
                name,
                [imageUrl],
                details.vehicle_rating,
                details.vehicle_renter,
                details.vehicle_model,
                details.vehicle_seats,
                details.vehicle_ac,
                details.vehicle_safetyRating,
                details.vehicle_address,
                details.vehicle_fuelInfo,
                details.vehicle_price,
                details.vehicle_features,
                details.vehicle_type,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 5.0,
                  ),
                ),
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

  void _navigateToVehicleInfoPage(
    BuildContext context,
    String vehicleName,
    List<String> vehicleimageUrls,
    String vehicleRating,
    String vehicleRenter,
    String model,
    String vehicleSeats,
    String vehicleAC,
    String vehicleSafetyRating,
    String vehicleAddress,
    String vehicleFuelInfo,
    int vehiclePrice,
    List<String> vehicleFeatures,
    String vehicleType,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleInfoPage(
          vehicleName: vehicleName,
          vehicleImageUrls: vehicleimageUrls,
          vehicleDetails: VehicleDetails(
            vehicle_rating: vehicleRating,
            vehicle_renter: vehicleRenter,
            vehicle_model: model,
            vehicle_seats: vehicleSeats,
            vehicle_ac: vehicleAC,
            vehicle_safetyRating: vehicleSafetyRating,
            vehicle_address: vehicleAddress,
            vehicle_fuelInfo: vehicleFuelInfo,
            vehicle_price: vehiclePrice,
            vehicle_features: vehicleFeatures,
            vehicle_type: vehicleType,
          ),
        ),
      ),
    );
  }
}
