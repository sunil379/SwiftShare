// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/customer_trips.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final int carPrice;
  final List<String> carFeatures;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final DateTime returnedDate;
  final TimeOfDay returnedTime;

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
    required this.returnedDate,
    required this.returnedTime,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _locationButtonClicked = false;
  String? _selectedPaymentMethod = 'Please Select Payment Option';
  late int total = 0;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = 'Please Select Payment Option';
    calculateTotal();
  }

  void calculateTotal() {
    final Duration difference =
        widget.returnedDate.difference(widget.selectedDate);
    final int daysDifference = difference.inDays;

    total = daysDifference * widget.carPrice;
  }

  @override
  Widget build(BuildContext context) {
    bool isPaymentMethodSelected =
        _selectedPaymentMethod != 'Please Select Payment Option';
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
            margin: const EdgeInsets.all(12),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Pickup Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  width: 150,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Return Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  width: 150,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${widget.returnedDate.day}/${widget.returnedDate.month}/${widget.returnedDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Pickup Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  width: 150,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.lightBlue,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.selectedTime.format(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Return Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  width: 150,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.returnedTime.format(context),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Owner Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  width: 150,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.lightBlue,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.carRenter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(left: 16.0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Container(
                  width: 150,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.lightBlue,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Rs $total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
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
            const Divider(
              color: Colors.black,
              thickness: 2.5,
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Options : ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$_selectedPaymentMethod',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentMethod(
                    icon: Icons.payment, methodName: 'Credit Card'),
                const SizedBox(height: 12),
                _buildPaymentMethod(
                    icon: Icons.payment, methodName: 'Debit Card'),
                const SizedBox(height: 12),
                _buildPaymentMethod(
                    icon: Icons.payment, methodName: 'Net Banking'),
                const SizedBox(height: 12),
                _buildPaymentMethod(
                    icon: Icons.payment, methodName: 'Cash On Delivery'),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(
              color: Colors.black,
              thickness: 2.5,
            ),
            const SizedBox(height: 24),
            OverflowBar(
              children: [
                const Text(
                  'Address : ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.carAddress,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: isPaymentMethodSelected
                      ? () {
                          // Navigate to Google Maps with the address
                          _openGoogleMaps(widget.carAddress);
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: isPaymentMethodSelected != null
                        ? MaterialStateProperty.all(Colors.redAccent)
                        : MaterialStateProperty.all(Colors.redAccent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 2,
                    ),
                    child: Text(
                      'See Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(
              color: Colors.black,
              thickness: 2.5,
            ),
            const SizedBox(height: 24),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.maxFinite,
                height: 60,
                child: ElevatedButton(
                  onPressed: _locationButtonClicked ? _confirmBooking : null,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(22),
                    backgroundColor: isPaymentMethodSelected != null
                        ? MaterialStateProperty.all(Colors.deepPurple)
                        : MaterialStateProperty.all(Colors.deepPurple),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String methodName,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (methodName != 'Cash On Delivery') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'This payment option is coming soon',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.0,
                ),
                backgroundColor: Colors.blueGrey[800],
                duration: const Duration(seconds: 6),
                // margin: const EdgeInsets.only(
                //     bottom: 70, left: 20, right: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 6.0,
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ),
            );
          } else {
            setState(() {
              _selectedPaymentMethod =
                  '$methodName selected!'; // Update selected payment method
            });
          }
        },
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(
              methodName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmBooking() async {
    // Implement booking functionality here
    if (_locationButtonClicked) {
      try {
        User? currentUser = _auth.currentUser;
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        Map<String, dynamic> bookingData = {
          'vehicleName': widget.carName,
          'model': widget.model,
          'selectedDate': widget.selectedDate,
          'selectedTime': widget.selectedTime.format(context),
          'returnedDate': widget.returnedDate,
          'returnedTime': widget.returnedTime.format(context),
          'vehicleOwner': widget.carRenter,
          'vehicleAddress': widget.carAddress,
          'vehiclePrice': widget.carPrice,
          'total': total,
        };

        if (currentUser != null) {
          DocumentReference bookingRef = firestore
              .collection('customers')
              .doc(currentUser.uid)
              .collection('bookings')
              .doc(widget.model);
          await bookingRef.set(bookingData);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Booking Confirmation'),
              content: Text('You have successfully booked ${widget.model}'),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyTripsPage(
                            modelName: widget.model,
                            pickupDate: widget.selectedDate,
                            pickupTime: widget.selectedTime,
                            returnDate: widget.returnedDate,
                            returnTime: widget.returnedTime,
                            ownerName: widget.carRenter,
                          ),
                        ),
                      );
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error confirming booking : $e')));
      }
    }
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
