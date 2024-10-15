import 'package:flutter/material.dart';

class CarIconUtils {
  static Widget buildCarIcon(String? fuelType) {
    switch (fuelType) {
      case 'Petrol':
        return const Icon(Icons.local_gas_station, color: Colors.red);
      case 'Diesel':
        return const Icon(Icons.local_gas_station, color: Colors.green);
      case 'CNG':
        return const Icon(Icons.nature_people, color: Colors.orange);
      default:
        return const Icon(Icons.error, color: Colors.grey);
    }
  }
}
