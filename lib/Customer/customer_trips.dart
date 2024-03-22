// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'Previous'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOngoingBookings(),
          _buildPreviousBookings(),
        ],
      ),
    );
  }

  Widget _buildOngoingBookings() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Your Booking: SS12911234'),
            subtitle: const Text('Hyundai - 2021'),
            trailing: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('29/11/2023'),
                Text('05/01/2024'),
              ],
            ),
            onTap: () {
              // Navigate to more booking details screen
            },
          ),
        );
      },
    );
  }

  Widget _buildPreviousBookings() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Previous Booking: SS12911234'),
            subtitle: const Text('Hyundai - 2021'),
            trailing: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('29/11/2023'),
                Text('05/01/2024'),
              ],
            ),
            onTap: () {
              // Navigate to more booking details screen
            },
          ),
        );
      },
    );
  }
}
