// vehicle_details.dart
// ignore_for_file: non_constant_identifier_names

class VehicleDetails {
  final String vehicle_rating;
  final String vehicle_renter;
  final String vehicle_model;
  final String vehicle_seats;
  final String vehicle_ac;
  final String vehicle_safetyRating;
  final String vehicle_address;
  final String vehicle_fuelInfo;
  final int vehicle_price;
  final List<String> vehicle_features;

  VehicleDetails({
    required this.vehicle_rating,
    required this.vehicle_renter,
    required this.vehicle_model,
    required this.vehicle_seats,
    required this.vehicle_ac,
    required this.vehicle_safetyRating,
    required this.vehicle_address,
    required this.vehicle_fuelInfo,
    required this.vehicle_price,
    required this.vehicle_features,
  });
}

class VehicleData {
  static final Map<String, List<VehicleDetails>> initialDetailsMap = {
    'Car': [
      VehicleDetails(
        vehicle_rating: '4.5',
        vehicle_renter: 'Jay Sharma',
        vehicle_seats: '4',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '5',
        vehicle_address: 'MIHAN, Nagpur',
        vehicle_fuelInfo: 'Petrol, 20 kmpl',
        vehicle_price: 2000,
        vehicle_features: ['Bluetooth', 'GPS', 'USB'],
        vehicle_model: 'Honda City',
      ),
      VehicleDetails(
        vehicle_rating: '4.0',
        vehicle_renter: 'Abhijit Banerjee',
        vehicle_seats: '2',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '4',
        vehicle_address: 'Medical Square, Nagpur',
        vehicle_fuelInfo: 'Diesel, 15 kmpl',
        vehicle_price: 2000,
        vehicle_features: ['Bluetooth', 'USB'],
        vehicle_model: 'Tata Nexon',
      ),
      VehicleDetails(
        vehicle_rating: '4.0',
        vehicle_renter: 'Rohit Sharma',
        vehicle_seats: '2',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '4',
        vehicle_address: '456 Street, City',
        vehicle_fuelInfo: 'Diesel, 15 kmpl',
        vehicle_price: 2000,
        vehicle_features: ['Bluetooth', 'USB'],
        vehicle_model: 'Mahindra Thar',
      ),
      VehicleDetails(
        vehicle_rating: '4.0',
        vehicle_renter: 'Raj Verma',
        vehicle_seats: '2',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '4',
        vehicle_address: '456 Street, City',
        vehicle_fuelInfo: 'Diesel, 15 kmpl',
        vehicle_price: 2000,
        vehicle_features: ['Bluetooth', 'USB'],
        vehicle_model: 'Mahindra XUV',
      ),
    ],
    'Bike': [
      VehicleDetails(
        vehicle_rating: '4.0',
        vehicle_renter: 'Dev Raj',
        vehicle_seats: '2',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '4',
        vehicle_address: '456 Street, City',
        vehicle_fuelInfo: 'Diesel, 15 kmpl',
        vehicle_price: 1500,
        vehicle_features: ['Bluetooth', 'USB'],
        vehicle_model: 'Livo',
      ),
      VehicleDetails(
        vehicle_rating: '4.0',
        vehicle_renter: 'Jane Doe',
        vehicle_seats: '2',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '4',
        vehicle_address: '456 Street, City',
        vehicle_fuelInfo: 'Diesel, 15 kmpl',
        vehicle_price: 1500,
        vehicle_features: ['Bluetooth', 'USB'],
        vehicle_model: 'Splendor',
      ),
      VehicleDetails(
        vehicle_rating: '4.8',
        vehicle_renter: 'John Smith',
        vehicle_seats: '5',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '5',
        vehicle_address: '789 Avenue, Town',
        vehicle_fuelInfo: 'Petrol, 25 kmpl',
        vehicle_price: 1500,
        vehicle_features: ['Bluetooth', 'GPS', 'USB', 'Sunroof'],
        vehicle_model: 'SP125',
      ),
    ],
    'Scooty': [
      VehicleDetails(
        vehicle_rating: '4.5',
        vehicle_renter: 'Alex Brown',
        vehicle_seats: '2',
        vehicle_ac: 'No',
        vehicle_safetyRating: '4',
        vehicle_address: '987 Road, Village',
        vehicle_fuelInfo: 'Petrol, 30 kmpl',
        vehicle_price: 1200,
        vehicle_features: ['Bluetooth', 'USB', 'Helmet Included'],
        vehicle_model: 'Activa 2020',
      ),
      VehicleDetails(
        vehicle_rating: '4.3',
        vehicle_renter: 'Sophia Garcia',
        vehicle_seats: '2',
        vehicle_ac: 'No',
        vehicle_safetyRating: '4',
        vehicle_address: '654 Lane, Suburb',
        vehicle_fuelInfo: 'Petrol, 25 kmpl',
        vehicle_price: 1200,
        vehicle_features: ['Bluetooth', 'USB', 'Phone Mount'],
        vehicle_model: 'Pleasure',
      ),
      VehicleDetails(
        vehicle_rating: '4.4',
        vehicle_renter: 'Olivia Martinez',
        vehicle_seats: '1',
        vehicle_ac: 'No',
        vehicle_safetyRating: '4',
        vehicle_address: '456 Avenue, Park',
        vehicle_fuelInfo: 'Electric, 50 kmpl',
        vehicle_price: 1200,
        vehicle_features: ['Bluetooth', 'USB', 'Locking Mechanism'],
        vehicle_model: 'Activa 2018',
      ),
      VehicleDetails(
        vehicle_rating: '4.7',
        vehicle_renter: 'Michael Miller',
        vehicle_seats: '1',
        vehicle_ac: 'No',
        vehicle_safetyRating: '4',
        vehicle_address: '123 Street, Downtown',
        vehicle_fuelInfo: 'Electric, 60 kmpl',
        vehicle_price: 1200,
        vehicle_features: ['Bluetooth', 'USB', 'Portable Charger'],
        vehicle_model: 'Activa 2019',
      ),
    ],
    'Electric Vehicle': [
      VehicleDetails(
        vehicle_rating: '4.6',
        vehicle_renter: 'William Taylor',
        vehicle_seats: '4',
        vehicle_ac: 'Yes',
        vehicle_safetyRating: '5',
        vehicle_address: '789 Boulevard, Lake',
        vehicle_fuelInfo: 'Electric, 300 km range',
        vehicle_price: 2500,
        vehicle_features: ['Bluetooth', 'USB', 'Autopilot'],
        vehicle_model: 'Tesla',
      ),
    ] // Add details for other images as needed
  };
}
