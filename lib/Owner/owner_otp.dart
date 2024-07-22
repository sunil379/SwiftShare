// otp_verification.dart

// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftshare_one/Owner/owner_homescreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String userId; //userId field to accept the user document ID
  final String name;
  final String mobile;
  final String address;
  final String email;
  final String identityProofURL;
  final String vehicleRCURL;
  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.userId,
    required this.name,
    required this.mobile,
    required this.address,
    required this.email,
    required this.identityProofURL,
    required this.vehicleRCURL, // Pass userId from the registration screen
  });
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late ScaffoldMessengerState _scaffoldMessengerState;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  Future<void> _verifyOTP(BuildContext context, String userId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text.trim(),
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      // Add user's phone number to Firestore
      await _firestore.collection('owners').doc(userCredential.user!.uid).set({
        'phoneNumber': widget.phoneNumber,
        'name': widget.name,
        'mobile': widget.mobile,
        'address': widget.address,
        'email': widget.email,
        'identityProofURL': widget.identityProofURL,
        'drivingLicenseURL': widget.vehicleRCURL,
      });

      setState(() {
        isLoading = false;
      });

      _scaffoldMessengerState.showSnackBar(const SnackBar(
        content: Text("Account created successfully."),
      ));
      // Navigate HomeScreen
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OwnerHomeScreen(),
        ),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      _scaffoldMessengerState.showSnackBar(SnackBar(
        content: Text("Error verifying OTP: $error"),
      ));
    }
  }

  String? _verificationId;

  Future<void> _sendOTP() async {
    verificationCompleted(AuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
    }

    verificationFailed(FirebaseAuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    }

    codeSent(String verificationId, int? resendToken) async {
      setState(() {
        _verificationId = verificationId;
      });
    }

    codeAutoRetrievalTimeout(String verificationId) {
      setState(() {
        _verificationId = verificationId;
      });
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (error) {
      _scaffoldMessengerState
          .showSnackBar(SnackBar(content: Text('Error sending OTP: $error')));
    }
  }

  void _resendOTP() {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    _sendOTP().then((_) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      _scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    }).catchError((error) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resending OTP: $error')),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  isLoading ? null : () => _verifyOTP(context, widget.userId),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verify OTP'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: isLoading ? null : _resendOTP,
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
