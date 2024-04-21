import 'package:flutter/material.dart';
import 'package:swiftshare_one/Customer/customer_login.dart';
import 'package:swiftshare_one/pages/app_start.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightBlue,
            ],
            begin: startAlignment,
            end: endAlignment,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ), // To adjust for status bar
              Image.asset(
                'assets/images/rectangle-7.png',
                width: 250, // Adjust the width as needed
                height: 170, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
              const Text(
                'SWIFTSHARE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "wheels on demand",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 150),
              const Text(
                'Please Sign in or Register',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerLoginScreen(),
                    ),
                  );
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
                    horizontal: 60,
                  ),
                  child: Text(
                    'LOGIN/REGISTER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 24),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => OwnerLoginScreen(),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue.shade900,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(
              //       vertical: 12,
              //       horizontal: 80,
              //     ),
              //     child: Text(
              //       'OWNER',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 20,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
