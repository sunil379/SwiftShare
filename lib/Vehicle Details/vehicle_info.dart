import 'package:cloud_firestore/cloud_firestore.dart';
import 'vehicle_details.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add vehicle details to Firestore
  Future<void> addVehicleDetailsToFirestore() async {
    VehicleData.initialDetailsMap.forEach((vehicleType, vehicleList) async {
      // Reference to the document (Car, Bike, Scooty, Electric Vehicle)
      DocumentReference vehicleTypeDoc =
          _firestore.collection('vehicle_details').doc(vehicleType);

      for (var vehicleDetail in vehicleList) {
        // Reference to the subcollection 'vehicle_renter'
        CollectionReference vehicleRenterCollection =
            vehicleTypeDoc.collection(vehicleDetail.vehicle_renter);

        // Add vehicle details as a document in the 'vehicle_renter' subcollection
        await vehicleRenterCollection.add({
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
      }
    });
  }
}
