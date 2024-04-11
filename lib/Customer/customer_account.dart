// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _name = '';
  late String _mobile = '';
  late String _address = '';
  late String _email = '';
  late String _identityProofURL = '';
  late String _drivingLicenseURL = '';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && mounted) {
        DocumentSnapshot userData =
            await _firestore.collection('customers').doc(user.uid).get();

        if (mounted) {
          setState(() {
            _name = userData['name'];
            _mobile = userData['mobile'];
            _address = userData['address'];
            _email = userData['email'];
            _identityProofURL = userData['identityProofURL'] ?? '';
            _drivingLicenseURL = userData['drivingLicenseURL'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error fetching user details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching user details: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Details',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        centerTitle: true,
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/image-9.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailField(
                      'Name  ', '  $_name', Colors.white, Colors.blue),
                  const SizedBox(height: 12.0),
                  _buildDetailField(
                      'Mobile ', ' $_mobile', Colors.white, Colors.blue),
                  const SizedBox(height: 12.0),
                  _buildDetailField(
                      'Address', _address, Colors.white, Colors.blue),
                  const SizedBox(height: 12.0),
                  _buildDetailField(
                      'Email   ', ' $_email', Colors.white, Colors.blue),
                  const SizedBox(height: 30),
                  Divider(
                    thickness: 3.5, // Adjust the thickness of the line
                    color: Colors.black
                        .withOpacity(0.4), // Set the color of the line
                  ),
                  const SizedBox(height: 30),
                  if (_identityProofURL.isNotEmpty)
                    _buildPDFButton(
                      'View Identity Proof',
                      _identityProofURL,
                      Colors.deepPurple,
                    ),
                  const SizedBox(height: 12),
                  if (_drivingLicenseURL.isNotEmpty)
                    _buildPDFButton(
                      'View Driving License',
                      _drivingLicenseURL,
                      Colors.deepPurple,
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailField(
      String label, String value, Color startColor, Color endColor) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            startColor.withOpacity(0.1), // Start color with some opacity
            endColor.withOpacity(0.9), // End color with some opacity
          ],
          stops: const [0.27, 0.24], // Start and end at extreme points
        ),
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPDFButton(
      String buttonText, String documentURL, Color backgroundColor) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {
            _showPDF(documentURL);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ), // Background color of the button
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPDF(String documentURL) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(documentURL: documentURL),
      ),
    );
  }
}

class PDFViewer extends StatelessWidget {
  final String documentURL;

  const PDFViewer({super.key, required this.documentURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: PDFView(
            filePath: documentURL,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            pageSnap: true,
          ),
        ),
      ),
    );
  }
}
