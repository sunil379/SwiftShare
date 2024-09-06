// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String name = '';
  late String mobile = '';
  late String address = '';
  late String email = '';
  late String identityProofURL = '';
  late String vehicleRCURL = '';

  bool isLoading = true;

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
            await _firestore.collection('owners').doc(user.uid).get();

        if (mounted) {
          setState(() {
            name = userData['name'];
            mobile = userData['mobile'];
            address = userData['address'];
            email = userData['email'];
            identityProofURL = userData['identityProofURL'];
            vehicleRCURL = userData['vehicleRC_URL'];
            isLoading = false;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildProfileImage(),
                  const SizedBox(height: 24),
                  buildEditableField('Name  ', ' $name',
                      (value) => name = value, Colors.white, Colors.blue),
                  const SizedBox(height: 12.0),
                  buildEditableField('Mobile ', ' $mobile',
                      (value) => mobile = value, Colors.white, Colors.blue),
                  const SizedBox(height: 12.0),
                  buildEditableField('Address', address,
                      (value) => address = value, Colors.white, Colors.blue),
                  const SizedBox(height: 12.0),
                  buildEditableField('Email  ', ' $email',
                      (value) => email = value, Colors.white, Colors.blue),
                  const SizedBox(height: 20),
                  Divider(
                    thickness: 3.5, // Adjust the thickness of the line
                    color: Colors.black
                        .withOpacity(0.4), // Set the color of the line
                  ),
                  const SizedBox(height: 30),
                  if (identityProofURL.isNotEmpty)
                    buildPDFButton(
                      'View Identity Proof',
                      identityProofURL,
                      Colors.deepPurple,
                    ),
                  const SizedBox(height: 12),
                  if (vehicleRCURL.isNotEmpty)
                    buildPDFButton(
                      'View Vehicel RC',
                      vehicleRCURL,
                      Colors.deepPurple,
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }

  Widget buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
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
    );
  }

  Widget buildEditableField(String label, String value, Function(String) onSave,
      Color startColor, Color endColor) {
    return Container(
      width: 400,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            startColor.withOpacity(0.1),
            endColor.withOpacity(0.9),
          ],
          stops: const [0.27, 0.24],
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              editField(label, value, onSave);
            },
          ),
        ],
      ),
    );
  }

  void editField(String label, String initialValue, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: initialValue);
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                onSave(controller.text);
                updateUserDetails();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('customers').doc(user.uid).update({
          'name': name,
          'mobile': mobile,
          'address': address,
          'email': email,
        });
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details updated successfully')),
        );
      }
    } catch (error) {
      print('Error updating user details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating details: $error')),
      );
    }
  }

  Widget buildPDFButton(
      String buttonText, String documentURL, Color backgroundColor) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {
            launchPDF(documentURL); // Launch PDF on button press
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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

  Future<void> launchPDF(String documentURL) async {
    try {
      if (await canLaunch(documentURL)) {
        await launch(documentURL);
      } else {
        throw 'Could not launch $documentURL';
      }
    } catch (e) {
      print('Error launching PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error opening PDF'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
