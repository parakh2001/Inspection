import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class InspectionService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Future<void> sendInspectionData(Map<String, dynamic> inspectionData) async {
    try {
      final response = await http.post(
        Uri.parse('https://gowaggon.com/crm/api/PostInspection'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(inspectionData),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Successfully inserted data
        print('Data inserted successfully: ${response.body}');
      } else {
        // Handle error response
        print(
            'Failed to insert data: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      print('Error sending data to API: $error');
    }
  }

  Future<void> postInspectionData(int serialNumber) async {
    print('this funciton is working fine');
    DatabaseEvent event =
        await _databaseReference.child('inspection/$serialNumber').once();

    if (event.snapshot.exists && event.snapshot.value != null) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      // Prepare the inspection data for the API
      Map<String, dynamic> inspectionData = {
        "serial_number": serialNumber,
        "car_doc": {
          "car_details": {
            "car_make": data['car_doc']?['car_details']?['car_make'] ?? 'N/A',
            "car_model": data['car_doc']?['car_details']?['car_model'] ?? 'N/A',
            "fuel_type": data['car_doc']?['car_details']?['fuel_type'] ?? 'N/A',
            "images": data['car_doc']?['car_details']?['images'] ?? '',
            "mfg_year_month":
                data['car_doc']?['car_details']?['mfg_year_month'] ?? 'N/A',
            "transmission":
                data['car_doc']?['car_details']?['transmission'] ?? 'N/A',
          },
          "others": {
            "chassisNumberImage":
                data['car_doc']?['others']?['chassisNumberImage'] ?? '',
            "engine_number":
                data['car_doc']?['others']?['engine_number'] ?? 'N/A',
            "hsrp_available":
                data['car_doc']?['others']?['hsrp_available'] ?? false,
            "isChassisNumberOk":
                data['car_doc']?['others']?['isChassisNumberOk'] ?? false,
            "noOfKeys": data['car_doc']?['others']?['noOfKeys'] ?? 0,
            "owners": data['car_doc']?['others']?['owners'] ?? 0,
          },
          "rc_details": {
            "rc_image": data['car_doc']?['rc_details']?['rc_image'] ?? '',
            "rc_number": data['car_doc']?['rc_details']?['rc_number'] ?? 'N/A',
          },
          "registration_details": {
            "registration_year_month": data['car_doc']?['registration_details']
                    ?['registration_year_month'] ??
                'N/A',
          },
        },
        "car_health": {
          "exterior": {
            "comments": data['car_health']?['exterior']?['comments'] ?? '',
            "images": data['car_health']?['exterior']?['images'] ?? [],
          },
          "extra": {
            "comments": data['car_health']?['extra']?['comments'] ?? '',
            "images": data['car_health']?['extra']?['images'] ?? [],
          },
          "final_verdict": data['car_health']?['final_verdict'] ?? '',
          "interior": {
            "comments": data['car_health']?['interior']?['comments'] ?? '',
            "images": data['car_health']?['interior']?['images'] ?? [],
          },
          "test_drive": {
            "comments": data['car_health']?['test_drive']?['comments'] ?? '',
            "images": data['car_health']?['test_drive']?['images'] ?? [],
          },
        },
      };

      // Now you can send the inspectionData to the API
      await sendInspectionData(inspectionData);
    } else {
      print('No valid data found for inspection ID: $serialNumber');
    }
  }
}
