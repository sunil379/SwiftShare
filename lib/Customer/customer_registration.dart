// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:swiftshare_one/Customer/customer_otp.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  const CustomerRegistrationScreen({super.key});

  @override
  _CustomerRegistrationScreenState createState() =>
      _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? identityProofURL;
  String? drivingLicenseURL;
  double uploadProgress = 0.0; // Track upload progress

  bool _validateInputs() {
    return nameController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  Future<void> _createAccount(BuildContext context) async {
    try {
      final String name = nameController.text;
      final String mobile = mobileController.text;
      final String address = addressController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      if (!_validateInputs()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill in all required fields."),
        ));
        return;
      }
      // Check if password and confirm password match
      if (password != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Passwords do not match."),
        ));
        return;
      }

      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      await _firestore
          .collection('customers')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'mobile': mobile,
        'address': address,
        'email': email,
        'identityProofURL': identityProofURL,
        'drivingLicenseURL': drivingLicenseURL,
      });
      // Navigate to OTP verification screen
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: mobile,
            userId: userCredential.user!.uid,
          ),
        ),
      );

      // Navigate to another screen or perform any action after successful registration
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Account created successfully."),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error creating account: $error"),
      ));
    }
  }

  Future<String> _uploadFile(File file, String fileName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Customer_Documents/$fileName');
      firebase_storage.UploadTask task = ref.putFile(file);

      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        setState(() {
          uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await task;

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }

  Future<String?> _uploadDocument(
      BuildContext context, String documentType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName =
            '$documentType-${DateTime.now().millisecondsSinceEpoch}.pdf';
        String downloadURL = await _uploadFile(file, fileName);
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Document uploaded successfully."),
        ));
        return downloadURL;
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No file selected."),
        ));
        return null;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error uploading document: $error"),
      ));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FOR CUSTOMER"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "New User Registration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please enter the details below",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: "Please enter country code (e.g.+91) "),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final url = await _uploadDocument(context, "identity_proof");
                if (url != null) {
                  setState(() {
                    identityProofURL = url;
                  });
                }
              },
              child: const Text('Submit the Identity Proof'),
            ),
            if (identityProofURL != null)
              LinearProgressIndicator(
                value: uploadProgress,
                minHeight: 10,
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final url = await _uploadDocument(context, "driving_license");
                if (url != null) {
                  setState(() {
                    drivingLicenseURL = url;
                  });
                }
              },
              child: const Text('Submit the Driving License'),
            ),
            if (drivingLicenseURL != null)
              LinearProgressIndicator(
                value: uploadProgress,
                minHeight: 10,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _createAccount(context),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
