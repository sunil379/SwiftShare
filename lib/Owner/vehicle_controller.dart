import 'package:get/get.dart';

class VehicleController extends GetxController {
  var vehicleRating = ''.obs;
  var vehicleRenter = ''.obs;
  var vehicleModel = ''.obs;
  var vehicleSeats = ''.obs;
  var vehicleAC = ''.obs;
  var vehicleSafetyRating = ''.obs;
  var vehicleAddress = ''.obs;
  var vehicleFuelInfo = ''.obs;
  var vehiclePrice = 0.obs;
  var vehicleFeatures = <String>[].obs;
  var vehicleType = ''.obs;

  void updateVehicleDetails(Map<String, dynamic> data) {
    vehicleRating.value = data['vehicle_rating'] ?? '';
    vehicleRenter.value = data['vehicle_renter'] ?? '';
    vehicleModel.value = data['vehicle_model'] ?? '';
    vehicleSeats.value = data['vehicle_seats'] ?? '';
    vehicleAC.value = data['vehicle_ac'] ?? '';
    vehicleSafetyRating.value = data['vehicle_safetyRating'] ?? '';
    vehicleAddress.value = data['vehicle_address'] ?? '';
    vehicleFuelInfo.value = data['vehicle_fuelInfo'] ?? '';
    vehiclePrice.value = data['vehicle_price'] ?? 0;
    vehicleFeatures.value = List<String>.from(data['vehicle_features'] ?? []);
    vehicleType.value = data['vehicle_type'] ?? '';
  }

  void resetVehicleDetails() {
    vehicleRating.value = '';
    vehicleRenter.value = '';
    vehicleModel.value = '';
    vehicleSeats.value = '';
    vehicleAC.value = '';
    vehicleSafetyRating.value = '';
    vehicleAddress.value = '';
    vehicleFuelInfo.value = '';
    vehiclePrice.value = 0;
    vehicleFeatures.value = [];
    vehicleType.value = '';
  }
}
