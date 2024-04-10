// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            fontWeight: FontWeight.bold,
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
                  const SizedBox(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.account_circle, size: 80),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailField('Name', _name, Colors.blue),
                  const SizedBox(height: 8.0),
                  _buildDetailField('Mobile', _mobile, Colors.green),
                  const SizedBox(height: 8.0),
                  _buildDetailField('Address', _address, Colors.orange),
                  const SizedBox(height: 8.0),
                  _buildDetailField('Email', _email, Colors.purple),
                  const SizedBox(height: 24),
                  if (_identityProofURL.isNotEmpty)
                    _buildPDFButton(
                      'View Identity Proof',
                      _identityProofURL,
                      Colors.blue,
                    ),
                  const SizedBox(height: 12),
                  if (_drivingLicenseURL.isNotEmpty)
                    _buildPDFButton(
                      'View Driving License',
                      _drivingLicenseURL,
                      Colors.green,
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailField(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18.0), // Set border radius
        border: Border.all(
          color: Colors.grey,
          width: 4.0,
        ), // Add border
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(
            width: 8,
          ), // Add a horizontal margin of 8 between label and value
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
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
      child: ElevatedButton(
        onPressed: () {
          _showPDF(documentURL);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Background color of the button
        ),
        child: Text(buttonText),
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
