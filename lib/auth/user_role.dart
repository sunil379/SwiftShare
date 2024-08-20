import 'package:flutter/material.dart';

class UserRoleProvider with ChangeNotifier {
  String? _role; //

  String? get role => _role;

  void setRole(String role) {
    role = role;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to check if the user is a Customer
  bool get isCustomer => _role == 'Customer';

  // Method to check if the user is an Owner
  bool get isOwner => _role == 'Owner';
}
