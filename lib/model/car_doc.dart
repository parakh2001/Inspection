class Inspection {
  final Map<String, CarDoc> inspections;

  Inspection({required this.inspections});

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      inspections: (json['inspection'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, CarDoc.fromJson(value['car_doc'])),
      ),
    );
  }
}

class CarDoc {
  final CarDetails carDetails;
  final Others others;
  final RcDetails rcDetails;
  final RegistrationDetails registrationDetails;

  CarDoc({
    required this.carDetails,
    required this.others,
    required this.rcDetails,
    required this.registrationDetails,
  });

  factory CarDoc.fromJson(Map<String, dynamic> json) {
    return CarDoc(
      carDetails: CarDetails.fromJson(json['car_details']),
      others: Others.fromJson(json['others']),
      rcDetails: RcDetails.fromJson(json['rc_details']),
      registrationDetails:
          RegistrationDetails.fromJson(json['registration_details']),
    );
  }
}

class CarDetails {
  final String carMake;
  final String carModel;
  final String fuelType;
  final List<String> images;
  final String mfgYearMonth;
  final String transmission;

  CarDetails({
    required this.carMake,
    required this.carModel,
    required this.fuelType,
    required this.images,
    required this.mfgYearMonth,
    required this.transmission,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      carMake: json['car_make'],
      carModel: json['car_model'],
      fuelType: json['fuel_type'],
      images: List<String>.from(json['images']),
      mfgYearMonth: json['mfg_year_month'],
      transmission: json['transmission'],
    );
  }
}

class Others {
  final String chassisNumberImage;
  final String engineNumber;
  final bool hsrpAvailable;
  final List<String> images;
  final bool isChassisNumberOk;
  final int noOfKeys;
  final String owners;

  Others({
    required this.chassisNumberImage,
    required this.engineNumber,
    required this.hsrpAvailable,
    required this.images,
    required this.isChassisNumberOk,
    required this.noOfKeys,
    required this.owners,
  });

  factory Others.fromJson(Map<String, dynamic> json) {
    return Others(
      chassisNumberImage: json['chassisNumberImage'],
      engineNumber: json['engine_number'],
      hsrpAvailable: json['hsrp_available'],
      images: List<String>.from(json['images']),
      isChassisNumberOk: json['isChassisNumberOk'],
      noOfKeys: json['noOfKeys'],
      owners: json['owners'],
    );
  }
}

class RcDetails {
  final String rcImage;
  final String rcNumber;

  RcDetails({
    required this.rcImage,
    required this.rcNumber,
  });

  factory RcDetails.fromJson(Map<String, dynamic> json) {
    return RcDetails(
      rcImage: json['rc_image'],
      rcNumber: json['rc_number'],
    );
  }
}

class RegistrationDetails {
  final String registrationYearMonth;

  RegistrationDetails({required this.registrationYearMonth});

  factory RegistrationDetails.fromJson(Map<String, dynamic> json) {
    return RegistrationDetails(
      registrationYearMonth: json['registration_year_month'],
    );
  }
}
