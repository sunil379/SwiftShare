// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:swiftshare_one/Owner/owner_otp.dart';

class OwnerRegistrationScreen extends StatefulWidget {
  const OwnerRegistrationScreen({super.key});

  @override
  _OwnerRegistrationScreenState createState() =>
      _OwnerRegistrationScreenState();
}

class _OwnerRegistrationScreenState extends State<OwnerRegistrationScreen> {
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
  String? vehicleRCURL;
  double? identityProofUploadProgress;
  double? vehicleRCUploadProgress;

  Future<void> _createAccount(BuildContext context) async {
    try {
      final String name = nameController.text;
      final String mobile = mobileController.text;
      final String address = addressController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      // Check if documents are uploaded
      if (identityProofURL == null || vehicleRCURL == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please upload documents."),
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
      await _firestore.collection('owners').doc(userCredential.user!.uid).set({
        'name': name,
        'mobile': mobile,
        'address': address,
        'email': email,
        'identityProofURL': identityProofURL,
        'vehicleRCURL': vehicleRCURL,
      });

      // Navigate to OTP verification screen
      await Navigator.push(
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
      // Example: Navigator.pushReplacementNamed(context, '/home');
      Navigator.pushReplacementNamed(context, '/owner_home');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error creating account: $error"),
      ));
    }
  }

  Future<String?> _uploadFile(
      File file, String fileName, Function(double)? onProgress) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Owner_Documents/$fileName');
      firebase_storage.UploadTask task = ref.putFile(
          file, firebase_storage.SettableMetadata(contentType: 'pdf'));

      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        double progress =
            snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        if (onProgress != null) {
          onProgress(progress);
        }
      });

      await task.whenComplete(() => {});

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> _uploadDocuments(BuildContext context) async {
    try {
      String? uploadedIdentityProofURL =
          await _uploadDocument(context, "identity_proof", (progress) {
        setState(() {
          identityProofUploadProgress = progress;
        });
      });
      String? uploadedVehicleRCURL =
          await _uploadDocument(context, "vehicle_rc", (progress) {
        setState(() {
          vehicleRCUploadProgress = progress;
        });
      });

      if (uploadedIdentityProofURL != null && uploadedVehicleRCURL != null) {
        setState(() {
          identityProofURL = uploadedIdentityProofURL;
          vehicleRCURL = uploadedVehicleRCURL;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Documents uploaded successfully."),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error uploading documents: $error"),
      ));
    }
  }

  Future<String?> _uploadDocument(BuildContext context, String documentType,
      Function(double)? onProgress) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName =
            '$documentType-${DateTime.now().millisecondsSinceEpoch}.pdf';
        String? downloadURL = await _uploadFile(file, fileName, onProgress);
        // Display success message
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
        title: const Text("FOR OWNER"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "New Renter Registration",
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
              decoration: const InputDecoration(labelText: 'Mobile Number',
                  hintText: 'Please enter country code (e.g. +91) '),
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
              onPressed: () => _uploadDocuments(context),
              child: const Text('Submit Documents'),
            ),
            const SizedBox(height: 16),
            identityProofUploadProgress != null ||
                    vehicleRCUploadProgress != null
                ? Column(
                    children: [
                      Text(
                        'Identity Proof Upload Progress: ${(identityProofUploadProgress ?? 0) * 100}%',
                      ),
                      LinearProgressIndicator(
                        value: identityProofUploadProgress ?? 0,
                      ),
                      Text(
                        'Vehicle RC Upload Progress: ${(vehicleRCUploadProgress ?? 0) * 100}%',
                      ),
                      LinearProgressIndicator(
                        value: vehicleRCUploadProgress ?? 0,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: identityProofURL != null && vehicleRCURL != null
                  ? () => _createAccount(context)
                  : null,
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
