import 'package:flutter/material.dart';

class Inspection {
  final String carId;
  final CarDoc carDoc;

  Inspection({
    required this.carId,
    required this.carDoc,
  });

  factory Inspection.fromMap(Map<dynamic, dynamic> data) {
    return Inspection(
      carId: data['car_id'] ?? '',
      carDoc: CarDoc.fromMap(data['car_doc']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'car_id': carId,
      'car_doc': carDoc.toMap(),
    };
  }
}

class CarDoc {
  final RcDetails rcDetails;
  final CarDetails carDetails;
  final RegistrationDetails registrationDetails;
  final Others others;

  CarDoc({
    required this.rcDetails,
    required this.carDetails,
    required this.registrationDetails,
    required this.others,
  });

  factory CarDoc.fromMap(Map<dynamic, dynamic> data) {
    return CarDoc(
      rcDetails: RcDetails.fromMap(data['rc_details']),
      carDetails: CarDetails.fromMap(data['car_details']),
      registrationDetails:
          RegistrationDetails.fromMap(data['registration_details']),
      others: Others.fromMap(data['others']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rc_details': rcDetails.toMap(),
      'car_details': carDetails.toMap(),
      'registration_details': registrationDetails.toMap(),
      'others': others.toMap(),
    };
  }
}

class RcDetails {
  final String rcNumber;
  final String rcImage;

  RcDetails({
    required this.rcNumber,
    required this.rcImage,
  });

  factory RcDetails.fromMap(Map<dynamic, dynamic> data) {
    return RcDetails(
      rcNumber: data['rc_number'] ?? '',
      rcImage: data['rc_image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rc_number': rcNumber,
      'rc_image': rcImage,
    };
  }
}

class CarDetails {
  final String mfgYearMonth;
  final String carMake;
  final String carModel;
  final String fuelType;
  final String transmission;
  final String images;

  CarDetails({
    required this.mfgYearMonth,
    required this.carMake,
    required this.carModel,
    required this.fuelType,
    required this.transmission,
    required this.images,
  });

  factory CarDetails.fromMap(Map<dynamic, dynamic> data) {
    return CarDetails(
      mfgYearMonth: data['mfg_year_month'] ?? '',
      carMake: data['car_make'] ?? '',
      carModel: data['car_model'] ?? '',
      fuelType: data['fuel_type'] ?? '',
      transmission: data['transmission'] ?? '',
      images: data['images'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mfg_year_month': mfgYearMonth,
      'car_make': carMake,
      'car_model': carModel,
      'fuel_type': fuelType,
      'transmission': transmission,
      'images': images,
    };
  }
}

class RegistrationDetails {
  final String registrationYearMonth;

  RegistrationDetails({
    required this.registrationYearMonth,
  });

  factory RegistrationDetails.fromMap(Map<dynamic, dynamic> data) {
    return RegistrationDetails(
      registrationYearMonth: data['registration_year_month'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registration_year_month': registrationYearMonth,
    };
  }
}

class Others {
  final int owners;
  final bool hsrpAvailable;
  final String engineNumber;
  final bool isChassisNumberOk;
  final String chassisNumberImage;
  final int noOfKeys;
  final List<String> images;
  final String engineImage;

  Others({
    required this.owners,
    required this.hsrpAvailable,
    required this.engineNumber,
    required this.isChassisNumberOk,
    required this.chassisNumberImage,
    required this.noOfKeys,
    required this.images,
    required this.engineImage,
  });

  factory Others.fromMap(Map<dynamic, dynamic> map) {
    return Others(
      owners: map['owners'] ?? 0,
      hsrpAvailable: map['hsrpAvailable'] ?? false,
      engineNumber: map['engineNumber'] ?? '',
      isChassisNumberOk: map['isChassisNumberOk'] ?? false,
      chassisNumberImage: map['chassisNumberImage'] ?? '',
      noOfKeys: map['noOfKeys'] ?? 0,
      images: List<String>.from(map['images'] ?? []),
      engineImage: map['engineImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'owners': owners,
      'hsrpAvailable': hsrpAvailable,
      'engineNumber': engineNumber,
      'isChassisNumberOk': isChassisNumberOk,
      'chassisNumberImage': chassisNumberImage,
      'noOfKeys': noOfKeys,
      'images': images,
      'engineImage': engineImage,
    };
  }
}
