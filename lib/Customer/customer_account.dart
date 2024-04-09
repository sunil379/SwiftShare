// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

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
      // Show error message using ScaffoldMessenger
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
          title: const Text('Account Details'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $_name',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mobile: $_mobile',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Address: $_address',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Email: $_email',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _identityProofURL.isNotEmpty
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PDFViewer(documentURL: _identityProofURL),
                                ),
                              );
                            },
                            child: const Text('View Identity Proof'),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 12),
                    _drivingLicenseURL.isNotEmpty
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFViewer(
                                      documentURL: _drivingLicenseURL),
                                ),
                              );
                            },
                            child: const Text('View Driving License'),
                          )
                        : const SizedBox(),
                  ],
                ),
              ));
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
      body: PDFView(
        filePath: documentURL,
      ),
    );
  }
}
