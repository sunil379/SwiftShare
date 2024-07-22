// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swiftshare_one/Owner/owner_homescreen.dart';
import 'package:swiftshare_one/Owner/owner_registration.dart';
import 'package:swiftshare_one/Owner/own_forget_pass.dart';

class OwnerLoginScreen extends StatelessWidget {
  OwnerLoginScreen({super.key});

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigate to the home screen after successful login
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OwnerHomeScreen()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error signing in with email and password : $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.4, 1.0]),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'SWIFTSHARE',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "wheels on demand",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'FOR OWNER',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please enter your login credentials below',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      focusNode: _emailFocusNode,
                      decoration:
                          const InputDecoration(labelText: 'Email Address'),
                      onSubmitted: (_) {
                        // When user submits on email field, move focus to password field
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordScreen(
                                    emailController: emailController,
                                    auth: _auth),
                              ),
                            );
                          },
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      onSubmitted: (_) {
                        // When user submits on password field, attempt sign in
                        String email = emailController.text;
                        String password = passwordController.text;
                        _signInWithEmailAndPassword(email, password, context);
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        String email = emailController.text;
                        String password = passwordController.text;
                        _signInWithEmailAndPassword(email, password, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not registered?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            width: 180,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OwnerRegistrationScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create an account',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
