import 'package:cloud_firestore/cloud_firestore.dart';
import 'vehicle_details.dart';

class VehicleInfo {
  final FirebaseFirestore vehicleStore = FirebaseFirestore.instance;

  // Function to add vehicle details to Firestore
  Future<void> addVehicleDetailsToFirestore() async {
    for (var vehicleType in VehicleData.initialDetailsMap.keys) {
      var vehicleList = VehicleData.initialDetailsMap[vehicleType];

      // Reference to the document (Car, Bike, Scooty, Electric Vehicle)
      DocumentReference vehicleTypeDoc =
          vehicleStore.collection('vehicle_details').doc(vehicleType);

      for (var vehicleDetail in vehicleList!) {
        // Print the vehicle model and renter to check uniqueness
        print('Processing vehicle model: ${vehicleDetail.vehicle_model} for renter: ${vehicleDetail.vehicle_renter}');

        // Reference to the document using vehicle_renter as the document ID
        DocumentReference vehicleRenterDoc = vehicleTypeDoc
            .collection(vehicleDetail.vehicle_renter)
            .doc(vehicleDetail.vehicle_model);

        // Check if the document already exists
        var docSnapshot = await vehicleRenterDoc.get();
        if (docSnapshot.exists) {
          print('Document already exists: ${vehicleDetail.vehicle_model}');
        } else {
          // Set vehicle details in the document if it doesn't exist
          await vehicleRenterDoc.set({
            'vehicle_rating': vehicleDetail.vehicle_rating,
            'vehicle_renter': vehicleDetail.vehicle_renter,
            'vehicle_model': vehicleDetail.vehicle_model,
            'vehicle_seats': vehicleDetail.vehicle_seats,
            'vehicle_ac': vehicleDetail.vehicle_ac,
            'vehicle_safetyRating': vehicleDetail.vehicle_safetyRating,
            'vehicle_address': vehicleDetail.vehicle_address,
            'vehicle_fuelInfo': vehicleDetail.vehicle_fuelInfo,
            'vehicle_price': vehicleDetail.vehicle_price,
            'vehicle_features': vehicleDetail.vehicle_features,
          });
          print('Document created: ${vehicleDetail.vehicle_model}');
        }
      }
    }
  }
}
