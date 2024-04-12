// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatefulWidget {
  final String carName;
  final List<String> carImageUrls;
  final String carRating;
  final String carRenter;
  final String model;
  final String carSeats;
  final String carAC;
  final String carSafetyRating;
  final String carAddress;
  final String carFuelInfo;
  final String carPrice;
  final List<String> carFeatures;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const BookingPage({
    super.key,
    required this.carName,
    required this.carImageUrls,
    required this.carRating,
    required this.carRenter,
    required this.model,
    required this.carSeats,
    required this.carAC,
    required this.carSafetyRating,
    required this.carAddress,
    required this.carFuelInfo,
    required this.carPrice,
    required this.carFeatures,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _locationButtonClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Booking Details',
          style: TextStyle(
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
                )),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Model : ${widget.model}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Pickup Date:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Owner Name:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.carRenter,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickup Time:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.selectedTime.format(context),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Price:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.carPrice,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 14.0),
            // SizedBox(
            //   height: 250,
            //   width: double.infinity,
            //   child: Stack(
            //     children: [
            //       ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: widget.carImageUrls.length,
            //         itemBuilder: (context, index) {
            //           return Container(
            //             width: 400, // Adjust width as needed
            //             // margin: const EdgeInsets.only(right: 8),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(12.0),
            //               border: Border.all(
            //                 color: Colors.grey,
            //                 width: 5.0,
            //               ),
            //               image: DecorationImage(
            //                 image: AssetImage(widget.carImageUrls[index]),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //       const SizedBox(height: 6),
            //       Align(
            //         alignment: Alignment.bottomLeft,
            //         child: Container(
            //           padding: const EdgeInsets.all(4),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(6),
            //           ),
            //           child: Text(
            //             widget.carRating,
            //             style: const TextStyle(
            //               fontSize: 12,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 24),
            const Text(
              'Address : ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.carAddress,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Google Maps with the address
                _openGoogleMaps(widget.carAddress);
              },
              child: const Text('See Location'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Payment Option: Cash on Delivery',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _locationButtonClicked ? _confirmBooking : null,
              child: const Text('Confirm Booking'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    // Implement booking functionality here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmation'),
        content: Text('You have successfully booked ${widget.carName}'),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to open Google Maps with a specific address
  Future<void> _openGoogleMaps(String address) async {
    // Encode the address for the URL
    final encodedAddress = Uri.encodeComponent(address);
    // Create the Google Maps URL with the encoded address
    final url =
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    // Launch the URL
    if (await canLaunch(url)) {
      await launch(url);
      setState(() {
        _locationButtonClicked = true;
      });
    } else {
      throw 'Could not launch $url';
    }
  }
}
