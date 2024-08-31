import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
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
      body: Column(
        children: [
          const SizedBox(
            width: 400,
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/rectangle-7.png'),
                  width: 150,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Text(
                  'SWIFTSHARE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 500,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                child: Text(
                  "SwiftShare is a platform designed to simplify and streamline the process of renting various types of vehicles. With a diverse fleet of bikes, scooters, cars, and e-vehicles.\n\n SwiftShare ensures a seamless experience from browsing required vehicles to quick reservation. Offering flexible rental options ranging from hourly, weekly to monthly durations.\n\n SwiftShare caters to both locals and tourists, offering a convenient and eco-friendly alternative to traditional transportation methods.",
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
