// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Trips'),
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: const [
        //     Tab(text: 'Ongoing'),
        //     Tab(text: 'Previous'),
        //   ],
        // ),
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
                )),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ),
      ),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: [
      //     _buildOngoingBookings(),
      //     _buildPreviousBookings(),
      //   ],
      // ),
      body: const Center(
        child: Text(
          'No Trips yet!',
          style: TextStyle(
            fontSize: 20, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Adjust the font weight as needed
          ),
        ),
      ),
    );
  }

//   Widget _buildOngoingBookings() {
//     return ListView.builder(
//       itemCount: 2,
//       itemBuilder: (context, index) {
//         return Card(
//           child: ListTile(
//             leading: const Icon(Icons.directions_car),
//             title: const Text('Your Booking: SS12911234'),
//             subtitle: const Text('Hyundai - 2021'),
//             trailing: const Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text('29/11/2023'),
//                 Text('05/01/2024'),
//               ],
//             ),
//             onTap: () {
//               // Navigate to more booking details screen
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPreviousBookings() {
//     return ListView.builder(
//       itemCount: 2,
//       itemBuilder: (context, index) {
//         return Card(
//           child: ListTile(
//             leading: const Icon(Icons.history),
//             title: const Text('Previous Booking: SS12911234'),
//             subtitle: const Text('Hyundai - 2021'),
//             trailing: const Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text('29/11/2023'),
//                 Text('05/01/2024'),
//               ],
//             ),
//             onTap: () {
//               // Navigate to more booking details screen
//             },
//           ),
//         );
//       },
//     );
//   }
//
}
