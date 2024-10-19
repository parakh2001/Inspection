import 'dart:convert';

class CarDetails {
  int? serialNumber;
  CarDoc? carDoc;
  CarHealth? carHealth;
  String? carId;
  String? reMarks;

  CarDetails({
    this.carDoc,
    this.carHealth,
    this.carId,
    this.reMarks,
    this.serialNumber,
  });

  CarDetails copyWith({
    CarDoc? carDoc,
    CarHealth? carHealth,
    String? carId,
    String? reMarks,
    int? serialNumber,
  }) =>
      CarDetails(
        carDoc: carDoc ?? this.carDoc,
        carHealth: carHealth ?? this.carHealth,
        carId: carId ?? this.carId,
        reMarks: reMarks ?? this.reMarks,
        serialNumber: serialNumber ?? this.serialNumber,
      );

  factory CarDetails.fromJson(String str) =>
      CarDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarDetails.fromMap(Map<String, dynamic> json) => CarDetails(
        carDoc:
            json["car_doc"] == null ? null : CarDoc.fromMap(json["car_doc"]),
        carHealth: json["car_health"] == null
            ? null
            : CarHealth.fromMap(json["car_health"]),
        carId: json["car_id"],
        reMarks: json["reMarks"],
        serialNumber: json["serialNumber"],
      );

  Map<String, dynamic> toMap() => {
        "car_doc": carDoc?.toMap(),
        "car_health": carHealth?.toMap(),
        "car_id": carId,
        "reMarks": reMarks,
        "serialNumber": serialNumber,
      };
}

class CarDoc {
  CarDetailsClass? carDetails;
  Others? others;
  RcDetails? rcDetails;
  RegistrationDetails? registrationDetails;

  CarDoc({
    this.carDetails,
    this.others,
    this.rcDetails,
    this.registrationDetails,
  });

  CarDoc copyWith({
    CarDetailsClass? carDetails,
    Others? others,
    RcDetails? rcDetails,
    RegistrationDetails? registrationDetails,
  }) =>
      CarDoc(
        carDetails: carDetails ?? this.carDetails,
        others: others ?? this.others,
        rcDetails: rcDetails ?? this.rcDetails,
        registrationDetails: registrationDetails ?? this.registrationDetails,
      );

  factory CarDoc.fromJson(String str) => CarDoc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarDoc.fromMap(Map<String, dynamic> json) => CarDoc(
        carDetails: json["car_details"] == null
            ? null
            : CarDetailsClass.fromMap(json["car_details"]),
        others: json["others"] == null ? null : Others.fromMap(json["others"]),
        rcDetails: json["rc_details"] == null
            ? null
            : RcDetails.fromMap(json["rc_details"]),
        registrationDetails: json["registration_details"] == null
            ? null
            : RegistrationDetails.fromMap(json["registration_details"]),
      );

  Map<String, dynamic> toMap() => {
        "car_details": carDetails?.toMap(),
        "others": others?.toMap(),
        "rc_details": rcDetails?.toMap(),
        "registration_details": registrationDetails?.toMap(),
      };
}

class CarDetailsClass {
  String? carMake;
  String? carModel;
  String? fuelType;
  String? images;
  String? mfgYearMonth;
  String? transmission;

  CarDetailsClass({
    this.carMake,
    this.carModel,
    this.fuelType,
    this.images,
    this.mfgYearMonth,
    this.transmission,
  });

  CarDetailsClass copyWith({
    String? carMake,
    String? carModel,
    String? fuelType,
    String? images,
    String? mfgYearMonth,
    String? transmission,
  }) =>
      CarDetailsClass(
        carMake: carMake ?? this.carMake,
        carModel: carModel ?? this.carModel,
        fuelType: fuelType ?? this.fuelType,
        images: images ?? this.images,
        mfgYearMonth: mfgYearMonth ?? this.mfgYearMonth,
        transmission: transmission ?? this.transmission,
      );

  factory CarDetailsClass.fromJson(String str) =>
      CarDetailsClass.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarDetailsClass.fromMap(Map<String, dynamic> json) => CarDetailsClass(
        carMake: json["car_make"],
        carModel: json["car_model"],
        fuelType: json["fuel_type"],
        images: json["images"],
        mfgYearMonth: json["mfg_year_month"],
        transmission: json["transmission"],
      );

  Map<String, dynamic> toMap() => {
        "car_make": carMake,
        "car_model": carModel,
        "fuel_type": fuelType,
        "images": images,
        "mfg_year_month": mfgYearMonth,
        "transmission": transmission,
      };
}

class Others {
  String? chassisNumberImage;
  String? engineNumber;
  bool? hsrpAvailable;
  List<String>? images;
  bool? isChassisNumberOk;
  int? noOfKeys;
  int? owners;

  Others({
    this.chassisNumberImage,
    this.engineNumber,
    this.hsrpAvailable,
    this.images,
    this.isChassisNumberOk,
    this.noOfKeys,
    this.owners,
  });

  Others copyWith({
    String? chassisNumberImage,
    String? engineNumber,
    bool? hsrpAvailable,
    List<String>? images,
    bool? isChassisNumberOk,
    int? noOfKeys,
    int? owners,
  }) =>
      Others(
        chassisNumberImage: chassisNumberImage ?? this.chassisNumberImage,
        engineNumber: engineNumber ?? this.engineNumber,
        hsrpAvailable: hsrpAvailable ?? this.hsrpAvailable,
        images: images ?? this.images,
        isChassisNumberOk: isChassisNumberOk ?? this.isChassisNumberOk,
        noOfKeys: noOfKeys ?? this.noOfKeys,
        owners: owners ?? this.owners,
      );

  factory Others.fromJson(String str) => Others.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Others.fromMap(Map<String, dynamic> json) => Others(
        chassisNumberImage: json["chassisNumberImage"],
        engineNumber: json["engine_number"],
        hsrpAvailable: json["hsrp_available"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        isChassisNumberOk: json["isChassisNumberOk"],
        noOfKeys: json["noOfKeys"],
        owners: json["owners"],
      );

  Map<String, dynamic> toMap() => {
        "chassisNumberImage": chassisNumberImage,
        "engine_number": engineNumber,
        "hsrp_available": hsrpAvailable,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "isChassisNumberOk": isChassisNumberOk,
        "noOfKeys": noOfKeys,
        "owners": owners,
      };
}

class RcDetails {
  String? rcImage;
  String? rcNumber;

  RcDetails({
    this.rcImage,
    this.rcNumber,
  });

  RcDetails copyWith({
    String? rcImage,
    String? rcNumber,
  }) =>
      RcDetails(
        rcImage: rcImage ?? this.rcImage,
        rcNumber: rcNumber ?? this.rcNumber,
      );

  factory RcDetails.fromJson(String str) => RcDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RcDetails.fromMap(Map<String, dynamic> json) => RcDetails(
        rcImage: json["rc_image"],
        rcNumber: json["rc_number"],
      );

  Map<String, dynamic> toMap() => {
        "rc_image": rcImage,
        "rc_number": rcNumber,
      };
}

class RegistrationDetails {
  String? registrationYearMonth;

  RegistrationDetails({
    this.registrationYearMonth,
  });

  RegistrationDetails copyWith({
    String? registrationYearMonth,
  }) =>
      RegistrationDetails(
        registrationYearMonth:
            registrationYearMonth ?? this.registrationYearMonth,
      );

  factory RegistrationDetails.fromJson(String str) =>
      RegistrationDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegistrationDetails.fromMap(Map<String, dynamic> json) =>
      RegistrationDetails(
        registrationYearMonth: json["registration_year_month"],
      );

  Map<String, dynamic> toMap() => {
        "registration_year_month": registrationYearMonth,
      };
}

class CarHealth {
  Battery? battery;
  Engine? engine;
  Extra? extra;
  FrontSide? frontSide;
  Interior1? interior1;
  Interior2? interior2;
  LeftSide? leftSide;
  RearSide? rearSide;
  RightSide? rightSide;
  TestDrive? testDrive;

  CarHealth({
    this.battery,
    this.engine,
    this.extra,
    this.frontSide,
    this.interior1,
    this.interior2,
    this.leftSide,
    this.rearSide,
    this.rightSide,
    this.testDrive,
  });

  CarHealth copyWith({
    Battery? battery,
    Engine? engine,
    Extra? extra,
    FrontSide? frontSide,
    Interior1? interior1,
    Interior2? interior2,
    LeftSide? leftSide,
    RearSide? rearSide,
    RightSide? rightSide,
    TestDrive? testDrive,
  }) =>
      CarHealth(
        battery: battery ?? this.battery,
        engine: engine ?? this.engine,
        extra: extra ?? this.extra,
        frontSide: frontSide ?? this.frontSide,
        interior1: interior1 ?? this.interior1,
        interior2: interior2 ?? this.interior2,
        leftSide: leftSide ?? this.leftSide,
        rearSide: rearSide ?? this.rearSide,
        rightSide: rightSide ?? this.rightSide,
        testDrive: testDrive ?? this.testDrive,
      );

  factory CarHealth.fromJson(String str) => CarHealth.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarHealth.fromMap(Map<String, dynamic> json) => CarHealth(
        battery:
            json["battery"] == null ? null : Battery.fromMap(json["battery"]),
        engine: json["engine"] == null ? null : Engine.fromMap(json["engine"]),
        extra: json["extra"] == null ? null : Extra.fromMap(json["extra"]),
        frontSide: json["front_side"] == null
            ? null
            : FrontSide.fromMap(json["front_side"]),
        interior1: json["interior-1"] == null
            ? null
            : Interior1.fromMap(json["interior-1"]),
        interior2: json["interior-2"] == null
            ? null
            : Interior2.fromMap(json["interior-2"]),
        leftSide: json["left_side"] == null
            ? null
            : LeftSide.fromMap(json["left_side"]),
        rearSide: json["rear_side"] == null
            ? null
            : RearSide.fromMap(json["rear_side"]),
        rightSide: json["right_side"] == null
            ? null
            : RightSide.fromMap(json["right_side"]),
        testDrive: json["test_drive"] == null
            ? null
            : TestDrive.fromMap(json["test_drive"]),
      );

  Map<String, dynamic> toMap() => {
        "battery": battery?.toMap(),
        "engine": engine?.toMap(),
        "extra": extra?.toMap(),
        "front_side": frontSide?.toMap(),
        "interior-1": interior1?.toMap(),
        "interior-2": interior2?.toMap(),
        "left_side": leftSide?.toMap(),
        "rear_side": rearSide?.toMap(),
        "right_side": rightSide?.toMap(),
        "test_drive": testDrive?.toMap(),
      };
}

class Battery {
  bool? aftermarketFitment;
  bool? damaged;
  String? images;
  bool? leakage;
  bool? wrongSize;

  Battery({
    this.aftermarketFitment,
    this.damaged,
    this.images,
    this.leakage,
    this.wrongSize,
  });

  Battery copyWith({
    bool? aftermarketFitment,
    bool? damaged,
    String? images,
    bool? leakage,
    bool? wrongSize,
  }) =>
      Battery(
        aftermarketFitment: aftermarketFitment ?? this.aftermarketFitment,
        damaged: damaged ?? this.damaged,
        images: images ?? this.images,
        leakage: leakage ?? this.leakage,
        wrongSize: wrongSize ?? this.wrongSize,
      );

  factory Battery.fromJson(String str) => Battery.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Battery.fromMap(Map<String, dynamic> json) => Battery(
        aftermarketFitment: json["aftermarket_fitment"],
        damaged: json["damaged"],
        images: json["images"],
        leakage: json["leakage"],
        wrongSize: json["wrong_size"],
      );

  Map<String, dynamic> toMap() => {
        "aftermarket_fitment": aftermarketFitment,
        "damaged": damaged,
        "images": images,
        "leakage": leakage,
        "wrong_size": wrongSize,
      };
}

class Engine {
  StaticEngineOn? staticEngineOn;

  Engine({
    this.staticEngineOn,
  });

  Engine copyWith({
    StaticEngineOn? staticEngineOn,
  }) =>
      Engine(
        staticEngineOn: staticEngineOn ?? this.staticEngineOn,
      );

  factory Engine.fromJson(String str) => Engine.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Engine.fromMap(Map<String, dynamic> json) => Engine(
        staticEngineOn: json["static_engine_on"] == null
            ? null
            : StaticEngineOn.fromMap(json["static_engine_on"]),
      );

  Map<String, dynamic> toMap() => {
        "static_engine_on": staticEngineOn?.toMap(),
      };
}

class StaticEngineOn {
  CheckForAtGearBoxLeakages? checkForAtGearBoxLeakages;
  CheckForEngineLeakages? checkForEngineLeakages;
  CheckForEnginePerformances? checkForEnginePerformances;
  CheckForManualGearBoxLeakages? checkForManualGearBoxLeakages;
  Videos? videos;

  StaticEngineOn({
    this.checkForAtGearBoxLeakages,
    this.checkForEngineLeakages,
    this.checkForEnginePerformances,
    this.checkForManualGearBoxLeakages,
    this.videos,
  });

  StaticEngineOn copyWith({
    CheckForAtGearBoxLeakages? checkForAtGearBoxLeakages,
    CheckForEngineLeakages? checkForEngineLeakages,
    CheckForEnginePerformances? checkForEnginePerformances,
    CheckForManualGearBoxLeakages? checkForManualGearBoxLeakages,
    Videos? videos,
  }) =>
      StaticEngineOn(
        checkForAtGearBoxLeakages:
            checkForAtGearBoxLeakages ?? this.checkForAtGearBoxLeakages,
        checkForEngineLeakages:
            checkForEngineLeakages ?? this.checkForEngineLeakages,
        checkForEnginePerformances:
            checkForEnginePerformances ?? this.checkForEnginePerformances,
        checkForManualGearBoxLeakages:
            checkForManualGearBoxLeakages ?? this.checkForManualGearBoxLeakages,
        videos: videos ?? this.videos,
      );

  factory StaticEngineOn.fromJson(String str) =>
      StaticEngineOn.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StaticEngineOn.fromMap(Map<String, dynamic> json) => StaticEngineOn(
        checkForAtGearBoxLeakages:
            json["check_for_at_gear_box_leakages"] == null
                ? null
                : CheckForAtGearBoxLeakages.fromMap(
                    json["check_for_at_gear_box_leakages"]),
        checkForEngineLeakages: json["check_for_engine_leakages"] == null
            ? null
            : CheckForEngineLeakages.fromMap(json["check_for_engine_leakages"]),
        checkForEnginePerformances:
            json["check_for_engine_performances"] == null
                ? null
                : CheckForEnginePerformances.fromMap(
                    json["check_for_engine_performances"]),
        checkForManualGearBoxLeakages:
            json["check_for_manual_gear_box_leakages"] == null
                ? null
                : CheckForManualGearBoxLeakages.fromMap(
                    json["check_for_manual_gear_box_leakages"]),
        videos: json["videos"] == null ? null : Videos.fromMap(json["videos"]),
      );

  Map<String, dynamic> toMap() => {
        "check_for_at_gear_box_leakages": checkForAtGearBoxLeakages?.toMap(),
        "check_for_engine_leakages": checkForEngineLeakages?.toMap(),
        "check_for_engine_performances": checkForEnginePerformances?.toMap(),
        "check_for_manual_gear_box_leakages":
            checkForManualGearBoxLeakages?.toMap(),
        "videos": videos?.toMap(),
      };
}

class CheckForAtGearBoxLeakages {
  bool? leakageFromAtGearboxHousing;
  bool? leakageFromAtInputShaft;

  CheckForAtGearBoxLeakages({
    this.leakageFromAtGearboxHousing,
    this.leakageFromAtInputShaft,
  });

  CheckForAtGearBoxLeakages copyWith({
    bool? leakageFromAtGearboxHousing,
    bool? leakageFromAtInputShaft,
  }) =>
      CheckForAtGearBoxLeakages(
        leakageFromAtGearboxHousing:
            leakageFromAtGearboxHousing ?? this.leakageFromAtGearboxHousing,
        leakageFromAtInputShaft:
            leakageFromAtInputShaft ?? this.leakageFromAtInputShaft,
      );

  factory CheckForAtGearBoxLeakages.fromJson(String str) =>
      CheckForAtGearBoxLeakages.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckForAtGearBoxLeakages.fromMap(Map<String, dynamic> json) =>
      CheckForAtGearBoxLeakages(
        leakageFromAtGearboxHousing: json["leakage_from_at_gearbox_housing"],
        leakageFromAtInputShaft: json["leakage_from_at_input_shaft"],
      );

  Map<String, dynamic> toMap() => {
        "leakage_from_at_gearbox_housing": leakageFromAtGearboxHousing,
        "leakage_from_at_input_shaft": leakageFromAtInputShaft,
      };
}

class CheckForEngineLeakages {
  bool? leakageFromEngineBlock;
  bool? leakageFromExhaustManifold;
  bool? leakageFromTurbocharger;
  bool? leakgeFromMetalTiming;
  bool? seepageFromEngineTiming;

  CheckForEngineLeakages({
    this.leakageFromEngineBlock,
    this.leakageFromExhaustManifold,
    this.leakageFromTurbocharger,
    this.leakgeFromMetalTiming,
    this.seepageFromEngineTiming,
  });

  CheckForEngineLeakages copyWith({
    bool? leakageFromEngineBlock,
    bool? leakageFromExhaustManifold,
    bool? leakageFromTurbocharger,
    bool? leakgeFromMetalTiming,
    bool? seepageFromEngineTiming,
  }) =>
      CheckForEngineLeakages(
        leakageFromEngineBlock:
            leakageFromEngineBlock ?? this.leakageFromEngineBlock,
        leakageFromExhaustManifold:
            leakageFromExhaustManifold ?? this.leakageFromExhaustManifold,
        leakageFromTurbocharger:
            leakageFromTurbocharger ?? this.leakageFromTurbocharger,
        leakgeFromMetalTiming:
            leakgeFromMetalTiming ?? this.leakgeFromMetalTiming,
        seepageFromEngineTiming:
            seepageFromEngineTiming ?? this.seepageFromEngineTiming,
      );

  factory CheckForEngineLeakages.fromJson(String str) =>
      CheckForEngineLeakages.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckForEngineLeakages.fromMap(Map<String, dynamic> json) =>
      CheckForEngineLeakages(
        leakageFromEngineBlock: json["leakage_from_engine_block"],
        leakageFromExhaustManifold: json["leakage_from_exhaust_manifold"],
        leakageFromTurbocharger: json["leakage_from_turbocharger"],
        leakgeFromMetalTiming: json["leakge_from_metal_timing"],
        seepageFromEngineTiming: json["seepage_from_engine_timing"],
      );

  Map<String, dynamic> toMap() => {
        "leakage_from_engine_block": leakageFromEngineBlock,
        "leakage_from_exhaust_manifold": leakageFromExhaustManifold,
        "leakage_from_turbocharger": leakageFromTurbocharger,
        "leakge_from_metal_timing": leakgeFromMetalTiming,
        "seepage_from_engine_timing": seepageFromEngineTiming,
      };
}

class CheckForEnginePerformances {
  bool? backCompressionInEngine;
  bool? overheaingDueToRadiatorSystem;
  bool? overheatingInEngine;

  CheckForEnginePerformances({
    this.backCompressionInEngine,
    this.overheaingDueToRadiatorSystem,
    this.overheatingInEngine,
  });

  CheckForEnginePerformances copyWith({
    bool? backCompressionInEngine,
    bool? overheaingDueToRadiatorSystem,
    bool? overheatingInEngine,
  }) =>
      CheckForEnginePerformances(
        backCompressionInEngine:
            backCompressionInEngine ?? this.backCompressionInEngine,
        overheaingDueToRadiatorSystem:
            overheaingDueToRadiatorSystem ?? this.overheaingDueToRadiatorSystem,
        overheatingInEngine: overheatingInEngine ?? this.overheatingInEngine,
      );

  factory CheckForEnginePerformances.fromJson(String str) =>
      CheckForEnginePerformances.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckForEnginePerformances.fromMap(Map<String, dynamic> json) =>
      CheckForEnginePerformances(
        backCompressionInEngine: json["back_compression_in_engine"],
        overheaingDueToRadiatorSystem:
            json["overheaing_due_to_radiator_system"],
        overheatingInEngine: json["overheating_in_engine"],
      );

  Map<String, dynamic> toMap() => {
        "back_compression_in_engine": backCompressionInEngine,
        "overheaing_due_to_radiator_system": overheaingDueToRadiatorSystem,
        "overheating_in_engine": overheatingInEngine,
      };
}

class CheckForManualGearBoxLeakages {
  bool? leakageFrom5ThGearHousing;
  bool? leakageFromDriveAxle;
  bool? leakageFromMtGearboxHousing;
  bool? leakageFromMtInputShaft;

  CheckForManualGearBoxLeakages({
    this.leakageFrom5ThGearHousing,
    this.leakageFromDriveAxle,
    this.leakageFromMtGearboxHousing,
    this.leakageFromMtInputShaft,
  });

  CheckForManualGearBoxLeakages copyWith({
    bool? leakageFrom5ThGearHousing,
    bool? leakageFromDriveAxle,
    bool? leakageFromMtGearboxHousing,
    bool? leakageFromMtInputShaft,
  }) =>
      CheckForManualGearBoxLeakages(
        leakageFrom5ThGearHousing:
            leakageFrom5ThGearHousing ?? this.leakageFrom5ThGearHousing,
        leakageFromDriveAxle: leakageFromDriveAxle ?? this.leakageFromDriveAxle,
        leakageFromMtGearboxHousing:
            leakageFromMtGearboxHousing ?? this.leakageFromMtGearboxHousing,
        leakageFromMtInputShaft:
            leakageFromMtInputShaft ?? this.leakageFromMtInputShaft,
      );

  factory CheckForManualGearBoxLeakages.fromJson(String str) =>
      CheckForManualGearBoxLeakages.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CheckForManualGearBoxLeakages.fromMap(Map<String, dynamic> json) =>
      CheckForManualGearBoxLeakages(
        leakageFrom5ThGearHousing: json["leakage_from_5th_gear_housing"],
        leakageFromDriveAxle: json["leakage_from_drive_axle"],
        leakageFromMtGearboxHousing: json["leakage_from_mt_gearbox_housing"],
        leakageFromMtInputShaft: json["leakage_from_mt_input_shaft"],
      );

  Map<String, dynamic> toMap() => {
        "leakage_from_5th_gear_housing": leakageFrom5ThGearHousing,
        "leakage_from_drive_axle": leakageFromDriveAxle,
        "leakage_from_mt_gearbox_housing": leakageFromMtGearboxHousing,
        "leakage_from_mt_input_shaft": leakageFromMtInputShaft,
      };
}

class Videos {
  String? engineNoiseVideo;
  String? testDriveVideo;

  Videos({
    this.engineNoiseVideo,
    this.testDriveVideo,
  });

  Videos copyWith({
    String? engineNoiseVideo,
    String? testDriveVideo,
  }) =>
      Videos(
        engineNoiseVideo: engineNoiseVideo ?? this.engineNoiseVideo,
        testDriveVideo: testDriveVideo ?? this.testDriveVideo,
      );

  factory Videos.fromJson(String str) => Videos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Videos.fromMap(Map<String, dynamic> json) => Videos(
        engineNoiseVideo: json["engine_noise_video"],
        testDriveVideo: json["test_drive_video"],
      );

  Map<String, dynamic> toMap() => {
        "engine_noise_video": engineNoiseVideo,
        "test_drive_video": testDriveVideo,
      };
}

class Extra {
  String? extraParts;

  Extra({
    this.extraParts,
  });

  Extra copyWith({
    String? extraParts,
  }) =>
      Extra(
        extraParts: extraParts ?? this.extraParts,
      );

  factory Extra.fromJson(String str) => Extra.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Extra.fromMap(Map<String, dynamic> json) => Extra(
        extraParts: json["extra_parts"],
      );

  Map<String, dynamic> toMap() => {
        "extra_parts": extraParts,
      };
}

class FrontStructure2 {}

class FrontSide {
  FrontExterior1? frontExterior1;
  FrontExterior2? frontExterior2;
  FrontStructure1? frontStructure1;
  FrontStructure2? frontStructure2;

  FrontSide({
    this.frontExterior1,
    this.frontExterior2,
    this.frontStructure1,
    this.frontStructure2,
  });

  FrontSide copyWith({
    FrontExterior1? frontExterior1,
    FrontExterior2? frontExterior2,
    FrontStructure1? frontStructure1,
  }) =>
      FrontSide(
        frontExterior1: frontExterior1 ?? this.frontExterior1,
        frontExterior2: frontExterior2 ?? this.frontExterior2,
        frontStructure1: frontStructure1 ?? this.frontStructure1,
      );

  factory FrontSide.fromJson(String str) => FrontSide.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontSide.fromMap(Map<String, dynamic> json) => FrontSide(
        frontExterior1: json["front_exterior_1"] == null
            ? null
            : FrontExterior1.fromMap(json["front_exterior_1"]),
        frontExterior2: json["front_exterior_2"] == null
            ? null
            : FrontExterior2.fromMap(json["front_exterior_2"]),
        frontStructure1: json["front_structure_1"] == null
            ? null
            : FrontStructure1.fromMap(json["front_structure_1"]),
      );

  Map<String, dynamic> toMap() => {
        "front_exterior_1": frontExterior1?.toMap(),
        "front_exterior_2": frontExterior2?.toMap(),
        "front_structure_1": frontStructure1?.toMap(),
      };
}

class FrontExterior1 {
  BonnetPanel? bonnetPanel;
  CarKey? carKey;
  CarKey? centralLockingRemoteHousing;
  FrontBumperGrill? frontBumperGrill;
  FrontBumperPanel? frontBumperPanel;
  FrontRegistrationPlate? frontRegistrationPlate;

  FrontExterior1({
    this.bonnetPanel,
    this.carKey,
    this.centralLockingRemoteHousing,
    this.frontBumperGrill,
    this.frontBumperPanel,
    this.frontRegistrationPlate,
  });

  FrontExterior1 copyWith({
    BonnetPanel? bonnetPanel,
    CarKey? carKey,
    CarKey? centralLockingRemoteHousing,
    FrontBumperGrill? frontBumperGrill,
    FrontBumperPanel? frontBumperPanel,
    FrontRegistrationPlate? frontRegistrationPlate,
  }) =>
      FrontExterior1(
        bonnetPanel: bonnetPanel ?? this.bonnetPanel,
        carKey: carKey ?? this.carKey,
        centralLockingRemoteHousing:
            centralLockingRemoteHousing ?? this.centralLockingRemoteHousing,
        frontBumperGrill: frontBumperGrill ?? this.frontBumperGrill,
        frontBumperPanel: frontBumperPanel ?? this.frontBumperPanel,
        frontRegistrationPlate:
            frontRegistrationPlate ?? this.frontRegistrationPlate,
      );

  factory FrontExterior1.fromJson(String str) =>
      FrontExterior1.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontExterior1.fromMap(Map<String, dynamic> json) => FrontExterior1(
        bonnetPanel: json["bonnet_panel"] == null
            ? null
            : BonnetPanel.fromMap(json["bonnet_panel"]),
        carKey:
            json["car_key"] == null ? null : CarKey.fromMap(json["car_key"]),
        centralLockingRemoteHousing:
            json["central_locking_remote_housing"] == null
                ? null
                : CarKey.fromMap(json["central_locking_remote_housing"]),
        frontBumperGrill: json["front_bumper_grill"] == null
            ? null
            : FrontBumperGrill.fromMap(json["front_bumper_grill"]),
        frontBumperPanel: json["front_bumper_panel"] == null
            ? null
            : FrontBumperPanel.fromMap(json["front_bumper_panel"]),
        frontRegistrationPlate: json["front_registration_plate"] == null
            ? null
            : FrontRegistrationPlate.fromMap(json["front_registration_plate"]),
      );

  Map<String, dynamic> toMap() => {
        "bonnet_panel": bonnetPanel?.toMap(),
        "car_key": carKey?.toMap(),
        "central_locking_remote_housing": centralLockingRemoteHousing?.toMap(),
        "front_bumper_grill": frontBumperGrill?.toMap(),
        "front_bumper_panel": frontBumperPanel?.toMap(),
        "front_registration_plate": frontRegistrationPlate?.toMap(),
      };
}

class BonnetPanel {
  bool? alignmentOut;
  bool? corrosionMajor;
  bool? corrosionMinor;
  String? images;
  bool? paintDefective;
  bool? repainted;
  bool? replaced;
  bool? sealantMissingCrackRepaired;
  bool? wrapping;

  BonnetPanel({
    this.alignmentOut,
    this.corrosionMajor,
    this.corrosionMinor,
    this.images,
    this.paintDefective,
    this.repainted,
    this.replaced,
    this.sealantMissingCrackRepaired,
    this.wrapping,
  });

  BonnetPanel copyWith({
    bool? alignmentOut,
    bool? corrosionMajor,
    bool? corrosionMinor,
    String? images,
    bool? paintDefective,
    bool? repainted,
    bool? replaced,
    bool? sealantMissingCrackRepaired,
    bool? wrapping,
  }) =>
      BonnetPanel(
        alignmentOut: alignmentOut ?? this.alignmentOut,
        corrosionMajor: corrosionMajor ?? this.corrosionMajor,
        corrosionMinor: corrosionMinor ?? this.corrosionMinor,
        images: images ?? this.images,
        paintDefective: paintDefective ?? this.paintDefective,
        repainted: repainted ?? this.repainted,
        replaced: replaced ?? this.replaced,
        sealantMissingCrackRepaired:
            sealantMissingCrackRepaired ?? this.sealantMissingCrackRepaired,
        wrapping: wrapping ?? this.wrapping,
      );

  factory BonnetPanel.fromJson(String str) =>
      BonnetPanel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BonnetPanel.fromMap(Map<String, dynamic> json) => BonnetPanel(
        alignmentOut: json["alignment_out"],
        corrosionMajor: json["corrosion_major"],
        corrosionMinor: json["corrosion_minor"],
        images: json["images"],
        paintDefective: json["paint_defective"],
        repainted: json["repainted"],
        replaced: json["replaced"],
        sealantMissingCrackRepaired: json["sealant_missing_crack_repaired"],
        wrapping: json["wrapping"],
      );

  Map<String, dynamic> toMap() => {
        "alignment_out": alignmentOut,
        "corrosion_major": corrosionMajor,
        "corrosion_minor": corrosionMinor,
        "images": images,
        "paint_defective": paintDefective,
        "repainted": repainted,
        "replaced": replaced,
        "sealant_missing_crack_repaired": sealantMissingCrackRepaired,
        "wrapping": wrapping,
      };
}

class CarKey {
  bool? damagedMajor;
  bool? damagedMinor;
  String? images;
  bool? noFreeMovement;
  bool? oneKeyMissing;

  CarKey({
    this.damagedMajor,
    this.damagedMinor,
    this.images,
    this.noFreeMovement,
    this.oneKeyMissing,
  });

  CarKey copyWith({
    bool? damagedMajor,
    bool? damagedMinor,
    String? images,
    bool? noFreeMovement,
    bool? oneKeyMissing,
  }) =>
      CarKey(
        damagedMajor: damagedMajor ?? this.damagedMajor,
        damagedMinor: damagedMinor ?? this.damagedMinor,
        images: images ?? this.images,
        noFreeMovement: noFreeMovement ?? this.noFreeMovement,
        oneKeyMissing: oneKeyMissing ?? this.oneKeyMissing,
      );

  factory CarKey.fromJson(String str) => CarKey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarKey.fromMap(Map<String, dynamic> json) => CarKey(
        damagedMajor: json["damaged_major"],
        damagedMinor: json["damaged_minor"],
        images: json["images"],
        noFreeMovement: json["no_free_movement"],
        oneKeyMissing: json["one_key_missing"],
      );

  Map<String, dynamic> toMap() => {
        "damaged_major": damagedMajor,
        "damaged_minor": damagedMinor,
        "images": images,
        "no_free_movement": noFreeMovement,
        "one_key_missing": oneKeyMissing,
      };
}

class FrontBumperGrill {
  bool? crackMajor;
  bool? crackMinor;
  String? images;
  bool? repaired;
  bool? scratchesMajor;
  bool? scratchesMinor;

  FrontBumperGrill({
    this.crackMajor,
    this.crackMinor,
    this.images,
    this.repaired,
    this.scratchesMajor,
    this.scratchesMinor,
  });

  FrontBumperGrill copyWith({
    bool? crackMajor,
    bool? crackMinor,
    String? images,
    bool? repaired,
    bool? scratchesMajor,
    bool? scratchesMinor,
  }) =>
      FrontBumperGrill(
        crackMajor: crackMajor ?? this.crackMajor,
        crackMinor: crackMinor ?? this.crackMinor,
        images: images ?? this.images,
        repaired: repaired ?? this.repaired,
        scratchesMajor: scratchesMajor ?? this.scratchesMajor,
        scratchesMinor: scratchesMinor ?? this.scratchesMinor,
      );

  factory FrontBumperGrill.fromJson(String str) =>
      FrontBumperGrill.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontBumperGrill.fromMap(Map<String, dynamic> json) =>
      FrontBumperGrill(
        crackMajor: json["crack_major"],
        crackMinor: json["crack_minor"],
        images: json["images"],
        repaired: json["repaired"],
        scratchesMajor: json["scratches_major"],
        scratchesMinor: json["scratches_minor"],
      );

  Map<String, dynamic> toMap() => {
        "crack_major": crackMajor,
        "crack_minor": crackMinor,
        "images": images,
        "repaired": repaired,
        "scratches_major": scratchesMajor,
        "scratches_minor": scratchesMinor,
      };
}

class FrontBumperPanel {
  String? images;
  bool? paintDefective;
  bool? partMissing;
  bool? repainted;
  bool? tabLocksScrewRepaired;
  bool? wrapping;

  FrontBumperPanel({
    this.images,
    this.paintDefective,
    this.partMissing,
    this.repainted,
    this.tabLocksScrewRepaired,
    this.wrapping,
  });

  FrontBumperPanel copyWith({
    String? images,
    bool? paintDefective,
    bool? partMissing,
    bool? repainted,
    bool? tabLocksScrewRepaired,
    bool? wrapping,
  }) =>
      FrontBumperPanel(
        images: images ?? this.images,
        paintDefective: paintDefective ?? this.paintDefective,
        partMissing: partMissing ?? this.partMissing,
        repainted: repainted ?? this.repainted,
        tabLocksScrewRepaired:
            tabLocksScrewRepaired ?? this.tabLocksScrewRepaired,
        wrapping: wrapping ?? this.wrapping,
      );

  factory FrontBumperPanel.fromJson(String str) =>
      FrontBumperPanel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontBumperPanel.fromMap(Map<String, dynamic> json) =>
      FrontBumperPanel(
        images: json["images"],
        paintDefective: json["paint_defective"],
        partMissing: json["part_missing"],
        repainted: json["repainted"],
        tabLocksScrewRepaired: json["tab_locks_screw_repaired"],
        wrapping: json["wrapping"],
      );

  Map<String, dynamic> toMap() => {
        "images": images,
        "paint_defective": paintDefective,
        "part_missing": partMissing,
        "repainted": repainted,
        "tab_locks_screw_repaired": tabLocksScrewRepaired,
        "wrapping": wrapping,
      };
}

class FrontRegistrationPlate {
  bool? aftermarketFitment;
  bool? damagedMajor;
  bool? damagedMinor;
  String? images;
  bool? partMissing;

  FrontRegistrationPlate({
    this.aftermarketFitment,
    this.damagedMajor,
    this.damagedMinor,
    this.images,
    this.partMissing,
  });

  FrontRegistrationPlate copyWith({
    bool? aftermarketFitment,
    bool? damagedMajor,
    bool? damagedMinor,
    String? images,
    bool? partMissing,
  }) =>
      FrontRegistrationPlate(
        aftermarketFitment: aftermarketFitment ?? this.aftermarketFitment,
        damagedMajor: damagedMajor ?? this.damagedMajor,
        damagedMinor: damagedMinor ?? this.damagedMinor,
        images: images ?? this.images,
        partMissing: partMissing ?? this.partMissing,
      );

  factory FrontRegistrationPlate.fromJson(String str) =>
      FrontRegistrationPlate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontRegistrationPlate.fromMap(Map<String, dynamic> json) =>
      FrontRegistrationPlate(
        aftermarketFitment: json["aftermarket fitment"],
        damagedMajor: json["damaged_major"],
        damagedMinor: json["damaged_minor"],
        images: json["images"],
        partMissing: json["part_missing"],
      );

  Map<String, dynamic> toMap() => {
        "aftermarket fitment": aftermarketFitment,
        "damaged_major": damagedMajor,
        "damaged_minor": damagedMinor,
        "images": images,
        "part_missing": partMissing,
      };
}

class FrontExterior2 {
  FrontLeftExterior? frontLeftFogLightHousing;
  FrontLeftExterior? frontRightFogLightHousing;
  FrontLeftExterior? leftDrl;
  FrontLeftExterior? leftHeadlightAssembly;
  FrontLeftExterior? leftHeadlightHousing;
  FrontLeftExterior? rightDrl;
  FrontLeftExterior? rightHeadlightAssembly;
  FrontLeftExterior? rightHeadlightHousing;

  FrontExterior2({
    this.frontLeftFogLightHousing,
    this.frontRightFogLightHousing,
    this.leftDrl,
    this.leftHeadlightAssembly,
    this.leftHeadlightHousing,
    this.rightDrl,
    this.rightHeadlightAssembly,
    this.rightHeadlightHousing,
  });

  FrontExterior2 copyWith({
    FrontLeftExterior? frontLeftFogLightHousing,
    FrontLeftExterior? frontRightFogLightHousing,
    FrontLeftExterior? leftDrl,
    FrontLeftExterior? leftHeadlightAssembly,
    FrontLeftExterior? leftHeadlightHousing,
    FrontLeftExterior? rightDrl,
    FrontLeftExterior? rightHeadlightAssembly,
    FrontLeftExterior? rightHeadlightHousing,
  }) =>
      FrontExterior2(
        frontLeftFogLightHousing:
            frontLeftFogLightHousing ?? this.frontLeftFogLightHousing,
        frontRightFogLightHousing:
            frontRightFogLightHousing ?? this.frontRightFogLightHousing,
        leftDrl: leftDrl ?? this.leftDrl,
        leftHeadlightAssembly:
            leftHeadlightAssembly ?? this.leftHeadlightAssembly,
        leftHeadlightHousing: leftHeadlightHousing ?? this.leftHeadlightHousing,
        rightDrl: rightDrl ?? this.rightDrl,
        rightHeadlightAssembly:
            rightHeadlightAssembly ?? this.rightHeadlightAssembly,
        rightHeadlightHousing:
            rightHeadlightHousing ?? this.rightHeadlightHousing,
      );

  factory FrontExterior2.fromJson(String str) =>
      FrontExterior2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontExterior2.fromMap(Map<String, dynamic> json) => FrontExterior2(
        frontLeftFogLightHousing: json["front_left_fog_light_housing"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_left_fog_light_housing"]),
        frontRightFogLightHousing: json["front_right_fog_light_housing"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_right_fog_light_housing"]),
        leftDrl: json["left_DRL"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_DRL"]),
        leftHeadlightAssembly: json["left_headlight_assembly"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_headlight_assembly"]),
        leftHeadlightHousing: json["left_headlight_housing"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_headlight_housing"]),
        rightDrl: json["right_drl"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_drl"]),
        rightHeadlightAssembly: json["right_headlight_assembly"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_headlight_assembly"]),
        rightHeadlightHousing: json["right_headlight_housing"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_headlight_housing"]),
      );

  Map<String, dynamic> toMap() => {
        "front_left_fog_light_housing": frontLeftFogLightHousing?.toMap(),
        "front_right_fog_light_housing": frontRightFogLightHousing?.toMap(),
        "left_DRL": leftDrl?.toMap(),
        "left_headlight_assembly": leftHeadlightAssembly?.toMap(),
        "left_headlight_housing": leftHeadlightHousing?.toMap(),
        "right_drl": rightDrl?.toMap(),
        "right_headlight_assembly": rightHeadlightAssembly?.toMap(),
        "right_headlight_housing": rightHeadlightHousing?.toMap(),
      };
}

class FrontLeftExterior {
  bool? bendDentMajor;
  bool? bendDentMinor;
  bool? corrosionMajor;
  bool? corrosionMinor;
  bool? crackMajor;
  bool? crackMinor;
  String? images;
  bool? punchesOpenRepaired;
  bool? repaired;
  bool? replaced;
  bool? hammerRepairedMajor;
  bool? hammerRepairedMinor;
  bool? sealantMissingCrackRepaired;

  FrontLeftExterior({
    this.bendDentMajor,
    this.bendDentMinor,
    this.corrosionMajor,
    this.corrosionMinor,
    this.crackMajor,
    this.crackMinor,
    this.images,
    this.punchesOpenRepaired,
    this.repaired,
    this.replaced,
    this.hammerRepairedMajor,
    this.hammerRepairedMinor,
    this.sealantMissingCrackRepaired,
  });

  FrontLeftExterior copyWith({
    bool? bendDentMajor,
    bool? bendDentMinor,
    bool? corrosionMajor,
    bool? corrosionMinor,
    bool? crackMajor,
    bool? crackMinor,
    String? images,
    bool? punchesOpenRepaired,
    bool? repaired,
    bool? replaced,
    bool? hammerRepairedMajor,
    bool? hammerRepairedMinor,
    bool? sealantMissingCrackRepaired,
  }) =>
      FrontLeftExterior(
        bendDentMajor: bendDentMajor ?? this.bendDentMajor,
        bendDentMinor: bendDentMinor ?? this.bendDentMinor,
        corrosionMajor: corrosionMajor ?? this.corrosionMajor,
        corrosionMinor: corrosionMinor ?? this.corrosionMinor,
        crackMajor: crackMajor ?? this.crackMajor,
        crackMinor: crackMinor ?? this.crackMinor,
        images: images ?? this.images,
        punchesOpenRepaired: punchesOpenRepaired ?? this.punchesOpenRepaired,
        repaired: repaired ?? this.repaired,
        replaced: replaced ?? this.replaced,
        hammerRepairedMajor: hammerRepairedMajor ?? this.hammerRepairedMajor,
        hammerRepairedMinor: hammerRepairedMinor ?? this.hammerRepairedMinor,
        sealantMissingCrackRepaired:
            sealantMissingCrackRepaired ?? this.sealantMissingCrackRepaired,
      );

  factory FrontLeftExterior.fromJson(String str) =>
      FrontLeftExterior.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontLeftExterior.fromMap(Map<String, dynamic> json) =>
      FrontLeftExterior(
        bendDentMajor: json["bend_dent_major"],
        bendDentMinor: json["bend_dent_minor"],
        corrosionMajor: json["corrosion_major"],
        corrosionMinor: json["corrosion_minor"],
        crackMajor: json["crack_major"],
        crackMinor: json["crack_minor"],
        images: json["images"],
        punchesOpenRepaired: json["punches_open_repaired"],
        repaired: json["repaired"],
        replaced: json["replaced"],
        hammerRepairedMajor: json["hammer_repaired_major"],
        hammerRepairedMinor: json["hammer_repaired_minor"],
        sealantMissingCrackRepaired: json["sealant_missing_crack_repaired"],
      );

  Map<String, dynamic> toMap() => {
        "bend_dent_major": bendDentMajor,
        "bend_dent_minor": bendDentMinor,
        "corrosion_major": corrosionMajor,
        "corrosion_minor": corrosionMinor,
        "crack_major": crackMajor,
        "crack_minor": crackMinor,
        "images": images,
        "punches_open_repaired": punchesOpenRepaired,
        "repaired": repaired,
        "replaced": replaced,
        "hammer_repaired_major": hammerRepairedMajor,
        "hammer_repaired_minor": hammerRepairedMinor,
        "sealant_missing_crack_repaired": sealantMissingCrackRepaired,
      };
}

class FrontStructure1 {
  EdRadiatorSupport? boltedRadiatorSupport;
  FibreRadiatorSupport? fibreRadiatorSupport;
  FrontLeftExterior? frontLeftLeg;
  FrontLeftExterior? frontRightLeft;
  EdRadiatorSupport? weldedRadiatorSupport;

  FrontStructure1({
    this.boltedRadiatorSupport,
    this.fibreRadiatorSupport,
    this.frontLeftLeg,
    this.frontRightLeft,
    this.weldedRadiatorSupport,
  });

  FrontStructure1 copyWith({
    EdRadiatorSupport? boltedRadiatorSupport,
    FibreRadiatorSupport? fibreRadiatorSupport,
    FrontLeftExterior? frontLeftLeg,
    FrontLeftExterior? frontRightLeft,
    EdRadiatorSupport? weldedRadiatorSupport,
  }) =>
      FrontStructure1(
        boltedRadiatorSupport:
            boltedRadiatorSupport ?? this.boltedRadiatorSupport,
        fibreRadiatorSupport: fibreRadiatorSupport ?? this.fibreRadiatorSupport,
        frontLeftLeg: frontLeftLeg ?? this.frontLeftLeg,
        frontRightLeft: frontRightLeft ?? this.frontRightLeft,
        weldedRadiatorSupport:
            weldedRadiatorSupport ?? this.weldedRadiatorSupport,
      );

  factory FrontStructure1.fromJson(String str) =>
      FrontStructure1.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontStructure1.fromMap(Map<String, dynamic> json) => FrontStructure1(
        boltedRadiatorSupport: json["bolted_radiator_support"] == null
            ? null
            : EdRadiatorSupport.fromMap(json["bolted_radiator_support"]),
        fibreRadiatorSupport: json["fibre_radiator_support"] == null
            ? null
            : FibreRadiatorSupport.fromMap(json["fibre_radiator_support"]),
        frontLeftLeg: json["front_left_leg"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_left_leg"]),
        frontRightLeft: json["front_right_left"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_right_left"]),
        weldedRadiatorSupport: json["welded_radiator_support"] == null
            ? null
            : EdRadiatorSupport.fromMap(json["welded_radiator_support"]),
      );

  Map<String, dynamic> toMap() => {
        "bolted_radiator_support": boltedRadiatorSupport?.toMap(),
        "fibre_radiator_support": fibreRadiatorSupport?.toMap(),
        "front_left_leg": frontLeftLeg?.toMap(),
        "front_right_left": frontRightLeft?.toMap(),
        "welded_radiator_support": weldedRadiatorSupport?.toMap(),
      };
}

class EdRadiatorSupport {
  bool? bendDentMajor;
  bool? bendDentMinor;
  bool? corrosionMajor;
  bool? corrosionMinor;
  bool? crackMajor;
  bool? crackMinor;

  EdRadiatorSupport({
    this.bendDentMajor,
    this.bendDentMinor,
    this.corrosionMajor,
    this.corrosionMinor,
    this.crackMajor,
    this.crackMinor,
  });

  EdRadiatorSupport copyWith({
    bool? bendDentMajor,
    bool? bendDentMinor,
    bool? corrosionMajor,
    bool? corrosionMinor,
    bool? crackMajor,
    bool? crackMinor,
  }) =>
      EdRadiatorSupport(
        bendDentMajor: bendDentMajor ?? this.bendDentMajor,
        bendDentMinor: bendDentMinor ?? this.bendDentMinor,
        corrosionMajor: corrosionMajor ?? this.corrosionMajor,
        corrosionMinor: corrosionMinor ?? this.corrosionMinor,
        crackMajor: crackMajor ?? this.crackMajor,
        crackMinor: crackMinor ?? this.crackMinor,
      );

  factory EdRadiatorSupport.fromJson(String str) =>
      EdRadiatorSupport.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EdRadiatorSupport.fromMap(Map<String, dynamic> json) =>
      EdRadiatorSupport(
        bendDentMajor: json["bend_dent_major"],
        bendDentMinor: json["bend_dent_minor"],
        corrosionMajor: json["corrosion_major"],
        corrosionMinor: json["corrosion_minor"],
        crackMajor: json["crack_major"],
        crackMinor: json["crack_minor"],
      );

  Map<String, dynamic> toMap() => {
        "bend_dent_major": bendDentMajor,
        "bend_dent_minor": bendDentMinor,
        "corrosion_major": corrosionMajor,
        "corrosion_minor": corrosionMinor,
        "crack_major": crackMajor,
        "crack_minor": crackMinor,
      };
}

class FibreRadiatorSupport {
  bool? crackMajor;
  bool? crackMinor;
  bool? repaired;

  FibreRadiatorSupport({
    this.crackMajor,
    this.crackMinor,
    this.repaired,
  });

  FibreRadiatorSupport copyWith({
    bool? crackMajor,
    bool? crackMinor,
    bool? repaired,
  }) =>
      FibreRadiatorSupport(
        crackMajor: crackMajor ?? this.crackMajor,
        crackMinor: crackMinor ?? this.crackMinor,
        repaired: repaired ?? this.repaired,
      );

  factory FibreRadiatorSupport.fromJson(String str) =>
      FibreRadiatorSupport.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FibreRadiatorSupport.fromMap(Map<String, dynamic> json) =>
      FibreRadiatorSupport(
        crackMajor: json["crack_major"],
        crackMinor: json["crack_minor"],
        repaired: json["repaired"],
      );

  Map<String, dynamic> toMap() => {
        "crack_major": crackMajor,
        "crack_minor": crackMinor,
        "repaired": repaired,
      };
}

class Interior1 {
  AcAssembly? acAssembly;
  Airbags? airbags;
  ClusterPanelAssembly? clusterPanelAssembly;
  DashboardAssembly? dashboardAssembly;
  FrontWindshieldGlass? frontWindshieldGlass;
  Seats? seats;

  Interior1({
    this.acAssembly,
    this.airbags,
    this.clusterPanelAssembly,
    this.dashboardAssembly,
    this.frontWindshieldGlass,
    this.seats,
  });

  Interior1 copyWith({
    AcAssembly? acAssembly,
    Airbags? airbags,
    ClusterPanelAssembly? clusterPanelAssembly,
    DashboardAssembly? dashboardAssembly,
    FrontWindshieldGlass? frontWindshieldGlass,
    Seats? seats,
  }) =>
      Interior1(
        acAssembly: acAssembly ?? this.acAssembly,
        airbags: airbags ?? this.airbags,
        clusterPanelAssembly: clusterPanelAssembly ?? this.clusterPanelAssembly,
        dashboardAssembly: dashboardAssembly ?? this.dashboardAssembly,
        frontWindshieldGlass: frontWindshieldGlass ?? this.frontWindshieldGlass,
        seats: seats ?? this.seats,
      );

  factory Interior1.fromJson(String str) => Interior1.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Interior1.fromMap(Map<String, dynamic> json) => Interior1(
        acAssembly: json["ac_assembly"] == null
            ? null
            : AcAssembly.fromMap(json["ac_assembly"]),
        airbags:
            json["airbags"] == null ? null : Airbags.fromMap(json["airbags"]),
        clusterPanelAssembly: json["cluster_panel_assembly"] == null
            ? null
            : ClusterPanelAssembly.fromMap(json["cluster_panel_assembly"]),
        dashboardAssembly: json["dashboard_assembly"] == null
            ? null
            : DashboardAssembly.fromMap(json["dashboard_assembly"]),
        frontWindshieldGlass: json["front_windshield_glass"] == null
            ? null
            : FrontWindshieldGlass.fromMap(json["front_windshield_glass"]),
        seats: json["seats"] == null ? null : Seats.fromMap(json["seats"]),
      );

  Map<String, dynamic> toMap() => {
        "ac_assembly": acAssembly?.toMap(),
        "airbags": airbags?.toMap(),
        "cluster_panel_assembly": clusterPanelAssembly?.toMap(),
        "dashboard_assembly": dashboardAssembly?.toMap(),
        "front_windshield_glass": frontWindshieldGlass?.toMap(),
        "seats": seats?.toMap(),
      };
}

class AcAssembly {
  bool? lessEffective;
  bool? notWorking;
  bool? noise;

  AcAssembly({
    this.lessEffective,
    this.notWorking,
    this.noise,
  });

  AcAssembly copyWith({
    bool? lessEffective,
    bool? notWorking,
    bool? noise,
  }) =>
      AcAssembly(
        lessEffective: lessEffective ?? this.lessEffective,
        notWorking: notWorking ?? this.notWorking,
        noise: noise ?? this.noise,
      );

  factory AcAssembly.fromJson(String str) =>
      AcAssembly.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AcAssembly.fromMap(Map<String, dynamic> json) => AcAssembly(
        lessEffective: json["less_effective"],
        notWorking: json["not_working"],
        noise: json["noise"],
      );

  Map<String, dynamic> toMap() => {
        "less_effective": lessEffective,
        "not_working": notWorking,
        "noise": noise,
      };
}

class Airbags {
  bool? driverSide;
  bool? passengerSide;

  Airbags({
    this.driverSide,
    this.passengerSide,
  });

  Airbags copyWith({
    bool? driverSide,
    bool? passengerSide,
  }) =>
      Airbags(
        driverSide: driverSide ?? this.driverSide,
        passengerSide: passengerSide ?? this.passengerSide,
      );

  factory Airbags.fromJson(String str) => Airbags.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Airbags.fromMap(Map<String, dynamic> json) => Airbags(
        driverSide: json["driver_side"],
        passengerSide: json["passenger_side"],
      );

  Map<String, dynamic> toMap() => {
        "driver_side": driverSide,
        "passenger_side": passengerSide,
      };
}

class ClusterPanelAssembly {
  bool? engineChecklight;
  bool? absLight;
  bool? srsLight;
  bool? automaticTransmissionLight;
  bool? speedometer;
  String? images;

  ClusterPanelAssembly({
    this.engineChecklight,
    this.absLight,
    this.srsLight,
    this.automaticTransmissionLight,
    this.speedometer,
    this.images,
  });

  ClusterPanelAssembly copyWith({
    bool? engineChecklight,
    bool? absLight,
    bool? srsLight,
    bool? automaticTransmissionLight,
    bool? speedometer,
    String? images,
  }) =>
      ClusterPanelAssembly(
        engineChecklight: engineChecklight ?? this.engineChecklight,
        absLight: absLight ?? this.absLight,
        srsLight: srsLight ?? this.srsLight,
        automaticTransmissionLight:
            automaticTransmissionLight ?? this.automaticTransmissionLight,
        speedometer: speedometer ?? this.speedometer,
        images: images ?? this.images,
      );

  factory ClusterPanelAssembly.fromJson(String str) =>
      ClusterPanelAssembly.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClusterPanelAssembly.fromMap(Map<String, dynamic> json) =>
      ClusterPanelAssembly(
        engineChecklight: json["engine_checklight"],
        absLight: json["abs_light"],
        srsLight: json["srs_light"],
        automaticTransmissionLight: json["automatic_transmission_light"],
        speedometer: json["speedometer"],
        images: json["images"],
      );

  Map<String, dynamic> toMap() => {
        "engine_checklight": engineChecklight,
        "abs_light": absLight,
        "srs_light": srsLight,
        "automatic_transmission_light": automaticTransmissionLight,
        "speedometer": speedometer,
        "images": images,
      };
}

class DashboardAssembly {
  Ac? acVent;
  Ac? acControls;

  DashboardAssembly({
    this.acVent,
    this.acControls,
  });

  DashboardAssembly copyWith({
    Ac? acVent,
    Ac? acControls,
  }) =>
      DashboardAssembly(
        acVent: acVent ?? this.acVent,
        acControls: acControls ?? this.acControls,
      );

  factory DashboardAssembly.fromJson(String str) =>
      DashboardAssembly.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardAssembly.fromMap(Map<String, dynamic> json) =>
      DashboardAssembly(
        acVent: json["ac_vent"] == null ? null : Ac.fromMap(json["ac_vent"]),
        acControls: json["ac_controls"] == null
            ? null
            : Ac.fromMap(json["ac_controls"]),
      );

  Map<String, dynamic> toMap() => {
        "ac_vent": acVent?.toMap(),
        "ac_controls": acControls?.toMap(),
      };
}

class Ac {
  bool? working;
  bool? damaged;
  String? images;

  Ac({
    this.working,
    this.damaged,
    this.images,
  });

  Ac copyWith({
    bool? working,
    bool? damaged,
    String? images,
  }) =>
      Ac(
        working: working ?? this.working,
        damaged: damaged ?? this.damaged,
        images: images ?? this.images,
      );

  factory Ac.fromJson(String str) => Ac.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ac.fromMap(Map<String, dynamic> json) => Ac(
        working: json["working"],
        damaged: json["damaged"],
        images: json["images"],
      );

  Map<String, dynamic> toMap() => {
        "working": working,
        "damaged": damaged,
        "images": images,
      };
}

class FrontWindshieldGlass {
  bool? crackMajor;
  bool? crackMinor;
  String? images;
  bool? scratchesMajor;
  bool? scratchesMinor;

  FrontWindshieldGlass({
    this.crackMajor,
    this.crackMinor,
    this.images,
    this.scratchesMajor,
    this.scratchesMinor,
  });

  FrontWindshieldGlass copyWith({
    bool? crackMajor,
    bool? crackMinor,
    String? images,
    bool? scratchesMajor,
    bool? scratchesMinor,
  }) =>
      FrontWindshieldGlass(
        crackMajor: crackMajor ?? this.crackMajor,
        crackMinor: crackMinor ?? this.crackMinor,
        images: images ?? this.images,
        scratchesMajor: scratchesMajor ?? this.scratchesMajor,
        scratchesMinor: scratchesMinor ?? this.scratchesMinor,
      );

  factory FrontWindshieldGlass.fromJson(String str) =>
      FrontWindshieldGlass.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontWindshieldGlass.fromMap(Map<String, dynamic> json) =>
      FrontWindshieldGlass(
        crackMajor: json["crack_major"],
        crackMinor: json["crack_minor"],
        images: json["images"],
        scratchesMajor: json["scratches_major"],
        scratchesMinor: json["scratches_minor"],
      );

  Map<String, dynamic> toMap() => {
        "crack_major": crackMajor,
        "crack_minor": crackMinor,
        "images": images,
        "scratches_major": scratchesMajor,
        "scratches_minor": scratchesMinor,
      };
}

class Seats {
  String? images;
  bool? damageMajor;
  bool? damageMinor;
  bool? aftermarketFitment;
  bool? electronicSeat;

  Seats({
    this.images,
    this.damageMajor,
    this.damageMinor,
    this.aftermarketFitment,
    this.electronicSeat,
  });

  Seats copyWith({
    String? images,
    bool? damageMajor,
    bool? damageMinor,
    bool? aftermarketFitment,
    bool? electronicSeat,
  }) =>
      Seats(
        images: images ?? this.images,
        damageMajor: damageMajor ?? this.damageMajor,
        damageMinor: damageMinor ?? this.damageMinor,
        aftermarketFitment: aftermarketFitment ?? this.aftermarketFitment,
        electronicSeat: electronicSeat ?? this.electronicSeat,
      );

  factory Seats.fromJson(String str) => Seats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Seats.fromMap(Map<String, dynamic> json) => Seats(
        images: json["images"],
        damageMajor: json["damage_major"],
        damageMinor: json["damage_minor"],
        aftermarketFitment: json["aftermarket_fitment"],
        electronicSeat: json["electronic_seat"],
      );

  Map<String, dynamic> toMap() => {
        "images": images,
        "damage_major": damageMajor,
        "damage_minor": damageMinor,
        "aftermarket_fitment": aftermarketFitment,
        "electronic_seat": electronicSeat,
      };
}

class Interior2Common {
  bool? bendDentMajor;
  bool? corrosionMajor;
  bool? corrosionMinor;
  bool? crackMajor;
  bool? crackMinor;
  bool? hammerRepairedMajor;
  bool? hammerRepairedMinor;
  String? images;
  bool? paintMismatch;
  bool? punchesOpenRepaired;
  bool? repainted;
  bool? replaced;
  bool? scratchesMajor;
  bool? scratchesMinor;
  bool? wrapping;

  Interior2Common({
    this.bendDentMajor,
    this.corrosionMajor,
    this.corrosionMinor,
    this.crackMajor,
    this.crackMinor,
    this.hammerRepairedMajor,
    this.hammerRepairedMinor,
    this.images,
    this.paintMismatch,
    this.punchesOpenRepaired,
    this.repainted,
    this.replaced,
    this.scratchesMajor,
    this.scratchesMinor,
    this.wrapping,
  });

  Interior2Common copyWith({
    bool? bendDentMajor,
    bool? corrosionMajor,
    bool? corrosionMinor,
    bool? crackMajor,
    bool? crackMinor,
    bool? hammerRepairedMajor,
    bool? hammerRepairedMinor,
    String? images,
    bool? paintMismatch,
    bool? punchesOpenRepaired,
    bool? repainted,
    bool? replaced,
    bool? scratchesMajor,
    bool? scratchesMinor,
    bool? wrapping,
  }) =>
      Interior2Common(
        bendDentMajor: bendDentMajor ?? this.bendDentMajor,
        corrosionMajor: corrosionMajor ?? this.corrosionMajor,
        corrosionMinor: corrosionMinor ?? this.corrosionMinor,
        crackMajor: crackMajor ?? this.crackMajor,
        crackMinor: crackMinor ?? this.crackMinor,
        hammerRepairedMajor: hammerRepairedMajor ?? this.hammerRepairedMajor,
        hammerRepairedMinor: hammerRepairedMinor ?? this.hammerRepairedMinor,
        images: images ?? this.images,
        paintMismatch: paintMismatch ?? this.paintMismatch,
        punchesOpenRepaired: punchesOpenRepaired ?? this.punchesOpenRepaired,
        repainted: repainted ?? this.repainted,
        replaced: replaced ?? this.replaced,
        scratchesMajor: scratchesMajor ?? this.scratchesMajor,
        scratchesMinor: scratchesMinor ?? this.scratchesMinor,
        wrapping: wrapping ?? this.wrapping,
      );

  factory Interior2Common.fromJson(String str) =>
      Interior2Common.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Interior2Common.fromMap(Map<String, dynamic> json) => Interior2Common(
        bendDentMajor: json["bend_dent_major"],
        corrosionMajor: json["corrosion_major"],
        corrosionMinor: json["corrosion_minor"],
        crackMajor: json["crack_major"],
        crackMinor: json["crack_minor"],
        hammerRepairedMajor: json["hammer_repaired_major"],
        hammerRepairedMinor: json["hammer_repaired_minor"],
        images: json["images"],
        paintMismatch: json["paint_mismatch"],
        punchesOpenRepaired: json["punches_open_repaired"],
        repainted: json["repainted"],
        replaced: json["replaced"],
        scratchesMajor: json["scratches_major"],
        scratchesMinor: json["scratches_minor"],
        wrapping: json["wrapping"],
      );

  Map<String, dynamic> toMap() => {
        "bend_dent_major": bendDentMajor,
        "corrosion_major": corrosionMajor,
        "corrosion_minor": corrosionMinor,
        "crack_major": crackMajor,
        "crack_minor": crackMinor,
        "hammer_repaired_major": hammerRepairedMajor,
        "hammer_repaired_minor": hammerRepairedMinor,
        "images": images,
        "paint_mismatch": paintMismatch,
        "punches_open_repaired": punchesOpenRepaired,
        "repainted": repainted,
        "replaced": replaced,
        "scratches_major": scratchesMajor,
        "scratches_minor": scratchesMinor,
        "wrapping": wrapping,
      };
}

class Interior2 {
  Interior2Common? audioStereoAssembly;
  Interior2Common? centreConsoleAssembly;
  Interior2Common? forwardParkingSensors;
  Interior2Common? frontLeftDoorAssembly;
  Interior2Common? frontRightDoorAssembly;
  Interior2Common? reverseParkingCamera;
  Interior2Common? reverseParkingSensors;

  Interior2({
    this.audioStereoAssembly,
    this.centreConsoleAssembly,
    this.forwardParkingSensors,
    this.frontLeftDoorAssembly,
    this.frontRightDoorAssembly,
    this.reverseParkingCamera,
    this.reverseParkingSensors,
  });

  Interior2 copyWith({
    Interior2Common? audioStereoAssembly,
    Interior2Common? centreConsoleAssembly,
    Interior2Common? forwardParkingSensors,
    Interior2Common? frontLeftDoorAssembly,
    Interior2Common? frontRightDoorAssembly,
    Interior2Common? reverseParkingCamera,
    Interior2Common? reverseParkingSensors,
  }) =>
      Interior2(
        audioStereoAssembly: audioStereoAssembly ?? this.audioStereoAssembly,
        centreConsoleAssembly:
            centreConsoleAssembly ?? this.centreConsoleAssembly,
        forwardParkingSensors:
            forwardParkingSensors ?? this.forwardParkingSensors,
        frontLeftDoorAssembly:
            frontLeftDoorAssembly ?? this.frontLeftDoorAssembly,
        frontRightDoorAssembly:
            frontRightDoorAssembly ?? this.frontRightDoorAssembly,
        reverseParkingCamera: reverseParkingCamera ?? this.reverseParkingCamera,
        reverseParkingSensors:
            reverseParkingSensors ?? this.reverseParkingSensors,
      );

  factory Interior2.fromJson(String str) => Interior2.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Interior2.fromMap(Map<String, dynamic> json) => Interior2(
        audioStereoAssembly: json["audio_stereo_assembly"] == null
            ? null
            : Interior2Common.fromMap(json["audio_stereo_assembly"]),
        centreConsoleAssembly: json["centre_console_assembly"] == null
            ? null
            : Interior2Common.fromMap(json["centre_console_assembly"]),
        forwardParkingSensors: json["forward_parking_sensors"] == null
            ? null
            : Interior2Common.fromMap(json["forward_parking_sensors"]),
        frontLeftDoorAssembly: json["front_left_door_assembly"] == null
            ? null
            : Interior2Common.fromMap(json["front_left_door_assembly"]),
        frontRightDoorAssembly: json["front_right_door_assembly"] == null
            ? null
            : Interior2Common.fromMap(json["front_right_door_assembly"]),
        reverseParkingCamera: json["reverse_parking_camera"] == null
            ? null
            : Interior2Common.fromMap(json["reverse_parking_camera"]),
        reverseParkingSensors: json["reverse_parking_sensors"] == null
            ? null
            : Interior2Common.fromMap(json["reverse_parking_sensors"]),
      );

  Map<String, dynamic> toMap() => {
        "audio_stereo_assembly": audioStereoAssembly?.toMap(),
        "centre_console_assembly": centreConsoleAssembly?.toMap(),
        "forward_parking_sensors": forwardParkingSensors?.toMap(),
        "front_left_door_assembly": frontLeftDoorAssembly?.toMap(),
        "front_right_door_assembly": frontRightDoorAssembly?.toMap(),
        "reverse_parking_camera": reverseParkingCamera?.toMap(),
        "reverse_parking_sensors": reverseParkingSensors?.toMap(),
      };
}

class LeftSide {
  FrontLeftExterior? frontLeftExterior;
  Interior2Common? frontLeftMechanical;
  FrontLeftStructure? frontLeftStructure;
  FrontLeftExterior? rearLeftExterior;
  FrontLeftExterior? rearLeftMechanical;
  RearLeftStructure? rearLeftStructure;

  LeftSide({
    this.frontLeftExterior,
    this.frontLeftMechanical,
    this.frontLeftStructure,
    this.rearLeftExterior,
    this.rearLeftMechanical,
    this.rearLeftStructure,
  });

  LeftSide copyWith({
    FrontLeftExterior? frontLeftExterior,
    Interior2Common? frontLeftMechanical,
    FrontLeftStructure? frontLeftStructure,
    FrontLeftExterior? rearLeftExterior,
    FrontLeftExterior? rearLeftMechanical,
    RearLeftStructure? rearLeftStructure,
  }) =>
      LeftSide(
        frontLeftExterior: frontLeftExterior ?? this.frontLeftExterior,
        frontLeftMechanical: frontLeftMechanical ?? this.frontLeftMechanical,
        frontLeftStructure: frontLeftStructure ?? this.frontLeftStructure,
        rearLeftExterior: rearLeftExterior ?? this.rearLeftExterior,
        rearLeftMechanical: rearLeftMechanical ?? this.rearLeftMechanical,
        rearLeftStructure: rearLeftStructure ?? this.rearLeftStructure,
      );

  factory LeftSide.fromJson(String str) => LeftSide.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeftSide.fromMap(Map<String, dynamic> json) => LeftSide(
        frontLeftExterior: json["front_left_exterior"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_left_exterior"]),
        frontLeftMechanical: json["front_left_mechanical"] == null
            ? null
            : Interior2Common.fromMap(json["front_left_mechanical"]),
        frontLeftStructure: json["front_left_structure"] == null
            ? null
            : FrontLeftStructure.fromMap(json["front_left_structure"]),
        rearLeftExterior: json["rear_left_exterior"] == null
            ? null
            : FrontLeftExterior.fromMap(json["rear_left_exterior"]),
        rearLeftMechanical: json["rear_left_mechanical"] == null
            ? null
            : FrontLeftExterior.fromMap(json["rear_left_mechanical"]),
        rearLeftStructure: json["rear_left_structure"] == null
            ? null
            : RearLeftStructure.fromMap(json["rear_left_structure"]),
      );

  Map<String, dynamic> toMap() => {
        "front_left_exterior": frontLeftExterior?.toMap(),
        "front_left_mechanical": frontLeftMechanical?.toMap(),
        "front_left_structure": frontLeftStructure?.toMap(),
        "rear_left_exterior": rearLeftExterior?.toMap(),
        "rear_left_mechanical": rearLeftMechanical?.toMap(),
        "rear_left_structure": rearLeftStructure?.toMap(),
      };
}

class FrontLeftStructure {
  Interior2Common? leftFloorPanChannel;
  Interior2Common? leftPillarB;
  Interior2Common? leftPillarC;
  TRunningBoard? leftRunningBoard;
  Interior2Common? rearLeftDoorChannel;
  Interior2Common? rearLeftFloorPan;
  Interior2Common? rearLeftWheelHouse;

  FrontLeftStructure({
    this.leftFloorPanChannel,
    this.leftPillarB,
    this.leftPillarC,
    this.leftRunningBoard,
    this.rearLeftDoorChannel,
    this.rearLeftFloorPan,
    this.rearLeftWheelHouse,
  });

  FrontLeftStructure copyWith({
    Interior2Common? leftFloorPanChannel,
    Interior2Common? leftPillarB,
    Interior2Common? leftPillarC,
    TRunningBoard? leftRunningBoard,
    Interior2Common? rearLeftDoorChannel,
    Interior2Common? rearLeftFloorPan,
    Interior2Common? rearLeftWheelHouse,
  }) =>
      FrontLeftStructure(
        leftFloorPanChannel: leftFloorPanChannel ?? this.leftFloorPanChannel,
        leftPillarB: leftPillarB ?? this.leftPillarB,
        leftPillarC: leftPillarC ?? this.leftPillarC,
        leftRunningBoard: leftRunningBoard ?? this.leftRunningBoard,
        rearLeftDoorChannel: rearLeftDoorChannel ?? this.rearLeftDoorChannel,
        rearLeftFloorPan: rearLeftFloorPan ?? this.rearLeftFloorPan,
        rearLeftWheelHouse: rearLeftWheelHouse ?? this.rearLeftWheelHouse,
      );

  factory FrontLeftStructure.fromJson(String str) =>
      FrontLeftStructure.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontLeftStructure.fromMap(Map<String, dynamic> json) =>
      FrontLeftStructure(
        leftFloorPanChannel: json["left_floor_pan_channel"] == null
            ? null
            : Interior2Common.fromMap(json["left_floor_pan_channel"]),
        leftPillarB: json["left_pillar_B"] == null
            ? null
            : Interior2Common.fromMap(json["left_pillar_B"]),
        leftPillarC: json["left_pillar_C"] == null
            ? null
            : Interior2Common.fromMap(json["left_pillar_C"]),
        leftRunningBoard: json["left_running_board"] == null
            ? null
            : TRunningBoard.fromMap(json["left_running_board"]),
        rearLeftDoorChannel: json["rear_left_door_channel"] == null
            ? null
            : Interior2Common.fromMap(json["rear_left_door_channel"]),
        rearLeftFloorPan: json["rear_left_floor_pan"] == null
            ? null
            : Interior2Common.fromMap(json["rear_left_floor_pan"]),
        rearLeftWheelHouse: json["rear_left_wheel_house"] == null
            ? null
            : Interior2Common.fromMap(json["rear_left_wheel_house"]),
      );

  Map<String, dynamic> toMap() => {
        "left_floor_pan_channel": leftFloorPanChannel?.toMap(),
        "left_pillar_B": leftPillarB?.toMap(),
        "left_pillar_C": leftPillarC?.toMap(),
        "left_running_board": leftRunningBoard?.toMap(),
        "rear_left_door_channel": rearLeftDoorChannel?.toMap(),
        "rear_left_floor_pan": rearLeftFloorPan?.toMap(),
        "rear_left_wheel_house": rearLeftWheelHouse?.toMap(),
      };
}

class TRunningBoard {
  bool? corrosionMajor;
  bool? corrosionMinor;
  bool? crack;
  String? images;
  bool? paintDefective;
  bool? paintMismatch;
  bool? punchesOpenRepaired;
  bool? repainted;
  bool? replaced;

  TRunningBoard({
    this.corrosionMajor,
    this.corrosionMinor,
    this.crack,
    this.images,
    this.paintDefective,
    this.paintMismatch,
    this.punchesOpenRepaired,
    this.repainted,
    this.replaced,
  });

  TRunningBoard copyWith({
    bool? corrosionMajor,
    bool? corrosionMinor,
    bool? crack,
    String? images,
    bool? paintDefective,
    bool? paintMismatch,
    bool? punchesOpenRepaired,
    bool? repainted,
    bool? replaced,
  }) =>
      TRunningBoard(
        corrosionMajor: corrosionMajor ?? this.corrosionMajor,
        corrosionMinor: corrosionMinor ?? this.corrosionMinor,
        crack: crack ?? this.crack,
        images: images ?? this.images,
        paintDefective: paintDefective ?? this.paintDefective,
        paintMismatch: paintMismatch ?? this.paintMismatch,
        punchesOpenRepaired: punchesOpenRepaired ?? this.punchesOpenRepaired,
        repainted: repainted ?? this.repainted,
        replaced: replaced ?? this.replaced,
      );

  factory TRunningBoard.fromJson(String str) =>
      TRunningBoard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TRunningBoard.fromMap(Map<String, dynamic> json) => TRunningBoard(
        corrosionMajor: json["corrosion_major"],
        corrosionMinor: json["corrosion_minor"],
        crack: json["crack"],
        images: json["images"],
        paintDefective: json["paint_defective"],
        paintMismatch: json["paint_mismatch"],
        punchesOpenRepaired: json["punches_open_repaired"],
        repainted: json["repainted"],
        replaced: json["replaced"],
      );

  Map<String, dynamic> toMap() => {
        "corrosion_major": corrosionMajor,
        "corrosion_minor": corrosionMinor,
        "crack": crack,
        "images": images,
        "paint_defective": paintDefective,
        "paint_mismatch": paintMismatch,
        "punches_open_repaired": punchesOpenRepaired,
        "repainted": repainted,
        "replaced": replaced,
      };
}

class RearLeftStructure {
  FrontLeftExterior? leftFenderLining;
  FrontLeftExterior? leftFenderPanel;
  FrontLeftExterior? leftSvmAssembly;
  FrontLeftExterior? rearLeftDoorPanel;

  RearLeftStructure({
    this.leftFenderLining,
    this.leftFenderPanel,
    this.leftSvmAssembly,
    this.rearLeftDoorPanel,
  });

  RearLeftStructure copyWith({
    FrontLeftExterior? leftFenderLining,
    FrontLeftExterior? leftFenderPanel,
    FrontLeftExterior? leftSvmAssembly,
    FrontLeftExterior? rearLeftDoorPanel,
  }) =>
      RearLeftStructure(
        leftFenderLining: leftFenderLining ?? this.leftFenderLining,
        leftFenderPanel: leftFenderPanel ?? this.leftFenderPanel,
        leftSvmAssembly: leftSvmAssembly ?? this.leftSvmAssembly,
        rearLeftDoorPanel: rearLeftDoorPanel ?? this.rearLeftDoorPanel,
      );

  factory RearLeftStructure.fromJson(String str) =>
      RearLeftStructure.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RearLeftStructure.fromMap(Map<String, dynamic> json) =>
      RearLeftStructure(
        leftFenderLining: json["left_fender_lining"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_fender_lining"]),
        leftFenderPanel: json["left_fender_panel"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_fender_panel"]),
        leftSvmAssembly: json["left_svm_assembly"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_svm_assembly"]),
        rearLeftDoorPanel: json["rear_left_door_panel"] == null
            ? null
            : FrontLeftExterior.fromMap(json["rear_left_door_panel"]),
      );

  Map<String, dynamic> toMap() => {
        "left_fender_lining": leftFenderLining?.toMap(),
        "left_fender_panel": leftFenderPanel?.toMap(),
        "left_svm_assembly": leftSvmAssembly?.toMap(),
        "rear_left_door_panel": rearLeftDoorPanel?.toMap(),
      };
}

class RearSide {
  RearExterior? rearExterior;
  RoofStructureAndRoot? roofStructureAndRoot;

  RearSide({
    this.rearExterior,
    this.roofStructureAndRoot,
  });

  RearSide copyWith({
    RearExterior? rearExterior,
    RoofStructureAndRoot? roofStructureAndRoot,
  }) =>
      RearSide(
        rearExterior: rearExterior ?? this.rearExterior,
        roofStructureAndRoot: roofStructureAndRoot ?? this.roofStructureAndRoot,
      );

  factory RearSide.fromJson(String str) => RearSide.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RearSide.fromMap(Map<String, dynamic> json) => RearSide(
        rearExterior: json["rear_exterior"] == null
            ? null
            : RearExterior.fromMap(json["rear_exterior"]),
        roofStructureAndRoot: json["roof_structure_and_root"] == null
            ? null
            : RoofStructureAndRoot.fromMap(json["roof_structure_and_root"]),
      );

  Map<String, dynamic> toMap() => {
        "rear_exterior": rearExterior?.toMap(),
        "roof_structure_and_root": roofStructureAndRoot?.toMap(),
      };
}

class RearExterior {
  FrontLeftExterior? dickeyDoorPanel;
  FrontLeftExterior? dickeyLeftStayRodShocker;
  FrontLeftExterior? dickeyRightStayRodShocker;
  Interior2Common? leftTailLightAssembly;
  Interior2Common? rearBumperPanel;
  Interior2Common? rearRegistrationPlate;
  Interior2Common? rearWindshieldGlass;
  Interior2Common? rightTailLightAssembly;

  RearExterior({
    this.dickeyDoorPanel,
    this.dickeyLeftStayRodShocker,
    this.dickeyRightStayRodShocker,
    this.leftTailLightAssembly,
    this.rearBumperPanel,
    this.rearRegistrationPlate,
    this.rearWindshieldGlass,
    this.rightTailLightAssembly,
  });

  RearExterior copyWith({
    FrontLeftExterior? dickeyDoorPanel,
    FrontLeftExterior? dickeyLeftStayRodShocker,
    FrontLeftExterior? dickeyRightStayRodShocker,
    Interior2Common? leftTailLightAssembly,
    Interior2Common? rearBumperPanel,
    Interior2Common? rearRegistrationPlate,
    Interior2Common? rearWindshieldGlass,
    Interior2Common? rightTailLightAssembly,
  }) =>
      RearExterior(
        dickeyDoorPanel: dickeyDoorPanel ?? this.dickeyDoorPanel,
        dickeyLeftStayRodShocker:
            dickeyLeftStayRodShocker ?? this.dickeyLeftStayRodShocker,
        dickeyRightStayRodShocker:
            dickeyRightStayRodShocker ?? this.dickeyRightStayRodShocker,
        leftTailLightAssembly:
            leftTailLightAssembly ?? this.leftTailLightAssembly,
        rearBumperPanel: rearBumperPanel ?? this.rearBumperPanel,
        rearRegistrationPlate:
            rearRegistrationPlate ?? this.rearRegistrationPlate,
        rearWindshieldGlass: rearWindshieldGlass ?? this.rearWindshieldGlass,
        rightTailLightAssembly:
            rightTailLightAssembly ?? this.rightTailLightAssembly,
      );

  factory RearExterior.fromJson(String str) =>
      RearExterior.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RearExterior.fromMap(Map<String, dynamic> json) => RearExterior(
        dickeyDoorPanel: json["dickey_door_panel"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_door_panel"]),
        dickeyLeftStayRodShocker: json["dickey_left_stay_rod_shocker"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_left_stay_rod_shocker"]),
        dickeyRightStayRodShocker: json["dickey_right_stay_rod_shocker"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_right_stay_rod_shocker"]),
        leftTailLightAssembly: json["left_tail_light_assembly"] == null
            ? null
            : Interior2Common.fromMap(json["left_tail_light_assembly"]),
        rearBumperPanel: json["rear_bumper_panel"] == null
            ? null
            : Interior2Common.fromMap(json["rear_bumper_panel"]),
        rearRegistrationPlate: json["rear_registration_plate"] == null
            ? null
            : Interior2Common.fromMap(json["rear_registration_plate"]),
        rearWindshieldGlass: json["rear_windshield_glass"] == null
            ? null
            : Interior2Common.fromMap(json["rear_windshield_glass"]),
        rightTailLightAssembly: json["right_tail_light_assembly"] == null
            ? null
            : Interior2Common.fromMap(json["right_tail_light_assembly"]),
      );

  Map<String, dynamic> toMap() => {
        "dickey_door_panel": dickeyDoorPanel?.toMap(),
        "dickey_left_stay_rod_shocker": dickeyLeftStayRodShocker?.toMap(),
        "dickey_right_stay_rod_shocker": dickeyRightStayRodShocker?.toMap(),
        "left_tail_light_assembly": leftTailLightAssembly?.toMap(),
        "rear_bumper_panel": rearBumperPanel?.toMap(),
        "rear_registration_plate": rearRegistrationPlate?.toMap(),
        "rear_windshield_glass": rearWindshieldGlass?.toMap(),
        "right_tail_light_assembly": rightTailLightAssembly?.toMap(),
      };
}

class RoofStructureAndRoot {
  FrontLeftExterior? dickeyBackPanel;
  FrontLeftExterior? dickeyFloor;
  FrontLeftExterior? dickeyLeftLeg;
  FrontLeftExterior? dickeyRightLeg;
  DickeySidewalls? dickeySidewalls;
  DickeyStrutTowers? dickeyStrutTowers;
  RoofPanel? roofPanel;
  SpareTyreAssembly? spareTyreAssembly;

  RoofStructureAndRoot({
    this.dickeyBackPanel,
    this.dickeyFloor,
    this.dickeyLeftLeg,
    this.dickeyRightLeg,
    this.dickeySidewalls,
    this.dickeyStrutTowers,
    this.roofPanel,
    this.spareTyreAssembly,
  });

  RoofStructureAndRoot copyWith({
    FrontLeftExterior? dickeyBackPanel,
    FrontLeftExterior? dickeyFloor,
    FrontLeftExterior? dickeyLeftLeg,
    FrontLeftExterior? dickeyRightLeg,
    DickeySidewalls? dickeySidewalls,
    DickeyStrutTowers? dickeyStrutTowers,
    RoofPanel? roofPanel,
    SpareTyreAssembly? spareTyreAssembly,
  }) =>
      RoofStructureAndRoot(
        dickeyBackPanel: dickeyBackPanel ?? this.dickeyBackPanel,
        dickeyFloor: dickeyFloor ?? this.dickeyFloor,
        dickeyLeftLeg: dickeyLeftLeg ?? this.dickeyLeftLeg,
        dickeyRightLeg: dickeyRightLeg ?? this.dickeyRightLeg,
        dickeySidewalls: dickeySidewalls ?? this.dickeySidewalls,
        dickeyStrutTowers: dickeyStrutTowers ?? this.dickeyStrutTowers,
        roofPanel: roofPanel ?? this.roofPanel,
        spareTyreAssembly: spareTyreAssembly ?? this.spareTyreAssembly,
      );

  factory RoofStructureAndRoot.fromJson(String str) =>
      RoofStructureAndRoot.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RoofStructureAndRoot.fromMap(Map<String, dynamic> json) =>
      RoofStructureAndRoot(
        dickeyBackPanel: json["dickey_back_panel"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_back_panel"]),
        dickeyFloor: json["dickey_floor"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_floor"]),
        dickeyLeftLeg: json["dickey_left_leg"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_left_leg"]),
        dickeyRightLeg: json["dickey_right_leg"] == null
            ? null
            : FrontLeftExterior.fromMap(json["dickey_right_leg"]),
        dickeySidewalls: json["dickey_sidewalls"] == null
            ? null
            : DickeySidewalls.fromMap(json["dickey_sidewalls"]),
        dickeyStrutTowers: json["dickey_strut_towers"] == null
            ? null
            : DickeyStrutTowers.fromMap(json["dickey_strut_towers"]),
        roofPanel: json["roof_panel"] == null
            ? null
            : RoofPanel.fromMap(json["roof_panel"]),
        spareTyreAssembly: json["spare_tyre_assembly"] == null
            ? null
            : SpareTyreAssembly.fromMap(json["spare_tyre_assembly"]),
      );

  Map<String, dynamic> toMap() => {
        "dickey_back_panel": dickeyBackPanel?.toMap(),
        "dickey_floor": dickeyFloor?.toMap(),
        "dickey_left_leg": dickeyLeftLeg?.toMap(),
        "dickey_right_leg": dickeyRightLeg?.toMap(),
        "dickey_sidewalls": dickeySidewalls?.toMap(),
        "dickey_strut_towers": dickeyStrutTowers?.toMap(),
        "roof_panel": roofPanel?.toMap(),
        "spare_tyre_assembly": spareTyreAssembly?.toMap(),
      };
}

class DickeySidewalls {
  FrontLeftExterior? leftDickeySidewall;
  FrontLeftExterior? rightDickeySidewall;

  DickeySidewalls({
    this.leftDickeySidewall,
    this.rightDickeySidewall,
  });

  DickeySidewalls copyWith({
    FrontLeftExterior? leftDickeySidewall,
    FrontLeftExterior? rightDickeySidewall,
  }) =>
      DickeySidewalls(
        leftDickeySidewall: leftDickeySidewall ?? this.leftDickeySidewall,
        rightDickeySidewall: rightDickeySidewall ?? this.rightDickeySidewall,
      );

  factory DickeySidewalls.fromJson(String str) =>
      DickeySidewalls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DickeySidewalls.fromMap(Map<String, dynamic> json) => DickeySidewalls(
        leftDickeySidewall: json["left_dickey_sidewall"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_dickey_sidewall"]),
        rightDickeySidewall: json["right_dickey_sidewall"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_dickey_sidewall"]),
      );

  Map<String, dynamic> toMap() => {
        "left_dickey_sidewall": leftDickeySidewall?.toMap(),
        "right_dickey_sidewall": rightDickeySidewall?.toMap(),
      };
}

class DickeyStrutTowers {
  FrontLeftExterior? leftDickeyStrutTower;
  FrontLeftExterior? rightDickeyStrutTower;

  DickeyStrutTowers({
    this.leftDickeyStrutTower,
    this.rightDickeyStrutTower,
  });

  DickeyStrutTowers copyWith({
    FrontLeftExterior? leftDickeyStrutTower,
    FrontLeftExterior? rightDickeyStrutTower,
  }) =>
      DickeyStrutTowers(
        leftDickeyStrutTower: leftDickeyStrutTower ?? this.leftDickeyStrutTower,
        rightDickeyStrutTower:
            rightDickeyStrutTower ?? this.rightDickeyStrutTower,
      );

  factory DickeyStrutTowers.fromJson(String str) =>
      DickeyStrutTowers.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DickeyStrutTowers.fromMap(Map<String, dynamic> json) =>
      DickeyStrutTowers(
        leftDickeyStrutTower: json["left_dickey_strut_tower"] == null
            ? null
            : FrontLeftExterior.fromMap(json["left_dickey_strut_tower"]),
        rightDickeyStrutTower: json["right_dickey_strut_tower"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_dickey_strut_tower"]),
      );

  Map<String, dynamic> toMap() => {
        "left_dickey_strut_tower": leftDickeyStrutTower?.toMap(),
        "right_dickey_strut_tower": rightDickeyStrutTower?.toMap(),
      };
}

class RoofPanel {
  bool? aftermarketDualTonePaint;
  bool? aftermarketSunroofFitment;
  bool? corrosionMajor;
  bool? corrosionMinor;
  bool? externalHoleTear;
  String? images;
  bool? multipleDentsDentMajor;
  bool? multipleDentsDentMinor;
  bool? paintDefective;
  bool? paintMismatch;
  bool? repainted;
  bool? repaired;
  bool? replaced;
  bool? scratchesMajor;
  bool? scratchesMinor;
  bool? sealantMissing;
  bool? wrapping;

  RoofPanel({
    this.aftermarketDualTonePaint,
    this.aftermarketSunroofFitment,
    this.corrosionMajor,
    this.corrosionMinor,
    this.externalHoleTear,
    this.images,
    this.multipleDentsDentMajor,
    this.multipleDentsDentMinor,
    this.paintDefective,
    this.paintMismatch,
    this.repainted,
    this.repaired,
    this.replaced,
    this.scratchesMajor,
    this.scratchesMinor,
    this.sealantMissing,
    this.wrapping,
  });

  RoofPanel copyWith({
    bool? aftermarketDualTonePaint,
    bool? aftermarketSunroofFitment,
    bool? corrosionMajor,
    bool? corrosionMinor,
    bool? externalHoleTear,
    String? images,
    bool? multipleDentsDentMajor,
    bool? multipleDentsDentMinor,
    bool? paintDefective,
    bool? paintMismatch,
    bool? repainted,
    bool? repaired,
    bool? replaced,
    bool? scratchesMajor,
    bool? scratchesMinor,
    bool? sealantMissing,
    bool? wrapping,
  }) =>
      RoofPanel(
        aftermarketDualTonePaint:
            aftermarketDualTonePaint ?? this.aftermarketDualTonePaint,
        aftermarketSunroofFitment:
            aftermarketSunroofFitment ?? this.aftermarketSunroofFitment,
        corrosionMajor: corrosionMajor ?? this.corrosionMajor,
        corrosionMinor: corrosionMinor ?? this.corrosionMinor,
        externalHoleTear: externalHoleTear ?? this.externalHoleTear,
        images: images ?? this.images,
        multipleDentsDentMajor:
            multipleDentsDentMajor ?? this.multipleDentsDentMajor,
        multipleDentsDentMinor:
            multipleDentsDentMinor ?? this.multipleDentsDentMinor,
        paintDefective: paintDefective ?? this.paintDefective,
        paintMismatch: paintMismatch ?? this.paintMismatch,
        repainted: repainted ?? this.repainted,
        repaired: repaired ?? this.repaired,
        replaced: replaced ?? this.replaced,
        scratchesMajor: scratchesMajor ?? this.scratchesMajor,
        scratchesMinor: scratchesMinor ?? this.scratchesMinor,
        sealantMissing: sealantMissing ?? this.sealantMissing,
        wrapping: wrapping ?? this.wrapping,
      );

  factory RoofPanel.fromJson(String str) => RoofPanel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RoofPanel.fromMap(Map<String, dynamic> json) => RoofPanel(
        aftermarketDualTonePaint: json["aftermarket_dual_tone_paint"],
        aftermarketSunroofFitment: json["aftermarket_sunroof_fitment"],
        corrosionMajor: json["corrosion_major"],
        corrosionMinor: json["corrosion_minor"],
        externalHoleTear: json["external_hole_tear"],
        images: json["images"],
        multipleDentsDentMajor: json["multiple_dents_dent_major"],
        multipleDentsDentMinor: json["multiple_dents_dent_minor"],
        paintDefective: json["paint_defective"],
        paintMismatch: json["paint_mismatch"],
        repainted: json["repainted"],
        repaired: json["repaired"],
        replaced: json["replaced"],
        scratchesMajor: json["scratches_major"],
        scratchesMinor: json["scratches_minor"],
        sealantMissing: json["sealant_missing"],
        wrapping: json["wrapping"],
      );

  Map<String, dynamic> toMap() => {
        "aftermarket_dual_tone_paint": aftermarketDualTonePaint,
        "aftermarket_sunroof_fitment": aftermarketSunroofFitment,
        "corrosion_major": corrosionMajor,
        "corrosion_minor": corrosionMinor,
        "external_hole_tear": externalHoleTear,
        "images": images,
        "multiple_dents_dent_major": multipleDentsDentMajor,
        "multiple_dents_dent_minor": multipleDentsDentMinor,
        "paint_defective": paintDefective,
        "paint_mismatch": paintMismatch,
        "repainted": repainted,
        "repaired": repaired,
        "replaced": replaced,
        "scratches_major": scratchesMajor,
        "scratches_minor": scratchesMinor,
        "sealant_missing": sealantMissing,
        "wrapping": wrapping,
      };
}

class SpareTyreAssembly {
  String? images;
  bool? spareTyreAvailable;

  SpareTyreAssembly({
    this.images,
    this.spareTyreAvailable,
  });

  SpareTyreAssembly copyWith({
    String? images,
    bool? spareTyreAvailable,
  }) =>
      SpareTyreAssembly(
        images: images ?? this.images,
        spareTyreAvailable: spareTyreAvailable ?? this.spareTyreAvailable,
      );

  factory SpareTyreAssembly.fromJson(String str) =>
      SpareTyreAssembly.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SpareTyreAssembly.fromMap(Map<String, dynamic> json) =>
      SpareTyreAssembly(
        images: json["images"],
        spareTyreAvailable: json["spare_tyre_available"],
      );

  Map<String, dynamic> toMap() => {
        "images": images,
        "spare_tyre_available": spareTyreAvailable,
      };
}

class RightSide {
  FrontRightExterior? frontRightExterior;
  FrontRightMechanical? frontRightMechanical;
  RearRightStructure? rearRightStructure;
  Interior2Common? rightRightMechanical;

  RightSide({
    this.frontRightExterior,
    this.frontRightMechanical,
    this.rearRightStructure,
    this.rightRightMechanical,
  });

  RightSide copyWith({
    FrontRightExterior? frontRightExterior,
    FrontRightMechanical? frontRightMechanical,
    RearRightStructure? rearRightStructure,
    Interior2Common? rightRightMechanical,
  }) =>
      RightSide(
        frontRightExterior: frontRightExterior ?? this.frontRightExterior,
        frontRightMechanical: frontRightMechanical ?? this.frontRightMechanical,
        rearRightStructure: rearRightStructure ?? this.rearRightStructure,
        rightRightMechanical: rightRightMechanical ?? this.rightRightMechanical,
      );

  factory RightSide.fromJson(String str) => RightSide.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RightSide.fromMap(Map<String, dynamic> json) => RightSide(
        frontRightExterior: json["front_right_exterior"] == null
            ? null
            : FrontRightExterior.fromMap(json["front_right_exterior"]),
        frontRightMechanical: json["front_right_mechanical"] == null
            ? null
            : FrontRightMechanical.fromMap(json["front_right_mechanical"]),
        rearRightStructure: json["rear_right_structure"] == null
            ? null
            : RearRightStructure.fromMap(json["rear_right_structure"]),
        rightRightMechanical: json["right_right_mechanical"] == null
            ? null
            : Interior2Common.fromMap(json["right_right_mechanical"]),
      );

  Map<String, dynamic> toMap() => {
        "front_right_exterior": frontRightExterior?.toMap(),
        "front_right_mechanical": frontRightMechanical?.toMap(),
        "rear_right_structure": rearRightStructure?.toMap(),
        "right_right_mechanical": rightRightMechanical?.toMap(),
      };
}

class FrontRightExterior {
  FrontLeftExterior? frontRightDoorPanel;
  FrontLeftExterior? rightFenderLining;
  FrontLeftExterior? rightFenderPanel;
  FrontLeftExterior? rightSvmAssembly;

  FrontRightExterior({
    this.frontRightDoorPanel,
    this.rightFenderLining,
    this.rightFenderPanel,
    this.rightSvmAssembly,
  });

  FrontRightExterior copyWith({
    FrontLeftExterior? frontRightDoorPanel,
    FrontLeftExterior? rightFenderLining,
    FrontLeftExterior? rightFenderPanel,
    FrontLeftExterior? rightSvmAssembly,
  }) =>
      FrontRightExterior(
        frontRightDoorPanel: frontRightDoorPanel ?? this.frontRightDoorPanel,
        rightFenderLining: rightFenderLining ?? this.rightFenderLining,
        rightFenderPanel: rightFenderPanel ?? this.rightFenderPanel,
        rightSvmAssembly: rightSvmAssembly ?? this.rightSvmAssembly,
      );

  factory FrontRightExterior.fromJson(String str) =>
      FrontRightExterior.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontRightExterior.fromMap(Map<String, dynamic> json) =>
      FrontRightExterior(
        frontRightDoorPanel: json["front_right_door_panel"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_right_door_panel"]),
        rightFenderLining: json["right_fender_lining"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_fender_lining"]),
        rightFenderPanel: json["right_fender_panel"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_fender_panel"]),
        rightSvmAssembly: json["right_svm_assembly"] == null
            ? null
            : FrontLeftExterior.fromMap(json["right_svm_assembly"]),
      );

  Map<String, dynamic> toMap() => {
        "front_right_door_panel": frontRightDoorPanel?.toMap(),
        "right_fender_lining": rightFenderLining?.toMap(),
        "right_fender_panel": rightFenderPanel?.toMap(),
        "right_svm_assembly": rightSvmAssembly?.toMap(),
      };
}

class FrontRightMechanical {
  bool? exhaustSystem;
  FrontLeftExterior? fourWheelDrive;
  FrontLeftExterior? frontRightBrakeAssembly;
  FrontRightSuspension? frontRightSuspension;
  FrontLeftExterior? frontRightTyreAssembly;
  FrontLeftExterior? frontWheelDrive;

  FrontRightMechanical({
    this.exhaustSystem,
    this.fourWheelDrive,
    this.frontRightBrakeAssembly,
    this.frontRightSuspension,
    this.frontRightTyreAssembly,
    this.frontWheelDrive,
  });

  FrontRightMechanical copyWith({
    bool? exhaustSystem,
    FrontLeftExterior? fourWheelDrive,
    FrontLeftExterior? frontRightBrakeAssembly,
    FrontRightSuspension? frontRightSuspension,
    FrontLeftExterior? frontRightTyreAssembly,
    FrontLeftExterior? frontWheelDrive,
  }) =>
      FrontRightMechanical(
        exhaustSystem: exhaustSystem ?? this.exhaustSystem,
        fourWheelDrive: fourWheelDrive ?? this.fourWheelDrive,
        frontRightBrakeAssembly:
            frontRightBrakeAssembly ?? this.frontRightBrakeAssembly,
        frontRightSuspension: frontRightSuspension ?? this.frontRightSuspension,
        frontRightTyreAssembly:
            frontRightTyreAssembly ?? this.frontRightTyreAssembly,
        frontWheelDrive: frontWheelDrive ?? this.frontWheelDrive,
      );

  factory FrontRightMechanical.fromJson(String str) =>
      FrontRightMechanical.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontRightMechanical.fromMap(Map<String, dynamic> json) =>
      FrontRightMechanical(
        exhaustSystem: json["exhaust_system"],
        fourWheelDrive: json["four_wheel_drive"] == null
            ? null
            : FrontLeftExterior.fromMap(json["four_wheel_drive"]),
        frontRightBrakeAssembly: json["front_right_brake_assembly"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_right_brake_assembly"]),
        frontRightSuspension: json["front_right_suspension"] == null
            ? null
            : FrontRightSuspension.fromMap(json["front_right_suspension"]),
        frontRightTyreAssembly: json["front_right_tyre_assembly"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_right_tyre_assembly"]),
        frontWheelDrive: json["front_wheel_drive"] == null
            ? null
            : FrontLeftExterior.fromMap(json["front_wheel_drive"]),
      );

  Map<String, dynamic> toMap() => {
        "exhaust_system": exhaustSystem,
        "four_wheel_drive": fourWheelDrive?.toMap(),
        "front_right_brake_assembly": frontRightBrakeAssembly?.toMap(),
        "front_right_suspension": frontRightSuspension?.toMap(),
        "front_right_tyre_assembly": frontRightTyreAssembly?.toMap(),
        "front_wheel_drive": frontWheelDrive?.toMap(),
      };
}

class FrontRightSuspension {
  bool? frontJumpingRodAssembly;
  bool? frontRightLinkRod;
  bool? frontRightLowerControlArmAssembly;
  bool? frontRightStrutAssembly;

  FrontRightSuspension({
    this.frontJumpingRodAssembly,
    this.frontRightLinkRod,
    this.frontRightLowerControlArmAssembly,
    this.frontRightStrutAssembly,
  });

  FrontRightSuspension copyWith({
    bool? frontJumpingRodAssembly,
    bool? frontRightLinkRod,
    bool? frontRightLowerControlArmAssembly,
    bool? frontRightStrutAssembly,
  }) =>
      FrontRightSuspension(
        frontJumpingRodAssembly:
            frontJumpingRodAssembly ?? this.frontJumpingRodAssembly,
        frontRightLinkRod: frontRightLinkRod ?? this.frontRightLinkRod,
        frontRightLowerControlArmAssembly: frontRightLowerControlArmAssembly ??
            this.frontRightLowerControlArmAssembly,
        frontRightStrutAssembly:
            frontRightStrutAssembly ?? this.frontRightStrutAssembly,
      );

  factory FrontRightSuspension.fromJson(String str) =>
      FrontRightSuspension.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FrontRightSuspension.fromMap(Map<String, dynamic> json) =>
      FrontRightSuspension(
        frontJumpingRodAssembly: json["front_jumping_rod_assembly"],
        frontRightLinkRod: json["front_right_link_rod"],
        frontRightLowerControlArmAssembly:
            json["front_right_lower_control_arm_assembly"],
        frontRightStrutAssembly: json["front_right_strut_assembly"],
      );

  Map<String, dynamic> toMap() => {
        "front_jumping_rod_assembly": frontJumpingRodAssembly,
        "front_right_link_rod": frontRightLinkRod,
        "front_right_lower_control_arm_assembly":
            frontRightLowerControlArmAssembly,
        "front_right_strut_assembly": frontRightStrutAssembly,
      };
}

class RearRightStructure {
  Interior2Common? rearRightDoorChannel;
  Interior2Common? rearRightFloorPan;
  Interior2Common? rearRightWheelHouse;
  Interior2Common? rightFloorPanChannel;
  Interior2Common? rightPillarB;
  Interior2Common? rightPillarC;
  TRunningBoard? rightRunningBoard;

  RearRightStructure({
    this.rearRightDoorChannel,
    this.rearRightFloorPan,
    this.rearRightWheelHouse,
    this.rightFloorPanChannel,
    this.rightPillarB,
    this.rightPillarC,
    this.rightRunningBoard,
  });

  RearRightStructure copyWith({
    Interior2Common? rearRightDoorChannel,
    Interior2Common? rearRightFloorPan,
    Interior2Common? rearRightWheelHouse,
    Interior2Common? rightFloorPanChannel,
    Interior2Common? rightPillarB,
    Interior2Common? rightPillarC,
    TRunningBoard? rightRunningBoard,
  }) =>
      RearRightStructure(
        rearRightDoorChannel: rearRightDoorChannel ?? this.rearRightDoorChannel,
        rearRightFloorPan: rearRightFloorPan ?? this.rearRightFloorPan,
        rearRightWheelHouse: rearRightWheelHouse ?? this.rearRightWheelHouse,
        rightFloorPanChannel: rightFloorPanChannel ?? this.rightFloorPanChannel,
        rightPillarB: rightPillarB ?? this.rightPillarB,
        rightPillarC: rightPillarC ?? this.rightPillarC,
        rightRunningBoard: rightRunningBoard ?? this.rightRunningBoard,
      );

  factory RearRightStructure.fromJson(String str) =>
      RearRightStructure.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RearRightStructure.fromMap(Map<String, dynamic> json) =>
      RearRightStructure(
        rearRightDoorChannel: json["rear_right_door_channel"] == null
            ? null
            : Interior2Common.fromMap(json["rear_right_door_channel"]),
        rearRightFloorPan: json["rear_right_floor_pan"] == null
            ? null
            : Interior2Common.fromMap(json["rear_right_floor_pan"]),
        rearRightWheelHouse: json["rear_right_wheel_house"] == null
            ? null
            : Interior2Common.fromMap(json["rear_right_wheel_house"]),
        rightFloorPanChannel: json["right_floor_pan_channel"] == null
            ? null
            : Interior2Common.fromMap(json["right_floor_pan_channel"]),
        rightPillarB: json["right_pillar_B"] == null
            ? null
            : Interior2Common.fromMap(json["right_pillar_B"]),
        rightPillarC: json["right_pillar_c"] == null
            ? null
            : Interior2Common.fromMap(json["right_pillar_c"]),
        rightRunningBoard: json["right_running_board"] == null
            ? null
            : TRunningBoard.fromMap(json["right_running_board"]),
      );

  Map<String, dynamic> toMap() => {
        "rear_right_door_channel": rearRightDoorChannel?.toMap(),
        "rear_right_floor_pan": rearRightFloorPan?.toMap(),
        "rear_right_wheel_house": rearRightWheelHouse?.toMap(),
        "right_floor_pan_channel": rightFloorPanChannel?.toMap(),
        "right_pillar_B": rightPillarB?.toMap(),
        "right_pillar_c": rightPillarC?.toMap(),
        "right_running_board": rightRunningBoard?.toMap(),
      };
}

class TestDrive {
  AccelerateToCheckClutch? accelerateToCheckClutch;
  ApplyBrakesTillCarStop? applyBrakesTillCarStop;
  bool? steeringHealth;

  TestDrive({
    this.accelerateToCheckClutch,
    this.applyBrakesTillCarStop,
    this.steeringHealth,
  });

  TestDrive copyWith({
    AccelerateToCheckClutch? accelerateToCheckClutch,
    ApplyBrakesTillCarStop? applyBrakesTillCarStop,
    bool? steeringHealth,
  }) =>
      TestDrive(
        accelerateToCheckClutch:
            accelerateToCheckClutch ?? this.accelerateToCheckClutch,
        applyBrakesTillCarStop:
            applyBrakesTillCarStop ?? this.applyBrakesTillCarStop,
        steeringHealth: steeringHealth ?? this.steeringHealth,
      );

  factory TestDrive.fromJson(String str) => TestDrive.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TestDrive.fromMap(Map<String, dynamic> json) => TestDrive(
        accelerateToCheckClutch: json["accelerate_to_check_clutch"] == null
            ? null
            : AccelerateToCheckClutch.fromMap(
                json["accelerate_to_check_clutch"]),
        applyBrakesTillCarStop: json["apply_brakes_till_car_stop"] == null
            ? null
            : ApplyBrakesTillCarStop.fromMap(
                json["apply_brakes_till_car_stop"]),
        steeringHealth: json["steering_health"],
      );

  Map<String, dynamic> toMap() => {
        "accelerate_to_check_clutch": accelerateToCheckClutch?.toMap(),
        "apply_brakes_till_car_stop": applyBrakesTillCarStop?.toMap(),
        "steering_health": steeringHealth,
      };
}

class AccelerateToCheckClutch {
  bool? clutchPedalVibration;
  bool? noiseFromTurbocharger;

  AccelerateToCheckClutch({
    this.clutchPedalVibration,
    this.noiseFromTurbocharger,
  });

  AccelerateToCheckClutch copyWith({
    bool? clutchPedalVibration,
    bool? noiseFromTurbocharger,
  }) =>
      AccelerateToCheckClutch(
        clutchPedalVibration: clutchPedalVibration ?? this.clutchPedalVibration,
        noiseFromTurbocharger:
            noiseFromTurbocharger ?? this.noiseFromTurbocharger,
      );

  factory AccelerateToCheckClutch.fromJson(String str) =>
      AccelerateToCheckClutch.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccelerateToCheckClutch.fromMap(Map<String, dynamic> json) =>
      AccelerateToCheckClutch(
        clutchPedalVibration: json["clutch_pedal_vibration"],
        noiseFromTurbocharger: json["noise_from_turbocharger"],
      );

  Map<String, dynamic> toMap() => {
        "clutch_pedal_vibration": clutchPedalVibration,
        "noise_from_turbocharger": noiseFromTurbocharger,
      };
}

class ApplyBrakesTillCarStop {
  bool? frontBrakeNoiseVibration;
  bool? idleStartStopNotWorking;
  bool? rearBrakeNoiseVibration;

  ApplyBrakesTillCarStop({
    this.frontBrakeNoiseVibration,
    this.idleStartStopNotWorking,
    this.rearBrakeNoiseVibration,
  });

  ApplyBrakesTillCarStop copyWith({
    bool? frontBrakeNoiseVibration,
    bool? idleStartStopNotWorking,
    bool? rearBrakeNoiseVibration,
  }) =>
      ApplyBrakesTillCarStop(
        frontBrakeNoiseVibration:
            frontBrakeNoiseVibration ?? this.frontBrakeNoiseVibration,
        idleStartStopNotWorking:
            idleStartStopNotWorking ?? this.idleStartStopNotWorking,
        rearBrakeNoiseVibration:
            rearBrakeNoiseVibration ?? this.rearBrakeNoiseVibration,
      );

  factory ApplyBrakesTillCarStop.fromJson(String str) =>
      ApplyBrakesTillCarStop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApplyBrakesTillCarStop.fromMap(Map<String, dynamic> json) =>
      ApplyBrakesTillCarStop(
        frontBrakeNoiseVibration: json["front_brake_noise_vibration"],
        idleStartStopNotWorking: json["idle_start_stop_not_working"],
        rearBrakeNoiseVibration: json["rear_brake_noise_vibration"],
      );

  Map<String, dynamic> toMap() => {
        "front_brake_noise_vibration": frontBrakeNoiseVibration,
        "idle_start_stop_not_working": idleStartStopNotWorking,
        "rear_brake_noise_vibration": rearBrakeNoiseVibration,
      };
}
