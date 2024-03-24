// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final LatLng _center = const LatLng(45.521563, -122.677433);
  late GoogleMapController mapController;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Widget _buildMap() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Column(
      children: [
        const ListTile(
          title: Text('Mahindra Thar AX (O) Hard Top Diesel MT RWD'),
          subtitle: Text(
              'Start 14 Feb 2024 End 20 Feb 2024\nPick-up location Mankapur, Nagpur 4.9 km Away'),
        ),
        ListTile(
          title: const Text('Payment'),
          subtitle: const Text('MasterCard **** **** **** 4567 5485'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text('Pay ₹500 /day'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildMap(),
          _buildBookingDetails(),
        ],
      ),
    );
  }
}
