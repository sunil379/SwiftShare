// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _nameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _retypePasswordFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? identityProofURL;
  String? vehicleRCURL;
  double uploadProgress = 0.0; // Track upload progress

  bool _validateInputs() {
    return nameController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  void _showSuccessSnackBar() {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text("Details uploaded, moving to OTP verification"),
      ),
    );
  }

  void _showErrorSnackBar(String error) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text("Error creating account: $error"),
      ),
    );
  }

  Future<void> _createAccount(BuildContext context) async {
    try {
      final String name = nameController.text;
      final String mobile = mobileController.text;
      final String address = addressController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      const String role = "owner";

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
      await _firestore.collection('owners').doc(userCredential.user!.uid).set({
        'name': name,
        'mobile': mobile,
        'address': address,
        'email': email,
        'identityProofURL': identityProofURL,
        'vehicleRC_URL': vehicleRCURL,
        'role': role,
      });

      _showSuccessSnackBar();
      // Navigate to OTP verification screen
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: mobile,
            userId: userCredential.user!.uid,
            name: name,
            mobile: mobile,
            address: address,
            email: email,
            identityProofURL: identityProofURL ?? '',
            vehicleRCURL: vehicleRCURL ?? '',
          ),
        ),
      );
    } catch (error) {
      _showErrorSnackBar(error.toString());
    }
  }

  Future<String> _uploadFile(File file, String fileName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Owner_Documents/$fileName');
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
        title: const Text(
          "FOR OWNER",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.4, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "New Owner Registration",
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
                focusNode: _nameFocusNode,
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  _nameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_mobileFocusNode);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                focusNode: _mobileFocusNode,
                controller: mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: "Please select country code",
                  prefixIcon: CountryCodePicker(
                    onChanged: (CountryCode? code) {
                      setState(() {
                        mobileController.text = code!.dialCode!;
                      });
                    },
                    initialSelection: 'IN',
                    favorite: const ['+91'],
                    alignLeft: false,
                    flagWidth: 18,
                  ),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  _mobileFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_addressFocusNode);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                focusNode: _addressFocusNode,
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  _addressFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                focusNode: _emailFocusNode,
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  _addressFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                focusNode: _passwordFocusNode,
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  _passwordFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_retypePasswordFocusNode);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                focusNode: _retypePasswordFocusNode,
                controller: confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
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
                child: const Text(
                  'Submit the Identity Proof',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              if (identityProofURL != null)
                LinearProgressIndicator(
                  value: uploadProgress,
                  minHeight: 10,
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final url = await _uploadDocument(context, "vehicle_rc");
                  if (url != null) {
                    setState(() {
                      vehicleRCURL = url;
                    });
                  }
                },
                child: const Text(
                  'Submit the Vehicle RC ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              if (vehicleRCURL != null)
                LinearProgressIndicator(
                  value: uploadProgress,
                  minHeight: 10,
                ),
              SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.blueGrey.shade900,
                  thickness: 2.0,
                ),
              ),
              ElevatedButton(
                onPressed: () => _createAccount(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _addressFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _retypePasswordFocusNode.dispose();
    super.dispose();
  }
}
