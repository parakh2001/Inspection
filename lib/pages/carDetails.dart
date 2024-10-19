import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspection/model/car_auction.dart';
import 'package:inspection/model/car_details.dart';
import '../model/new_lead.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class CarDetailsPage extends StatefulWidget {
  final Lead
      carDetails; // If editing existing data, serialNumber should be passed
  const CarDetailsPage({Key? key, required this.carDetails}) : super(key: key);
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late DatabaseReference _database;
  int _selectedIndex = 0; // To keep track of the selected page
  List<File> _interiorImages = [];
  List<File> _exteriorImages = [];
  List<File> _extraImages = [];
  List<File> _testDriveImages = [];
  bool _isInteriorExpanded = false;
  bool _isExteriorExpanded = false;
  bool _isExtraExpanded = false;
  bool _isTestDriveExpanded = false;
  final TextEditingController _interiorCommentsController =
      TextEditingController();
  final TextEditingController _exteriorCommentsController =
      TextEditingController();
  final TextEditingController _extraCommentsController =
      TextEditingController();

  final TextEditingController _testDriveBeforeController =
      TextEditingController(); // Controller for before test drive
  final TextEditingController _testDriveAfterController =
      TextEditingController(); // Controller for after test drive
  // State variable to manage the expand/collapse
  TextEditingController _testDriveCommentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formInspectionKey = GlobalKey<FormState>();
  final _formBottomKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _commentsController = TextEditingController();
  bool _isUploading = false;
  bool _isInteriorComplete = false;
  bool _isExteriorVisible = false;
  bool _isExtraVisible = false;
  int _currentSectionIndex = 0;
  // Text controllers for car details
  final TextEditingController _mfgYearMonthController = TextEditingController();
  final TextEditingController _carMakeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _ownersController = TextEditingController();
  final TextEditingController _numberOfKeyController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _reMarksController = TextEditingController();
  final TextEditingController _carFairPriceController = TextEditingController();
  CarDoc? carDoc;
  bool _hsrpAvailable = false;
  bool _isChassisNumberOk = false;
  bool battryLeakage = false;
  bool battryWrongSize = false;
  bool battryDamaged = false;
  bool battryAfterMarketFitment = false;
  bool leakageFromAtGearboxHousing = false;
  bool leakageFromAtInputShaft = false;
  bool leakageFromEngineBlock = false;
  bool leakageFromExhaustManifold = false;
  bool leakageFromTurbocharger = false;
  bool leakageFromMetalTiming = false;
  bool seepageFromEngineTiming = false;
  bool backCompressionInEngine = false;
  bool overheaingDueToRadiatorSystem = false;
  bool overheatingInEngine = false;
  bool leakageFromMtInputShaft = false;
  bool leakageFromMtGearboxHousing = false;
  bool leakageFromDriveAxle = false;
  bool leakageFrom5ThGearHousing = false;
  bool bonnetAlignmentOut = false;
  bool bonnetCorrosionMajor = false;
  bool bonnetCorrosionMinor = false;
  bool bonnetRepainted = false;
  bool bonnetReplaced = false;
  bool bonnetSealantMissingCrackRepaired = false;
  bool bonnetWrapping = false;
  bool bonnetPaintDefective = false;
  bool carKeyOneKeyMissing = false;
  bool carKeyNoFreeMovement = false;
  bool carKeyDamagedMajor = false;
  bool carKeyDamagedMinor = false;
  bool centralLockingRemoteHousingDamagedMinor = false;
  bool centralLockingRemoteHousingOneKeyMissing = false;
  bool centralLockingRemoteHousingNoFreeMovement = false;
  bool centralLockingRemoteHousingDamagedMajor = false;
  bool frontBumperGrillCrackMajor = false;
  bool frontBumperGrillCrackMinor = false;
  bool frontBumperGrillScratchesMajor = false;
  bool frontBumperGrillScratchesMinor = false;
  bool frontBumperGrillRepaired = false;
  bool frontBumperPanelPartMissing = false;
  bool frontBumperPanelRepainted = false;
  bool frontBumperPanelTabLocksScrewRepaired = false;
  bool frontBumperPanelWrapping = false;
  bool frontBumperPanelPaintDefective = false;
  bool frontRegistrationPlatePartMissing = false;
  bool frontRegistrationPlateAftermarketFitment = false;
  bool frontRegistrationPlateDamagedMajor = false;
  bool frontRegistrationPlateDamagedMinor = false;
  //frontLeftFogLightHousing
  bool frontLeftFogLightHousingBendDentMajor = false;
  bool frontLeftFogLightHousingBendDentMinor = false;
  bool frontLeftFogLightHousingCrackMajor = false;
  bool frontLeftFogLightHousingCrackMinor = false;
  bool frontLeftFogLightHousingPunchesOpenRepaired = false;
  bool frontLeftFogLightHousingRepaired = false;
  bool frontLeftFogLightHousingReplaced = false;
  bool frontLeftFogLightHousingCorrosionMajor = false;
  bool frontLeftFogLightHousingCorrosionMinor = false;
  //frontRightFogLightHousing
  bool frontRightFogLightHousingBendDentMajor = false;
  bool frontRightFogLightHousingBendDentMinor = false;
  bool frontRightFogLightHousingCrackMajor = false;
  bool frontRightFogLightHousingCrackMinor = false;
  bool frontRightFogLightHousingPunchesOpenRepaired = false;
  bool frontRightFogLightHousingRepaired = false;
  bool frontRightFogLightHousingReplaced = false;
  bool frontRightFogLightHousingCorrosionMajor = false;
  bool frontRightFogLightHousingCorrosionMinor = false;
  //left DRL
  bool leftDrlBendDentMajor = false;
  bool leftDrlBendDentMinor = false;
  bool leftDrlCrackMajor = false;
  bool leftDrlCrackMinor = false;
  bool leftDrlPunchesOpenRepaired = false;
  bool leftDrlRepaired = false;
  bool leftDrlReplaced = false;
  bool leftDrlCorrosionMajor = false;
  bool leftDrlCorrosionMinor = false;
  //Left headlight assembly
  bool leftHeadlightAssemblyBendDentMajor = false;
  bool leftHeadlightAssemblyBendDentMinor = false;
  bool leftHeadlightAssemblyCrackMajor = false;
  bool leftHeadlightAssemblyCrackMinor = false;
  bool leftHeadlightAssemblyPunchesOpenRepaired = false;
  bool leftHeadlightAssemblyRepaired = false;
  bool leftHeadlightAssemblyReplaced = false;
  bool leftHeadlightAssemblyCorrosionMajor = false;
  bool leftHeadlightAssemblyCorrosionMinor = false;
  //Left headlight housing
  bool leftHeadlightHousingBendDentMajor = false;
  bool leftHeadlightHousingBendDentMinor = false;
  bool leftHeadlightHousingCrackMajor = false;
  bool leftHeadlightHousingCrackMinor = false;
  bool leftHeadlightHousingPunchesOpenRepaired = false;
  bool leftHeadlightHousingRepaired = false;
  bool leftHeadlightHousingReplaced = false;
  bool leftHeadlightHousingCorrosionMajor = false;
  bool leftHeadlightHousingCorrosionMinor = false;
  //right DRL
  bool rightDrlBendDentMajor = false;
  bool rightDrlBendDentMinor = false;
  bool rightDrlCrackMajor = false;
  bool rightDrlCrackMinor = false;
  bool rightDrlPunchesOpenRepaired = false;
  bool rightDrlRepaired = false;
  bool rightDrlReplaced = false;
  bool rightDrlCorrosionMajor = false;
  bool rightDrlCorrosionMinor = false;
  //right headlight assembly
  bool rightHeadlightAssemblyBendDentMajor = false;
  bool rightHeadlightAssemblyBendDentMinor = false;
  bool rightHeadlightAssemblyCrackMajor = false;
  bool rightHeadlightAssemblyCrackMinor = false;
  bool rightHeadlightAssemblyPunchesOpenRepaired = false;
  bool rightHeadlightAssemblyRepaired = false;
  bool rightHeadlightAssemblyReplaced = false;
  bool rightHeadlightAssemblyCorrosionMajor = false;
  bool rightHeadlightAssemblyCorrosionMinor = false;
  //right headlight housing
  bool rightHeadlightHousingBendDentMajor = false;
  bool rightHeadlightHousingBendDentMinor = false;
  bool rightHeadlightHousingCrackMajor = false;
  bool rightHeadlightHousingCrackMinor = false;
  bool rightHeadlightHousingPunchesOpenRepaired = false;
  bool rightHeadlightHousingRepaired = false;
  bool rightHeadlightHousingReplaced = false;
  bool rightHeadlightHousingCorrosionMajor = false;
  bool rightHeadlightHousingCorrosionMinor = false;
  // Bolted radiator support
  bool boltedRadiatorSupportBendDentMajor = false;
  bool boltedRadiatorSupportBendDentMinor = false;
  bool boltedRadiatorSupportCrackMajor = false;
  bool boltedRadiatorSupportCrackMinor = false;
  bool boltedRadiatorSupportCorrosionMajor = false;
  bool boltedRadiatorSupportCorrosionMinor = false;
  // Welded radiator support
  bool weldedRadiatorSupportBendDentMajor = false;
  bool weldedRadiatorSupportBendDentMinor = false;
  bool weldedRadiatorSupportCrackMajor = false;
  bool weldedRadiatorSupportCrackMinor = false;
  bool weldedRadiatorSupportCorrosionMajor = false;
  bool weldedRadiatorSupportCorrosionMinor = false;
  // Fibre radiator support
  bool fibreRadiatorSupportCrackMajor = false;
  bool fibreRadiatorSupportCrackMinor = false;
  bool fibreRadiatorSupportRepaired = false;
  //front left leg
  bool frontLeftLegBendDentMajor = false;
  bool frontLeftLegBendDentMinor = false;
  bool frontLeftLegCrackMajor = false;
  bool frontLeftLegCrackMinor = false;
  bool frontLeftLegPunchesOpenRepaired = false;
  bool frontLeftLegRepaired = false;
  bool frontLeftLegReplaced = false;
  bool frontLeftLegCorrosionMajor = false;
  bool frontLeftLegCorrosionMinor = false;
  //front right left
  bool frontRightLeftBendDentMajor = false;
  bool frontRightLeftBendDentMinor = false;
  bool frontRightLeftCrackMajor = false;
  bool frontRightLeftCrackMinor = false;
  bool frontRightLeftPunchesOpenRepaired = false;
  bool frontRightLeftRepaired = false;
  bool frontRightLeftReplaced = false;
  bool frontRightLeftCorrosionMajor = false;
  bool frontRightLeftCorrosionMinor = false;
  //Interior-1 ac assembly
  bool acAssemblyLessEffective = false;
  bool acAssemblyNotWorking = false;
  bool acAssemblyNoise = false;
  //Interior-1 air bags
  bool airBagsDriverSide = false;
  bool airBagsPassengerSide = false;
  //Interior-1 Cluster panel assembly
  bool clusterPanelAssemblyEngineCheckLight = false;
  bool clusterPanelAssemblyAbsLight = false;
  bool clusterPanelAssemblySrsLight = false;
  bool clusterPanelAssemblyAutomaticTransmissionLight = false;
  bool clusterPanelAssemblySpeedometer = false;

  //Interior-1 Dashboard assembly / ac_vent
  bool dashboardAssemblyAcVentWorking = false;
  bool dashboardAssemblyAcVentDamaged = false;
  //Interior-1 Dashboard assembly / ac_controls
  bool dashboardAssemblyAcControlsWorking = false;
  bool dashboardAssemblyAcControlsDamaged = false;
  //Interior-1 Front windshield glass
  bool frontWindshieldGlassCrackMajor = false;
  bool frontWindshieldGlassCrackMinor = false;
  bool frontWindshieldGlassScratchesMajor = false;
  bool frontWindshieldGlassScratchesMinor = false;
  //Interior-1 seats
  bool seatsDamageMajor = false;
  bool seatsDamageMinor = false;
  bool seatsAftermarketFitment = false;
  bool seatsElectronicSeat = false;
  //Interior-2 Audio stereo assembly
  bool audioStereoAssemblyBendDentMajor = false;
  bool audioStereoAssemblyCrackMajor = false;
  bool audioStereoAssemblyCrackMinor = false;
  bool audioStereoAssemblyCorrosionMajor = false;
  bool audioStereoAssemblyCorrosionMinor = false;
  bool audioStereoAssemblyHammerRepairedMajor = false;
  bool audioStereoAssemblyHammerRepairedMinor = false;
  bool audioStereoAssemblyPaintMisMatch = false;
  bool audioStereoAssemblyPunchesOpenRepaired = false;
  bool audioStereoAssemblyRepainted = false;
  bool audioStereoAssemblyReplaced = false;
  bool audioStereoAssemblyScratchesMajor = false;
  bool audioStereoAssemblyScratchesMinor = false;
  bool audioStereoAssemblyWrapping = false;
  //Interior-2 Centre console assembly
  bool centreConsoleAssemblyBendDentMajor = false;
  bool centreConsoleAssemblyCrackMajor = false;
  bool centreConsoleAssemblyCrackMinor = false;
  bool centreConsoleAssemblyCorrosionMajor = false;
  bool centreConsoleAssemblyCorrosionMinor = false;
  bool centreConsoleAssemblyHammerRepairedMajor = false;
  bool centreConsoleAssemblyHammerRepairedMinor = false;
  bool centreConsoleAssemblyPaintMisMatch = false;
  bool centreConsoleAssemblyPunchesOpenRepaired = false;
  bool centreConsoleAssemblyRepainted = false;
  bool centreConsoleAssemblyReplaced = false;
  bool centreConsoleAssemblyScratchesMajor = false;
  bool centreConsoleAssemblyScratchesMinor = false;
  bool centreConsoleAssemblyWrapping = false;
  //Interior-2 Forward parking sensors
  bool forwardParkingSensorsBendDentMajor = false;
  bool forwardParkingSensorsCrackMajor = false;
  bool forwardParkingSensorsCrackMinor = false;
  bool forwardParkingSensorsCorrosionMajor = false;
  bool forwardParkingSensorsCorrosionMinor = false;
  bool forwardParkingSensorsHammerRepairedMajor = false;
  bool forwardParkingSensorsHammerRepairedMinor = false;
  bool forwardParkingSensorsPaintMisMatch = false;
  bool forwardParkingSensorsPunchesOpenRepaired = false;
  bool forwardParkingSensorsRepainted = false;
  bool forwardParkingSensorsReplaced = false;
  bool forwardParkingSensorsScratchesMajor = false;
  bool forwardParkingSensorsScratchesMinor = false;
  bool forwardParkingSensorsWrapping = false;
  //Interior-2 Front left door assembly
  bool frontLeftDoorAssemblyBendDentMajor = false;
  bool frontLeftDoorAssemblyCrackMajor = false;
  bool frontLeftDoorAssemblyCrackMinor = false;
  bool frontLeftDoorAssemblyCorrosionMajor = false;
  bool frontLeftDoorAssemblyCorrosionMinor = false;
  bool frontLeftDoorAssemblyHammerRepairedMajor = false;
  bool frontLeftDoorAssemblyHammerRepairedMinor = false;
  bool frontLeftDoorAssemblyPaintMisMatch = false;
  bool frontLeftDoorAssemblyPunchesOpenRepaired = false;
  bool frontLeftDoorAssemblyRepainted = false;
  bool frontLeftDoorAssemblyReplaced = false;
  bool frontLeftDoorAssemblyScratchesMajor = false;
  bool frontLeftDoorAssemblyScratchesMinor = false;
  bool frontLeftDoorAssemblyWrapping = false;
  //Interior-2 Front right door assembly
  bool frontRightDoorAssemblyBendDentMajor = false;
  bool frontRightDoorAssemblyCrackMajor = false;
  bool frontRightDoorAssemblyCrackMinor = false;
  bool frontRightDoorAssemblyCorrosionMajor = false;
  bool frontRightDoorAssemblyCorrosionMinor = false;
  bool frontRightDoorAssemblyHammerRepairedMajor = false;
  bool frontRightDoorAssemblyHammerRepairedMinor = false;
  bool frontRightDoorAssemblyPaintMisMatch = false;
  bool frontRightDoorAssemblyPunchesOpenRepaired = false;
  bool frontRightDoorAssemblyRepainted = false;
  bool frontRightDoorAssemblyReplaced = false;
  bool frontRightDoorAssemblyScratchesMajor = false;
  bool frontRightDoorAssemblyScratchesMinor = false;
  bool frontRightDoorAssemblyWrapping = false;
  //Interior-2 Reverse parking camera
  bool reverseParkingCameraBendDentMajor = false;
  bool reverseParkingCameraCrackMajor = false;
  bool reverseParkingCameraCrackMinor = false;
  bool reverseParkingCameraCorrosionMajor = false;
  bool reverseParkingCameraCorrosionMinor = false;
  bool reverseParkingCameraHammerRepairedMajor = false;
  bool reverseParkingCameraHammerRepairedMinor = false;
  bool reverseParkingCameraPaintMisMatch = false;
  bool reverseParkingCameraPunchesOpenRepaired = false;
  bool reverseParkingCameraRepainted = false;
  bool reverseParkingCameraReplaced = false;
  bool reverseParkingCameraScratchesMajor = false;
  bool reverseParkingCameraScratchesMinor = false;
  bool reverseParkingCameraWrapping = false;
  //Interior-2 Reverse parking sensors
  bool reverseParkingSensorsBendDentMajor = false;
  bool reverseParkingSensorsCrackMajor = false;
  bool reverseParkingSensorsCrackMinor = false;
  bool reverseParkingSensorsCorrosionMajor = false;
  bool reverseParkingSensorsCorrosionMinor = false;
  bool reverseParkingSensorsHammerRepairedMajor = false;
  bool reverseParkingSensorsHammerRepairedMinor = false;
  bool reverseParkingSensorsPaintMisMatch = false;
  bool reverseParkingSensorsPunchesOpenRepaired = false;
  bool reverseParkingSensorsRepainted = false;
  bool reverseParkingSensorsReplaced = false;
  bool reverseParkingSensorsScratchesMajor = false;
  bool reverseParkingSensorsScratchesMinor = false;
  bool reverseParkingSensorsWrapping = false;
  //left side / Front left exterior
  bool frontLeftExteriorBendDentMajor = false;
  bool frontLeftExteriorBendDentMinor = false;
  bool frontLeftExteriorCrackMajor = false;
  bool frontLeftExteriorCrackMinor = false;
  bool frontLeftExteriorCorrosionMajor = false;
  bool frontLeftExteriorCorrosionMinor = false;
  bool frontLeftExteriorPunchesOpenRepaired = false;
  bool frontLeftExteriorRepaired = false;
  bool frontLeftExteriorReplaced = false;
  //left side / Front left mechanical
  bool frontLeftMechanicalBendDentMajor = false;
  bool frontLeftMechanicalCrackMajor = false;
  bool frontLeftMechanicalCrackMinor = false;
  bool frontLeftMechanicalCorrosionMajor = false;
  bool frontLeftMechanicalCorrosionMinor = false;
  bool frontLeftMechanicalHammerRepairedMajor = false;
  bool frontLeftMechanicalHammerRepairedMinor = false;
  bool frontLeftMechanicalPaintMisMatch = false;
  bool frontLeftMechanicalPunchesOpenRepaired = false;
  bool frontLeftMechanicalRepainted = false;
  bool frontLeftMechanicalReplaced = false;
  bool frontLeftMechanicalScratchesMajor = false;
  bool frontLeftMechanicalScratchesMinor = false;
  bool frontLeftMechanicalWrapping = false;
  //left side / Rear left exterior
  bool rearLeftExteriorBendDentMajor = false;
  bool rearLeftExteriorBendDentMinor = false;
  bool rearLeftExteriorCrackMajor = false;
  bool rearLeftExteriorCrackMinor = false;
  bool rearLeftExteriorCorrosionMajor = false;
  bool rearLeftExteriorCorrosionMinor = false;
  bool rearLeftExteriorPunchesOpenRepaired = false;
  bool rearLeftExteriorRepaired = false;
  bool rearLeftExteriorReplaced = false;
  //left side / Rear left mechanical
  bool rearLeftMechanicalBendDentMajor = false;
  bool rearLeftMechanicalBendDentMinor = false;
  bool rearLeftMechanicalCrackMajor = false;
  bool rearLeftMechanicalCrackMinor = false;
  bool rearLeftMechanicalCorrosionMajor = false;
  bool rearLeftMechanicalCorrosionMinor = false;
  bool rearLeftMechanicalPunchesOpenRepaired = false;
  bool rearLeftMechanicalRepaired = false;
  bool rearLeftMechanicalReplaced = false;
  //left side / Left floor pan channel
  bool leftFloorPanChannelBendDentMajor = false;
  bool leftFloorPanChannelCrackMajor = false;
  bool leftFloorPanChannelCrackMinor = false;
  bool leftFloorPanChannelCorrosionMajor = false;
  bool leftFloorPanChannelCorrosionMinor = false;
  bool leftFloorPanChannelHammerRepairedMajor = false;
  bool leftFloorPanChannelHammerRepairedMinor = false;
  bool leftFloorPanChannelPaintMisMatch = false;
  bool leftFloorPanChannelPunchesOpenRepaired = false;
  bool leftFloorPanChannelRepainted = false;
  bool leftFloorPanChannelReplaced = false;
  bool leftFloorPanChannelScratchesMajor = false;
  bool leftFloorPanChannelScratchesMinor = false;
  bool leftFloorPanChannelWrapping = false;
  //left side / Left pillar B
  bool leftPillarBBendDentMajor = false;
  bool leftPillarBCrackMajor = false;
  bool leftPillarBCrackMinor = false;
  bool leftPillarBCorrosionMajor = false;
  bool leftPillarBCorrosionMinor = false;
  bool leftPillarBHammerRepairedMajor = false;
  bool leftPillarBHammerRepairedMinor = false;
  bool leftPillarBPaintMisMatch = false;
  bool leftPillarBPunchesOpenRepaired = false;
  bool leftPillarBRepainted = false;
  bool leftPillarBReplaced = false;
  bool leftPillarBScratchesMajor = false;
  bool leftPillarBScratchesMinor = false;
  bool leftPillarBWrapping = false;
  //left side / Left pillar C
  bool leftPillarCBendDentMajor = false;
  bool leftPillarCCrackMajor = false;
  bool leftPillarCCrackMinor = false;
  bool leftPillarCCorrosionMajor = false;
  bool leftPillarCCorrosionMinor = false;
  bool leftPillarCHammerRepairedMajor = false;
  bool leftPillarCHammerRepairedMinor = false;
  bool leftPillarCPaintMisMatch = false;
  bool leftPillarCPunchesOpenRepaired = false;
  bool leftPillarCRepainted = false;
  bool leftPillarCReplaced = false;
  bool leftPillarCScratchesMajor = false;
  bool leftPillarCScratchesMinor = false;
  bool leftPillarCWrapping = false;
  //left side / Left running board
  bool leftRunningBoardCrack = false;
  bool leftRunningBoardCorrosionMajor = false;
  bool leftRunningBoardCorrosionMinor = false;
  bool leftRunningBoardPaintDefective = false;
  bool leftRunningBoardPaintMisMatch = false;
  bool leftRunningBoardPunchesOpenRepaired = false;
  bool leftRunningBoardRepainted = false;
  bool leftRunningBoardReplaced = false;
  //left side / Rear left door channel
  bool rearLeftDoorChannelBendDentMajor = false;
  bool rearLeftDoorChannelCrackMajor = false;
  bool rearLeftDoorChannelCrackMinor = false;
  bool rearLeftDoorChannelCorrosionMajor = false;
  bool rearLeftDoorChannelCorrosionMinor = false;
  bool rearLeftDoorChannelHammerRepairedMajor = false;
  bool rearLeftDoorChannelHammerRepairedMinor = false;
  bool rearLeftDoorChannelPaintMisMatch = false;
  bool rearLeftDoorChannelPunchesOpenRepaired = false;
  bool rearLeftDoorChannelRepainted = false;
  bool rearLeftDoorChannelReplaced = false;
  bool rearLeftDoorChannelScratchesMajor = false;
  bool rearLeftDoorChannelScratchesMinor = false;
  bool rearLeftDoorChannelWrapping = false;
  //left side / Rear left floor pan
  bool rearLeftFloorPanBendDentMajor = false;
  bool rearLeftFloorPanCrackMajor = false;
  bool rearLeftFloorPanCrackMinor = false;
  bool rearLeftFloorPanCorrosionMajor = false;
  bool rearLeftFloorPanCorrosionMinor = false;
  bool rearLeftFloorPanHammerRepairedMajor = false;
  bool rearLeftFloorPanHammerRepairedMinor = false;
  bool rearLeftFloorPanPaintMisMatch = false;
  bool rearLeftFloorPanPunchesOpenRepaired = false;
  bool rearLeftFloorPanRepainted = false;
  bool rearLeftFloorPanReplaced = false;
  bool rearLeftFloorPanScratchesMajor = false;
  bool rearLeftFloorPanScratchesMinor = false;
  bool rearLeftFloorPanWrapping = false;
  //left side / Rear left wheel house
  bool rearLeftWheelHouseBendDentMajor = false;
  bool rearLeftWheelHouseCrackMajor = false;
  bool rearLeftWheelHouseCrackMinor = false;
  bool rearLeftWheelHouseCorrosionMajor = false;
  bool rearLeftWheelHouseCorrosionMinor = false;
  bool rearLeftWheelHouseHammerRepairedMajor = false;
  bool rearLeftWheelHouseHammerRepairedMinor = false;
  bool rearLeftWheelHousePaintMisMatch = false;
  bool rearLeftWheelHousePunchesOpenRepaired = false;
  bool rearLeftWheelHouseRepainted = false;
  bool rearLeftWheelHouseReplaced = false;
  bool rearLeftWheelHouseScratchesMajor = false;
  bool rearLeftWheelHouseScratchesMinor = false;
  bool rearLeftWheelHouseWrapping = false;
  //left side / Left fender lining
  bool leftFenderLiningBendDentMajor = false;
  bool leftFenderLiningBendDentMinor = false;
  bool leftFenderLiningCrackMajor = false;
  bool leftFenderLiningCrackMinor = false;
  bool leftFenderLiningCorrosionMajor = false;
  bool leftFenderLiningCorrosionMinor = false;
  bool leftFenderLiningPunchesOpenRepaired = false;
  bool leftFenderLiningRepaired = false;
  bool leftFenderLiningReplaced = false;
  //left side / Left fender panel
  bool leftFenderPanelBendDentMajor = false;
  bool leftFenderPanelBendDentMinor = false;
  bool leftFenderPanelCrackMajor = false;
  bool leftFenderPanelCrackMinor = false;
  bool leftFenderPanelCorrosionMajor = false;
  bool leftFenderPanelCorrosionMinor = false;
  bool leftFenderPanelPunchesOpenRepaired = false;
  bool leftFenderPanelRepaired = false;
  bool leftFenderPanelReplaced = false;
  //left side / Left svm assembly
  bool leftSvmAssemblyBendDentMajor = false;
  bool leftSvmAssemblyBendDentMinor = false;
  bool leftSvmAssemblyCrackMajor = false;
  bool leftSvmAssemblyCrackMinor = false;
  bool leftSvmAssemblyCorrosionMajor = false;
  bool leftSvmAssemblyCorrosionMinor = false;
  bool leftSvmAssemblyPunchesOpenRepaired = false;
  bool leftSvmAssemblyRepaired = false;
  bool leftSvmAssemblyReplaced = false;
  //left side / Rear left door panel
  bool rearLeftDoorPanelBendDentMajor = false;
  bool rearLeftDoorPanelBendDentMinor = false;
  bool rearLeftDoorPanelCrackMajor = false;
  bool rearLeftDoorPanelCrackMinor = false;
  bool rearLeftDoorPanelCorrosionMajor = false;
  bool rearLeftDoorPanelCorrosionMinor = false;
  bool rearLeftDoorPanelPunchesOpenRepaired = false;
  bool rearLeftDoorPanelRepaired = false;
  bool rearLeftDoorPanelReplaced = false;
  //rear side /Dickey door panel
  bool dickeyDoorPanelBendDentMajor = false;
  bool dickeyDoorPanelBendDentMinor = false;
  bool dickeyDoorPanelCrackMajor = false;
  bool dickeyDoorPanelCrackMinor = false;
  bool dickeyDoorPanelCorrosionMajor = false;
  bool dickeyDoorPanelCorrosionMinor = false;
  bool dickeyDoorPanelHammerRepairedMajor = false;
  bool dickeyDoorPanelHammerRepairedMinor = false;
  bool dickeyDoorPanelPunchesOpenRepaired = false;
  bool dickeyDoorPanelReplaced = false;
  //rear side /Dickey left stay rod shocker
  bool dickeyLeftStayRodShockerBendDentMajor = false;
  bool dickeyLeftStayRodShockerBendDentMinor = false;
  bool dickeyLeftStayRodShockerCrackMajor = false;
  bool dickeyLeftStayRodShockerCrackMinor = false;
  bool dickeyLeftStayRodShockerCorrosionMajor = false;
  bool dickeyLeftStayRodShockerCorrosionMinor = false;
  bool dickeyLeftStayRodShockerHammerRepairedMajor = false;
  bool dickeyLeftStayRodShockerHammerRepairedMinor = false;
  bool dickeyLeftStayRodShockerPunchesOpenRepaired = false;
  bool dickeyLeftStayRodShockerReplaced = false;
  //rear side /Dickey right stay rod shocker
  bool dickeyRightStayRodShockerBendDentMajor = false;
  bool dickeyRightStayRodShockerBendDentMinor = false;
  bool dickeyRightStayRodShockerCrackMajor = false;
  bool dickeyRightStayRodShockerCrackMinor = false;
  bool dickeyRightStayRodShockerCorrosionMajor = false;
  bool dickeyRightStayRodShockerCorrosionMinor = false;
  bool dickeyRightStayRodShockerHammerRepairedMajor = false;
  bool dickeyRightStayRodShockerHammerRepairedMinor = false;
  bool dickeyRightStayRodShockerPunchesOpenRepaired = false;
  bool dickeyRightStayRodShockerReplaced = false;
  //rear side /Left tail light assembly
  bool leftTailLightAssemblyBendDentMajor = false;
  bool leftTailLightAssemblyCrackMajor = false;
  bool leftTailLightAssemblyCrackMinor = false;
  bool leftTailLightAssemblyCorrosionMajor = false;
  bool leftTailLightAssemblyCorrosionMinor = false;
  bool leftTailLightAssemblyHammerRepairedMajor = false;
  bool leftTailLightAssemblyHammerRepairedMinor = false;
  bool leftTailLightAssemblyPaintMisMatch = false;
  bool leftTailLightAssemblyPunchesOpenRepaired = false;
  bool leftTailLightAssemblyRepainted = false;
  bool leftTailLightAssemblyReplaced = false;
  bool leftTailLightAssemblyScratchesMajor = false;
  bool leftTailLightAssemblyScratchesMinor = false;
  bool leftTailLightAssemblyWrapping = false;
  //rear side /Rear bumper panel
  bool rearBumperPanelBendDentMajor = false;
  bool rearBumperPanelCrackMajor = false;
  bool rearBumperPanelCrackMinor = false;
  bool rearBumperPanelCorrosionMajor = false;
  bool rearBumperPanelCorrosionMinor = false;
  bool rearBumperPanelHammerRepairedMajor = false;
  bool rearBumperPanelHammerRepairedMinor = false;
  bool rearBumperPanelPaintMisMatch = false;
  bool rearBumperPanelPunchesOpenRepaired = false;
  bool rearBumperPanelRepainted = false;
  bool rearBumperPanelReplaced = false;
  bool rearBumperPanelScratchesMajor = false;
  bool rearBumperPanelScratchesMinor = false;
  bool rearBumperPanelWrapping = false;
  //rear side /Rear registration plate
  bool rearRegistrationPlateBendDentMajor = false;
  bool rearRegistrationPlateCrackMajor = false;
  bool rearRegistrationPlateCrackMinor = false;
  bool rearRegistrationPlateCorrosionMajor = false;
  bool rearRegistrationPlateCorrosionMinor = false;
  bool rearRegistrationPlateHammerRepairedMajor = false;
  bool rearRegistrationPlateHammerRepairedMinor = false;
  bool rearRegistrationPlatePaintMisMatch = false;
  bool rearRegistrationPlatePunchesOpenRepaired = false;
  bool rearRegistrationPlateRepainted = false;
  bool rearRegistrationPlateReplaced = false;
  bool rearRegistrationPlateScratchesMajor = false;
  bool rearRegistrationPlateScratchesMinor = false;
  bool rearRegistrationPlateWrapping = false;
  //rear side /Rear windshield glass
  bool rearWindshieldGlassBendDentMajor = false;
  bool rearWindshieldGlassCrackMajor = false;
  bool rearWindshieldGlassCrackMinor = false;
  bool rearWindshieldGlassCorrosionMajor = false;
  bool rearWindshieldGlassCorrosionMinor = false;
  bool rearWindshieldGlassHammerRepairedMajor = false;
  bool rearWindshieldGlassHammerRepairedMinor = false;
  bool rearWindshieldGlassPaintMisMatch = false;
  bool rearWindshieldGlassPunchesOpenRepaired = false;
  bool rearWindshieldGlassRepainted = false;
  bool rearWindshieldGlassReplaced = false;
  bool rearWindshieldGlassScratchesMajor = false;
  bool rearWindshieldGlassScratchesMinor = false;
  bool rearWindshieldGlassWrapping = false;
  //rear side /Right tail light assembly
  bool rightTailLightAssemblyBendDentMajor = false;
  bool rightTailLightAssemblyCrackMajor = false;
  bool rightTailLightAssemblyCrackMinor = false;
  bool rightTailLightAssemblyCorrosionMajor = false;
  bool rightTailLightAssemblyCorrosionMinor = false;
  bool rightTailLightAssemblyHammerRepairedMajor = false;
  bool rightTailLightAssemblyHammerRepairedMinor = false;
  bool rightTailLightAssemblyPaintMisMatch = false;
  bool rightTailLightAssemblyPunchesOpenRepaired = false;
  bool rightTailLightAssemblyRepainted = false;
  bool rightTailLightAssemblyReplaced = false;
  bool rightTailLightAssemblyScratchesMajor = false;
  bool rightTailLightAssemblyScratchesMinor = false;
  bool rightTailLightAssemblyWrapping = false;
  //rear side /Dickey back panel
  bool dickeyBackPanelBendDentMajor = false;
  bool dickeyBackPanelBendDentMinor = false;
  bool dickeyBackPanelCrackMajor = false;
  bool dickeyBackPanelCrackMinor = false;
  bool dickeyBackPanelCorrosionMajor = false;
  bool dickeyBackPanelCorrosionMinor = false;
  bool dickeyBackPanelHammerRepairedMajor = false;
  bool dickeyBackPanelHammerRepairedMinor = false;
  bool dickeyBackPanelPaintMisMatch = false;
  bool dickeyBackPanelPunchesOpenRepaired = false;
  bool dickeyBackPanelReplaced = false;
  //rear side /Dickey Floor
  bool dickeyFloorBendDentMajor = false;
  bool dickeyFloorBendDentMinor = false;
  bool dickeyFloorCrackMajor = false;
  bool dickeyFloorCrackMinor = false;
  bool dickeyFloorCorrosionMajor = false;
  bool dickeyFloorCorrosionMinor = false;
  bool dickeyFloorHammerRepairedMajor = false;
  bool dickeyFloorHammerRepairedMinor = false;
  bool dickeyFloorPaintMisMatch = false;
  bool dickeyFloorPunchesOpenRepaired = false;
  bool dickeyFloorReplaced = false;
  //rear side /Dickey left leg
  bool dickeyLeftLegBendDentMajor = false;
  bool dickeyLeftLegBendDentMinor = false;
  bool dickeyLeftLegCrackMajor = false;
  bool dickeyLeftLegCrackMinor = false;
  bool dickeyLeftLegCorrosionMajor = false;
  bool dickeyLeftLegCorrosionMinor = false;
  bool dickeyLeftLegHammerRepairedMajor = false;
  bool dickeyLeftLegHammerRepairedMinor = false;
  bool dickeyLeftLegPaintMisMatch = false;
  bool dickeyLeftLegPunchesOpenRepaired = false;
  bool dickeyLeftLegRepaired = false;
  bool dickeyLeftLegReplaced = false;
  //rear side /Dickey Right leg
  bool dickeyRightLegBendDentMajor = false;
  bool dickeyRightLegBendDentMinor = false;
  bool dickeyRightLegCrackMajor = false;
  bool dickeyRightLegCrackMinor = false;
  bool dickeyRightLegCorrosionMajor = false;
  bool dickeyRightLegCorrosionMinor = false;
  bool dickeyRightLegHammerRepairedMajor = false;
  bool dickeyRightLegHammerRepairedMinor = false;
  bool dickeyRightLegPaintMisMatch = false;
  bool dickeyRightLegPunchesOpenRepaired = false;
  bool dickeyRightLegRepaired = false;
  bool dickeyRightLegReplaced = false;
  //rear side /Left dickey sidewall
  bool leftDickeySidewallBendDentMajor = false;
  bool leftDickeySidewallBendDentMinor = false;
  bool leftDickeySidewallCrackMajor = false;
  bool leftDickeySidewallCrackMinor = false;
  bool leftDickeySidewallCorrosionMajor = false;
  bool leftDickeySidewallCorrosionMinor = false;
  bool leftDickeySidewallPunchesOpenRepaired = false;
  bool leftDickeySidewallSealantMissingCrackRepaired = false;
  bool leftDickeySidewallReplaced = false;
  //rear side /Right dickey sidewall
  bool rightDickeySidewallBendDentMajor = false;
  bool rightDickeySidewallBendDentMinor = false;
  bool rightDickeySidewallCrackMajor = false;
  bool rightDickeySidewallCrackMinor = false;
  bool rightDickeySidewallCorrosionMajor = false;
  bool rightDickeySidewallCorrosionMinor = false;
  bool rightDickeySidewallPunchesOpenRepaired = false;
  bool rightDickeySidewallSealantMissingCrackRepaired = false;
  bool rightDickeySidewallReplaced = false;
  //rear side /Left dickey strut tower
  bool leftDickeyStrutTowerBendDentMajor = false;
  bool leftDickeyStrutTowerBendDentMinor = false;
  bool leftDickeyStrutTowerCrackMajor = false;
  bool leftDickeyStrutTowerCrackMinor = false;
  bool leftDickeyStrutTowerCorrosionMajor = false;
  bool leftDickeyStrutTowerCorrosionMinor = false;
  bool leftDickeyStrutTowerPunchesOpenRepaired = false;
  bool leftDickeyStrutTowerSealantMissingCrackRepaired = false;
  bool leftDickeyStrutTowerReplaced = false;
  //rear side /Right dickey strut tower
  bool rightDickeyStrutTowerBendDentMajor = false;
  bool rightDickeyStrutTowerBendDentMinor = false;
  bool rightDickeyStrutTowerCrackMajor = false;
  bool rightDickeyStrutTowerCrackMinor = false;
  bool rightDickeyStrutTowerCorrosionMajor = false;
  bool rightDickeyStrutTowerCorrosionMinor = false;
  bool rightDickeyStrutTowerPunchesOpenRepaired = false;
  bool rightDickeyStrutTowerSealantMissingCrackRepaired = false;
  bool rightDickeyStrutTowerReplaced = false;
  //rear side /roof panel
  bool roofPanelAftermarketDualTonePaint = false;
  bool roofPanelAftermarketSunroofFitment = false;
  bool roofPanelMultipleDentsDentMajor = false;
  bool roofPanelMultipleDentsDentMinor = false;
  bool roofPanelCorrosionMajor = false;
  bool roofPanelCorrosionMinor = false;
  bool roofPanelExternalHoleTear = false;
  bool roofPanelPaintDefective = false;
  bool roofPanelPaintMisMatch = false;
  bool roofPanelRepainted = false;
  bool roofPanelRepaired = false;
  bool roofPanelScratchesMajor = false;
  bool roofPanelScratchesMinor = false;
  bool roofPanelSealantMissing = false;
  bool roofPanelWrapping = false;
  bool roofPanelReplaced = false;

  ///Spare tyre available
  bool spareTyreAvailable = false;

  //Front right door panel
  bool frontRightDoorPanelBendDentMajor = false;
  bool frontRightDoorPanelBendDentMinor = false;
  bool frontRightDoorPanelCrackMajor = false;
  bool frontRightDoorPanelCrackMinor = false;
  bool frontRightDoorPanelCorrosionMajor = false;
  bool frontRightDoorPanelCorrosionMinor = false;
  bool frontRightDoorPanelPunchesOpenRepaired = false;
  bool frontRightDoorPanelRepaired = false;
  bool frontRightDoorPanelReplaced = false;
  //Right fender lining
  bool rightFenderLiningBendDentMajor = false;
  bool rightFenderLiningBendDentMinor = false;
  bool rightFenderLiningCrackMajor = false;
  bool rightFenderLiningCrackMinor = false;
  bool rightFenderLiningCorrosionMajor = false;
  bool rightFenderLiningCorrosionMinor = false;
  bool rightFenderLiningPunchesOpenRepaired = false;
  bool rightFenderLiningRepaired = false;
  bool rightFenderLiningReplaced = false;
  //Right fender panel
  bool rightFenderPanelBendDentMajor = false;
  bool rightFenderPanelBendDentMinor = false;
  bool rightFenderPanelCrackMajor = false;
  bool rightFenderPanelCrackMinor = false;
  bool rightFenderPanelCorrosionMajor = false;
  bool rightFenderPanelCorrosionMinor = false;
  bool rightFenderPanelPunchesOpenRepaired = false;
  bool rightFenderPanelRepaired = false;
  bool rightFenderPanelReplaced = false;
  //Right svm assembly
  bool rightSvmAssemblyBendDentMajor = false;
  bool rightSvmAssemblyBendDentMinor = false;
  bool rightSvmAssemblyCrackMajor = false;
  bool rightSvmAssemblyCrackMinor = false;
  bool rightSvmAssemblyCorrosionMajor = false;
  bool rightSvmAssemblyCorrosionMinor = false;
  bool rightSvmAssemblyPunchesOpenRepaired = false;
  bool rightSvmAssemblyRepaired = false;
  bool rightSvmAssemblyReplaced = false;
  //Front right mechanical
  bool frontRightMechanicalExhaustSystem = false;
  //Front wheel drive
  bool frontWheelDriveBendDentMajor = false;
  bool frontWheelDriveBendDentMinor = false;
  bool frontWheelDriveCrackMajor = false;
  bool frontWheelDriveCrackMinor = false;
  bool frontWheelDriveCorrosionMajor = false;
  bool frontWheelDriveCorrosionMinor = false;
  bool frontWheelDrivePunchesOpenRepaired = false;
  bool frontWheelDriveRepaired = false;
  bool frontWheelDriveReplaced = false;
  //Four wheel drive
  bool fourWheelDriveBendDentMajor = false;
  bool fourWheelDriveBendDentMinor = false;
  bool fourWheelDriveCrackMajor = false;
  bool fourWheelDriveCrackMinor = false;
  bool fourWheelDriveCorrosionMajor = false;
  bool fourWheelDriveCorrosionMinor = false;
  bool fourWheelDriveHammerRepairedMajor = false;
  bool fourWheelDriveHammerRepairedMinor = false;
  bool fourWheelDrivePunchesOpenRepaired = false;
  bool fourWheelDriveRepaired = false;
  bool fourWheelDriveReplaced = false;
  //Front right brake assembly
  bool frontRightBrakeAssemblyBendDentMajor = false;
  bool frontRightBrakeAssemblyBendDentMinor = false;
  bool frontRightBrakeAssemblyCrackMajor = false;
  bool frontRightBrakeAssemblyCrackMinor = false;
  bool frontRightBrakeAssemblyCorrosionMajor = false;
  bool frontRightBrakeAssemblyCorrosionMinor = false;
  bool frontRightBrakeAssemblyHammerRepairedMajor = false;
  bool frontRightBrakeAssemblyHammerRepairedMinor = false;
  bool frontRightBrakeAssemblyPunchesOpenRepaired = false;
  bool frontRightBrakeAssemblyRepaired = false;
  bool frontRightBrakeAssemblyReplaced = false;
  //Front right tyer assembly
  bool frontRightTyreAssemblyBendDentMajor = false;
  bool frontRightTyreAssemblyBendDentMinor = false;
  bool frontRightTyreAssemblyCrackMajor = false;
  bool frontRightTyreAssemblyCrackMinor = false;
  bool frontRightTyreAssemblyCorrosionMajor = false;
  bool frontRightTyreAssemblyCorrosionMinor = false;
  bool frontRightTyreAssemblyHammerRepairedMajor = false;
  bool frontRightTyreAssemblyHammerRepairedMinor = false;
  bool frontRightTyreAssemblyPunchesOpenRepaired = false;
  bool frontRightTyreAssemblyRepaired = false;
  bool frontRightTyreAssemblyReplaced = false;
  //Front right suspension
  bool frontRightSuspensionFrontJumpingRodAssembly = false;
  bool frontRightSuspensionFrontRightLinkRod = false;
  bool frontRightSuspensionFrontRightLowerControlArmAssembly = false;
  bool frontRightSuspensionFrontRightStrutAssembly = false;
//Right mechanical
  bool rightMechanicalBendDentMajor = false;
  bool rightMechanicalBendDentMinor = false;
  bool rightMechanicalCrackMajor = false;
  bool rightMechanicalCrackMinor = false;
  bool rightMechanicalCorrosionMajor = false;
  bool rightMechanicalCorrosionMinor = false;
  bool rightMechanicalHammerRepairedMajor = false;
  bool rightMechanicalHammerRepairedMinor = false;
  bool rightMechanicalPaintMisMatch = false;
  bool rightMechanicalPunchesOpenRepaired = false;
  bool rightMechanicalRepainted = false;
  bool rightMechanicalReplaced = false;
  bool rightMechanicalScratchesMajor = false;
  bool rightMechanicalScratchesMinor = false;
  bool rightMechanicalWrapping = false;
//Rear right door channel
  bool rearRightDoorChannelBendDentMajor = false;
  bool rearRightDoorChannelBendDentMinor = false;
  bool rearRightDoorChannelCrackMajor = false;
  bool rearRightDoorChannelCrackMinor = false;
  bool rearRightDoorChannelCorrosionMajor = false;
  bool rearRightDoorChannelCorrosionMinor = false;
  bool rearRightDoorChannelHammerRepairedMajor = false;
  bool rearRightDoorChannelHammerRepairedMinor = false;
  bool rearRightDoorChannelPaintMisMatch = false;
  bool rearRightDoorChannelPunchesOpenRepaired = false;
  bool rearRightDoorChannelRepainted = false;
  bool rearRightDoorChannelReplaced = false;
  bool rearRightDoorChannelScratchesMajor = false;
  bool rearRightDoorChannelScratchesMinor = false;
  bool rearRightDoorChannelWrapping = false;
  //Rear right floor pan
  bool rearRightFloorPanBendDentMajor = false;
  bool rearRightFloorPanBendDentMinor = false;
  bool rearRightFloorPanCrackMajor = false;
  bool rearRightFloorPanCrackMinor = false;
  bool rearRightFloorPanCorrosionMajor = false;
  bool rearRightFloorPanCorrosionMinor = false;
  bool rearRightFloorPanHammerRepairedMajor = false;
  bool rearRightFloorPanHammerRepairedMinor = false;
  bool rearRightFloorPanPaintMisMatch = false;
  bool rearRightFloorPanPunchesOpenRepaired = false;
  bool rearRightFloorPanRepainted = false;
  bool rearRightFloorPanReplaced = false;
  bool rearRightFloorPanScratchesMajor = false;
  bool rearRightFloorPanScratchesMinor = false;
  bool rearRightFloorPanWrapping = false;
  //Rear right wheel house
  bool rearRightWheelHouseBendDentMajor = false;
  bool rearRightWheelHouseBendDentMinor = false;
  bool rearRightWheelHouseCrackMajor = false;
  bool rearRightWheelHouseCrackMinor = false;
  bool rearRightWheelHouseCorrosionMajor = false;
  bool rearRightWheelHouseCorrosionMinor = false;
  bool rearRightWheelHouseHammerRepairedMajor = false;
  bool rearRightWheelHouseHammerRepairedMinor = false;
  bool rearRightWheelHousePaintMisMatch = false;
  bool rearRightWheelHousePunchesOpenRepaired = false;
  bool rearRightWheelHouseRepainted = false;
  bool rearRightWheelHouseReplaced = false;
  bool rearRightWheelHouseScratchesMajor = false;
  bool rearRightWheelHouseScratchesMinor = false;
  bool rearRightWheelHouseWrapping = false;
  //Right floor pan channel
  bool rightFloorPanChannelBendDentMajor = false;
  bool rightFloorPanChannelBendDentMinor = false;
  bool rightFloorPanChannelCrackMajor = false;
  bool rightFloorPanChannelCrackMinor = false;
  bool rightFloorPanChannelCorrosionMajor = false;
  bool rightFloorPanChannelCorrosionMinor = false;
  bool rightFloorPanChannelHammerRepairedMajor = false;
  bool rightFloorPanChannelHammerRepairedMinor = false;
  bool rightFloorPanChannelPaintMisMatch = false;
  bool rightFloorPanChannelPunchesOpenRepaired = false;
  bool rightFloorPanChannelRepainted = false;
  bool rightFloorPanChannelReplaced = false;
  bool rightFloorPanChannelScratchesMajor = false;
  bool rightFloorPanChannelScratchesMinor = false;
  bool rightFloorPanChannelWrapping = false;
  //Right pillar B
  bool rightPillarBBendDentMajor = false;
  bool rightPillarBBendDentMinor = false;
  bool rightPillarBCrackMajor = false;
  bool rightPillarBCrackMinor = false;
  bool rightPillarBCorrosionMajor = false;
  bool rightPillarBCorrosionMinor = false;
  bool rightPillarBHammerRepairedMajor = false;
  bool rightPillarBHammerRepairedMinor = false;
  bool rightPillarBPaintMisMatch = false;
  bool rightPillarBPunchesOpenRepaired = false;
  bool rightPillarBRepainted = false;
  bool rightPillarBReplaced = false;
  bool rightPillarBScratchesMajor = false;
  bool rightPillarBScratchesMinor = false;
  bool rightPillarBWrapping = false;
  //Right pillar C
  bool rightPillarCBendDentMajor = false;
  bool rightPillarCBendDentMinor = false;
  bool rightPillarCCrackMajor = false;
  bool rightPillarCCrackMinor = false;
  bool rightPillarCCorrosionMajor = false;
  bool rightPillarCCorrosionMinor = false;
  bool rightPillarCHammerRepairedMajor = false;
  bool rightPillarCHammerRepairedMinor = false;
  bool rightPillarCPaintMisMatch = false;
  bool rightPillarCPunchesOpenRepaired = false;
  bool rightPillarCRepainted = false;
  bool rightPillarCReplaced = false;
  bool rightPillarCScratchesMajor = false;
  bool rightPillarCScratchesMinor = false;
  bool rightPillarCWrapping = false;
  //Right running board
  bool rightRunningBoardCrack = false;
  bool rightRunningBoardCorrosionMajor = false;
  bool rightRunningBoardCorrosionMinor = false;
  bool rightRunningBoardPaintDefective = false;
  bool rightRunningBoardPaintMisMatch = false;
  bool rightRunningBoardPunchesOpenRepaired = false;
  bool rightRunningBoardRepainted = false;
  bool rightRunningBoardReplaced = false;

  ///test Drive
  bool testDriveSteeringHealth = false;
  bool testDriveClutchPedalVibration = false;
  bool testDriveNoiseFromTurbocharger = false;
  bool testDriveFrontBrakeNoiseVibration = false;
  bool testDriveIdleStartStopNotWorking = false;
  bool testDriveRearBrakeNoiseVibration = false;

  final ImagePicker picker = ImagePicker();
  File? _selectedRcImage;
  File? _selectedCarImage;
  File? _selectedChassisNumberImage;
  File? _selectedBatteryImage;
  File? _selectedBonnetImage;
  File? _selectedCarKeyImage;
  File? _selectedCentralLockingRemoteHousingImage;
  File? _selectedFrontBumperGrillImage;
  File? _selectedFrontBumperPanelImage;
  File? _selectedFrontRegistrationPlateImage;
  File? _selectedFrontLeftFogLightHousingImage;
  File? _selectedFrontRightFogLightHousingImage;
  File? _selectedLeftHeadlightAssemblyImage;
  File? _selectedLeftHeadlightHousingImage;
  File? _selectedLeftDrlImage;
  File? _selectedRightHeadlightAssemblyImage;
  File? _selectedRightHeadlightHousingImage;
  File? _selectedRightDrlImage;
  File? _selectedFrontLeftLegImage;
  File? _selectedFrontRightLeftImage;
  File? _selectedClusterPanelAssemblyImage;
  File? _selectedDashboardAssemblyAcVentImage;
  File? _selectedDashboardAssemblyAcControlsImage;
  File? _selectedFrontWindshieldGlassImage;
  File? _selectedSeatsImage;
  File? _selectedAudioStereoAssemblyImage;
  File? _selectedCentreConsoleAssemblyImage;
  File? _selectedForwardParkingSensorsImage;
  File? _selectedFrontRightDoorAssemblyImage;
  File? _selectedFrontLeftDoorAssemblyImage;
  File? _selectedReverseParkingCameraImage;
  File? _selectedReverseParkingSensorsImage;
  File? _selectedFrontLeftExteriorImage;
  File? _selectedFrontLeftMechanicalImage;
  File? _selectedRearLeftExteriorImage;
  File? _selectedRearLeftMechanicalImage;
  File? _selectedLeftFloorPanChannelImage;
  File? _selectedLeftPillarBImage;
  File? _selectedLeftPillarCImage;
  File? _selectedLeftRunningBoardImage;
  File? _selectedRearLeftFloorPanImage;
  File? _selectedRearLeftDoorChannelImage;
  File? _selectedRearLeftWheelHouseImage;
  File? _selectedLeftFenderLiningImage;
  File? _selectedLeftFenderPanelImage;
  File? _selectedLeftSvmAssemblyImage;
  File? _selectedRearLeftDoorPanelImage;
  File? _selectedDickeyDoorPanelImage;
  File? _selectedDickeyLeftStayRodShockerImage;
  File? _selectedDickeyRightStayRodShockerImage;
  File? _selectedLeftTailLightAssemblyImage;
  File? _selectedRearBumperPanelImage;
  File? _selectedRearWindshieldGlassImage;
  File? _selectedRearRegistrationPlateImage;
  File? _selectedRightTailLightAssemblyImage;
  File? _selectedDickeyBackPanelImage;
  File? _selectedDickeyFloorImage;
  File? _selectedDickeyLeftLegImage;
  File? _selectedDickeyRightLegImage;
  File? _selectedLeftDickeySidewallImage;
  File? _selectedRightDickeySidewallImage;
  File? _selectedLeftDickeyStrutTowerImage;
  File? _selectedRightDickeyStrutTowerImage;
  File? _selectedRoofPanelImage;
  File? _selectedSpareTyreAssemblyImage;
  File? _selectedFrontRightDoorPanelImage;
  File? _selectedRightFenderLiningImage;
  File? _selectedRightFenderPanelImage;
  File? _selectedRightSvmAssemblyImage;
  File? _selectedFourWheelDriveImage;
  File? _selectedFrontRightBrakeAssemblyImage;
  File? _selectedFrontWheelDriveImage;
  File? _selectedFrontRightTyreAssemblyImage;
  File? _selectedRightMechanicalImage;
  File? _selectedRearRightDoorChannelImage;
  File? _selectedRearRightFloorPanImage;
  File? _selectedRearRightWheelHouseImage;
  File? _selectedRightFloorPanChannelImage;
  File? _selectedRightPillarBImage;
  File? _selectedRightPillarCImage;
  File? _selectedRightRunningBoardImage;
  List<File> _selectedOtherImages = [];
  //Image String
  String? selectedRcImage;
  String? selectedCarImage;
  String? selectedChassisNumberImage;
  String? selectedBatteryImage;
  String? selectedBonnetImage;
  String? selectedCarKeyImage;
  String? selectedCentralLockingRemoteHousingImage;
  String? selectedFrontBumperGrillImage;
  String? selectedFrontBumperPanelImage;
  String? selectedFrontRegistrationPlateImage;
  String? selectedFrontLeftFogLightHousingImage;
  String? selectedFrontRightFogLightHousingImage;
  String? selectedLeftHeadlightAssemblyImage;
  String? selectedLeftHeadlightHousingImage;
  String? selectedLeftDrlImage;
  String? selectedRightHeadlightAssemblyImage;
  String? selectedRightHeadlightHousingImage;
  String? selectedRightDrlImage;
  String? selectedFrontLeftLegImage;
  String? selectedFrontRightLeftImage;
  String? selectedClusterPanelAssemblyImage;
  String? selectedDashboardAssemblyAcVentImage;
  String? selectedDashboardAssemblyAcControlsImage;
  String? selectedFrontWindshieldGlassImage;
  String? selectedSeatsImage;
  String? selectedAudioStereoAssemblyImage;
  String? selectedCentreConsoleAssemblyImage;
  String? selectedForwardParkingSensorsImage;
  String? selectedFrontRightDoorAssemblyImage;
  String? selectedFrontLeftDoorAssemblyImage;
  String? selectedReverseParkingCameraImage;
  String? selectedReverseParkingSensorsImage;
  String? selectedFrontLeftExteriorImage;
  String? selectedFrontLeftMechanicalImage;
  String? selectedRearLeftExteriorImage;
  String? selectedRearLeftMechanicalImage;
  String? selectedLeftFloorPanChannelImage;
  String? selectedLeftPillarBImage;
  String? selectedLeftPillarCImage;
  String? selectedLeftRunningBoardImage;
  String? selectedRearLeftFloorPanImage;
  String? selectedRearLeftDoorChannelImage;
  String? selectedRearLeftWheelHouseImage;
  String? selectedLeftFenderLiningImage;
  String? selectedLeftFenderPanelImage;
  String? selectedLeftSvmAssemblyImage;
  String? selectedRearLeftDoorPanelImage;
  String? selectedDickeyDoorPanelImage;
  String? selectedDickeyLeftStayRodShockerImage;
  String? selectedDickeyRightStayRodShockerImage;
  String? selectedLeftTailLightAssemblyImage;
  String? selectedRearBumperPanelImage;
  String? selectedRearWindshieldGlassImage;
  String? selectedRearRegistrationPlateImage;
  String? selectedRightTailLightAssemblyImage;
  String? selectedDickeyBackPanelImage;
  String? selectedDickeyFloorImage;
  String? selectedDickeyLeftLegImage;
  String? selectedDickeyRightLegImage;
  String? selectedLeftDickeySidewallImage;
  String? selectedRightDickeySidewallImage;
  String? selectedLeftDickeyStrutTowerImage;
  String? selectedRightDickeyStrutTowerImage;
  String? selectedRoofPanelImage;
  String? selectedSpareTyreAssemblyImage;
  String? selectedFrontRightDoorPanelImage;
  String? selectedRightFenderLiningImage;
  String? selectedRightFenderPanelImage;
  String? selectedRightSvmAssemblyImage;
  String? selectedFourWheelDriveImage;
  String? selectedFrontRightBrakeAssemblyImage;
  String? selectedFrontWheelDriveImage;
  String? selectedFrontRightTyreAssemblyImage;
  String? selectedRightMechanicalImage;
  String? selectedRearRightDoorChannelImage;
  String? selectedRearRightFloorPanImage;
  String? selectedRearRightWheelHouseImage;
  String? selectedRightFloorPanChannelImage;
  String? selectedRightPillarBImage;
  String? selectedRightPillarCImage;
  String? selectedRightRunningBoardImage;
  List<String> selectedOtherImages = [];
  List<String> selectedAllImages = [];
  List<bool> battery = [];
  List<bool> engineRating = [];
  List<bool> frontSide = [];
  List<bool> interior1 = [];
  List<bool> interior2 = [];
  List<bool> leftSide = [];
  List<bool> rearSide = [];
  List<bool> rightSide = [];
  List<bool> testDrive = [];

  ///rc details
  final TextEditingController _rcNumberController = TextEditingController();

  ///video
  final TextEditingController engineNoiseVideo = TextEditingController();
  final TextEditingController testDriveVideo = TextEditingController();

  //extra parts
  final TextEditingController extraParts = TextEditingController();

  ///Registration details
  final TextEditingController _registrationYearMonthController =
      TextEditingController();
  void dispose() {
    // Dispose of the controllers when not in use to avoid memory leaks
    _testDriveBeforeController.dispose();
    _testDriveAfterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('inspection');
    log("${widget.carDetails.serialNumber}");
    // _loadCarData();
  }

  // Future<void> _pickImage() async {
  //   final List<XFile>? image = await picker.pickMultiImage(
  //     limit: 10,
  //   );

  //   if (image != null) {
  //     setState(() {
  //       image.forEach(
  //         (element) {
  //           _selectedOtherImages.add(File(element.path));
  //         },
  //       );
  //     });
  //     image.forEach(
  //       (element) async {
  //         final File file = File(element.path);
  //         final String fileName =
  //             '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //         final Reference reference = storage.ref(
  //             'inspection/${widget.carDetails.serialNumber}/car_doc/other_details/images/$fileName');
  //         final UploadTask uploadTask = reference.putFile(file);
  //         final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
  //           () {},
  //         );
  //         if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
  //           final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //           setState(() {
  //             selectedOtherImages.add(downloadUrl);
  //           });
  //           print('Image uploaded successfully: $downloadUrl');
  //         } else {
  //           // Image upload failed
  //           print('Image upload failed');
  //         }
  //       },
  //     );
  //   }
  // }

  // Future<void> _saveInspectionData() async {
  //   setState(() {
  //     _isUploading = true;
  //   });
  //   try {
  //     // Save comments to Firebase Realtime Database
  //     final String comment = _commentsController.text;
  //     await _database
  //         .child(
  //             '${widget.carDetails.serialNumber}/car_health/interior/comments')
  //         .set(comment);
  //     // Upload each image to Firebase Storage
  //     for (int i = 0; i < _interiorImages.length; i++) {
  //       File image = _interiorImages[i];
  //       String imageRef =
  //           '${widget.carDetails.serialNumber}/car_health/interior/interior_image_$i.jpg';
  //       // Upload image to Firebase Storage
  //       await storage.ref(imageRef).putFile(image);
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Inspection data saved successfully!")),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error saving inspection data: $e"),
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       _isUploading = false;
  //     });
  //   }
  // }
  void _checkSectionCompletion(String section) {
    if (section == "interior" &&
        _interiorImages.isNotEmpty &&
        _interiorCommentsController.text.isNotEmpty) {
      setState(() {
        _isInteriorComplete = true;
        _isExteriorVisible = true; // Show the exterior section
      });
    } else if (section == "exterior" &&
        _exteriorImages.isNotEmpty &&
        _exteriorCommentsController.text.isNotEmpty) {
      setState(() {
        _isExteriorVisible = true;
        _isExtraVisible = true; // Show the extra section
      });
    }
  }

  Future<void> _saveSectionData(String sectionName, List<File> images,
      TextEditingController commentsController) async {
    try {
      // Save comments to Firebase Realtime Database
      final String comment = commentsController.text;
      await _database
          .child(
              '${widget.carDetails.serialNumber}/car_health/$sectionName/remarks')
          .set(comment);

      // List to hold all upload tasks
      List<Future> uploadTasks = [];
      List<String> imageUrls = []; // List to store image URLs

      // Upload each image to Firebase Storage in parallel
      for (int i = 0; i < images.length; i++) {
        File image = images[i];
        String imageRef =
            'inspection/${widget.carDetails.serialNumber}/$sectionName/${sectionName}_image_$i.jpg';

        // Add upload task
        uploadTasks.add(
          storage.ref(imageRef).putFile(image).then((taskSnapshot) async {
            // Get the download URL
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            imageUrls.add(downloadUrl); // Store the URL in the list
          }),
        );
      }
      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      // Save the image URLs to the database
      await _database
          .child(
              '${widget.carDetails.serialNumber}/car_health/$sectionName/images')
          .set(imageUrls);
    } catch (e) {
      throw e; // Handle errors
    }
  }

  Future<void> _saveInspectionData() async {
    setState(() {
      _isUploading = true;
    });
    try {
      await _saveSectionData(
          "interior", _interiorImages, _interiorCommentsController);
      await _saveSectionData(
          "exterior", _exteriorImages, _exteriorCommentsController);
      await _saveSectionData("extra", _extraImages, _extraCommentsController);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inspection data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving inspection data: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _pickImage(List<File> sectionImages, String sectionName) async {
    if (sectionImages.length < 15) {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          sectionImages.add(File(image.path));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Maximum 15 images allowed for $sectionName section")),
      );
    }
  }

  // Future<void> _pickImage() async {
  //   // Allow the user to pick multiple images
  //   final List<XFile>? images = await picker.pickMultiImage();
  //   // Check if any images were selected
  //   if (images != null && images.isNotEmpty) {
  //     if (images.length > 5) {
  //       // If the user selects more than 5 images, show a message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('You can only select up to 5 images.')),
  //       );
  //       return;
  //     }
  //     // Store selected images in state
  //     setState(() {
  //       _selectedOtherImages.clear(); // Clear previous selections if needed
  //       _selectedOtherImages
  //           .addAll(images.map((element) => File(element.path)));
  //     });
  //     // Upload images to storage
  //     for (final element in images) {
  //       final File file = File(element.path);
  //       final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //       final Reference reference = storage.ref(
  //           'inspection/${widget.carDetails.serialNumber}/car_doc/other_details/images/$fileName');
  //       final UploadTask uploadTask = reference.putFile(file);
  //       final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
  //       if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
  //         final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //         setState(() {
  //           selectedOtherImages.add(downloadUrl);
  //         });
  //         print('Image uploaded successfully: $downloadUrl');
  //       } else {
  //         // Image upload failed
  //         print('Image upload failed');
  //       }
  //     }
  //   } else {
  //     // If no images were selected, show a message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please select at least one image.')),
  //     );
  //   }
  // }

  // Future<String> uploadImage(
  //     {required XFile imageVar, required imageRef}) async {
  //   final File file = File(imageVar.path);
  //   final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   final Reference reference = storage.ref('$imageRef/$fileName');
  //   final UploadTask uploadTask = reference.putFile(file);
  //   final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
  //     () {},
  //   );
  //   if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
  //     final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //     print('Image uploaded successfully: $downloadUrl');
  //     return downloadUrl;
  //   } else {
  //     // Image upload failed
  //     print('Image upload failed');
  //     return '';
  //   }
  // }
  Future<String> uploadImage({
    required XFile imageVar,
    required String imageRef,
  }) async {
    final File file = File(imageVar.path);
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference reference = storage.ref('$imageRef/$fileName');
    try {
      final UploadTask uploadTask = reference.putFile(file);
      // Show upload progress if needed (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });

      // Wait for the upload to completerc
      final TaskSnapshot taskSnapshot = await uploadTask;
      // Check if the upload was successful
      if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('Image uploaded successfully: $downloadUrl');
        return downloadUrl;
      } else {
        throw Exception('Image upload failed: Incomplete transfer.');
      }
    } catch (e) {
      // Handle any exceptions during the upload
      print('Image upload failed: $e');
      throw Exception('Image upload failed: $e');
    }
  }

  // // // Load existing data if serialNumber is provided
  // void _loadCarData() async {
  //   setState(() {
  //     _mfgYearMonthController.text = widget.carDetails.manfYear.toString();
  //     _carMakeController.text = widget.carDetails.brand.toString();
  //     _carModelController.text = widget.carDetails.model.toString();
  //     _fuelTypeController.text = widget.carDetails.fuelType.toString();
  //     _transmissionController.text = widget.carDetails.transmission.toString();
  //   });
  // }

  // Function to show max bid reached SnackBar
  void showErrorSnackBar(
      {required BuildContext context, required String errorMsg}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMsg),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Save data to Firebase
  void _saveCarDetails() async {
    setState(() {
      carDoc = CarDoc(
        rcDetails: RcDetails(
          rcNumber: _rcNumberController.text,
          rcImage: selectedRcImage, // Replace with actual logic for image
        ),
        carDetails: CarDetailsClass(
          mfgYearMonth: _mfgYearMonthController.text,
          carMake: _carMakeController.text,
          carModel: _carModelController.text,
          fuelType: _fuelTypeController.text,
          transmission: _transmissionController.text,
          images: selectedCarImage, // Replace with actual logic for image
        ),
        registrationDetails: RegistrationDetails(
          registrationYearMonth: _mfgYearMonthController.text,
        ),
        others: Others(
          owners: int.parse(_ownersController.text),
          hsrpAvailable: _hsrpAvailable,
          engineNumber: _engineNumberController.text,
          isChassisNumberOk: _isChassisNumberOk,
          chassisNumberImage: selectedChassisNumberImage,
          noOfKeys: int.tryParse(_numberOfKeyController.text),
          images: selectedOtherImages,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Car Details Saved!')),
    );
  }

  Future<void> sendDataToApi() async {
    // Define the URL for the API
    final url = Uri.parse('https://gowaggon.com/crm/api/PostInspection');
    final newCarDoc = CarDetails(
      serialNumber: widget.carDetails.serialNumber,
      reMarks: _reMarksController.text,
      carDoc: carDoc,
      carHealth: CarHealth(
        battery: Battery(
          aftermarketFitment: battryAfterMarketFitment,
          damaged: battryDamaged,
          leakage: battryLeakage,
          wrongSize: battryWrongSize,
          images: selectedBatteryImage,
        ),
        engine: Engine(
          staticEngineOn: StaticEngineOn(
            checkForAtGearBoxLeakages: CheckForAtGearBoxLeakages(
              leakageFromAtGearboxHousing: leakageFromAtGearboxHousing,
              leakageFromAtInputShaft: leakageFromAtInputShaft,
            ),
            checkForEngineLeakages: CheckForEngineLeakages(
              leakageFromEngineBlock: leakageFromEngineBlock,
              leakageFromExhaustManifold: leakageFromExhaustManifold,
              leakageFromTurbocharger: leakageFromTurbocharger,
              leakgeFromMetalTiming: leakageFromMetalTiming,
              seepageFromEngineTiming: seepageFromEngineTiming,
            ),
            checkForEnginePerformances: CheckForEnginePerformances(
              backCompressionInEngine: backCompressionInEngine,
              overheaingDueToRadiatorSystem: overheaingDueToRadiatorSystem,
              overheatingInEngine: overheatingInEngine,
            ),
            checkForManualGearBoxLeakages: CheckForManualGearBoxLeakages(
              leakageFrom5ThGearHousing: leakageFrom5ThGearHousing,
              leakageFromDriveAxle: leakageFromDriveAxle,
              leakageFromMtGearboxHousing: leakageFromMtGearboxHousing,
              leakageFromMtInputShaft: leakageFromMtInputShaft,
            ),
            videos: Videos(
              engineNoiseVideo: '',
              testDriveVideo: '',
            ),
          ),
        ),
        extra: Extra(
          extraParts: extraParts.text,
        ),
        frontSide: FrontSide(
          frontExterior1: FrontExterior1(
            bonnetPanel: BonnetPanel(
              images: selectedBonnetImage,
              alignmentOut: bonnetAlignmentOut,
              corrosionMajor: bonnetCorrosionMajor,
              corrosionMinor: bonnetCorrosionMinor,
              paintDefective: bonnetPaintDefective,
              repainted: bonnetRepainted,
              replaced: bonnetReplaced,
            ),
            carKey: CarKey(
              images: selectedCarKeyImage,
              damagedMajor: carKeyDamagedMajor,
              damagedMinor: carKeyDamagedMinor,
              noFreeMovement: carKeyNoFreeMovement,
              oneKeyMissing: carKeyOneKeyMissing,
            ),
            centralLockingRemoteHousing: CarKey(
              images: selectedCentralLockingRemoteHousingImage,
              damagedMajor: centralLockingRemoteHousingDamagedMajor,
              damagedMinor: centralLockingRemoteHousingDamagedMinor,
              noFreeMovement: centralLockingRemoteHousingNoFreeMovement,
              oneKeyMissing: centralLockingRemoteHousingOneKeyMissing,
            ),
            frontBumperGrill: FrontBumperGrill(
              images: selectedFrontBumperGrillImage,
              crackMajor: frontBumperGrillCrackMajor,
              crackMinor: frontBumperGrillCrackMinor,
              repaired: frontBumperGrillRepaired,
              scratchesMajor: frontBumperGrillScratchesMajor,
              scratchesMinor: frontBumperGrillScratchesMajor,
            ),
            frontBumperPanel: FrontBumperPanel(
              images: selectedFrontBumperPanelImage,
              repainted: frontBumperPanelRepainted,
              paintDefective: frontBumperPanelPaintDefective,
              wrapping: frontBumperPanelWrapping,
              tabLocksScrewRepaired: frontBumperPanelTabLocksScrewRepaired,
              partMissing: frontBumperPanelPartMissing,
            ),
            frontRegistrationPlate: FrontRegistrationPlate(
              images: selectedFrontRegistrationPlateImage,
              damagedMinor: frontRegistrationPlateDamagedMinor,
              damagedMajor: frontRegistrationPlateDamagedMajor,
              aftermarketFitment: frontRegistrationPlateAftermarketFitment,
              partMissing: frontRegistrationPlatePartMissing,
            ),
          ),
          frontExterior2: FrontExterior2(
            frontLeftFogLightHousing: FrontLeftExterior(
              images: selectedFrontLeftFogLightHousingImage,
              repaired: frontLeftFogLightHousingRepaired,
              replaced: frontLeftFogLightHousingReplaced,
              crackMajor: frontLeftFogLightHousingCrackMajor,
              crackMinor: frontLeftFogLightHousingCrackMinor,
              corrosionMinor: frontLeftFogLightHousingCorrosionMinor,
              corrosionMajor: frontLeftFogLightHousingCrackMajor,
              bendDentMajor: frontLeftFogLightHousingBendDentMajor,
              bendDentMinor: frontLeftFogLightHousingBendDentMinor,
              punchesOpenRepaired: frontLeftFogLightHousingPunchesOpenRepaired,
            ),
            frontRightFogLightHousing: FrontLeftExterior(
              images: selectedFrontRightFogLightHousingImage,
              repaired: frontRightFogLightHousingRepaired,
              replaced: frontRightFogLightHousingReplaced,
              crackMajor: frontRightFogLightHousingCrackMajor,
              crackMinor: frontRightFogLightHousingCrackMinor,
              corrosionMinor: frontRightFogLightHousingCorrosionMinor,
              corrosionMajor: frontRightFogLightHousingCrackMajor,
              bendDentMajor: frontRightFogLightHousingBendDentMajor,
              bendDentMinor: frontRightFogLightHousingBendDentMinor,
              punchesOpenRepaired: frontRightFogLightHousingPunchesOpenRepaired,
            ),
            leftDrl: FrontLeftExterior(
              images: selectedLeftDrlImage,
              repaired: leftDrlRepaired,
              replaced: leftDrlReplaced,
              crackMajor: leftDrlCrackMajor,
              crackMinor: leftDrlCrackMinor,
              corrosionMinor: leftDrlCorrosionMinor,
              corrosionMajor: leftDrlCrackMajor,
              bendDentMajor: leftDrlBendDentMajor,
              bendDentMinor: leftDrlBendDentMinor,
              punchesOpenRepaired: leftDrlPunchesOpenRepaired,
            ),
            leftHeadlightAssembly: FrontLeftExterior(
              images: selectedLeftHeadlightAssemblyImage,
              repaired: leftHeadlightAssemblyRepaired,
              replaced: leftHeadlightAssemblyReplaced,
              crackMajor: leftHeadlightAssemblyCrackMajor,
              crackMinor: leftHeadlightAssemblyCrackMinor,
              corrosionMinor: leftHeadlightAssemblyCorrosionMinor,
              corrosionMajor: leftHeadlightAssemblyCrackMajor,
              bendDentMajor: leftHeadlightAssemblyBendDentMajor,
              bendDentMinor: leftHeadlightAssemblyBendDentMinor,
              punchesOpenRepaired: leftHeadlightAssemblyPunchesOpenRepaired,
            ),
            leftHeadlightHousing: FrontLeftExterior(
              images: selectedLeftHeadlightHousingImage,
              repaired: leftHeadlightHousingRepaired,
              replaced: leftHeadlightHousingReplaced,
              crackMajor: leftHeadlightHousingCrackMajor,
              crackMinor: leftHeadlightHousingCrackMinor,
              corrosionMinor: leftHeadlightHousingCorrosionMinor,
              corrosionMajor: leftHeadlightHousingCrackMajor,
              bendDentMajor: leftHeadlightHousingBendDentMajor,
              bendDentMinor: leftHeadlightHousingBendDentMinor,
              punchesOpenRepaired: leftHeadlightHousingPunchesOpenRepaired,
            ),
            rightDrl: FrontLeftExterior(
              images: selectedRightDrlImage,
              repaired: rightDrlRepaired,
              replaced: rightDrlReplaced,
              crackMajor: rightDrlCrackMajor,
              crackMinor: rightDrlCrackMinor,
              corrosionMinor: rightDrlCorrosionMinor,
              corrosionMajor: rightDrlCrackMajor,
              bendDentMajor: rightDrlBendDentMajor,
              bendDentMinor: rightDrlBendDentMinor,
              punchesOpenRepaired: rightDrlPunchesOpenRepaired,
            ),
            rightHeadlightAssembly: FrontLeftExterior(
              images: selectedRightHeadlightAssemblyImage,
              repaired: rightHeadlightAssemblyRepaired,
              replaced: rightHeadlightAssemblyReplaced,
              crackMajor: rightHeadlightAssemblyCrackMajor,
              crackMinor: rightHeadlightAssemblyCrackMinor,
              corrosionMinor: rightHeadlightAssemblyCorrosionMinor,
              corrosionMajor: rightHeadlightAssemblyCrackMajor,
              bendDentMajor: rightHeadlightAssemblyBendDentMajor,
              bendDentMinor: rightHeadlightAssemblyBendDentMinor,
              punchesOpenRepaired: rightHeadlightAssemblyPunchesOpenRepaired,
            ),
            rightHeadlightHousing: FrontLeftExterior(
              images: selectedRightHeadlightHousingImage,
              repaired: rightHeadlightHousingRepaired,
              replaced: rightHeadlightHousingReplaced,
              crackMajor: rightHeadlightHousingCrackMajor,
              crackMinor: rightHeadlightHousingCrackMinor,
              corrosionMinor: rightHeadlightHousingCorrosionMinor,
              corrosionMajor: rightHeadlightHousingCrackMajor,
              bendDentMajor: rightHeadlightHousingBendDentMajor,
              bendDentMinor: rightHeadlightHousingBendDentMinor,
              punchesOpenRepaired: rightHeadlightHousingPunchesOpenRepaired,
            ),
          ),
          frontStructure1: FrontStructure1(
            boltedRadiatorSupport: EdRadiatorSupport(
              crackMajor: boltedRadiatorSupportCrackMajor,
              crackMinor: boltedRadiatorSupportCrackMinor,
              corrosionMinor: boltedRadiatorSupportCorrosionMinor,
              corrosionMajor: boltedRadiatorSupportCrackMajor,
              bendDentMajor: boltedRadiatorSupportBendDentMajor,
              bendDentMinor: boltedRadiatorSupportBendDentMinor,
            ),
            fibreRadiatorSupport: FibreRadiatorSupport(
              crackMajor: fibreRadiatorSupportCrackMajor,
              crackMinor: fibreRadiatorSupportCrackMinor,
              repaired: fibreRadiatorSupportRepaired,
            ),
            frontLeftLeg: FrontLeftExterior(
              images: selectedFrontLeftLegImage,
              repaired: frontLeftLegRepaired,
              replaced: frontLeftLegReplaced,
              crackMajor: frontLeftLegCrackMajor,
              crackMinor: frontLeftLegCrackMinor,
              corrosionMinor: frontLeftLegCorrosionMinor,
              corrosionMajor: frontLeftLegCrackMajor,
              bendDentMajor: frontLeftLegBendDentMajor,
              bendDentMinor: frontLeftLegBendDentMinor,
              punchesOpenRepaired: frontLeftLegPunchesOpenRepaired,
            ),
            frontRightLeft: FrontLeftExterior(
              images: selectedFrontRightLeftImage,
              repaired: frontRightLeftRepaired,
              replaced: frontRightLeftReplaced,
              crackMajor: frontRightLeftCrackMajor,
              crackMinor: frontRightLeftCrackMinor,
              corrosionMinor: frontRightLeftCorrosionMinor,
              corrosionMajor: frontRightLeftCrackMajor,
              bendDentMajor: frontRightLeftBendDentMajor,
              bendDentMinor: frontRightLeftBendDentMinor,
              punchesOpenRepaired: frontRightLeftPunchesOpenRepaired,
            ),
            weldedRadiatorSupport: EdRadiatorSupport(
              crackMajor: weldedRadiatorSupportCrackMajor,
              crackMinor: weldedRadiatorSupportCrackMinor,
              corrosionMinor: weldedRadiatorSupportCorrosionMinor,
              corrosionMajor: weldedRadiatorSupportCrackMajor,
              bendDentMajor: weldedRadiatorSupportBendDentMajor,
              bendDentMinor: weldedRadiatorSupportBendDentMinor,
            ),
          ),
        ),
        interior1: Interior1(
          acAssembly: AcAssembly(
            lessEffective: acAssemblyNoise,
            noise: acAssemblyNoise,
            notWorking: acAssemblyNotWorking,
          ),
          airbags: Airbags(
            driverSide: airBagsDriverSide,
            passengerSide: airBagsPassengerSide,
          ),
          clusterPanelAssembly: ClusterPanelAssembly(
            engineChecklight: clusterPanelAssemblyEngineCheckLight,
            absLight: clusterPanelAssemblyAbsLight,
            srsLight: clusterPanelAssemblySrsLight,
            automaticTransmissionLight:
                clusterPanelAssemblyAutomaticTransmissionLight,
            speedometer: clusterPanelAssemblySpeedometer,
            images: selectedClusterPanelAssemblyImage,
          ),
          dashboardAssembly: DashboardAssembly(
            acVent: Ac(
              working: dashboardAssemblyAcVentWorking,
              damaged: dashboardAssemblyAcVentDamaged,
              images: selectedDashboardAssemblyAcVentImage,
            ),
            acControls: Ac(
              working: dashboardAssemblyAcControlsWorking,
              damaged: dashboardAssemblyAcControlsDamaged,
              images: selectedDashboardAssemblyAcControlsImage,
            ),
          ),
          frontWindshieldGlass: FrontWindshieldGlass(
            crackMajor: frontWindshieldGlassCrackMajor,
            crackMinor: frontWindshieldGlassCrackMinor,
            scratchesMajor: frontWindshieldGlassScratchesMajor,
            scratchesMinor: frontWindshieldGlassScratchesMinor,
            images: selectedFrontWindshieldGlassImage,
          ),
          seats: Seats(
            damageMajor: seatsDamageMajor,
            damageMinor: seatsDamageMinor,
            aftermarketFitment: seatsAftermarketFitment,
            electronicSeat: seatsElectronicSeat,
            images: selectedSeatsImage,
          ),
        ),
        interior2: Interior2(
          audioStereoAssembly: Interior2Common(
            images: selectedAudioStereoAssemblyImage,
            replaced: audioStereoAssemblyReplaced,
            crackMajor: audioStereoAssemblyCrackMajor,
            crackMinor: audioStereoAssemblyCrackMinor,
            corrosionMinor: audioStereoAssemblyCorrosionMinor,
            corrosionMajor: audioStereoAssemblyCrackMajor,
            bendDentMajor: audioStereoAssemblyBendDentMajor,
            punchesOpenRepaired: audioStereoAssemblyPunchesOpenRepaired,
            repainted: audioStereoAssemblyRepainted,
            hammerRepairedMajor: audioStereoAssemblyHammerRepairedMajor,
            hammerRepairedMinor: audioStereoAssemblyHammerRepairedMinor,
            wrapping: audioStereoAssemblyWrapping,
            scratchesMinor: audioStereoAssemblyScratchesMinor,
            scratchesMajor: audioStereoAssemblyScratchesMajor,
            paintMismatch: audioStereoAssemblyPaintMisMatch,
          ),
          centreConsoleAssembly: Interior2Common(
            images: selectedCentreConsoleAssemblyImage,
            replaced: centreConsoleAssemblyReplaced,
            crackMajor: centreConsoleAssemblyCrackMajor,
            crackMinor: centreConsoleAssemblyCrackMinor,
            corrosionMinor: centreConsoleAssemblyCorrosionMinor,
            corrosionMajor: centreConsoleAssemblyCrackMajor,
            bendDentMajor: centreConsoleAssemblyBendDentMajor,
            punchesOpenRepaired: centreConsoleAssemblyPunchesOpenRepaired,
            repainted: centreConsoleAssemblyRepainted,
            hammerRepairedMajor: centreConsoleAssemblyHammerRepairedMajor,
            hammerRepairedMinor: centreConsoleAssemblyHammerRepairedMinor,
            wrapping: centreConsoleAssemblyWrapping,
            scratchesMinor: centreConsoleAssemblyScratchesMinor,
            scratchesMajor: centreConsoleAssemblyScratchesMajor,
            paintMismatch: centreConsoleAssemblyPaintMisMatch,
          ),
          forwardParkingSensors: Interior2Common(
            images: selectedForwardParkingSensorsImage,
            replaced: forwardParkingSensorsReplaced,
            crackMajor: forwardParkingSensorsCrackMajor,
            crackMinor: forwardParkingSensorsCrackMinor,
            corrosionMinor: forwardParkingSensorsCorrosionMinor,
            corrosionMajor: forwardParkingSensorsCrackMajor,
            bendDentMajor: forwardParkingSensorsBendDentMajor,
            punchesOpenRepaired: forwardParkingSensorsPunchesOpenRepaired,
            repainted: forwardParkingSensorsRepainted,
            hammerRepairedMajor: forwardParkingSensorsHammerRepairedMajor,
            hammerRepairedMinor: forwardParkingSensorsHammerRepairedMinor,
            wrapping: forwardParkingSensorsWrapping,
            scratchesMinor: forwardParkingSensorsScratchesMinor,
            scratchesMajor: forwardParkingSensorsScratchesMajor,
            paintMismatch: forwardParkingSensorsPaintMisMatch,
          ),
          frontLeftDoorAssembly: Interior2Common(
            images: selectedFrontLeftDoorAssemblyImage,
            replaced: frontLeftDoorAssemblyReplaced,
            crackMajor: frontLeftDoorAssemblyCrackMajor,
            crackMinor: frontLeftDoorAssemblyCrackMinor,
            corrosionMinor: frontLeftDoorAssemblyCorrosionMinor,
            corrosionMajor: frontLeftDoorAssemblyCrackMajor,
            bendDentMajor: frontLeftDoorAssemblyBendDentMajor,
            punchesOpenRepaired: frontLeftDoorAssemblyPunchesOpenRepaired,
            repainted: frontLeftDoorAssemblyRepainted,
            hammerRepairedMajor: frontLeftDoorAssemblyHammerRepairedMajor,
            hammerRepairedMinor: frontLeftDoorAssemblyHammerRepairedMinor,
            wrapping: frontLeftDoorAssemblyWrapping,
            scratchesMinor: frontLeftDoorAssemblyScratchesMinor,
            scratchesMajor: frontLeftDoorAssemblyScratchesMajor,
            paintMismatch: frontLeftDoorAssemblyPaintMisMatch,
          ),
          frontRightDoorAssembly: Interior2Common(
            images: selectedFrontRightDoorAssemblyImage,
            replaced: frontRightDoorAssemblyReplaced,
            crackMajor: frontRightDoorAssemblyCrackMajor,
            crackMinor: frontRightDoorAssemblyCrackMinor,
            corrosionMinor: frontRightDoorAssemblyCorrosionMinor,
            corrosionMajor: frontRightDoorAssemblyCrackMajor,
            bendDentMajor: frontRightDoorAssemblyBendDentMajor,
            punchesOpenRepaired: frontRightDoorAssemblyPunchesOpenRepaired,
            repainted: frontRightDoorAssemblyRepainted,
            hammerRepairedMajor: frontRightDoorAssemblyHammerRepairedMajor,
            hammerRepairedMinor: frontRightDoorAssemblyHammerRepairedMinor,
            wrapping: frontRightDoorAssemblyWrapping,
            scratchesMinor: frontRightDoorAssemblyScratchesMinor,
            scratchesMajor: frontRightDoorAssemblyScratchesMajor,
            paintMismatch: frontRightDoorAssemblyPaintMisMatch,
          ),
          reverseParkingCamera: Interior2Common(
            images: selectedReverseParkingCameraImage,
            replaced: reverseParkingCameraReplaced,
            crackMajor: reverseParkingCameraCrackMajor,
            crackMinor: reverseParkingCameraCrackMinor,
            corrosionMinor: reverseParkingCameraCorrosionMinor,
            corrosionMajor: reverseParkingCameraCrackMajor,
            bendDentMajor: reverseParkingCameraBendDentMajor,
            punchesOpenRepaired: reverseParkingCameraPunchesOpenRepaired,
            repainted: reverseParkingCameraRepainted,
            hammerRepairedMajor: reverseParkingCameraHammerRepairedMajor,
            hammerRepairedMinor: reverseParkingCameraHammerRepairedMinor,
            wrapping: reverseParkingCameraWrapping,
            scratchesMinor: reverseParkingCameraScratchesMinor,
            scratchesMajor: reverseParkingCameraScratchesMajor,
            paintMismatch: reverseParkingCameraPaintMisMatch,
          ),
          reverseParkingSensors: Interior2Common(
            images: selectedReverseParkingSensorsImage,
            replaced: reverseParkingSensorsReplaced,
            crackMajor: reverseParkingSensorsCrackMajor,
            crackMinor: reverseParkingSensorsCrackMinor,
            corrosionMinor: reverseParkingSensorsCorrosionMinor,
            corrosionMajor: reverseParkingSensorsCrackMajor,
            bendDentMajor: reverseParkingSensorsBendDentMajor,
            punchesOpenRepaired: reverseParkingSensorsPunchesOpenRepaired,
            repainted: reverseParkingSensorsRepainted,
            hammerRepairedMajor: reverseParkingSensorsHammerRepairedMajor,
            hammerRepairedMinor: reverseParkingSensorsHammerRepairedMinor,
            wrapping: reverseParkingSensorsWrapping,
            scratchesMinor: reverseParkingSensorsScratchesMinor,
            scratchesMajor: reverseParkingSensorsScratchesMajor,
            paintMismatch: reverseParkingSensorsPaintMisMatch,
          ),
        ),
        leftSide: LeftSide(
          frontLeftExterior: FrontLeftExterior(
            images: selectedFrontLeftExteriorImage,
            repaired: frontLeftExteriorRepaired,
            replaced: frontLeftExteriorReplaced,
            crackMajor: frontLeftExteriorCrackMajor,
            crackMinor: frontLeftExteriorCrackMinor,
            corrosionMinor: frontLeftExteriorCorrosionMinor,
            corrosionMajor: frontLeftExteriorCrackMajor,
            bendDentMajor: frontLeftExteriorBendDentMajor,
            bendDentMinor: frontLeftExteriorBendDentMinor,
            punchesOpenRepaired: frontLeftExteriorPunchesOpenRepaired,
          ),
          frontLeftMechanical: Interior2Common(
            images: selectedFrontLeftMechanicalImage,
            replaced: frontLeftMechanicalReplaced,
            crackMajor: frontLeftMechanicalCrackMajor,
            crackMinor: frontLeftMechanicalCrackMinor,
            corrosionMinor: frontLeftMechanicalCorrosionMinor,
            corrosionMajor: frontLeftMechanicalCrackMajor,
            bendDentMajor: frontLeftMechanicalBendDentMajor,
            punchesOpenRepaired: frontLeftMechanicalPunchesOpenRepaired,
            repainted: frontLeftMechanicalRepainted,
            hammerRepairedMajor: frontLeftMechanicalHammerRepairedMajor,
            hammerRepairedMinor: frontLeftMechanicalHammerRepairedMinor,
            wrapping: frontLeftMechanicalWrapping,
            scratchesMinor: frontLeftMechanicalScratchesMinor,
            scratchesMajor: frontLeftMechanicalScratchesMajor,
            paintMismatch: frontLeftMechanicalPaintMisMatch,
          ),
          frontLeftStructure: FrontLeftStructure(
            leftFloorPanChannel: Interior2Common(
              images: selectedLeftFloorPanChannelImage,
              replaced: leftFloorPanChannelReplaced,
              crackMajor: leftFloorPanChannelCrackMajor,
              crackMinor: leftFloorPanChannelCrackMinor,
              corrosionMinor: leftFloorPanChannelCorrosionMinor,
              corrosionMajor: leftFloorPanChannelCrackMajor,
              bendDentMajor: leftFloorPanChannelBendDentMajor,
              punchesOpenRepaired: leftFloorPanChannelPunchesOpenRepaired,
              repainted: leftFloorPanChannelRepainted,
              hammerRepairedMajor: leftFloorPanChannelHammerRepairedMajor,
              hammerRepairedMinor: leftFloorPanChannelHammerRepairedMinor,
              wrapping: leftFloorPanChannelWrapping,
              scratchesMinor: leftFloorPanChannelScratchesMinor,
              scratchesMajor: leftFloorPanChannelScratchesMajor,
              paintMismatch: leftFloorPanChannelPaintMisMatch,
            ),
            leftPillarB: Interior2Common(
              images: selectedLeftPillarBImage,
              replaced: leftPillarBReplaced,
              crackMajor: leftPillarBCrackMajor,
              crackMinor: leftPillarBCrackMinor,
              corrosionMinor: leftPillarBCorrosionMinor,
              corrosionMajor: leftPillarBCrackMajor,
              bendDentMajor: leftPillarBBendDentMajor,
              punchesOpenRepaired: leftPillarBPunchesOpenRepaired,
              repainted: leftPillarBRepainted,
              hammerRepairedMajor: leftPillarBHammerRepairedMajor,
              hammerRepairedMinor: leftPillarBHammerRepairedMinor,
              wrapping: leftPillarBWrapping,
              scratchesMinor: leftPillarBScratchesMinor,
              scratchesMajor: leftPillarBScratchesMajor,
              paintMismatch: leftPillarBPaintMisMatch,
            ),
            leftPillarC: Interior2Common(
              images: selectedLeftPillarCImage,
              replaced: leftPillarCReplaced,
              crackMajor: leftPillarCCrackMajor,
              crackMinor: leftPillarCCrackMinor,
              corrosionMinor: leftPillarCCorrosionMinor,
              corrosionMajor: leftPillarCCrackMajor,
              bendDentMajor: leftPillarCBendDentMajor,
              punchesOpenRepaired: leftPillarCPunchesOpenRepaired,
              repainted: leftPillarCRepainted,
              hammerRepairedMajor: leftPillarCHammerRepairedMajor,
              hammerRepairedMinor: leftPillarCHammerRepairedMinor,
              wrapping: leftPillarCWrapping,
              scratchesMinor: leftPillarCScratchesMinor,
              scratchesMajor: leftPillarCScratchesMajor,
              paintMismatch: leftPillarCPaintMisMatch,
            ),
            leftRunningBoard: TRunningBoard(
              images: selectedLeftRunningBoardImage,
              replaced: leftRunningBoardReplaced,
              corrosionMinor: leftRunningBoardCorrosionMinor,
              corrosionMajor: leftRunningBoardCorrosionMinor,
              crack: leftRunningBoardCrack,
              punchesOpenRepaired: leftRunningBoardPunchesOpenRepaired,
              repainted: leftRunningBoardRepainted,
              paintMismatch: leftRunningBoardPaintMisMatch,
            ),
            rearLeftDoorChannel: Interior2Common(
              images: selectedRearLeftDoorChannelImage,
              replaced: rearLeftDoorChannelReplaced,
              crackMajor: rearLeftDoorChannelCrackMajor,
              crackMinor: rearLeftDoorChannelCrackMinor,
              corrosionMinor: rearLeftDoorChannelCorrosionMinor,
              corrosionMajor: rearLeftDoorChannelCrackMajor,
              bendDentMajor: rearLeftDoorChannelBendDentMajor,
              punchesOpenRepaired: rearLeftDoorChannelPunchesOpenRepaired,
              repainted: rearLeftDoorChannelRepainted,
              hammerRepairedMajor: rearLeftDoorChannelHammerRepairedMajor,
              hammerRepairedMinor: rearLeftDoorChannelHammerRepairedMinor,
              wrapping: rearLeftDoorChannelWrapping,
              scratchesMinor: rearLeftDoorChannelScratchesMinor,
              scratchesMajor: rearLeftDoorChannelScratchesMajor,
              paintMismatch: rearLeftDoorChannelPaintMisMatch,
            ),
            rearLeftFloorPan: Interior2Common(
              images: selectedRearLeftFloorPanImage,
              replaced: rearLeftFloorPanReplaced,
              crackMajor: rearLeftFloorPanCrackMajor,
              crackMinor: rearLeftFloorPanCrackMinor,
              corrosionMinor: rearLeftFloorPanCorrosionMinor,
              corrosionMajor: rearLeftFloorPanCrackMajor,
              bendDentMajor: rearLeftFloorPanBendDentMajor,
              punchesOpenRepaired: rearLeftFloorPanPunchesOpenRepaired,
              repainted: rearLeftFloorPanRepainted,
              hammerRepairedMajor: rearLeftFloorPanHammerRepairedMajor,
              hammerRepairedMinor: rearLeftFloorPanHammerRepairedMinor,
              wrapping: rearLeftFloorPanWrapping,
              scratchesMinor: rearLeftFloorPanScratchesMinor,
              scratchesMajor: rearLeftFloorPanScratchesMajor,
              paintMismatch: rearLeftFloorPanPaintMisMatch,
            ),
            rearLeftWheelHouse: Interior2Common(
              images: selectedRearLeftWheelHouseImage,
              replaced: rearLeftWheelHouseReplaced,
              crackMajor: rearLeftWheelHouseCrackMajor,
              crackMinor: rearLeftWheelHouseCrackMinor,
              corrosionMinor: rearLeftWheelHouseCorrosionMinor,
              corrosionMajor: rearLeftWheelHouseCrackMajor,
              bendDentMajor: rearLeftWheelHouseBendDentMajor,
              punchesOpenRepaired: rearLeftWheelHousePunchesOpenRepaired,
              repainted: rearLeftWheelHouseRepainted,
              hammerRepairedMajor: rearLeftWheelHouseHammerRepairedMajor,
              hammerRepairedMinor: rearLeftWheelHouseHammerRepairedMinor,
              wrapping: rearLeftWheelHouseWrapping,
              scratchesMinor: rearLeftWheelHouseScratchesMinor,
              scratchesMajor: rearLeftWheelHouseScratchesMajor,
              paintMismatch: rearLeftWheelHousePaintMisMatch,
            ),
          ),
          rearLeftExterior: FrontLeftExterior(
            images: selectedRearLeftExteriorImage,
            repaired: rearLeftExteriorRepaired,
            replaced: rearLeftExteriorReplaced,
            crackMajor: rearLeftExteriorCrackMajor,
            crackMinor: rearLeftExteriorCrackMinor,
            corrosionMinor: rearLeftExteriorCorrosionMinor,
            corrosionMajor: rearLeftExteriorCrackMajor,
            bendDentMajor: rearLeftExteriorBendDentMajor,
            bendDentMinor: rearLeftExteriorBendDentMinor,
            punchesOpenRepaired: rearLeftExteriorPunchesOpenRepaired,
          ),
          rearLeftMechanical: FrontLeftExterior(
            images: selectedRearLeftExteriorImage,
            repaired: rearLeftExteriorRepaired,
            replaced: rearLeftExteriorReplaced,
            crackMajor: rearLeftExteriorCrackMajor,
            crackMinor: rearLeftExteriorCrackMinor,
            corrosionMinor: rearLeftExteriorCorrosionMinor,
            corrosionMajor: rearLeftExteriorCrackMajor,
            bendDentMajor: rearLeftExteriorBendDentMajor,
            bendDentMinor: rearLeftExteriorBendDentMinor,
            punchesOpenRepaired: rearLeftExteriorPunchesOpenRepaired,
          ),
          rearLeftStructure: RearLeftStructure(
            leftFenderLining: FrontLeftExterior(
              images: selectedLeftFenderLiningImage,
              repaired: leftFenderLiningRepaired,
              replaced: leftFenderLiningReplaced,
              crackMajor: leftFenderLiningCrackMajor,
              crackMinor: leftFenderLiningCrackMinor,
              corrosionMinor: leftFenderLiningCorrosionMinor,
              corrosionMajor: leftFenderLiningCrackMajor,
              bendDentMajor: leftFenderLiningBendDentMajor,
              bendDentMinor: leftFenderLiningBendDentMinor,
              punchesOpenRepaired: leftFenderLiningPunchesOpenRepaired,
            ),
            leftFenderPanel: FrontLeftExterior(
              images: selectedLeftFenderPanelImage,
              repaired: leftFenderPanelRepaired,
              replaced: leftFenderPanelReplaced,
              crackMajor: leftFenderPanelCrackMajor,
              crackMinor: leftFenderPanelCrackMinor,
              corrosionMinor: leftFenderPanelCorrosionMinor,
              corrosionMajor: leftFenderPanelCrackMajor,
              bendDentMajor: leftFenderPanelBendDentMajor,
              bendDentMinor: leftFenderPanelBendDentMinor,
              punchesOpenRepaired: leftFenderPanelPunchesOpenRepaired,
            ),
            leftSvmAssembly: FrontLeftExterior(
              images: selectedLeftSvmAssemblyImage,
              repaired: leftSvmAssemblyRepaired,
              replaced: leftSvmAssemblyReplaced,
              crackMajor: leftSvmAssemblyCrackMajor,
              crackMinor: leftSvmAssemblyCrackMinor,
              corrosionMinor: leftSvmAssemblyCorrosionMinor,
              corrosionMajor: leftSvmAssemblyCrackMajor,
              bendDentMajor: leftSvmAssemblyBendDentMajor,
              bendDentMinor: leftSvmAssemblyBendDentMinor,
              punchesOpenRepaired: leftSvmAssemblyPunchesOpenRepaired,
            ),
            rearLeftDoorPanel: FrontLeftExterior(
              images: selectedRearLeftDoorPanelImage,
              repaired: rearLeftDoorPanelRepaired,
              replaced: rearLeftDoorPanelReplaced,
              crackMajor: rearLeftDoorPanelCrackMajor,
              crackMinor: rearLeftDoorPanelCrackMinor,
              corrosionMinor: rearLeftDoorPanelCorrosionMinor,
              corrosionMajor: rearLeftDoorPanelCrackMajor,
              bendDentMajor: rearLeftDoorPanelBendDentMajor,
              bendDentMinor: rearLeftDoorPanelBendDentMinor,
              punchesOpenRepaired: rearLeftDoorPanelPunchesOpenRepaired,
            ),
          ),
        ),
        rearSide: RearSide(
          rearExterior: RearExterior(
            dickeyDoorPanel: FrontLeftExterior(
              images: selectedDickeyDoorPanelImage,
              hammerRepairedMinor: dickeyDoorPanelHammerRepairedMinor,
              hammerRepairedMajor: dickeyDoorPanelHammerRepairedMajor,
              replaced: dickeyDoorPanelReplaced,
              crackMajor: dickeyDoorPanelCrackMajor,
              crackMinor: dickeyDoorPanelCrackMinor,
              corrosionMinor: dickeyDoorPanelCorrosionMinor,
              corrosionMajor: dickeyDoorPanelCrackMajor,
              bendDentMajor: dickeyDoorPanelBendDentMajor,
              bendDentMinor: dickeyDoorPanelBendDentMinor,
              punchesOpenRepaired: dickeyDoorPanelPunchesOpenRepaired,
            ),
            dickeyLeftStayRodShocker: FrontLeftExterior(
              images: selectedDickeyLeftStayRodShockerImage,
              hammerRepairedMinor: dickeyLeftStayRodShockerHammerRepairedMinor,
              hammerRepairedMajor: dickeyRightStayRodShockerHammerRepairedMajor,
              replaced: dickeyLeftStayRodShockerReplaced,
              crackMajor: dickeyLeftStayRodShockerCrackMajor,
              crackMinor: dickeyLeftStayRodShockerCrackMinor,
              corrosionMinor: dickeyLeftStayRodShockerCorrosionMinor,
              corrosionMajor: dickeyLeftStayRodShockerCrackMajor,
              bendDentMajor: dickeyLeftStayRodShockerBendDentMajor,
              bendDentMinor: dickeyLeftStayRodShockerBendDentMinor,
              punchesOpenRepaired: dickeyLeftStayRodShockerPunchesOpenRepaired,
            ),
            dickeyRightStayRodShocker: FrontLeftExterior(
              images: selectedDickeyRightStayRodShockerImage,
              hammerRepairedMinor: dickeyRightStayRodShockerHammerRepairedMinor,
              hammerRepairedMajor: dickeyRightStayRodShockerHammerRepairedMajor,
              replaced: dickeyRightStayRodShockerReplaced,
              crackMajor: dickeyRightStayRodShockerCrackMajor,
              crackMinor: dickeyRightStayRodShockerCrackMinor,
              corrosionMinor: dickeyRightStayRodShockerCorrosionMinor,
              corrosionMajor: dickeyRightStayRodShockerCrackMajor,
              bendDentMajor: dickeyRightStayRodShockerBendDentMajor,
              bendDentMinor: dickeyRightStayRodShockerBendDentMinor,
              punchesOpenRepaired: dickeyRightStayRodShockerPunchesOpenRepaired,
            ),
            leftTailLightAssembly: Interior2Common(
              images: selectedLeftTailLightAssemblyImage,
              replaced: leftTailLightAssemblyReplaced,
              crackMajor: leftTailLightAssemblyCrackMajor,
              crackMinor: leftTailLightAssemblyCrackMinor,
              corrosionMinor: leftTailLightAssemblyCorrosionMinor,
              corrosionMajor: leftTailLightAssemblyCrackMajor,
              bendDentMajor: leftTailLightAssemblyBendDentMajor,
              punchesOpenRepaired: leftTailLightAssemblyPunchesOpenRepaired,
              repainted: leftTailLightAssemblyRepainted,
              hammerRepairedMajor: leftTailLightAssemblyHammerRepairedMajor,
              hammerRepairedMinor: leftTailLightAssemblyHammerRepairedMinor,
              wrapping: leftTailLightAssemblyWrapping,
              scratchesMinor: leftTailLightAssemblyScratchesMinor,
              scratchesMajor: leftTailLightAssemblyScratchesMajor,
              paintMismatch: leftTailLightAssemblyPaintMisMatch,
            ),
            rearBumperPanel: Interior2Common(
              images: selectedRearBumperPanelImage,
              replaced: rearBumperPanelReplaced,
              crackMajor: rearBumperPanelCrackMajor,
              crackMinor: rearBumperPanelCrackMinor,
              corrosionMinor: rearBumperPanelCorrosionMinor,
              corrosionMajor: rearBumperPanelCrackMajor,
              bendDentMajor: rearBumperPanelBendDentMajor,
              punchesOpenRepaired: rearBumperPanelPunchesOpenRepaired,
              repainted: rearBumperPanelRepainted,
              hammerRepairedMajor: rearBumperPanelHammerRepairedMajor,
              hammerRepairedMinor: rearBumperPanelHammerRepairedMinor,
              wrapping: rearBumperPanelWrapping,
              scratchesMinor: rearBumperPanelScratchesMinor,
              scratchesMajor: rearBumperPanelScratchesMajor,
              paintMismatch: rearBumperPanelPaintMisMatch,
            ),
            rearRegistrationPlate: Interior2Common(
              images: selectedRearRegistrationPlateImage,
              replaced: rearRegistrationPlateReplaced,
              crackMajor: rearRegistrationPlateCrackMajor,
              crackMinor: rearRegistrationPlateCrackMinor,
              corrosionMinor: rearRegistrationPlateCorrosionMinor,
              corrosionMajor: rearRegistrationPlateCrackMajor,
              bendDentMajor: rearRegistrationPlateBendDentMajor,
              punchesOpenRepaired: rearRegistrationPlatePunchesOpenRepaired,
              repainted: rearRegistrationPlateRepainted,
              hammerRepairedMajor: rearRegistrationPlateHammerRepairedMajor,
              hammerRepairedMinor: rearRegistrationPlateHammerRepairedMinor,
              wrapping: rearRegistrationPlateWrapping,
              scratchesMinor: rearRegistrationPlateScratchesMinor,
              scratchesMajor: rearRegistrationPlateScratchesMajor,
              paintMismatch: rearRegistrationPlatePaintMisMatch,
            ),
            rearWindshieldGlass: Interior2Common(
              images: selectedRearWindshieldGlassImage,
              replaced: rearWindshieldGlassReplaced,
              crackMajor: rearWindshieldGlassCrackMajor,
              crackMinor: rearWindshieldGlassCrackMinor,
              corrosionMinor: rearWindshieldGlassCorrosionMinor,
              corrosionMajor: rearWindshieldGlassCrackMajor,
              bendDentMajor: rearWindshieldGlassBendDentMajor,
              punchesOpenRepaired: rearWindshieldGlassPunchesOpenRepaired,
              repainted: rearWindshieldGlassRepainted,
              hammerRepairedMajor: rearWindshieldGlassHammerRepairedMajor,
              hammerRepairedMinor: rearWindshieldGlassHammerRepairedMinor,
              wrapping: rearWindshieldGlassWrapping,
              scratchesMinor: rearWindshieldGlassScratchesMinor,
              scratchesMajor: rearWindshieldGlassScratchesMajor,
              paintMismatch: rearWindshieldGlassPaintMisMatch,
            ),
            rightTailLightAssembly: Interior2Common(
              images: selectedRightTailLightAssemblyImage,
              replaced: rightTailLightAssemblyReplaced,
              crackMajor: rightTailLightAssemblyCrackMajor,
              crackMinor: rightTailLightAssemblyCrackMinor,
              corrosionMinor: rightTailLightAssemblyCorrosionMinor,
              corrosionMajor: rightTailLightAssemblyCrackMajor,
              bendDentMajor: rightTailLightAssemblyBendDentMajor,
              punchesOpenRepaired: rightTailLightAssemblyPunchesOpenRepaired,
              repainted: rightTailLightAssemblyRepainted,
              hammerRepairedMajor: rightTailLightAssemblyHammerRepairedMajor,
              hammerRepairedMinor: rightTailLightAssemblyHammerRepairedMinor,
              wrapping: rightTailLightAssemblyWrapping,
              scratchesMinor: rightTailLightAssemblyScratchesMinor,
              scratchesMajor: rightTailLightAssemblyScratchesMajor,
              paintMismatch: rightTailLightAssemblyPaintMisMatch,
            ),
          ),
          roofStructureAndRoot: RoofStructureAndRoot(
              dickeyBackPanel: FrontLeftExterior(
                images: selectedDickeyBackPanelImage,
                hammerRepairedMinor: dickeyBackPanelHammerRepairedMinor,
                hammerRepairedMajor: dickeyBackPanelHammerRepairedMajor,
                replaced: dickeyBackPanelReplaced,
                crackMajor: dickeyBackPanelCrackMajor,
                crackMinor: dickeyBackPanelCrackMinor,
                corrosionMinor: dickeyBackPanelCorrosionMinor,
                corrosionMajor: dickeyBackPanelCrackMajor,
                bendDentMajor: dickeyBackPanelBendDentMajor,
                bendDentMinor: dickeyBackPanelBendDentMinor,
                punchesOpenRepaired: dickeyBackPanelPunchesOpenRepaired,
              ),
              dickeyFloor: FrontLeftExterior(
                images: selectedDickeyFloorImage,
                hammerRepairedMinor: dickeyFloorHammerRepairedMinor,
                hammerRepairedMajor: dickeyFloorHammerRepairedMajor,
                replaced: dickeyFloorReplaced,
                crackMajor: dickeyFloorCrackMajor,
                crackMinor: dickeyFloorCrackMinor,
                corrosionMinor: dickeyFloorCorrosionMinor,
                corrosionMajor: dickeyFloorCrackMajor,
                bendDentMajor: dickeyFloorBendDentMajor,
                bendDentMinor: dickeyFloorBendDentMinor,
                punchesOpenRepaired: dickeyFloorPunchesOpenRepaired,
              ),
              dickeyLeftLeg: FrontLeftExterior(
                images: selectedDickeyLeftLegImage,
                hammerRepairedMinor: dickeyLeftLegHammerRepairedMinor,
                hammerRepairedMajor: dickeyLeftLegHammerRepairedMajor,
                replaced: dickeyLeftLegReplaced,
                repaired: dickeyLeftLegRepaired,
                crackMajor: dickeyLeftLegCrackMajor,
                crackMinor: dickeyLeftLegCrackMinor,
                corrosionMinor: dickeyLeftLegCorrosionMinor,
                corrosionMajor: dickeyLeftLegCrackMajor,
                bendDentMajor: dickeyLeftLegBendDentMajor,
                bendDentMinor: dickeyLeftLegBendDentMinor,
                punchesOpenRepaired: dickeyLeftLegPunchesOpenRepaired,
              ),
              dickeyRightLeg: FrontLeftExterior(
                images: selectedDickeyRightLegImage,
                hammerRepairedMinor: dickeyRightLegHammerRepairedMinor,
                hammerRepairedMajor: dickeyRightLegHammerRepairedMajor,
                replaced: dickeyRightLegReplaced,
                repaired: dickeyRightLegRepaired,
                crackMajor: dickeyRightLegCrackMajor,
                crackMinor: dickeyRightLegCrackMinor,
                corrosionMinor: dickeyRightLegCorrosionMinor,
                corrosionMajor: dickeyRightLegCrackMajor,
                bendDentMajor: dickeyRightLegBendDentMajor,
                bendDentMinor: dickeyRightLegBendDentMinor,
                punchesOpenRepaired: dickeyRightLegPunchesOpenRepaired,
              ),
              dickeySidewalls: DickeySidewalls(
                leftDickeySidewall: FrontLeftExterior(
                  images: selectedLeftDickeySidewallImage,
                  sealantMissingCrackRepaired:
                      leftDickeySidewallSealantMissingCrackRepaired,
                  replaced: leftDickeySidewallReplaced,
                  crackMajor: leftDickeySidewallCrackMajor,
                  crackMinor: leftDickeySidewallCrackMinor,
                  corrosionMinor: leftDickeySidewallCorrosionMinor,
                  corrosionMajor: leftDickeySidewallCrackMajor,
                  bendDentMajor: leftDickeySidewallBendDentMajor,
                  bendDentMinor: leftDickeySidewallBendDentMinor,
                  punchesOpenRepaired: leftDickeySidewallPunchesOpenRepaired,
                ),
                rightDickeySidewall: FrontLeftExterior(
                  images: selectedRightDickeySidewallImage,
                  replaced: rightDickeySidewallReplaced,
                  sealantMissingCrackRepaired:
                      rightDickeySidewallSealantMissingCrackRepaired,
                  crackMajor: rightDickeySidewallCrackMajor,
                  crackMinor: rightDickeySidewallCrackMinor,
                  corrosionMinor: rightDickeySidewallCorrosionMinor,
                  corrosionMajor: rightDickeySidewallCrackMajor,
                  bendDentMajor: rightDickeySidewallBendDentMajor,
                  bendDentMinor: rightDickeySidewallBendDentMinor,
                  punchesOpenRepaired: rightDickeySidewallPunchesOpenRepaired,
                ),
              ),
              dickeyStrutTowers: DickeyStrutTowers(
                leftDickeyStrutTower: FrontLeftExterior(
                  images: selectedLeftDickeyStrutTowerImage,
                  sealantMissingCrackRepaired:
                      leftDickeyStrutTowerSealantMissingCrackRepaired,
                  replaced: leftDickeyStrutTowerReplaced,
                  crackMajor: leftDickeyStrutTowerCrackMajor,
                  crackMinor: leftDickeyStrutTowerCrackMinor,
                  corrosionMinor: leftDickeyStrutTowerCorrosionMinor,
                  corrosionMajor: leftDickeyStrutTowerCrackMajor,
                  bendDentMajor: leftDickeyStrutTowerBendDentMajor,
                  bendDentMinor: leftDickeyStrutTowerBendDentMinor,
                  punchesOpenRepaired: leftDickeyStrutTowerPunchesOpenRepaired,
                ),
                rightDickeyStrutTower: FrontLeftExterior(
                  images: selectedRightDickeyStrutTowerImage,
                  sealantMissingCrackRepaired:
                      rightDickeyStrutTowerSealantMissingCrackRepaired,
                  replaced: rightDickeyStrutTowerReplaced,
                  crackMajor: rightDickeyStrutTowerCrackMajor,
                  crackMinor: rightDickeyStrutTowerCrackMinor,
                  corrosionMinor: rightDickeyStrutTowerCorrosionMinor,
                  corrosionMajor: rightDickeyStrutTowerCrackMajor,
                  bendDentMajor: rightDickeyStrutTowerBendDentMajor,
                  bendDentMinor: rightDickeyStrutTowerBendDentMinor,
                  punchesOpenRepaired: rightDickeyStrutTowerPunchesOpenRepaired,
                ),
              ),
              roofPanel: RoofPanel(
                images: selectedRoofPanelImage,
                replaced: roofPanelReplaced,
                repaired: roofPanelRepaired,
                wrapping: roofPanelWrapping,
                paintDefective: roofPanelPaintMisMatch,
                corrosionMinor: roofPanelCorrosionMinor,
                corrosionMajor: roofPanelCorrosionMajor,
                repainted: roofPanelRepainted,
                paintMismatch: roofPanelPaintMisMatch,
                scratchesMinor: roofPanelScratchesMinor,
                scratchesMajor: roofPanelScratchesMajor,
                sealantMissing: roofPanelSealantMissing,
                multipleDentsDentMajor: roofPanelMultipleDentsDentMajor,
                multipleDentsDentMinor: roofPanelMultipleDentsDentMinor,
                aftermarketSunroofFitment: roofPanelAftermarketSunroofFitment,
                externalHoleTear: roofPanelExternalHoleTear,
                aftermarketDualTonePaint: roofPanelAftermarketDualTonePaint,
              ),
              spareTyreAssembly: SpareTyreAssembly(
                images: selectedSpareTyreAssemblyImage,
                spareTyreAvailable: spareTyreAvailable,
              )),
        ),
        rightSide: RightSide(
          frontRightExterior: FrontRightExterior(
            frontRightDoorPanel: FrontLeftExterior(
              images: selectedFrontRightDoorPanelImage,
              replaced: frontRightDoorPanelReplaced,
              repaired: frontRightDoorPanelRepaired,
              crackMajor: frontRightDoorPanelCrackMajor,
              crackMinor: frontRightDoorPanelCrackMinor,
              corrosionMinor: frontRightDoorPanelCorrosionMinor,
              corrosionMajor: frontRightDoorPanelCrackMajor,
              bendDentMajor: frontRightDoorPanelBendDentMajor,
              bendDentMinor: frontRightDoorPanelBendDentMinor,
              punchesOpenRepaired: frontRightDoorPanelPunchesOpenRepaired,
            ),
            rightFenderLining: FrontLeftExterior(
              images: selectedRightFenderLiningImage,
              replaced: rightFenderLiningReplaced,
              repaired: rightFenderLiningRepaired,
              crackMajor: rightFenderLiningCrackMajor,
              crackMinor: rightFenderLiningCrackMinor,
              corrosionMinor: rightFenderLiningCorrosionMinor,
              corrosionMajor: rightFenderLiningCrackMajor,
              bendDentMajor: rightFenderLiningBendDentMajor,
              bendDentMinor: rightFenderLiningBendDentMinor,
              punchesOpenRepaired: rightFenderLiningPunchesOpenRepaired,
            ),
            rightFenderPanel: FrontLeftExterior(
              images: selectedRightFenderPanelImage,
              replaced: rightFenderPanelReplaced,
              repaired: rightFenderPanelRepaired,
              crackMajor: rightFenderPanelCrackMajor,
              crackMinor: rightFenderPanelCrackMinor,
              corrosionMinor: rightFenderPanelCorrosionMinor,
              corrosionMajor: rightFenderPanelCrackMajor,
              bendDentMajor: rightFenderPanelBendDentMajor,
              bendDentMinor: rightFenderPanelBendDentMinor,
              punchesOpenRepaired: rightFenderPanelPunchesOpenRepaired,
            ),
            rightSvmAssembly: FrontLeftExterior(
              images: selectedRightSvmAssemblyImage,
              replaced: rightSvmAssemblyReplaced,
              repaired: rightSvmAssemblyRepaired,
              crackMajor: rightSvmAssemblyCrackMajor,
              crackMinor: rightSvmAssemblyCrackMinor,
              corrosionMinor: rightSvmAssemblyCorrosionMinor,
              corrosionMajor: rightSvmAssemblyCrackMajor,
              bendDentMajor: rightSvmAssemblyBendDentMajor,
              bendDentMinor: rightSvmAssemblyBendDentMinor,
              punchesOpenRepaired: rightSvmAssemblyPunchesOpenRepaired,
            ),
          ),
          frontRightMechanical: FrontRightMechanical(
            exhaustSystem: frontRightMechanicalExhaustSystem,
            fourWheelDrive: FrontLeftExterior(
              images: selectedFourWheelDriveImage,
              replaced: fourWheelDriveReplaced,
              repaired: fourWheelDriveRepaired,
              crackMajor: fourWheelDriveCrackMajor,
              crackMinor: fourWheelDriveCrackMinor,
              corrosionMinor: fourWheelDriveCorrosionMinor,
              corrosionMajor: fourWheelDriveCrackMajor,
              bendDentMajor: fourWheelDriveBendDentMajor,
              bendDentMinor: fourWheelDriveBendDentMinor,
              punchesOpenRepaired: fourWheelDrivePunchesOpenRepaired,
            ),
            frontRightBrakeAssembly: FrontLeftExterior(
              images: selectedFrontRightBrakeAssemblyImage,
              replaced: frontRightBrakeAssemblyReplaced,
              repaired: frontRightBrakeAssemblyRepaired,
              crackMajor: frontRightBrakeAssemblyCrackMajor,
              crackMinor: frontRightBrakeAssemblyCrackMinor,
              corrosionMinor: frontRightBrakeAssemblyCorrosionMinor,
              corrosionMajor: frontRightBrakeAssemblyCrackMajor,
              bendDentMajor: frontRightBrakeAssemblyBendDentMajor,
              bendDentMinor: frontRightBrakeAssemblyBendDentMinor,
              punchesOpenRepaired: frontRightBrakeAssemblyPunchesOpenRepaired,
            ),
            frontRightSuspension: FrontRightSuspension(
              frontJumpingRodAssembly:
                  frontRightSuspensionFrontJumpingRodAssembly,
              frontRightLinkRod: frontRightSuspensionFrontRightLinkRod,
              frontRightLowerControlArmAssembly:
                  frontRightSuspensionFrontRightLowerControlArmAssembly,
              frontRightStrutAssembly:
                  frontRightSuspensionFrontRightStrutAssembly,
            ),
            frontRightTyreAssembly: FrontLeftExterior(
              images: selectedFrontRightTyreAssemblyImage,
              replaced: frontRightTyreAssemblyReplaced,
              repaired: frontRightTyreAssemblyRepaired,
              crackMajor: frontRightTyreAssemblyCrackMajor,
              crackMinor: frontRightTyreAssemblyCrackMinor,
              corrosionMinor: frontRightTyreAssemblyCorrosionMinor,
              corrosionMajor: frontRightTyreAssemblyCrackMajor,
              bendDentMajor: frontRightTyreAssemblyBendDentMajor,
              bendDentMinor: frontRightTyreAssemblyBendDentMinor,
              punchesOpenRepaired: frontRightTyreAssemblyPunchesOpenRepaired,
            ),
            frontWheelDrive: FrontLeftExterior(
              images: selectedFrontWheelDriveImage,
              replaced: frontWheelDriveReplaced,
              repaired: frontWheelDriveRepaired,
              crackMajor: frontWheelDriveCrackMajor,
              crackMinor: frontWheelDriveCrackMinor,
              corrosionMinor: frontWheelDriveCorrosionMinor,
              corrosionMajor: frontWheelDriveCrackMajor,
              bendDentMajor: frontWheelDriveBendDentMajor,
              bendDentMinor: frontWheelDriveBendDentMinor,
              punchesOpenRepaired: frontWheelDrivePunchesOpenRepaired,
            ),
          ),
          rearRightStructure: RearRightStructure(
            rearRightDoorChannel: Interior2Common(
              images: selectedRearRightDoorChannelImage,
              replaced: rearRightDoorChannelReplaced,
              crackMajor: rearRightDoorChannelCrackMajor,
              crackMinor: rearRightDoorChannelCrackMinor,
              corrosionMinor: rearRightDoorChannelCorrosionMinor,
              corrosionMajor: rearRightDoorChannelCrackMajor,
              bendDentMajor: rearRightDoorChannelBendDentMajor,
              punchesOpenRepaired: rearRightDoorChannelPunchesOpenRepaired,
              repainted: rearRightDoorChannelRepainted,
              hammerRepairedMajor: rearRightDoorChannelHammerRepairedMajor,
              hammerRepairedMinor: rearRightDoorChannelHammerRepairedMinor,
              wrapping: rearRightDoorChannelWrapping,
              scratchesMinor: rearRightDoorChannelScratchesMinor,
              scratchesMajor: rearRightDoorChannelScratchesMajor,
              paintMismatch: rearRightDoorChannelPaintMisMatch,
            ),
            rearRightFloorPan: Interior2Common(
              images: selectedRearRightFloorPanImage,
              replaced: rearRightFloorPanReplaced,
              crackMajor: rearRightFloorPanCrackMajor,
              crackMinor: rearRightFloorPanCrackMinor,
              corrosionMinor: rearRightFloorPanCorrosionMinor,
              corrosionMajor: rearRightFloorPanCrackMajor,
              bendDentMajor: rearRightFloorPanBendDentMajor,
              punchesOpenRepaired: rearRightFloorPanPunchesOpenRepaired,
              repainted: rearRightFloorPanRepainted,
              hammerRepairedMajor: rearRightFloorPanHammerRepairedMajor,
              hammerRepairedMinor: rearRightFloorPanHammerRepairedMinor,
              wrapping: rearRightFloorPanWrapping,
              scratchesMinor: rearRightFloorPanScratchesMinor,
              scratchesMajor: rearRightFloorPanScratchesMajor,
              paintMismatch: rearRightFloorPanPaintMisMatch,
            ),
            rearRightWheelHouse: Interior2Common(
              images: selectedRearRightWheelHouseImage,
              replaced: rearRightWheelHouseReplaced,
              crackMajor: rearRightWheelHouseCrackMajor,
              crackMinor: rearRightWheelHouseCrackMinor,
              corrosionMinor: rearRightWheelHouseCorrosionMinor,
              corrosionMajor: rearRightWheelHouseCrackMajor,
              bendDentMajor: rearRightWheelHouseBendDentMajor,
              punchesOpenRepaired: rearRightWheelHousePunchesOpenRepaired,
              repainted: rearRightWheelHouseRepainted,
              hammerRepairedMajor: rearRightWheelHouseHammerRepairedMajor,
              hammerRepairedMinor: rearRightWheelHouseHammerRepairedMinor,
              wrapping: rearRightWheelHouseWrapping,
              scratchesMinor: rearRightWheelHouseScratchesMinor,
              scratchesMajor: rearRightWheelHouseScratchesMajor,
              paintMismatch: rearRightWheelHousePaintMisMatch,
            ),
            rightFloorPanChannel: Interior2Common(
              images: selectedRightFloorPanChannelImage,
              replaced: rightFloorPanChannelReplaced,
              crackMajor: rightFloorPanChannelCrackMajor,
              crackMinor: rightFloorPanChannelCrackMinor,
              corrosionMinor: rightFloorPanChannelCorrosionMinor,
              corrosionMajor: rightFloorPanChannelCrackMajor,
              bendDentMajor: rightFloorPanChannelBendDentMajor,
              punchesOpenRepaired: rightFloorPanChannelPunchesOpenRepaired,
              repainted: rightFloorPanChannelRepainted,
              hammerRepairedMajor: rightFloorPanChannelHammerRepairedMajor,
              hammerRepairedMinor: rightFloorPanChannelHammerRepairedMinor,
              wrapping: rightFloorPanChannelWrapping,
              scratchesMinor: rightFloorPanChannelScratchesMinor,
              scratchesMajor: rightFloorPanChannelScratchesMajor,
              paintMismatch: rightFloorPanChannelPaintMisMatch,
            ),
            rightPillarB: Interior2Common(
              images: selectedRightPillarBImage,
              replaced: rightPillarBReplaced,
              crackMajor: rightPillarBCrackMajor,
              crackMinor: rightPillarBCrackMinor,
              corrosionMinor: rightPillarBCorrosionMinor,
              corrosionMajor: rightPillarBCrackMajor,
              bendDentMajor: rightPillarBBendDentMajor,
              punchesOpenRepaired: rightPillarBPunchesOpenRepaired,
              repainted: rightPillarBRepainted,
              hammerRepairedMajor: rightPillarBHammerRepairedMajor,
              hammerRepairedMinor: rightPillarBHammerRepairedMinor,
              wrapping: rightPillarBWrapping,
              scratchesMinor: rightPillarBScratchesMinor,
              scratchesMajor: rightPillarBScratchesMajor,
              paintMismatch: rightPillarBPaintMisMatch,
            ),
            rightPillarC: Interior2Common(
              images: selectedRightPillarCImage,
              replaced: rightPillarCReplaced,
              crackMajor: rightPillarCCrackMajor,
              crackMinor: rightPillarCCrackMinor,
              corrosionMinor: rightPillarCCorrosionMinor,
              corrosionMajor: rightPillarCCrackMajor,
              bendDentMajor: rightPillarCBendDentMajor,
              punchesOpenRepaired: rightPillarCPunchesOpenRepaired,
              repainted: rightPillarCRepainted,
              hammerRepairedMajor: rightPillarCHammerRepairedMajor,
              hammerRepairedMinor: rightPillarCHammerRepairedMinor,
              wrapping: rightPillarCWrapping,
              scratchesMinor: rightPillarCScratchesMinor,
              scratchesMajor: rightPillarCScratchesMajor,
              paintMismatch: rightPillarCPaintMisMatch,
            ),
            rightRunningBoard: TRunningBoard(
              images: selectedRightRunningBoardImage,
              replaced: rightRunningBoardReplaced,
              repainted: rightRunningBoardRepainted,
              corrosionMinor: rightRunningBoardCorrosionMinor,
              corrosionMajor: rightRunningBoardCorrosionMajor,
              punchesOpenRepaired: rightRunningBoardPunchesOpenRepaired,
              paintMismatch: rightRunningBoardPaintMisMatch,
              paintDefective: rightRunningBoardPaintDefective,
              crack: rightRunningBoardCrack,
            ),
          ),
          rightRightMechanical: Interior2Common(
            images: selectedRightMechanicalImage,
            replaced: rightMechanicalReplaced,
            crackMajor: rightMechanicalCrackMajor,
            crackMinor: rightMechanicalCrackMinor,
            corrosionMinor: rightMechanicalCorrosionMinor,
            corrosionMajor: rightMechanicalCrackMajor,
            bendDentMajor: rightMechanicalBendDentMajor,
            punchesOpenRepaired: rightMechanicalPunchesOpenRepaired,
            repainted: rightMechanicalRepainted,
            hammerRepairedMajor: rightMechanicalHammerRepairedMajor,
            hammerRepairedMinor: rightMechanicalHammerRepairedMinor,
            wrapping: rightMechanicalWrapping,
            scratchesMinor: rightMechanicalScratchesMinor,
            scratchesMajor: rightMechanicalScratchesMajor,
            paintMismatch: rightMechanicalPaintMisMatch,
          ),
        ),
        testDrive: TestDrive(
          steeringHealth: testDriveSteeringHealth,
          accelerateToCheckClutch: AccelerateToCheckClutch(
            clutchPedalVibration: testDriveClutchPedalVibration,
            noiseFromTurbocharger: testDriveNoiseFromTurbocharger,
          ),
          applyBrakesTillCarStop: ApplyBrakesTillCarStop(
            frontBrakeNoiseVibration: testDriveFrontBrakeNoiseVibration,
            idleStartStopNotWorking: testDriveIdleStartStopNotWorking,
            rearBrakeNoiseVibration: testDriveRearBrakeNoiseVibration,
          ),
        ),
      ),
    );
    // Prepare the data from newCarDoc
    // Assuming newCarDoc is an object with a toMap method to convert it to a Map
    Map<String, dynamic> requestBody = newCarDoc.toMap();
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Specify the content type
        },
        body: jsonEncode(requestBody), // Encode the Map to JSON
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Successfully sent the data
        print('Data sent successfully: ${response.body}');
      } else {
        // Handle the error response
        print('Failed to send data: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions
      print('Error occurred: $error');
    }
  }

  // void _saveCarInspection() async {
  //   DatabaseReference carAuctionRef =
  //       FirebaseDatabase.instance.ref('car_auction');
  //   await engineRatingCheck();
  //   num engineRatingValue = 0.0;
  //   num carPrice = _carFairPriceController.text.isEmpty
  //       ? num.parse(widget.carDetails.car_price.toString())
  //       : num.parse(_carFairPriceController.text);
  //   setState(() {
  //     var trueBool = engineRating.where(
  //       (element) => element == true,
  //     );
  //     engineRatingValue = (trueBool.length * 5) / 14;
  //   });

  //   final DateTime newStartTime = DateTime.now();
  //   final DateTime newEndTime = newStartTime.add(const Duration(hours: 2));

  //   final newCarDoc = CarDetails(
  //     serialNumber: widget.carDetails.serialNumber,
  //     reMarks: _reMarksController.text,
  //     carDoc: carDoc,
  //     carHealth: CarHealth(
  //       battery: Battery(
  //         aftermarketFitment: battryAfterMarketFitment,
  //         damaged: battryDamaged,
  //         leakage: battryLeakage,
  //         wrongSize: battryWrongSize,
  //         images: selectedBatteryImage,
  //       ),
  //       engine: Engine(
  //         staticEngineOn: StaticEngineOn(
  //           checkForAtGearBoxLeakages: CheckForAtGearBoxLeakages(
  //             leakageFromAtGearboxHousing: leakageFromAtGearboxHousing,
  //             leakageFromAtInputShaft: leakageFromAtInputShaft,
  //           ),
  //           checkForEngineLeakages: CheckForEngineLeakages(
  //             leakageFromEngineBlock: leakageFromEngineBlock,
  //             leakageFromExhaustManifold: leakageFromExhaustManifold,
  //             leakageFromTurbocharger: leakageFromTurbocharger,
  //             leakgeFromMetalTiming: leakageFromMetalTiming,
  //             seepageFromEngineTiming: seepageFromEngineTiming,
  //           ),
  //           checkForEnginePerformances: CheckForEnginePerformances(
  //             backCompressionInEngine: backCompressionInEngine,
  //             overheaingDueToRadiatorSystem: overheaingDueToRadiatorSystem,
  //             overheatingInEngine: overheatingInEngine,
  //           ),
  //           checkForManualGearBoxLeakages: CheckForManualGearBoxLeakages(
  //             leakageFrom5ThGearHousing: leakageFrom5ThGearHousing,
  //             leakageFromDriveAxle: leakageFromDriveAxle,
  //             leakageFromMtGearboxHousing: leakageFromMtGearboxHousing,
  //             leakageFromMtInputShaft: leakageFromMtInputShaft,
  //           ),
  //           videos: Videos(
  //             engineNoiseVideo: '',
  //             testDriveVideo: '',
  //           ),
  //         ),
  //       ),
  //       extra: Extra(
  //         extraParts: extraParts.text,
  //       ),
  //       frontSide: FrontSide(
  //         frontExterior1: FrontExterior1(
  //           bonnetPanel: BonnetPanel(
  //             images: selectedBonnetImage,
  //             alignmentOut: bonnetAlignmentOut,
  //             corrosionMajor: bonnetCorrosionMajor,
  //             corrosionMinor: bonnetCorrosionMinor,
  //             paintDefective: bonnetPaintDefective,
  //             repainted: bonnetRepainted,
  //             replaced: bonnetReplaced,
  //           ),
  //           carKey: CarKey(
  //             images: selectedCarKeyImage,
  //             damagedMajor: carKeyDamagedMajor,
  //             damagedMinor: carKeyDamagedMinor,
  //             noFreeMovement: carKeyNoFreeMovement,
  //             oneKeyMissing: carKeyOneKeyMissing,
  //           ),
  //           centralLockingRemoteHousing: CarKey(
  //             images: selectedCentralLockingRemoteHousingImage,
  //             damagedMajor: centralLockingRemoteHousingDamagedMajor,
  //             damagedMinor: centralLockingRemoteHousingDamagedMinor,
  //             noFreeMovement: centralLockingRemoteHousingNoFreeMovement,
  //             oneKeyMissing: centralLockingRemoteHousingOneKeyMissing,
  //           ),
  //           frontBumperGrill: FrontBumperGrill(
  //             images: selectedFrontBumperGrillImage,
  //             crackMajor: frontBumperGrillCrackMajor,
  //             crackMinor: frontBumperGrillCrackMinor,
  //             repaired: frontBumperGrillRepaired,
  //             scratchesMajor: frontBumperGrillScratchesMajor,
  //             scratchesMinor: frontBumperGrillScratchesMajor,
  //           ),
  //           frontBumperPanel: FrontBumperPanel(
  //             images: selectedFrontBumperPanelImage,
  //             repainted: frontBumperPanelRepainted,
  //             paintDefective: frontBumperPanelPaintDefective,
  //             wrapping: frontBumperPanelWrapping,
  //             tabLocksScrewRepaired: frontBumperPanelTabLocksScrewRepaired,
  //             partMissing: frontBumperPanelPartMissing,
  //           ),
  //           frontRegistrationPlate: FrontRegistrationPlate(
  //             images: selectedFrontRegistrationPlateImage,
  //             damagedMinor: frontRegistrationPlateDamagedMinor,
  //             damagedMajor: frontRegistrationPlateDamagedMajor,
  //             aftermarketFitment: frontRegistrationPlateAftermarketFitment,
  //             partMissing: frontRegistrationPlatePartMissing,
  //           ),
  //         ),
  //         frontExterior2: FrontExterior2(
  //           frontLeftFogLightHousing: FrontLeftExterior(
  //             images: selectedFrontLeftFogLightHousingImage,
  //             repaired: frontLeftFogLightHousingRepaired,
  //             replaced: frontLeftFogLightHousingReplaced,
  //             crackMajor: frontLeftFogLightHousingCrackMajor,
  //             crackMinor: frontLeftFogLightHousingCrackMinor,
  //             corrosionMinor: frontLeftFogLightHousingCorrosionMinor,
  //             corrosionMajor: frontLeftFogLightHousingCrackMajor,
  //             bendDentMajor: frontLeftFogLightHousingBendDentMajor,
  //             bendDentMinor: frontLeftFogLightHousingBendDentMinor,
  //             punchesOpenRepaired: frontLeftFogLightHousingPunchesOpenRepaired,
  //           ),
  //           frontRightFogLightHousing: FrontLeftExterior(
  //             images: selectedFrontRightFogLightHousingImage,
  //             repaired: frontRightFogLightHousingRepaired,
  //             replaced: frontRightFogLightHousingReplaced,
  //             crackMajor: frontRightFogLightHousingCrackMajor,
  //             crackMinor: frontRightFogLightHousingCrackMinor,
  //             corrosionMinor: frontRightFogLightHousingCorrosionMinor,
  //             corrosionMajor: frontRightFogLightHousingCrackMajor,
  //             bendDentMajor: frontRightFogLightHousingBendDentMajor,
  //             bendDentMinor: frontRightFogLightHousingBendDentMinor,
  //             punchesOpenRepaired: frontRightFogLightHousingPunchesOpenRepaired,
  //           ),
  //           leftDrl: FrontLeftExterior(
  //             images: selectedLeftDrlImage,
  //             repaired: leftDrlRepaired,
  //             replaced: leftDrlReplaced,
  //             crackMajor: leftDrlCrackMajor,
  //             crackMinor: leftDrlCrackMinor,
  //             corrosionMinor: leftDrlCorrosionMinor,
  //             corrosionMajor: leftDrlCrackMajor,
  //             bendDentMajor: leftDrlBendDentMajor,
  //             bendDentMinor: leftDrlBendDentMinor,
  //             punchesOpenRepaired: leftDrlPunchesOpenRepaired,
  //           ),
  //           leftHeadlightAssembly: FrontLeftExterior(
  //             images: selectedLeftHeadlightAssemblyImage,
  //             repaired: leftHeadlightAssemblyRepaired,
  //             replaced: leftHeadlightAssemblyReplaced,
  //             crackMajor: leftHeadlightAssemblyCrackMajor,
  //             crackMinor: leftHeadlightAssemblyCrackMinor,
  //             corrosionMinor: leftHeadlightAssemblyCorrosionMinor,
  //             corrosionMajor: leftHeadlightAssemblyCrackMajor,
  //             bendDentMajor: leftHeadlightAssemblyBendDentMajor,
  //             bendDentMinor: leftHeadlightAssemblyBendDentMinor,
  //             punchesOpenRepaired: leftHeadlightAssemblyPunchesOpenRepaired,
  //           ),
  //           leftHeadlightHousing: FrontLeftExterior(
  //             images: selectedLeftHeadlightHousingImage,
  //             repaired: leftHeadlightHousingRepaired,
  //             replaced: leftHeadlightHousingReplaced,
  //             crackMajor: leftHeadlightHousingCrackMajor,
  //             crackMinor: leftHeadlightHousingCrackMinor,
  //             corrosionMinor: leftHeadlightHousingCorrosionMinor,
  //             corrosionMajor: leftHeadlightHousingCrackMajor,
  //             bendDentMajor: leftHeadlightHousingBendDentMajor,
  //             bendDentMinor: leftHeadlightHousingBendDentMinor,
  //             punchesOpenRepaired: leftHeadlightHousingPunchesOpenRepaired,
  //           ),
  //           rightDrl: FrontLeftExterior(
  //             images: selectedRightDrlImage,
  //             repaired: rightDrlRepaired,
  //             replaced: rightDrlReplaced,
  //             crackMajor: rightDrlCrackMajor,
  //             crackMinor: rightDrlCrackMinor,
  //             corrosionMinor: rightDrlCorrosionMinor,
  //             corrosionMajor: rightDrlCrackMajor,
  //             bendDentMajor: rightDrlBendDentMajor,
  //             bendDentMinor: rightDrlBendDentMinor,
  //             punchesOpenRepaired: rightDrlPunchesOpenRepaired,
  //           ),
  //           rightHeadlightAssembly: FrontLeftExterior(
  //             images: selectedRightHeadlightAssemblyImage,
  //             repaired: rightHeadlightAssemblyRepaired,
  //             replaced: rightHeadlightAssemblyReplaced,
  //             crackMajor: rightHeadlightAssemblyCrackMajor,
  //             crackMinor: rightHeadlightAssemblyCrackMinor,
  //             corrosionMinor: rightHeadlightAssemblyCorrosionMinor,
  //             corrosionMajor: rightHeadlightAssemblyCrackMajor,
  //             bendDentMajor: rightHeadlightAssemblyBendDentMajor,
  //             bendDentMinor: rightHeadlightAssemblyBendDentMinor,
  //             punchesOpenRepaired: rightHeadlightAssemblyPunchesOpenRepaired,
  //           ),
  //           rightHeadlightHousing: FrontLeftExterior(
  //             images: selectedRightHeadlightHousingImage,
  //             repaired: rightHeadlightHousingRepaired,
  //             replaced: rightHeadlightHousingReplaced,
  //             crackMajor: rightHeadlightHousingCrackMajor,
  //             crackMinor: rightHeadlightHousingCrackMinor,
  //             corrosionMinor: rightHeadlightHousingCorrosionMinor,
  //             corrosionMajor: rightHeadlightHousingCrackMajor,
  //             bendDentMajor: rightHeadlightHousingBendDentMajor,
  //             bendDentMinor: rightHeadlightHousingBendDentMinor,
  //             punchesOpenRepaired: rightHeadlightHousingPunchesOpenRepaired,
  //           ),
  //         ),
  //         frontStructure1: FrontStructure1(
  //           boltedRadiatorSupport: EdRadiatorSupport(
  //             crackMajor: boltedRadiatorSupportCrackMajor,
  //             crackMinor: boltedRadiatorSupportCrackMinor,
  //             corrosionMinor: boltedRadiatorSupportCorrosionMinor,
  //             corrosionMajor: boltedRadiatorSupportCrackMajor,
  //             bendDentMajor: boltedRadiatorSupportBendDentMajor,
  //             bendDentMinor: boltedRadiatorSupportBendDentMinor,
  //           ),
  //           fibreRadiatorSupport: FibreRadiatorSupport(
  //             crackMajor: fibreRadiatorSupportCrackMajor,
  //             crackMinor: fibreRadiatorSupportCrackMinor,
  //             repaired: fibreRadiatorSupportRepaired,
  //           ),
  //           frontLeftLeg: FrontLeftExterior(
  //             images: selectedFrontLeftLegImage,
  //             repaired: frontLeftLegRepaired,
  //             replaced: frontLeftLegReplaced,
  //             crackMajor: frontLeftLegCrackMajor,
  //             crackMinor: frontLeftLegCrackMinor,
  //             corrosionMinor: frontLeftLegCorrosionMinor,
  //             corrosionMajor: frontLeftLegCrackMajor,
  //             bendDentMajor: frontLeftLegBendDentMajor,
  //             bendDentMinor: frontLeftLegBendDentMinor,
  //             punchesOpenRepaired: frontLeftLegPunchesOpenRepaired,
  //           ),
  //           frontRightLeft: FrontLeftExterior(
  //             images: selectedFrontRightLeftImage,
  //             repaired: frontRightLeftRepaired,
  //             replaced: frontRightLeftReplaced,
  //             crackMajor: frontRightLeftCrackMajor,
  //             crackMinor: frontRightLeftCrackMinor,
  //             corrosionMinor: frontRightLeftCorrosionMinor,
  //             corrosionMajor: frontRightLeftCrackMajor,
  //             bendDentMajor: frontRightLeftBendDentMajor,
  //             bendDentMinor: frontRightLeftBendDentMinor,
  //             punchesOpenRepaired: frontRightLeftPunchesOpenRepaired,
  //           ),
  //           weldedRadiatorSupport: EdRadiatorSupport(
  //             crackMajor: weldedRadiatorSupportCrackMajor,
  //             crackMinor: weldedRadiatorSupportCrackMinor,
  //             corrosionMinor: weldedRadiatorSupportCorrosionMinor,
  //             corrosionMajor: weldedRadiatorSupportCrackMajor,
  //             bendDentMajor: weldedRadiatorSupportBendDentMajor,
  //             bendDentMinor: weldedRadiatorSupportBendDentMinor,
  //           ),
  //         ),
  //       ),
  //       interior1: Interior1(
  //         acAssembly: AcAssembly(
  //           lessEffective: acAssemblyNoise,
  //           noise: acAssemblyNoise,
  //           notWorking: acAssemblyNotWorking,
  //         ),
  //         airbags: Airbags(
  //           driverSide: airBagsDriverSide,
  //           passengerSide: airBagsPassengerSide,
  //         ),
  //         clusterPanelAssembly: ClusterPanelAssembly(
  //           engineChecklight: clusterPanelAssemblyEngineCheckLight,
  //           absLight: clusterPanelAssemblyAbsLight,
  //           srsLight: clusterPanelAssemblySrsLight,
  //           automaticTransmissionLight:
  //               clusterPanelAssemblyAutomaticTransmissionLight,
  //           speedometer: clusterPanelAssemblySpeedometer,
  //           images: selectedClusterPanelAssemblyImage,
  //         ),
  //         dashboardAssembly: DashboardAssembly(
  //           acVent: Ac(
  //             working: dashboardAssemblyAcVentWorking,
  //             damaged: dashboardAssemblyAcVentDamaged,
  //             images: selectedDashboardAssemblyAcVentImage,
  //           ),
  //           acControls: Ac(
  //             working: dashboardAssemblyAcControlsWorking,
  //             damaged: dashboardAssemblyAcControlsDamaged,
  //             images: selectedDashboardAssemblyAcControlsImage,
  //           ),
  //         ),
  //         frontWindshieldGlass: FrontWindshieldGlass(
  //           crackMajor: frontWindshieldGlassCrackMajor,
  //           crackMinor: frontWindshieldGlassCrackMinor,
  //           scratchesMajor: frontWindshieldGlassScratchesMajor,
  //           scratchesMinor: frontWindshieldGlassScratchesMinor,
  //           images: selectedFrontWindshieldGlassImage,
  //         ),
  //         seats: Seats(
  //           damageMajor: seatsDamageMajor,
  //           damageMinor: seatsDamageMinor,
  //           aftermarketFitment: seatsAftermarketFitment,
  //           electronicSeat: seatsElectronicSeat,
  //           images: selectedSeatsImage,
  //         ),
  //       ),
  //       interior2: Interior2(
  //         audioStereoAssembly: Interior2Common(
  //           images: selectedAudioStereoAssemblyImage,
  //           replaced: audioStereoAssemblyReplaced,
  //           crackMajor: audioStereoAssemblyCrackMajor,
  //           crackMinor: audioStereoAssemblyCrackMinor,
  //           corrosionMinor: audioStereoAssemblyCorrosionMinor,
  //           corrosionMajor: audioStereoAssemblyCrackMajor,
  //           bendDentMajor: audioStereoAssemblyBendDentMajor,
  //           punchesOpenRepaired: audioStereoAssemblyPunchesOpenRepaired,
  //           repainted: audioStereoAssemblyRepainted,
  //           hammerRepairedMajor: audioStereoAssemblyHammerRepairedMajor,
  //           hammerRepairedMinor: audioStereoAssemblyHammerRepairedMinor,
  //           wrapping: audioStereoAssemblyWrapping,
  //           scratchesMinor: audioStereoAssemblyScratchesMinor,
  //           scratchesMajor: audioStereoAssemblyScratchesMajor,
  //           paintMismatch: audioStereoAssemblyPaintMisMatch,
  //         ),
  //         centreConsoleAssembly: Interior2Common(
  //           images: selectedCentreConsoleAssemblyImage,
  //           replaced: centreConsoleAssemblyReplaced,
  //           crackMajor: centreConsoleAssemblyCrackMajor,
  //           crackMinor: centreConsoleAssemblyCrackMinor,
  //           corrosionMinor: centreConsoleAssemblyCorrosionMinor,
  //           corrosionMajor: centreConsoleAssemblyCrackMajor,
  //           bendDentMajor: centreConsoleAssemblyBendDentMajor,
  //           punchesOpenRepaired: centreConsoleAssemblyPunchesOpenRepaired,
  //           repainted: centreConsoleAssemblyRepainted,
  //           hammerRepairedMajor: centreConsoleAssemblyHammerRepairedMajor,
  //           hammerRepairedMinor: centreConsoleAssemblyHammerRepairedMinor,
  //           wrapping: centreConsoleAssemblyWrapping,
  //           scratchesMinor: centreConsoleAssemblyScratchesMinor,
  //           scratchesMajor: centreConsoleAssemblyScratchesMajor,
  //           paintMismatch: centreConsoleAssemblyPaintMisMatch,
  //         ),
  //         forwardParkingSensors: Interior2Common(
  //           images: selectedForwardParkingSensorsImage,
  //           replaced: forwardParkingSensorsReplaced,
  //           crackMajor: forwardParkingSensorsCrackMajor,
  //           crackMinor: forwardParkingSensorsCrackMinor,
  //           corrosionMinor: forwardParkingSensorsCorrosionMinor,
  //           corrosionMajor: forwardParkingSensorsCrackMajor,
  //           bendDentMajor: forwardParkingSensorsBendDentMajor,
  //           punchesOpenRepaired: forwardParkingSensorsPunchesOpenRepaired,
  //           repainted: forwardParkingSensorsRepainted,
  //           hammerRepairedMajor: forwardParkingSensorsHammerRepairedMajor,
  //           hammerRepairedMinor: forwardParkingSensorsHammerRepairedMinor,
  //           wrapping: forwardParkingSensorsWrapping,
  //           scratchesMinor: forwardParkingSensorsScratchesMinor,
  //           scratchesMajor: forwardParkingSensorsScratchesMajor,
  //           paintMismatch: forwardParkingSensorsPaintMisMatch,
  //         ),
  //         frontLeftDoorAssembly: Interior2Common(
  //           images: selectedFrontLeftDoorAssemblyImage,
  //           replaced: frontLeftDoorAssemblyReplaced,
  //           crackMajor: frontLeftDoorAssemblyCrackMajor,
  //           crackMinor: frontLeftDoorAssemblyCrackMinor,
  //           corrosionMinor: frontLeftDoorAssemblyCorrosionMinor,
  //           corrosionMajor: frontLeftDoorAssemblyCrackMajor,
  //           bendDentMajor: frontLeftDoorAssemblyBendDentMajor,
  //           punchesOpenRepaired: frontLeftDoorAssemblyPunchesOpenRepaired,
  //           repainted: frontLeftDoorAssemblyRepainted,
  //           hammerRepairedMajor: frontLeftDoorAssemblyHammerRepairedMajor,
  //           hammerRepairedMinor: frontLeftDoorAssemblyHammerRepairedMinor,
  //           wrapping: frontLeftDoorAssemblyWrapping,
  //           scratchesMinor: frontLeftDoorAssemblyScratchesMinor,
  //           scratchesMajor: frontLeftDoorAssemblyScratchesMajor,
  //           paintMismatch: frontLeftDoorAssemblyPaintMisMatch,
  //         ),
  //         frontRightDoorAssembly: Interior2Common(
  //           images: selectedFrontRightDoorAssemblyImage,
  //           replaced: frontRightDoorAssemblyReplaced,
  //           crackMajor: frontRightDoorAssemblyCrackMajor,
  //           crackMinor: frontRightDoorAssemblyCrackMinor,
  //           corrosionMinor: frontRightDoorAssemblyCorrosionMinor,
  //           corrosionMajor: frontRightDoorAssemblyCrackMajor,
  //           bendDentMajor: frontRightDoorAssemblyBendDentMajor,
  //           punchesOpenRepaired: frontRightDoorAssemblyPunchesOpenRepaired,
  //           repainted: frontRightDoorAssemblyRepainted,
  //           hammerRepairedMajor: frontRightDoorAssemblyHammerRepairedMajor,
  //           hammerRepairedMinor: frontRightDoorAssemblyHammerRepairedMinor,
  //           wrapping: frontRightDoorAssemblyWrapping,
  //           scratchesMinor: frontRightDoorAssemblyScratchesMinor,
  //           scratchesMajor: frontRightDoorAssemblyScratchesMajor,
  //           paintMismatch: frontRightDoorAssemblyPaintMisMatch,
  //         ),
  //         reverseParkingCamera: Interior2Common(
  //           images: selectedReverseParkingCameraImage,
  //           replaced: reverseParkingCameraReplaced,
  //           crackMajor: reverseParkingCameraCrackMajor,
  //           crackMinor: reverseParkingCameraCrackMinor,
  //           corrosionMinor: reverseParkingCameraCorrosionMinor,
  //           corrosionMajor: reverseParkingCameraCrackMajor,
  //           bendDentMajor: reverseParkingCameraBendDentMajor,
  //           punchesOpenRepaired: reverseParkingCameraPunchesOpenRepaired,
  //           repainted: reverseParkingCameraRepainted,
  //           hammerRepairedMajor: reverseParkingCameraHammerRepairedMajor,
  //           hammerRepairedMinor: reverseParkingCameraHammerRepairedMinor,
  //           wrapping: reverseParkingCameraWrapping,
  //           scratchesMinor: reverseParkingCameraScratchesMinor,
  //           scratchesMajor: reverseParkingCameraScratchesMajor,
  //           paintMismatch: reverseParkingCameraPaintMisMatch,
  //         ),
  //         reverseParkingSensors: Interior2Common(
  //           images: selectedReverseParkingSensorsImage,
  //           replaced: reverseParkingSensorsReplaced,
  //           crackMajor: reverseParkingSensorsCrackMajor,
  //           crackMinor: reverseParkingSensorsCrackMinor,
  //           corrosionMinor: reverseParkingSensorsCorrosionMinor,
  //           corrosionMajor: reverseParkingSensorsCrackMajor,
  //           bendDentMajor: reverseParkingSensorsBendDentMajor,
  //           punchesOpenRepaired: reverseParkingSensorsPunchesOpenRepaired,
  //           repainted: reverseParkingSensorsRepainted,
  //           hammerRepairedMajor: reverseParkingSensorsHammerRepairedMajor,
  //           hammerRepairedMinor: reverseParkingSensorsHammerRepairedMinor,
  //           wrapping: reverseParkingSensorsWrapping,
  //           scratchesMinor: reverseParkingSensorsScratchesMinor,
  //           scratchesMajor: reverseParkingSensorsScratchesMajor,
  //           paintMismatch: reverseParkingSensorsPaintMisMatch,
  //         ),
  //       ),
  //       leftSide: LeftSide(
  //         frontLeftExterior: FrontLeftExterior(
  //           images: selectedFrontLeftExteriorImage,
  //           repaired: frontLeftExteriorRepaired,
  //           replaced: frontLeftExteriorReplaced,
  //           crackMajor: frontLeftExteriorCrackMajor,
  //           crackMinor: frontLeftExteriorCrackMinor,
  //           corrosionMinor: frontLeftExteriorCorrosionMinor,
  //           corrosionMajor: frontLeftExteriorCrackMajor,
  //           bendDentMajor: frontLeftExteriorBendDentMajor,
  //           bendDentMinor: frontLeftExteriorBendDentMinor,
  //           punchesOpenRepaired: frontLeftExteriorPunchesOpenRepaired,
  //         ),
  //         frontLeftMechanical: Interior2Common(
  //           images: selectedFrontLeftMechanicalImage,
  //           replaced: frontLeftMechanicalReplaced,
  //           crackMajor: frontLeftMechanicalCrackMajor,
  //           crackMinor: frontLeftMechanicalCrackMinor,
  //           corrosionMinor: frontLeftMechanicalCorrosionMinor,
  //           corrosionMajor: frontLeftMechanicalCrackMajor,
  //           bendDentMajor: frontLeftMechanicalBendDentMajor,
  //           punchesOpenRepaired: frontLeftMechanicalPunchesOpenRepaired,
  //           repainted: frontLeftMechanicalRepainted,
  //           hammerRepairedMajor: frontLeftMechanicalHammerRepairedMajor,
  //           hammerRepairedMinor: frontLeftMechanicalHammerRepairedMinor,
  //           wrapping: frontLeftMechanicalWrapping,
  //           scratchesMinor: frontLeftMechanicalScratchesMinor,
  //           scratchesMajor: frontLeftMechanicalScratchesMajor,
  //           paintMismatch: frontLeftMechanicalPaintMisMatch,
  //         ),
  //         frontLeftStructure: FrontLeftStructure(
  //           leftFloorPanChannel: Interior2Common(
  //             images: selectedLeftFloorPanChannelImage,
  //             replaced: leftFloorPanChannelReplaced,
  //             crackMajor: leftFloorPanChannelCrackMajor,
  //             crackMinor: leftFloorPanChannelCrackMinor,
  //             corrosionMinor: leftFloorPanChannelCorrosionMinor,
  //             corrosionMajor: leftFloorPanChannelCrackMajor,
  //             bendDentMajor: leftFloorPanChannelBendDentMajor,
  //             punchesOpenRepaired: leftFloorPanChannelPunchesOpenRepaired,
  //             repainted: leftFloorPanChannelRepainted,
  //             hammerRepairedMajor: leftFloorPanChannelHammerRepairedMajor,
  //             hammerRepairedMinor: leftFloorPanChannelHammerRepairedMinor,
  //             wrapping: leftFloorPanChannelWrapping,
  //             scratchesMinor: leftFloorPanChannelScratchesMinor,
  //             scratchesMajor: leftFloorPanChannelScratchesMajor,
  //             paintMismatch: leftFloorPanChannelPaintMisMatch,
  //           ),
  //           leftPillarB: Interior2Common(
  //             images: selectedLeftPillarBImage,
  //             replaced: leftPillarBReplaced,
  //             crackMajor: leftPillarBCrackMajor,
  //             crackMinor: leftPillarBCrackMinor,
  //             corrosionMinor: leftPillarBCorrosionMinor,
  //             corrosionMajor: leftPillarBCrackMajor,
  //             bendDentMajor: leftPillarBBendDentMajor,
  //             punchesOpenRepaired: leftPillarBPunchesOpenRepaired,
  //             repainted: leftPillarBRepainted,
  //             hammerRepairedMajor: leftPillarBHammerRepairedMajor,
  //             hammerRepairedMinor: leftPillarBHammerRepairedMinor,
  //             wrapping: leftPillarBWrapping,
  //             scratchesMinor: leftPillarBScratchesMinor,
  //             scratchesMajor: leftPillarBScratchesMajor,
  //             paintMismatch: leftPillarBPaintMisMatch,
  //           ),
  //           leftPillarC: Interior2Common(
  //             images: selectedLeftPillarCImage,
  //             replaced: leftPillarCReplaced,
  //             crackMajor: leftPillarCCrackMajor,
  //             crackMinor: leftPillarCCrackMinor,
  //             corrosionMinor: leftPillarCCorrosionMinor,
  //             corrosionMajor: leftPillarCCrackMajor,
  //             bendDentMajor: leftPillarCBendDentMajor,
  //             punchesOpenRepaired: leftPillarCPunchesOpenRepaired,
  //             repainted: leftPillarCRepainted,
  //             hammerRepairedMajor: leftPillarCHammerRepairedMajor,
  //             hammerRepairedMinor: leftPillarCHammerRepairedMinor,
  //             wrapping: leftPillarCWrapping,
  //             scratchesMinor: leftPillarCScratchesMinor,
  //             scratchesMajor: leftPillarCScratchesMajor,
  //             paintMismatch: leftPillarCPaintMisMatch,
  //           ),
  //           leftRunningBoard: TRunningBoard(
  //             images: selectedLeftRunningBoardImage,
  //             replaced: leftRunningBoardReplaced,
  //             corrosionMinor: leftRunningBoardCorrosionMinor,
  //             corrosionMajor: leftRunningBoardCorrosionMinor,
  //             crack: leftRunningBoardCrack,
  //             punchesOpenRepaired: leftRunningBoardPunchesOpenRepaired,
  //             repainted: leftRunningBoardRepainted,
  //             paintMismatch: leftRunningBoardPaintMisMatch,
  //           ),
  //           rearLeftDoorChannel: Interior2Common(
  //             images: selectedRearLeftDoorChannelImage,
  //             replaced: rearLeftDoorChannelReplaced,
  //             crackMajor: rearLeftDoorChannelCrackMajor,
  //             crackMinor: rearLeftDoorChannelCrackMinor,
  //             corrosionMinor: rearLeftDoorChannelCorrosionMinor,
  //             corrosionMajor: rearLeftDoorChannelCrackMajor,
  //             bendDentMajor: rearLeftDoorChannelBendDentMajor,
  //             punchesOpenRepaired: rearLeftDoorChannelPunchesOpenRepaired,
  //             repainted: rearLeftDoorChannelRepainted,
  //             hammerRepairedMajor: rearLeftDoorChannelHammerRepairedMajor,
  //             hammerRepairedMinor: rearLeftDoorChannelHammerRepairedMinor,
  //             wrapping: rearLeftDoorChannelWrapping,
  //             scratchesMinor: rearLeftDoorChannelScratchesMinor,
  //             scratchesMajor: rearLeftDoorChannelScratchesMajor,
  //             paintMismatch: rearLeftDoorChannelPaintMisMatch,
  //           ),
  //           rearLeftFloorPan: Interior2Common(
  //             images: selectedRearLeftFloorPanImage,
  //             replaced: rearLeftFloorPanReplaced,
  //             crackMajor: rearLeftFloorPanCrackMajor,
  //             crackMinor: rearLeftFloorPanCrackMinor,
  //             corrosionMinor: rearLeftFloorPanCorrosionMinor,
  //             corrosionMajor: rearLeftFloorPanCrackMajor,
  //             bendDentMajor: rearLeftFloorPanBendDentMajor,
  //             punchesOpenRepaired: rearLeftFloorPanPunchesOpenRepaired,
  //             repainted: rearLeftFloorPanRepainted,
  //             hammerRepairedMajor: rearLeftFloorPanHammerRepairedMajor,
  //             hammerRepairedMinor: rearLeftFloorPanHammerRepairedMinor,
  //             wrapping: rearLeftFloorPanWrapping,
  //             scratchesMinor: rearLeftFloorPanScratchesMinor,
  //             scratchesMajor: rearLeftFloorPanScratchesMajor,
  //             paintMismatch: rearLeftFloorPanPaintMisMatch,
  //           ),
  //           rearLeftWheelHouse: Interior2Common(
  //             images: selectedRearLeftWheelHouseImage,
  //             replaced: rearLeftWheelHouseReplaced,
  //             crackMajor: rearLeftWheelHouseCrackMajor,
  //             crackMinor: rearLeftWheelHouseCrackMinor,
  //             corrosionMinor: rearLeftWheelHouseCorrosionMinor,
  //             corrosionMajor: rearLeftWheelHouseCrackMajor,
  //             bendDentMajor: rearLeftWheelHouseBendDentMajor,
  //             punchesOpenRepaired: rearLeftWheelHousePunchesOpenRepaired,
  //             repainted: rearLeftWheelHouseRepainted,
  //             hammerRepairedMajor: rearLeftWheelHouseHammerRepairedMajor,
  //             hammerRepairedMinor: rearLeftWheelHouseHammerRepairedMinor,
  //             wrapping: rearLeftWheelHouseWrapping,
  //             scratchesMinor: rearLeftWheelHouseScratchesMinor,
  //             scratchesMajor: rearLeftWheelHouseScratchesMajor,
  //             paintMismatch: rearLeftWheelHousePaintMisMatch,
  //           ),
  //         ),
  //         rearLeftExterior: FrontLeftExterior(
  //           images: selectedRearLeftExteriorImage,
  //           repaired: rearLeftExteriorRepaired,
  //           replaced: rearLeftExteriorReplaced,
  //           crackMajor: rearLeftExteriorCrackMajor,
  //           crackMinor: rearLeftExteriorCrackMinor,
  //           corrosionMinor: rearLeftExteriorCorrosionMinor,
  //           corrosionMajor: rearLeftExteriorCrackMajor,
  //           bendDentMajor: rearLeftExteriorBendDentMajor,
  //           bendDentMinor: rearLeftExteriorBendDentMinor,
  //           punchesOpenRepaired: rearLeftExteriorPunchesOpenRepaired,
  //         ),
  //         rearLeftMechanical: FrontLeftExterior(
  //           images: selectedRearLeftExteriorImage,
  //           repaired: rearLeftExteriorRepaired,
  //           replaced: rearLeftExteriorReplaced,
  //           crackMajor: rearLeftExteriorCrackMajor,
  //           crackMinor: rearLeftExteriorCrackMinor,
  //           corrosionMinor: rearLeftExteriorCorrosionMinor,
  //           corrosionMajor: rearLeftExteriorCrackMajor,
  //           bendDentMajor: rearLeftExteriorBendDentMajor,
  //           bendDentMinor: rearLeftExteriorBendDentMinor,
  //           punchesOpenRepaired: rearLeftExteriorPunchesOpenRepaired,
  //         ),
  //         rearLeftStructure: RearLeftStructure(
  //           leftFenderLining: FrontLeftExterior(
  //             images: selectedLeftFenderLiningImage,
  //             repaired: leftFenderLiningRepaired,
  //             replaced: leftFenderLiningReplaced,
  //             crackMajor: leftFenderLiningCrackMajor,
  //             crackMinor: leftFenderLiningCrackMinor,
  //             corrosionMinor: leftFenderLiningCorrosionMinor,
  //             corrosionMajor: leftFenderLiningCrackMajor,
  //             bendDentMajor: leftFenderLiningBendDentMajor,
  //             bendDentMinor: leftFenderLiningBendDentMinor,
  //             punchesOpenRepaired: leftFenderLiningPunchesOpenRepaired,
  //           ),
  //           leftFenderPanel: FrontLeftExterior(
  //             images: selectedLeftFenderPanelImage,
  //             repaired: leftFenderPanelRepaired,
  //             replaced: leftFenderPanelReplaced,
  //             crackMajor: leftFenderPanelCrackMajor,
  //             crackMinor: leftFenderPanelCrackMinor,
  //             corrosionMinor: leftFenderPanelCorrosionMinor,
  //             corrosionMajor: leftFenderPanelCrackMajor,
  //             bendDentMajor: leftFenderPanelBendDentMajor,
  //             bendDentMinor: leftFenderPanelBendDentMinor,
  //             punchesOpenRepaired: leftFenderPanelPunchesOpenRepaired,
  //           ),
  //           leftSvmAssembly: FrontLeftExterior(
  //             images: selectedLeftSvmAssemblyImage,
  //             repaired: leftSvmAssemblyRepaired,
  //             replaced: leftSvmAssemblyReplaced,
  //             crackMajor: leftSvmAssemblyCrackMajor,
  //             crackMinor: leftSvmAssemblyCrackMinor,
  //             corrosionMinor: leftSvmAssemblyCorrosionMinor,
  //             corrosionMajor: leftSvmAssemblyCrackMajor,
  //             bendDentMajor: leftSvmAssemblyBendDentMajor,
  //             bendDentMinor: leftSvmAssemblyBendDentMinor,
  //             punchesOpenRepaired: leftSvmAssemblyPunchesOpenRepaired,
  //           ),
  //           rearLeftDoorPanel: FrontLeftExterior(
  //             images: selectedRearLeftDoorPanelImage,
  //             repaired: rearLeftDoorPanelRepaired,
  //             replaced: rearLeftDoorPanelReplaced,
  //             crackMajor: rearLeftDoorPanelCrackMajor,
  //             crackMinor: rearLeftDoorPanelCrackMinor,
  //             corrosionMinor: rearLeftDoorPanelCorrosionMinor,
  //             corrosionMajor: rearLeftDoorPanelCrackMajor,
  //             bendDentMajor: rearLeftDoorPanelBendDentMajor,
  //             bendDentMinor: rearLeftDoorPanelBendDentMinor,
  //             punchesOpenRepaired: rearLeftDoorPanelPunchesOpenRepaired,
  //           ),
  //         ),
  //       ),
  //       rearSide: RearSide(
  //         rearExterior: RearExterior(
  //           dickeyDoorPanel: FrontLeftExterior(
  //             images: selectedDickeyDoorPanelImage,
  //             hammerRepairedMinor: dickeyDoorPanelHammerRepairedMinor,
  //             hammerRepairedMajor: dickeyDoorPanelHammerRepairedMajor,
  //             replaced: dickeyDoorPanelReplaced,
  //             crackMajor: dickeyDoorPanelCrackMajor,
  //             crackMinor: dickeyDoorPanelCrackMinor,
  //             corrosionMinor: dickeyDoorPanelCorrosionMinor,
  //             corrosionMajor: dickeyDoorPanelCrackMajor,
  //             bendDentMajor: dickeyDoorPanelBendDentMajor,
  //             bendDentMinor: dickeyDoorPanelBendDentMinor,
  //             punchesOpenRepaired: dickeyDoorPanelPunchesOpenRepaired,
  //           ),
  //           dickeyLeftStayRodShocker: FrontLeftExterior(
  //             images: selectedDickeyLeftStayRodShockerImage,
  //             hammerRepairedMinor: dickeyLeftStayRodShockerHammerRepairedMinor,
  //             hammerRepairedMajor: dickeyRightStayRodShockerHammerRepairedMajor,
  //             replaced: dickeyLeftStayRodShockerReplaced,
  //             crackMajor: dickeyLeftStayRodShockerCrackMajor,
  //             crackMinor: dickeyLeftStayRodShockerCrackMinor,
  //             corrosionMinor: dickeyLeftStayRodShockerCorrosionMinor,
  //             corrosionMajor: dickeyLeftStayRodShockerCrackMajor,
  //             bendDentMajor: dickeyLeftStayRodShockerBendDentMajor,
  //             bendDentMinor: dickeyLeftStayRodShockerBendDentMinor,
  //             punchesOpenRepaired: dickeyLeftStayRodShockerPunchesOpenRepaired,
  //           ),
  //           dickeyRightStayRodShocker: FrontLeftExterior(
  //             images: selectedDickeyRightStayRodShockerImage,
  //             hammerRepairedMinor: dickeyRightStayRodShockerHammerRepairedMinor,
  //             hammerRepairedMajor: dickeyRightStayRodShockerHammerRepairedMajor,
  //             replaced: dickeyRightStayRodShockerReplaced,
  //             crackMajor: dickeyRightStayRodShockerCrackMajor,
  //             crackMinor: dickeyRightStayRodShockerCrackMinor,
  //             corrosionMinor: dickeyRightStayRodShockerCorrosionMinor,
  //             corrosionMajor: dickeyRightStayRodShockerCrackMajor,
  //             bendDentMajor: dickeyRightStayRodShockerBendDentMajor,
  //             bendDentMinor: dickeyRightStayRodShockerBendDentMinor,
  //             punchesOpenRepaired: dickeyRightStayRodShockerPunchesOpenRepaired,
  //           ),
  //           leftTailLightAssembly: Interior2Common(
  //             images: selectedLeftTailLightAssemblyImage,
  //             replaced: leftTailLightAssemblyReplaced,
  //             crackMajor: leftTailLightAssemblyCrackMajor,
  //             crackMinor: leftTailLightAssemblyCrackMinor,
  //             corrosionMinor: leftTailLightAssemblyCorrosionMinor,
  //             corrosionMajor: leftTailLightAssemblyCrackMajor,
  //             bendDentMajor: leftTailLightAssemblyBendDentMajor,
  //             punchesOpenRepaired: leftTailLightAssemblyPunchesOpenRepaired,
  //             repainted: leftTailLightAssemblyRepainted,
  //             hammerRepairedMajor: leftTailLightAssemblyHammerRepairedMajor,
  //             hammerRepairedMinor: leftTailLightAssemblyHammerRepairedMinor,
  //             wrapping: leftTailLightAssemblyWrapping,
  //             scratchesMinor: leftTailLightAssemblyScratchesMinor,
  //             scratchesMajor: leftTailLightAssemblyScratchesMajor,
  //             paintMismatch: leftTailLightAssemblyPaintMisMatch,
  //           ),
  //           rearBumperPanel: Interior2Common(
  //             images: selectedRearBumperPanelImage,
  //             replaced: rearBumperPanelReplaced,
  //             crackMajor: rearBumperPanelCrackMajor,
  //             crackMinor: rearBumperPanelCrackMinor,
  //             corrosionMinor: rearBumperPanelCorrosionMinor,
  //             corrosionMajor: rearBumperPanelCrackMajor,
  //             bendDentMajor: rearBumperPanelBendDentMajor,
  //             punchesOpenRepaired: rearBumperPanelPunchesOpenRepaired,
  //             repainted: rearBumperPanelRepainted,
  //             hammerRepairedMajor: rearBumperPanelHammerRepairedMajor,
  //             hammerRepairedMinor: rearBumperPanelHammerRepairedMinor,
  //             wrapping: rearBumperPanelWrapping,
  //             scratchesMinor: rearBumperPanelScratchesMinor,
  //             scratchesMajor: rearBumperPanelScratchesMajor,
  //             paintMismatch: rearBumperPanelPaintMisMatch,
  //           ),
  //           rearRegistrationPlate: Interior2Common(
  //             images: selectedRearRegistrationPlateImage,
  //             replaced: rearRegistrationPlateReplaced,
  //             crackMajor: rearRegistrationPlateCrackMajor,
  //             crackMinor: rearRegistrationPlateCrackMinor,
  //             corrosionMinor: rearRegistrationPlateCorrosionMinor,
  //             corrosionMajor: rearRegistrationPlateCrackMajor,
  //             bendDentMajor: rearRegistrationPlateBendDentMajor,
  //             punchesOpenRepaired: rearRegistrationPlatePunchesOpenRepaired,
  //             repainted: rearRegistrationPlateRepainted,
  //             hammerRepairedMajor: rearRegistrationPlateHammerRepairedMajor,
  //             hammerRepairedMinor: rearRegistrationPlateHammerRepairedMinor,
  //             wrapping: rearRegistrationPlateWrapping,
  //             scratchesMinor: rearRegistrationPlateScratchesMinor,
  //             scratchesMajor: rearRegistrationPlateScratchesMajor,
  //             paintMismatch: rearRegistrationPlatePaintMisMatch,
  //           ),
  //           rearWindshieldGlass: Interior2Common(
  //             images: selectedRearWindshieldGlassImage,
  //             replaced: rearWindshieldGlassReplaced,
  //             crackMajor: rearWindshieldGlassCrackMajor,
  //             crackMinor: rearWindshieldGlassCrackMinor,
  //             corrosionMinor: rearWindshieldGlassCorrosionMinor,
  //             corrosionMajor: rearWindshieldGlassCrackMajor,
  //             bendDentMajor: rearWindshieldGlassBendDentMajor,
  //             punchesOpenRepaired: rearWindshieldGlassPunchesOpenRepaired,
  //             repainted: rearWindshieldGlassRepainted,
  //             hammerRepairedMajor: rearWindshieldGlassHammerRepairedMajor,
  //             hammerRepairedMinor: rearWindshieldGlassHammerRepairedMinor,
  //             wrapping: rearWindshieldGlassWrapping,
  //             scratchesMinor: rearWindshieldGlassScratchesMinor,
  //             scratchesMajor: rearWindshieldGlassScratchesMajor,
  //             paintMismatch: rearWindshieldGlassPaintMisMatch,
  //           ),
  //           rightTailLightAssembly: Interior2Common(
  //             images: selectedRightTailLightAssemblyImage,
  //             replaced: rightTailLightAssemblyReplaced,
  //             crackMajor: rightTailLightAssemblyCrackMajor,
  //             crackMinor: rightTailLightAssemblyCrackMinor,
  //             corrosionMinor: rightTailLightAssemblyCorrosionMinor,
  //             corrosionMajor: rightTailLightAssemblyCrackMajor,
  //             bendDentMajor: rightTailLightAssemblyBendDentMajor,
  //             punchesOpenRepaired: rightTailLightAssemblyPunchesOpenRepaired,
  //             repainted: rightTailLightAssemblyRepainted,
  //             hammerRepairedMajor: rightTailLightAssemblyHammerRepairedMajor,
  //             hammerRepairedMinor: rightTailLightAssemblyHammerRepairedMinor,
  //             wrapping: rightTailLightAssemblyWrapping,
  //             scratchesMinor: rightTailLightAssemblyScratchesMinor,
  //             scratchesMajor: rightTailLightAssemblyScratchesMajor,
  //             paintMismatch: rightTailLightAssemblyPaintMisMatch,
  //           ),
  //         ),
  //         roofStructureAndRoot: RoofStructureAndRoot(
  //             dickeyBackPanel: FrontLeftExterior(
  //               images: selectedDickeyBackPanelImage,
  //               hammerRepairedMinor: dickeyBackPanelHammerRepairedMinor,
  //               hammerRepairedMajor: dickeyBackPanelHammerRepairedMajor,
  //               replaced: dickeyBackPanelReplaced,
  //               crackMajor: dickeyBackPanelCrackMajor,
  //               crackMinor: dickeyBackPanelCrackMinor,
  //               corrosionMinor: dickeyBackPanelCorrosionMinor,
  //               corrosionMajor: dickeyBackPanelCrackMajor,
  //               bendDentMajor: dickeyBackPanelBendDentMajor,
  //               bendDentMinor: dickeyBackPanelBendDentMinor,
  //               punchesOpenRepaired: dickeyBackPanelPunchesOpenRepaired,
  //             ),
  //             dickeyFloor: FrontLeftExterior(
  //               images: selectedDickeyFloorImage,
  //               hammerRepairedMinor: dickeyFloorHammerRepairedMinor,
  //               hammerRepairedMajor: dickeyFloorHammerRepairedMajor,
  //               replaced: dickeyFloorReplaced,
  //               crackMajor: dickeyFloorCrackMajor,
  //               crackMinor: dickeyFloorCrackMinor,
  //               corrosionMinor: dickeyFloorCorrosionMinor,
  //               corrosionMajor: dickeyFloorCrackMajor,
  //               bendDentMajor: dickeyFloorBendDentMajor,
  //               bendDentMinor: dickeyFloorBendDentMinor,
  //               punchesOpenRepaired: dickeyFloorPunchesOpenRepaired,
  //             ),
  //             dickeyLeftLeg: FrontLeftExterior(
  //               images: selectedDickeyLeftLegImage,
  //               hammerRepairedMinor: dickeyLeftLegHammerRepairedMinor,
  //               hammerRepairedMajor: dickeyLeftLegHammerRepairedMajor,
  //               replaced: dickeyLeftLegReplaced,
  //               repaired: dickeyLeftLegRepaired,
  //               crackMajor: dickeyLeftLegCrackMajor,
  //               crackMinor: dickeyLeftLegCrackMinor,
  //               corrosionMinor: dickeyLeftLegCorrosionMinor,
  //               corrosionMajor: dickeyLeftLegCrackMajor,
  //               bendDentMajor: dickeyLeftLegBendDentMajor,
  //               bendDentMinor: dickeyLeftLegBendDentMinor,
  //               punchesOpenRepaired: dickeyLeftLegPunchesOpenRepaired,
  //             ),
  //             dickeyRightLeg: FrontLeftExterior(
  //               images: selectedDickeyRightLegImage,
  //               hammerRepairedMinor: dickeyRightLegHammerRepairedMinor,
  //               hammerRepairedMajor: dickeyRightLegHammerRepairedMajor,
  //               replaced: dickeyRightLegReplaced,
  //               repaired: dickeyRightLegRepaired,
  //               crackMajor: dickeyRightLegCrackMajor,
  //               crackMinor: dickeyRightLegCrackMinor,
  //               corrosionMinor: dickeyRightLegCorrosionMinor,
  //               corrosionMajor: dickeyRightLegCrackMajor,
  //               bendDentMajor: dickeyRightLegBendDentMajor,
  //               bendDentMinor: dickeyRightLegBendDentMinor,
  //               punchesOpenRepaired: dickeyRightLegPunchesOpenRepaired,
  //             ),
  //             dickeySidewalls: DickeySidewalls(
  //               leftDickeySidewall: FrontLeftExterior(
  //                 images: selectedLeftDickeySidewallImage,
  //                 sealantMissingCrackRepaired:
  //                     leftDickeySidewallSealantMissingCrackRepaired,
  //                 replaced: leftDickeySidewallReplaced,
  //                 crackMajor: leftDickeySidewallCrackMajor,
  //                 crackMinor: leftDickeySidewallCrackMinor,
  //                 corrosionMinor: leftDickeySidewallCorrosionMinor,
  //                 corrosionMajor: leftDickeySidewallCrackMajor,
  //                 bendDentMajor: leftDickeySidewallBendDentMajor,
  //                 bendDentMinor: leftDickeySidewallBendDentMinor,
  //                 punchesOpenRepaired: leftDickeySidewallPunchesOpenRepaired,
  //               ),
  //               rightDickeySidewall: FrontLeftExterior(
  //                 images: selectedRightDickeySidewallImage,
  //                 replaced: rightDickeySidewallReplaced,
  //                 sealantMissingCrackRepaired:
  //                     rightDickeySidewallSealantMissingCrackRepaired,
  //                 crackMajor: rightDickeySidewallCrackMajor,
  //                 crackMinor: rightDickeySidewallCrackMinor,
  //                 corrosionMinor: rightDickeySidewallCorrosionMinor,
  //                 corrosionMajor: rightDickeySidewallCrackMajor,
  //                 bendDentMajor: rightDickeySidewallBendDentMajor,
  //                 bendDentMinor: rightDickeySidewallBendDentMinor,
  //                 punchesOpenRepaired: rightDickeySidewallPunchesOpenRepaired,
  //               ),
  //             ),
  //             dickeyStrutTowers: DickeyStrutTowers(
  //               leftDickeyStrutTower: FrontLeftExterior(
  //                 images: selectedLeftDickeyStrutTowerImage,
  //                 sealantMissingCrackRepaired:
  //                     leftDickeyStrutTowerSealantMissingCrackRepaired,
  //                 replaced: leftDickeyStrutTowerReplaced,
  //                 crackMajor: leftDickeyStrutTowerCrackMajor,
  //                 crackMinor: leftDickeyStrutTowerCrackMinor,
  //                 corrosionMinor: leftDickeyStrutTowerCorrosionMinor,
  //                 corrosionMajor: leftDickeyStrutTowerCrackMajor,
  //                 bendDentMajor: leftDickeyStrutTowerBendDentMajor,
  //                 bendDentMinor: leftDickeyStrutTowerBendDentMinor,
  //                 punchesOpenRepaired: leftDickeyStrutTowerPunchesOpenRepaired,
  //               ),
  //               rightDickeyStrutTower: FrontLeftExterior(
  //                 images: selectedRightDickeyStrutTowerImage,
  //                 sealantMissingCrackRepaired:
  //                     rightDickeyStrutTowerSealantMissingCrackRepaired,
  //                 replaced: rightDickeyStrutTowerReplaced,
  //                 crackMajor: rightDickeyStrutTowerCrackMajor,
  //                 crackMinor: rightDickeyStrutTowerCrackMinor,
  //                 corrosionMinor: rightDickeyStrutTowerCorrosionMinor,
  //                 corrosionMajor: rightDickeyStrutTowerCrackMajor,
  //                 bendDentMajor: rightDickeyStrutTowerBendDentMajor,
  //                 bendDentMinor: rightDickeyStrutTowerBendDentMinor,
  //                 punchesOpenRepaired: rightDickeyStrutTowerPunchesOpenRepaired,
  //               ),
  //             ),
  //             roofPanel: RoofPanel(
  //               images: selectedRoofPanelImage,
  //               replaced: roofPanelReplaced,
  //               repaired: roofPanelRepaired,
  //               wrapping: roofPanelWrapping,
  //               paintDefective: roofPanelPaintMisMatch,
  //               corrosionMinor: roofPanelCorrosionMinor,
  //               corrosionMajor: roofPanelCorrosionMajor,
  //               repainted: roofPanelRepainted,
  //               paintMismatch: roofPanelPaintMisMatch,
  //               scratchesMinor: roofPanelScratchesMinor,
  //               scratchesMajor: roofPanelScratchesMajor,
  //               sealantMissing: roofPanelSealantMissing,
  //               multipleDentsDentMajor: roofPanelMultipleDentsDentMajor,
  //               multipleDentsDentMinor: roofPanelMultipleDentsDentMinor,
  //               aftermarketSunroofFitment: roofPanelAftermarketSunroofFitment,
  //               externalHoleTear: roofPanelExternalHoleTear,
  //               aftermarketDualTonePaint: roofPanelAftermarketDualTonePaint,
  //             ),
  //             spareTyreAssembly: SpareTyreAssembly(
  //               images: selectedSpareTyreAssemblyImage,
  //               spareTyreAvailable: spareTyreAvailable,
  //             )),
  //       ),
  //       rightSide: RightSide(
  //         frontRightExterior: FrontRightExterior(
  //           frontRightDoorPanel: FrontLeftExterior(
  //             images: selectedFrontRightDoorPanelImage,
  //             replaced: frontRightDoorPanelReplaced,
  //             repaired: frontRightDoorPanelRepaired,
  //             crackMajor: frontRightDoorPanelCrackMajor,
  //             crackMinor: frontRightDoorPanelCrackMinor,
  //             corrosionMinor: frontRightDoorPanelCorrosionMinor,
  //             corrosionMajor: frontRightDoorPanelCrackMajor,
  //             bendDentMajor: frontRightDoorPanelBendDentMajor,
  //             bendDentMinor: frontRightDoorPanelBendDentMinor,
  //             punchesOpenRepaired: frontRightDoorPanelPunchesOpenRepaired,
  //           ),
  //           rightFenderLining: FrontLeftExterior(
  //             images: selectedRightFenderLiningImage,
  //             replaced: rightFenderLiningReplaced,
  //             repaired: rightFenderLiningRepaired,
  //             crackMajor: rightFenderLiningCrackMajor,
  //             crackMinor: rightFenderLiningCrackMinor,
  //             corrosionMinor: rightFenderLiningCorrosionMinor,
  //             corrosionMajor: rightFenderLiningCrackMajor,
  //             bendDentMajor: rightFenderLiningBendDentMajor,
  //             bendDentMinor: rightFenderLiningBendDentMinor,
  //             punchesOpenRepaired: rightFenderLiningPunchesOpenRepaired,
  //           ),
  //           rightFenderPanel: FrontLeftExterior(
  //             images: selectedRightFenderPanelImage,
  //             replaced: rightFenderPanelReplaced,
  //             repaired: rightFenderPanelRepaired,
  //             crackMajor: rightFenderPanelCrackMajor,
  //             crackMinor: rightFenderPanelCrackMinor,
  //             corrosionMinor: rightFenderPanelCorrosionMinor,
  //             corrosionMajor: rightFenderPanelCrackMajor,
  //             bendDentMajor: rightFenderPanelBendDentMajor,
  //             bendDentMinor: rightFenderPanelBendDentMinor,
  //             punchesOpenRepaired: rightFenderPanelPunchesOpenRepaired,
  //           ),
  //           rightSvmAssembly: FrontLeftExterior(
  //             images: selectedRightSvmAssemblyImage,
  //             replaced: rightSvmAssemblyReplaced,
  //             repaired: rightSvmAssemblyRepaired,
  //             crackMajor: rightSvmAssemblyCrackMajor,
  //             crackMinor: rightSvmAssemblyCrackMinor,
  //             corrosionMinor: rightSvmAssemblyCorrosionMinor,
  //             corrosionMajor: rightSvmAssemblyCrackMajor,
  //             bendDentMajor: rightSvmAssemblyBendDentMajor,
  //             bendDentMinor: rightSvmAssemblyBendDentMinor,
  //             punchesOpenRepaired: rightSvmAssemblyPunchesOpenRepaired,
  //           ),
  //         ),
  //         frontRightMechanical: FrontRightMechanical(
  //           exhaustSystem: frontRightMechanicalExhaustSystem,
  //           fourWheelDrive: FrontLeftExterior(
  //             images: selectedFourWheelDriveImage,
  //             replaced: fourWheelDriveReplaced,
  //             repaired: fourWheelDriveRepaired,
  //             crackMajor: fourWheelDriveCrackMajor,
  //             crackMinor: fourWheelDriveCrackMinor,
  //             corrosionMinor: fourWheelDriveCorrosionMinor,
  //             corrosionMajor: fourWheelDriveCrackMajor,
  //             bendDentMajor: fourWheelDriveBendDentMajor,
  //             bendDentMinor: fourWheelDriveBendDentMinor,
  //             punchesOpenRepaired: fourWheelDrivePunchesOpenRepaired,
  //           ),
  //           frontRightBrakeAssembly: FrontLeftExterior(
  //             images: selectedFrontRightBrakeAssemblyImage,
  //             replaced: frontRightBrakeAssemblyReplaced,
  //             repaired: frontRightBrakeAssemblyRepaired,
  //             crackMajor: frontRightBrakeAssemblyCrackMajor,
  //             crackMinor: frontRightBrakeAssemblyCrackMinor,
  //             corrosionMinor: frontRightBrakeAssemblyCorrosionMinor,
  //             corrosionMajor: frontRightBrakeAssemblyCrackMajor,
  //             bendDentMajor: frontRightBrakeAssemblyBendDentMajor,
  //             bendDentMinor: frontRightBrakeAssemblyBendDentMinor,
  //             punchesOpenRepaired: frontRightBrakeAssemblyPunchesOpenRepaired,
  //           ),
  //           frontRightSuspension: FrontRightSuspension(
  //             frontJumpingRodAssembly:
  //                 frontRightSuspensionFrontJumpingRodAssembly,
  //             frontRightLinkRod: frontRightSuspensionFrontRightLinkRod,
  //             frontRightLowerControlArmAssembly:
  //                 frontRightSuspensionFrontRightLowerControlArmAssembly,
  //             frontRightStrutAssembly:
  //                 frontRightSuspensionFrontRightStrutAssembly,
  //           ),
  //           frontRightTyreAssembly: FrontLeftExterior(
  //             images: selectedFrontRightTyreAssemblyImage,
  //             replaced: frontRightTyreAssemblyReplaced,
  //             repaired: frontRightTyreAssemblyRepaired,
  //             crackMajor: frontRightTyreAssemblyCrackMajor,
  //             crackMinor: frontRightTyreAssemblyCrackMinor,
  //             corrosionMinor: frontRightTyreAssemblyCorrosionMinor,
  //             corrosionMajor: frontRightTyreAssemblyCrackMajor,
  //             bendDentMajor: frontRightTyreAssemblyBendDentMajor,
  //             bendDentMinor: frontRightTyreAssemblyBendDentMinor,
  //             punchesOpenRepaired: frontRightTyreAssemblyPunchesOpenRepaired,
  //           ),
  //           frontWheelDrive: FrontLeftExterior(
  //             images: selectedFrontWheelDriveImage,
  //             replaced: frontWheelDriveReplaced,
  //             repaired: frontWheelDriveRepaired,
  //             crackMajor: frontWheelDriveCrackMajor,
  //             crackMinor: frontWheelDriveCrackMinor,
  //             corrosionMinor: frontWheelDriveCorrosionMinor,
  //             corrosionMajor: frontWheelDriveCrackMajor,
  //             bendDentMajor: frontWheelDriveBendDentMajor,
  //             bendDentMinor: frontWheelDriveBendDentMinor,
  //             punchesOpenRepaired: frontWheelDrivePunchesOpenRepaired,
  //           ),
  //         ),
  //         rearRightStructure: RearRightStructure(
  //           rearRightDoorChannel: Interior2Common(
  //             images: selectedRearRightDoorChannelImage,
  //             replaced: rearRightDoorChannelReplaced,
  //             crackMajor: rearRightDoorChannelCrackMajor,
  //             crackMinor: rearRightDoorChannelCrackMinor,
  //             corrosionMinor: rearRightDoorChannelCorrosionMinor,
  //             corrosionMajor: rearRightDoorChannelCrackMajor,
  //             bendDentMajor: rearRightDoorChannelBendDentMajor,
  //             punchesOpenRepaired: rearRightDoorChannelPunchesOpenRepaired,
  //             repainted: rearRightDoorChannelRepainted,
  //             hammerRepairedMajor: rearRightDoorChannelHammerRepairedMajor,
  //             hammerRepairedMinor: rearRightDoorChannelHammerRepairedMinor,
  //             wrapping: rearRightDoorChannelWrapping,
  //             scratchesMinor: rearRightDoorChannelScratchesMinor,
  //             scratchesMajor: rearRightDoorChannelScratchesMajor,
  //             paintMismatch: rearRightDoorChannelPaintMisMatch,
  //           ),
  //           rearRightFloorPan: Interior2Common(
  //             images: selectedRearRightFloorPanImage,
  //             replaced: rearRightFloorPanReplaced,
  //             crackMajor: rearRightFloorPanCrackMajor,
  //             crackMinor: rearRightFloorPanCrackMinor,
  //             corrosionMinor: rearRightFloorPanCorrosionMinor,
  //             corrosionMajor: rearRightFloorPanCrackMajor,
  //             bendDentMajor: rearRightFloorPanBendDentMajor,
  //             punchesOpenRepaired: rearRightFloorPanPunchesOpenRepaired,
  //             repainted: rearRightFloorPanRepainted,
  //             hammerRepairedMajor: rearRightFloorPanHammerRepairedMajor,
  //             hammerRepairedMinor: rearRightFloorPanHammerRepairedMinor,
  //             wrapping: rearRightFloorPanWrapping,
  //             scratchesMinor: rearRightFloorPanScratchesMinor,
  //             scratchesMajor: rearRightFloorPanScratchesMajor,
  //             paintMismatch: rearRightFloorPanPaintMisMatch,
  //           ),
  //           rearRightWheelHouse: Interior2Common(
  //             images: selectedRearRightWheelHouseImage,
  //             replaced: rearRightWheelHouseReplaced,
  //             crackMajor: rearRightWheelHouseCrackMajor,
  //             crackMinor: rearRightWheelHouseCrackMinor,
  //             corrosionMinor: rearRightWheelHouseCorrosionMinor,
  //             corrosionMajor: rearRightWheelHouseCrackMajor,
  //             bendDentMajor: rearRightWheelHouseBendDentMajor,
  //             punchesOpenRepaired: rearRightWheelHousePunchesOpenRepaired,
  //             repainted: rearRightWheelHouseRepainted,
  //             hammerRepairedMajor: rearRightWheelHouseHammerRepairedMajor,
  //             hammerRepairedMinor: rearRightWheelHouseHammerRepairedMinor,
  //             wrapping: rearRightWheelHouseWrapping,
  //             scratchesMinor: rearRightWheelHouseScratchesMinor,
  //             scratchesMajor: rearRightWheelHouseScratchesMajor,
  //             paintMismatch: rearRightWheelHousePaintMisMatch,
  //           ),
  //           rightFloorPanChannel: Interior2Common(
  //             images: selectedRightFloorPanChannelImage,
  //             replaced: rightFloorPanChannelReplaced,
  //             crackMajor: rightFloorPanChannelCrackMajor,
  //             crackMinor: rightFloorPanChannelCrackMinor,
  //             corrosionMinor: rightFloorPanChannelCorrosionMinor,
  //             corrosionMajor: rightFloorPanChannelCrackMajor,
  //             bendDentMajor: rightFloorPanChannelBendDentMajor,
  //             punchesOpenRepaired: rightFloorPanChannelPunchesOpenRepaired,
  //             repainted: rightFloorPanChannelRepainted,
  //             hammerRepairedMajor: rightFloorPanChannelHammerRepairedMajor,
  //             hammerRepairedMinor: rightFloorPanChannelHammerRepairedMinor,
  //             wrapping: rightFloorPanChannelWrapping,
  //             scratchesMinor: rightFloorPanChannelScratchesMinor,
  //             scratchesMajor: rightFloorPanChannelScratchesMajor,
  //             paintMismatch: rightFloorPanChannelPaintMisMatch,
  //           ),
  //           rightPillarB: Interior2Common(
  //             images: selectedRightPillarBImage,
  //             replaced: rightPillarBReplaced,
  //             crackMajor: rightPillarBCrackMajor,
  //             crackMinor: rightPillarBCrackMinor,
  //             corrosionMinor: rightPillarBCorrosionMinor,
  //             corrosionMajor: rightPillarBCrackMajor,
  //             bendDentMajor: rightPillarBBendDentMajor,
  //             punchesOpenRepaired: rightPillarBPunchesOpenRepaired,
  //             repainted: rightPillarBRepainted,
  //             hammerRepairedMajor: rightPillarBHammerRepairedMajor,
  //             hammerRepairedMinor: rightPillarBHammerRepairedMinor,
  //             wrapping: rightPillarBWrapping,
  //             scratchesMinor: rightPillarBScratchesMinor,
  //             scratchesMajor: rightPillarBScratchesMajor,
  //             paintMismatch: rightPillarBPaintMisMatch,
  //           ),
  //           rightPillarC: Interior2Common(
  //             images: selectedRightPillarCImage,
  //             replaced: rightPillarCReplaced,
  //             crackMajor: rightPillarCCrackMajor,
  //             crackMinor: rightPillarCCrackMinor,
  //             corrosionMinor: rightPillarCCorrosionMinor,
  //             corrosionMajor: rightPillarCCrackMajor,
  //             bendDentMajor: rightPillarCBendDentMajor,
  //             punchesOpenRepaired: rightPillarCPunchesOpenRepaired,
  //             repainted: rightPillarCRepainted,
  //             hammerRepairedMajor: rightPillarCHammerRepairedMajor,
  //             hammerRepairedMinor: rightPillarCHammerRepairedMinor,
  //             wrapping: rightPillarCWrapping,
  //             scratchesMinor: rightPillarCScratchesMinor,
  //             scratchesMajor: rightPillarCScratchesMajor,
  //             paintMismatch: rightPillarCPaintMisMatch,
  //           ),
  //           rightRunningBoard: TRunningBoard(
  //             images: selectedRightRunningBoardImage,
  //             replaced: rightRunningBoardReplaced,
  //             repainted: rightRunningBoardRepainted,
  //             corrosionMinor: rightRunningBoardCorrosionMinor,
  //             corrosionMajor: rightRunningBoardCorrosionMajor,
  //             punchesOpenRepaired: rightRunningBoardPunchesOpenRepaired,
  //             paintMismatch: rightRunningBoardPaintMisMatch,
  //             paintDefective: rightRunningBoardPaintDefective,
  //             crack: rightRunningBoardCrack,
  //           ),
  //         ),
  //         rightRightMechanical: Interior2Common(
  //           images: selectedRightMechanicalImage,
  //           replaced: rightMechanicalReplaced,
  //           crackMajor: rightMechanicalCrackMajor,
  //           crackMinor: rightMechanicalCrackMinor,
  //           corrosionMinor: rightMechanicalCorrosionMinor,
  //           corrosionMajor: rightMechanicalCrackMajor,
  //           bendDentMajor: rightMechanicalBendDentMajor,
  //           punchesOpenRepaired: rightMechanicalPunchesOpenRepaired,
  //           repainted: rightMechanicalRepainted,
  //           hammerRepairedMajor: rightMechanicalHammerRepairedMajor,
  //           hammerRepairedMinor: rightMechanicalHammerRepairedMinor,
  //           wrapping: rightMechanicalWrapping,
  //           scratchesMinor: rightMechanicalScratchesMinor,
  //           scratchesMajor: rightMechanicalScratchesMajor,
  //           paintMismatch: rightMechanicalPaintMisMatch,
  //         ),
  //       ),
  //       testDrive: TestDrive(
  //         steeringHealth: testDriveSteeringHealth,
  //         accelerateToCheckClutch: AccelerateToCheckClutch(
  //           clutchPedalVibration: testDriveClutchPedalVibration,
  //           noiseFromTurbocharger: testDriveNoiseFromTurbocharger,
  //         ),
  //         applyBrakesTillCarStop: ApplyBrakesTillCarStop(
  //           frontBrakeNoiseVibration: testDriveFrontBrakeNoiseVibration,
  //           idleStartStopNotWorking: testDriveIdleStartStopNotWorking,
  //           rearBrakeNoiseVibration: testDriveRearBrakeNoiseVibration,
  //         ),
  //       ),
  //     ),
  //   );

  //   final carAuction = CarAuction(
  //     id: widget.carDetails.serialNumber.toString(),
  //     isPurchased: false,
  //     endTime: newEndTime.millisecondsSinceEpoch,
  //     startTime: newStartTime.millisecondsSinceEpoch,
  //     auctionCount: 1,
  //     auctionStatus: true,
  //     carImages: selectedAllImages,
  //     imagePath: selectedAllImages.first,
  //     coolDownHours: 1,
  //     isFinalized: false,
  //     isOcb: false,
  //     isRcTransfer: false,
  //     variant: widget.carDetails.fuelType,
  //     clientLocation: widget.carDetails.userCity,
  //     companyName: widget.carDetails.brand,
  //     model: widget.carDetails.model,
  //     transmission: widget.carDetails.transmission,
  //     carPrice: carPrice,
  //     commissionPrice: carPrice * 0.12,
  //     engineRating: engineRatingValue,
  //     manufacturingYear: widget.carDetails.manfYear.toString(),
  //     totalDistance: num.tryParse(widget.carDetails.km),
  //     rtoNumber: widget.carDetails.rtoLoc,
  //     maxBidPrice: num.tryParse(widget.carDetails.car_price.toString() * 2),
  //     highestBid: 0.0,
  //   );
  //   ElevatedButton(
  //     onPressed: () async {
  //       // Show the "Car Inspection Saved!" message immediately
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Car Inspection Saved!')),
  //       );
  //       try {
  //         // Save the car details to Firebase
  //         await _database
  //             .child(widget.carDetails.serialNumber.toString())
  //             .set(newCarDoc.toMap());
  //         // Send data to the API
  //         await sendDataToApi();
  //         // Save car auction details to Firebase
  //         await carAuctionRef
  //             .child(widget.carDetails.serialNumber.toString())
  //             .set(carAuction.toMap());

  //         // Optionally, show another message if everything succeeds
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Car details successfully saved!')),
  //         );
  //       } catch (error) {
  //         // Show error message if something fails
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to save data: $error')),
  //         );
  //       }
  //     },
  //     child: const Text('Submit'),
  //   );
  //   // await _database
  //   //     .child(widget.carDetails.serialNumber.toString())
  //   //     .set(newCarDoc.toMap());
  //   // await sendDataToApi();
  //   // await carAuctionRef
  //   //     .child(widget.carDetails.serialNumber.toString())
  //   //     .set(carAuction.toMap());

  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //   const SnackBar(content: Text('Car Inspection Saved!')),
  //   // );
  //   Navigator.pop(context);
  //   Navigator.pop(context);
  // }

  String getUId() {
    const uuid = Uuid();
    return uuid.v1();
  }

  engineRatingCheck() {
    setState(() {
      engineRating.clear();
      engineRating.add(leakageFromAtGearboxHousing);
      engineRating.add(leakageFromAtInputShaft);
      engineRating.add(leakageFromEngineBlock);
      engineRating.add(leakageFromExhaustManifold);
      engineRating.add(leakageFromTurbocharger);
      engineRating.add(leakageFromMetalTiming);
      engineRating.add(seepageFromEngineTiming);
      engineRating.add(backCompressionInEngine);
      engineRating.add(overheaingDueToRadiatorSystem);
      engineRating.add(overheatingInEngine);
      engineRating.add(leakageFromMtInputShaft);
      engineRating.add(leakageFromMtGearboxHousing);
      engineRating.add(leakageFromDriveAxle);
      engineRating.add(leakageFrom5ThGearHousing);
    });
  }

  int engineIssueCheck() {
    engineRating.clear();
    engineRating.add(leakageFromAtGearboxHousing);
    engineRating.add(leakageFromAtInputShaft);
    engineRating.add(leakageFromEngineBlock);
    engineRating.add(leakageFromExhaustManifold);
    engineRating.add(leakageFromTurbocharger);
    engineRating.add(leakageFromMetalTiming);
    engineRating.add(seepageFromEngineTiming);
    engineRating.add(backCompressionInEngine);
    engineRating.add(overheaingDueToRadiatorSystem);
    engineRating.add(overheatingInEngine);
    engineRating.add(leakageFromMtInputShaft);
    engineRating.add(leakageFromMtGearboxHousing);
    engineRating.add(leakageFromDriveAxle);
    engineRating.add(leakageFrom5ThGearHousing);
    var trueBool = engineRating.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int batteryIssueCheck() {
    battery.clear();
    battery.add(battryLeakage);
    battery.add(battryWrongSize);
    battery.add(battryDamaged);
    battery.add(battryAfterMarketFitment);
    var trueBool = battery.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int frontSideIssueCheck() {
    frontSide.clear();
    frontSide.add(bonnetAlignmentOut);
    frontSide.add(bonnetCorrosionMajor);
    frontSide.add(bonnetCorrosionMinor);
    frontSide.add(bonnetRepainted);
    frontSide.add(bonnetReplaced);
    frontSide.add(bonnetSealantMissingCrackRepaired);
    frontSide.add(bonnetWrapping);
    frontSide.add(bonnetPaintDefective);
    frontSide.add(carKeyOneKeyMissing);
    frontSide.add(carKeyNoFreeMovement);
    frontSide.add(carKeyDamagedMajor);
    frontSide.add(carKeyDamagedMinor);
    frontSide.add(centralLockingRemoteHousingDamagedMinor);
    frontSide.add(centralLockingRemoteHousingOneKeyMissing);
    frontSide.add(centralLockingRemoteHousingNoFreeMovement);
    frontSide.add(centralLockingRemoteHousingDamagedMajor);
    frontSide.add(frontBumperGrillCrackMajor);
    frontSide.add(frontBumperGrillCrackMinor);
    frontSide.add(frontBumperGrillScratchesMajor);
    frontSide.add(frontBumperGrillScratchesMinor);
    frontSide.add(frontBumperGrillRepaired);
    frontSide.add(frontBumperPanelPartMissing);
    frontSide.add(frontBumperPanelRepainted);
    frontSide.add(frontBumperPanelTabLocksScrewRepaired);
    frontSide.add(frontBumperPanelWrapping);
    frontSide.add(frontBumperPanelPaintDefective);
    frontSide.add(frontRegistrationPlatePartMissing);
    frontSide.add(frontRegistrationPlateAftermarketFitment);
    frontSide.add(frontRegistrationPlateDamagedMajor);
    frontSide.add(frontRegistrationPlateDamagedMinor);
    frontSide.add(frontLeftFogLightHousingBendDentMajor);
    frontSide.add(frontLeftFogLightHousingBendDentMinor);
    frontSide.add(frontLeftFogLightHousingCrackMajor);
    frontSide.add(frontLeftFogLightHousingCrackMinor);
    frontSide.add(frontLeftFogLightHousingPunchesOpenRepaired);
    frontSide.add(frontLeftFogLightHousingRepaired);
    frontSide.add(frontLeftFogLightHousingReplaced);
    frontSide.add(frontLeftFogLightHousingCorrosionMajor);
    frontSide.add(frontLeftFogLightHousingCorrosionMinor);
    frontSide.add(frontRightFogLightHousingBendDentMajor);
    frontSide.add(frontRightFogLightHousingBendDentMinor);
    frontSide.add(frontRightFogLightHousingCrackMajor);
    frontSide.add(frontRightFogLightHousingCrackMinor);
    frontSide.add(frontRightFogLightHousingPunchesOpenRepaired);
    frontSide.add(frontRightFogLightHousingRepaired);
    frontSide.add(frontRightFogLightHousingReplaced);
    frontSide.add(frontRightFogLightHousingCorrosionMajor);
    frontSide.add(frontRightFogLightHousingCorrosionMinor);
    frontSide.add(leftDrlBendDentMajor);
    frontSide.add(leftDrlBendDentMinor);
    frontSide.add(leftDrlCrackMajor);
    frontSide.add(leftDrlCrackMinor);
    frontSide.add(leftDrlPunchesOpenRepaired);
    frontSide.add(leftDrlRepaired);
    frontSide.add(leftDrlReplaced);
    frontSide.add(leftDrlCorrosionMajor);
    frontSide.add(leftDrlCorrosionMinor);
    frontSide.add(leftHeadlightAssemblyBendDentMajor);
    frontSide.add(leftHeadlightAssemblyBendDentMinor);
    frontSide.add(leftHeadlightAssemblyCrackMajor);
    frontSide.add(leftHeadlightAssemblyCrackMinor);
    frontSide.add(leftHeadlightAssemblyPunchesOpenRepaired);
    frontSide.add(leftHeadlightAssemblyRepaired);
    frontSide.add(leftHeadlightAssemblyReplaced);
    frontSide.add(leftHeadlightAssemblyCorrosionMajor);
    frontSide.add(leftHeadlightAssemblyCorrosionMinor);
    frontSide.add(leftHeadlightHousingBendDentMajor);
    frontSide.add(leftHeadlightHousingBendDentMinor);
    frontSide.add(leftHeadlightHousingCrackMajor);
    frontSide.add(leftHeadlightHousingCrackMinor);
    frontSide.add(leftHeadlightHousingPunchesOpenRepaired);
    frontSide.add(leftHeadlightHousingRepaired);
    frontSide.add(leftHeadlightHousingReplaced);
    frontSide.add(leftHeadlightHousingCorrosionMajor);
    frontSide.add(leftHeadlightHousingCorrosionMinor);
    frontSide.add(rightDrlBendDentMajor);
    frontSide.add(rightDrlBendDentMinor);
    frontSide.add(rightDrlCrackMajor);
    frontSide.add(rightDrlCrackMinor);
    frontSide.add(rightDrlPunchesOpenRepaired);
    frontSide.add(rightDrlRepaired);
    frontSide.add(rightDrlReplaced);
    frontSide.add(rightDrlCorrosionMajor);
    frontSide.add(rightDrlCorrosionMinor);
    frontSide.add(rightHeadlightAssemblyBendDentMajor);
    frontSide.add(rightHeadlightAssemblyBendDentMinor);
    frontSide.add(rightHeadlightAssemblyCrackMajor);
    frontSide.add(rightHeadlightAssemblyCrackMinor);
    frontSide.add(rightHeadlightAssemblyPunchesOpenRepaired);
    frontSide.add(rightHeadlightAssemblyRepaired);
    frontSide.add(rightHeadlightAssemblyReplaced);
    frontSide.add(rightHeadlightAssemblyCorrosionMajor);
    frontSide.add(rightHeadlightAssemblyCorrosionMinor);
    frontSide.add(rightHeadlightHousingBendDentMajor);
    frontSide.add(rightHeadlightHousingBendDentMinor);
    frontSide.add(rightHeadlightHousingCrackMajor);
    frontSide.add(rightHeadlightHousingCrackMinor);
    frontSide.add(rightHeadlightHousingPunchesOpenRepaired);
    frontSide.add(rightHeadlightHousingRepaired);
    frontSide.add(rightHeadlightHousingReplaced);
    frontSide.add(rightHeadlightHousingCorrosionMajor);
    frontSide.add(rightHeadlightHousingCorrosionMinor);
    frontSide.add(boltedRadiatorSupportBendDentMajor);
    frontSide.add(boltedRadiatorSupportBendDentMinor);
    frontSide.add(boltedRadiatorSupportCrackMajor);
    frontSide.add(boltedRadiatorSupportCrackMinor);
    frontSide.add(boltedRadiatorSupportCorrosionMajor);
    frontSide.add(boltedRadiatorSupportCorrosionMinor);
    frontSide.add(weldedRadiatorSupportBendDentMajor);
    frontSide.add(weldedRadiatorSupportBendDentMinor);
    frontSide.add(weldedRadiatorSupportCrackMajor);
    frontSide.add(weldedRadiatorSupportCrackMinor);
    frontSide.add(weldedRadiatorSupportCorrosionMajor);
    frontSide.add(weldedRadiatorSupportCorrosionMinor);
    frontSide.add(fibreRadiatorSupportCrackMajor);
    frontSide.add(fibreRadiatorSupportCrackMinor);
    frontSide.add(fibreRadiatorSupportRepaired);
    frontSide.add(frontLeftLegBendDentMajor);
    frontSide.add(frontLeftLegBendDentMinor);
    frontSide.add(frontLeftLegCrackMajor);
    frontSide.add(frontLeftLegCrackMinor);
    frontSide.add(frontLeftLegPunchesOpenRepaired);
    frontSide.add(frontLeftLegRepaired);
    frontSide.add(frontLeftLegReplaced);
    frontSide.add(frontLeftLegCorrosionMajor);
    frontSide.add(frontLeftLegCorrosionMinor);
    frontSide.add(frontRightLeftBendDentMajor);
    frontSide.add(frontRightLeftBendDentMinor);
    frontSide.add(frontRightLeftCrackMajor);
    frontSide.add(frontRightLeftCrackMinor);
    frontSide.add(frontRightLeftPunchesOpenRepaired);
    frontSide.add(frontRightLeftRepaired);
    frontSide.add(frontRightLeftReplaced);
    frontSide.add(frontRightLeftCorrosionMajor);
    frontSide.add(frontRightLeftCorrosionMinor);
    var trueBool = frontSide.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int interior1IssueCheck() {
    interior1.clear();
    interior1.add(acAssemblyLessEffective);
    interior1.add(acAssemblyNotWorking);
    interior1.add(acAssemblyNoise);
    interior1.add(airBagsDriverSide);
    interior1.add(airBagsPassengerSide);
    interior1.add(clusterPanelAssemblyEngineCheckLight);
    interior1.add(clusterPanelAssemblySpeedometer);
    interior1.add(clusterPanelAssemblyAbsLight);
    interior1.add(clusterPanelAssemblySrsLight);
    interior1.add(clusterPanelAssemblyAutomaticTransmissionLight);
    interior1.add(dashboardAssemblyAcVentWorking);
    interior1.add(dashboardAssemblyAcVentDamaged);
    interior1.add(dashboardAssemblyAcControlsWorking);
    interior1.add(dashboardAssemblyAcControlsDamaged);
    interior1.add(frontWindshieldGlassCrackMajor);
    interior1.add(frontWindshieldGlassCrackMinor);
    interior1.add(frontWindshieldGlassScratchesMajor);
    interior1.add(frontWindshieldGlassScratchesMinor);
    interior1.add(seatsDamageMajor);
    interior1.add(seatsDamageMinor);
    interior1.add(seatsAftermarketFitment);
    interior1.add(seatsElectronicSeat);
    var trueBool = interior1.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int interior2IssueCheck() {
    interior2.clear();
    interior2.add(audioStereoAssemblyBendDentMajor);
    interior2.add(audioStereoAssemblyCrackMajor);
    interior2.add(audioStereoAssemblyCrackMinor);
    interior2.add(audioStereoAssemblyCorrosionMajor);
    interior2.add(audioStereoAssemblyCorrosionMinor);
    interior2.add(audioStereoAssemblyHammerRepairedMajor);
    interior2.add(audioStereoAssemblyHammerRepairedMinor);
    interior2.add(audioStereoAssemblyPaintMisMatch);
    interior2.add(audioStereoAssemblyPunchesOpenRepaired);
    interior2.add(audioStereoAssemblyRepainted);
    interior2.add(audioStereoAssemblyReplaced);
    interior2.add(audioStereoAssemblyScratchesMajor);
    interior2.add(audioStereoAssemblyScratchesMinor);
    interior2.add(audioStereoAssemblyWrapping);
    interior2.add(centreConsoleAssemblyBendDentMajor);
    interior2.add(centreConsoleAssemblyCrackMajor);
    interior2.add(centreConsoleAssemblyCrackMinor);
    interior2.add(centreConsoleAssemblyCorrosionMajor);
    interior2.add(centreConsoleAssemblyCorrosionMinor);
    interior2.add(centreConsoleAssemblyHammerRepairedMajor);
    interior2.add(centreConsoleAssemblyHammerRepairedMinor);
    interior2.add(centreConsoleAssemblyPaintMisMatch);
    interior2.add(centreConsoleAssemblyPunchesOpenRepaired);
    interior2.add(centreConsoleAssemblyRepainted);
    interior2.add(centreConsoleAssemblyReplaced);
    interior2.add(centreConsoleAssemblyScratchesMajor);
    interior2.add(centreConsoleAssemblyScratchesMinor);
    interior2.add(centreConsoleAssemblyWrapping);
    interior2.add(forwardParkingSensorsBendDentMajor);
    interior2.add(forwardParkingSensorsCrackMajor);
    interior2.add(forwardParkingSensorsCrackMinor);
    interior2.add(forwardParkingSensorsCorrosionMajor);
    interior2.add(forwardParkingSensorsCorrosionMinor);
    interior2.add(forwardParkingSensorsHammerRepairedMajor);
    interior2.add(forwardParkingSensorsHammerRepairedMinor);
    interior2.add(forwardParkingSensorsPaintMisMatch);
    interior2.add(forwardParkingSensorsPunchesOpenRepaired);
    interior2.add(forwardParkingSensorsRepainted);
    interior2.add(forwardParkingSensorsReplaced);
    interior2.add(forwardParkingSensorsScratchesMajor);
    interior2.add(forwardParkingSensorsScratchesMinor);
    interior2.add(forwardParkingSensorsWrapping);
    interior2.add(frontLeftDoorAssemblyBendDentMajor);
    interior2.add(frontLeftDoorAssemblyCrackMajor);
    interior2.add(frontLeftDoorAssemblyCrackMinor);
    interior2.add(frontLeftDoorAssemblyCorrosionMajor);
    interior2.add(frontLeftDoorAssemblyCorrosionMinor);
    interior2.add(frontLeftDoorAssemblyHammerRepairedMajor);
    interior2.add(frontLeftDoorAssemblyHammerRepairedMinor);
    interior2.add(frontLeftDoorAssemblyPaintMisMatch);
    interior2.add(frontLeftDoorAssemblyPunchesOpenRepaired);
    interior2.add(frontLeftDoorAssemblyRepainted);
    interior2.add(frontLeftDoorAssemblyReplaced);
    interior2.add(frontLeftDoorAssemblyScratchesMajor);
    interior2.add(frontLeftDoorAssemblyScratchesMinor);
    interior2.add(frontLeftDoorAssemblyWrapping);
    interior2.add(frontRightDoorAssemblyBendDentMajor);
    interior2.add(frontRightDoorAssemblyCrackMajor);
    interior2.add(frontRightDoorAssemblyCrackMinor);
    interior2.add(frontRightDoorAssemblyCorrosionMajor);
    interior2.add(frontRightDoorAssemblyCorrosionMinor);
    interior2.add(frontRightDoorAssemblyHammerRepairedMajor);
    interior2.add(frontRightDoorAssemblyHammerRepairedMinor);
    interior2.add(frontRightDoorAssemblyPaintMisMatch);
    interior2.add(frontRightDoorAssemblyPunchesOpenRepaired);
    interior2.add(frontRightDoorAssemblyRepainted);
    interior2.add(frontRightDoorAssemblyReplaced);
    interior2.add(frontRightDoorAssemblyScratchesMajor);
    interior2.add(frontRightDoorAssemblyScratchesMinor);
    interior2.add(frontRightDoorAssemblyWrapping);
    interior2.add(reverseParkingCameraBendDentMajor);
    interior2.add(reverseParkingCameraCrackMajor);
    interior2.add(reverseParkingCameraCrackMinor);
    interior2.add(reverseParkingCameraCorrosionMajor);
    interior2.add(reverseParkingCameraCorrosionMinor);
    interior2.add(reverseParkingCameraHammerRepairedMajor);
    interior2.add(reverseParkingCameraHammerRepairedMinor);
    interior2.add(reverseParkingCameraPaintMisMatch);
    interior2.add(reverseParkingCameraPunchesOpenRepaired);
    interior2.add(reverseParkingCameraRepainted);
    interior2.add(reverseParkingCameraReplaced);
    interior2.add(reverseParkingCameraScratchesMajor);
    interior2.add(reverseParkingCameraScratchesMinor);
    interior2.add(reverseParkingCameraWrapping);
    interior2.add(reverseParkingSensorsBendDentMajor);
    interior2.add(reverseParkingSensorsCrackMajor);
    interior2.add(reverseParkingSensorsCrackMinor);
    interior2.add(reverseParkingSensorsCorrosionMajor);
    interior2.add(reverseParkingSensorsCorrosionMinor);
    interior2.add(reverseParkingSensorsHammerRepairedMajor);
    interior2.add(reverseParkingSensorsHammerRepairedMinor);
    interior2.add(reverseParkingSensorsPaintMisMatch);
    interior2.add(reverseParkingSensorsPunchesOpenRepaired);
    interior2.add(reverseParkingSensorsRepainted);
    interior2.add(reverseParkingSensorsReplaced);
    interior2.add(reverseParkingSensorsScratchesMajor);
    interior2.add(reverseParkingSensorsScratchesMinor);
    interior2.add(reverseParkingSensorsWrapping);
    var trueBool = interior2.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int leftSideIssueCheck() {
    leftSide.clear();
    leftSide.add(frontLeftExteriorBendDentMajor);
    leftSide.add(frontLeftExteriorBendDentMinor);
    leftSide.add(frontLeftExteriorCrackMajor);
    leftSide.add(frontLeftExteriorCrackMinor);
    leftSide.add(frontLeftExteriorCorrosionMajor);
    leftSide.add(frontLeftExteriorCorrosionMinor);
    leftSide.add(frontLeftExteriorPunchesOpenRepaired);
    leftSide.add(frontLeftExteriorRepaired);
    leftSide.add(frontLeftExteriorReplaced);
    leftSide.add(frontLeftMechanicalBendDentMajor);
    leftSide.add(frontLeftMechanicalCrackMajor);
    leftSide.add(frontLeftMechanicalCrackMinor);
    leftSide.add(frontLeftMechanicalCorrosionMajor);
    leftSide.add(frontLeftMechanicalCorrosionMinor);
    leftSide.add(frontLeftMechanicalHammerRepairedMajor);
    leftSide.add(frontLeftMechanicalHammerRepairedMinor);
    leftSide.add(frontLeftMechanicalPaintMisMatch);
    leftSide.add(frontLeftMechanicalPunchesOpenRepaired);
    leftSide.add(frontLeftMechanicalRepainted);
    leftSide.add(frontLeftMechanicalReplaced);
    leftSide.add(frontLeftMechanicalScratchesMajor);
    leftSide.add(frontLeftMechanicalScratchesMinor);
    leftSide.add(frontLeftMechanicalWrapping);
    leftSide.add(rearLeftExteriorBendDentMajor);
    leftSide.add(rearLeftExteriorBendDentMinor);
    leftSide.add(rearLeftExteriorCrackMajor);
    leftSide.add(rearLeftExteriorCrackMinor);
    leftSide.add(rearLeftExteriorCorrosionMajor);
    leftSide.add(rearLeftExteriorCorrosionMinor);
    leftSide.add(rearLeftExteriorPunchesOpenRepaired);
    leftSide.add(rearLeftExteriorRepaired);
    leftSide.add(rearLeftExteriorReplaced);
    leftSide.add(rearLeftMechanicalBendDentMajor);
    leftSide.add(rearLeftMechanicalBendDentMinor);
    leftSide.add(rearLeftMechanicalCrackMajor);
    leftSide.add(rearLeftMechanicalCrackMinor);
    leftSide.add(rearLeftMechanicalCorrosionMajor);
    leftSide.add(rearLeftMechanicalCorrosionMinor);
    leftSide.add(rearLeftMechanicalPunchesOpenRepaired);
    leftSide.add(rearLeftMechanicalRepaired);
    leftSide.add(rearLeftMechanicalReplaced);
    leftSide.add(leftFloorPanChannelBendDentMajor);
    leftSide.add(leftFloorPanChannelCrackMajor);
    leftSide.add(leftFloorPanChannelCrackMinor);
    leftSide.add(leftFloorPanChannelCorrosionMajor);
    leftSide.add(leftFloorPanChannelCorrosionMinor);
    leftSide.add(leftFloorPanChannelHammerRepairedMajor);
    leftSide.add(leftFloorPanChannelHammerRepairedMinor);
    leftSide.add(leftFloorPanChannelPaintMisMatch);
    leftSide.add(leftFloorPanChannelPunchesOpenRepaired);
    leftSide.add(leftFloorPanChannelRepainted);
    leftSide.add(leftFloorPanChannelReplaced);
    leftSide.add(leftFloorPanChannelScratchesMajor);
    leftSide.add(leftFloorPanChannelScratchesMinor);
    leftSide.add(leftFloorPanChannelWrapping);
    leftSide.add(leftPillarBBendDentMajor);
    leftSide.add(leftPillarBCrackMajor);
    leftSide.add(leftPillarBCrackMinor);
    leftSide.add(leftPillarBCorrosionMajor);
    leftSide.add(leftPillarBCorrosionMinor);
    leftSide.add(leftPillarBHammerRepairedMajor);
    leftSide.add(leftPillarBHammerRepairedMinor);
    leftSide.add(leftPillarBPaintMisMatch);
    leftSide.add(leftPillarBPunchesOpenRepaired);
    leftSide.add(leftPillarBRepainted);
    leftSide.add(leftPillarBReplaced);
    leftSide.add(leftPillarBScratchesMajor);
    leftSide.add(leftPillarBScratchesMinor);
    leftSide.add(leftPillarBWrapping);
    leftSide.add(leftPillarCBendDentMajor);
    leftSide.add(leftPillarCCrackMajor);
    leftSide.add(leftPillarCCrackMinor);
    leftSide.add(leftPillarCCorrosionMajor);
    leftSide.add(leftPillarCCorrosionMinor);
    leftSide.add(leftPillarCHammerRepairedMajor);
    leftSide.add(leftPillarCHammerRepairedMinor);
    leftSide.add(leftPillarCPaintMisMatch);
    leftSide.add(leftPillarCPunchesOpenRepaired);
    leftSide.add(leftPillarCRepainted);
    leftSide.add(leftPillarCReplaced);
    leftSide.add(leftPillarCScratchesMajor);
    leftSide.add(leftPillarCScratchesMinor);
    leftSide.add(leftPillarCWrapping);
    leftSide.add(leftRunningBoardCrack);
    leftSide.add(leftRunningBoardCorrosionMajor);
    leftSide.add(leftRunningBoardCorrosionMinor);
    leftSide.add(leftRunningBoardPaintDefective);
    leftSide.add(leftRunningBoardPaintMisMatch);
    leftSide.add(leftRunningBoardPunchesOpenRepaired);
    leftSide.add(leftRunningBoardRepainted);
    leftSide.add(leftRunningBoardReplaced);
    leftSide.add(rearLeftDoorChannelBendDentMajor);
    leftSide.add(rearLeftDoorChannelCrackMajor);
    leftSide.add(rearLeftDoorChannelCrackMinor);
    leftSide.add(rearLeftDoorChannelCorrosionMajor);
    leftSide.add(rearLeftDoorChannelCorrosionMinor);
    leftSide.add(rearLeftDoorChannelHammerRepairedMajor);
    leftSide.add(rearLeftDoorChannelHammerRepairedMinor);
    leftSide.add(rearLeftDoorChannelPaintMisMatch);
    leftSide.add(rearLeftDoorChannelPunchesOpenRepaired);
    leftSide.add(rearLeftDoorChannelRepainted);
    leftSide.add(rearLeftDoorChannelReplaced);
    leftSide.add(rearLeftDoorChannelScratchesMajor);
    leftSide.add(rearLeftDoorChannelScratchesMinor);
    leftSide.add(rearLeftDoorChannelWrapping);
    leftSide.add(rearLeftFloorPanBendDentMajor);
    leftSide.add(rearLeftFloorPanCrackMajor);
    leftSide.add(rearLeftFloorPanCrackMinor);
    leftSide.add(rearLeftFloorPanCorrosionMajor);
    leftSide.add(rearLeftFloorPanCorrosionMinor);
    leftSide.add(rearLeftFloorPanHammerRepairedMajor);
    leftSide.add(rearLeftFloorPanHammerRepairedMinor);
    leftSide.add(rearLeftFloorPanPaintMisMatch);
    leftSide.add(rearLeftFloorPanPunchesOpenRepaired);
    leftSide.add(rearLeftFloorPanRepainted);
    leftSide.add(rearLeftFloorPanReplaced);
    leftSide.add(rearLeftFloorPanScratchesMajor);
    leftSide.add(rearLeftFloorPanScratchesMinor);
    leftSide.add(rearLeftFloorPanWrapping);
    leftSide.add(rearLeftWheelHouseBendDentMajor);
    leftSide.add(rearLeftWheelHouseCrackMajor);
    leftSide.add(rearLeftWheelHouseCrackMinor);
    leftSide.add(rearLeftWheelHouseCorrosionMajor);
    leftSide.add(rearLeftWheelHouseCorrosionMinor);
    leftSide.add(rearLeftWheelHouseHammerRepairedMajor);
    leftSide.add(rearLeftWheelHouseHammerRepairedMinor);
    leftSide.add(rearLeftWheelHousePaintMisMatch);
    leftSide.add(rearLeftWheelHousePunchesOpenRepaired);
    leftSide.add(rearLeftWheelHouseRepainted);
    leftSide.add(rearLeftWheelHouseReplaced);
    leftSide.add(rearLeftWheelHouseScratchesMajor);
    leftSide.add(rearLeftWheelHouseScratchesMinor);
    leftSide.add(rearLeftWheelHouseWrapping);
    leftSide.add(leftFenderLiningBendDentMajor);
    leftSide.add(leftFenderLiningBendDentMinor);
    leftSide.add(leftFenderLiningCrackMajor);
    leftSide.add(leftFenderLiningCrackMinor);
    leftSide.add(leftFenderLiningCorrosionMajor);
    leftSide.add(leftFenderLiningCorrosionMinor);
    leftSide.add(leftFenderLiningPunchesOpenRepaired);
    leftSide.add(leftFenderLiningRepaired);
    leftSide.add(leftFenderLiningReplaced);
    leftSide.add(leftFenderPanelBendDentMajor);
    leftSide.add(leftFenderPanelBendDentMinor);
    leftSide.add(leftFenderPanelCrackMajor);
    leftSide.add(leftFenderPanelCrackMinor);
    leftSide.add(leftFenderPanelCorrosionMajor);
    leftSide.add(leftFenderPanelCorrosionMinor);
    leftSide.add(leftFenderPanelPunchesOpenRepaired);
    leftSide.add(leftFenderPanelRepaired);
    leftSide.add(leftFenderPanelReplaced);
    leftSide.add(leftSvmAssemblyBendDentMajor);
    leftSide.add(leftSvmAssemblyBendDentMinor);
    leftSide.add(leftSvmAssemblyCrackMajor);
    leftSide.add(leftSvmAssemblyCrackMinor);
    leftSide.add(leftSvmAssemblyCorrosionMajor);
    leftSide.add(leftSvmAssemblyCorrosionMinor);
    leftSide.add(leftSvmAssemblyPunchesOpenRepaired);
    leftSide.add(leftSvmAssemblyRepaired);
    leftSide.add(leftSvmAssemblyReplaced);
    leftSide.add(rearLeftDoorPanelBendDentMajor);
    leftSide.add(rearLeftDoorPanelBendDentMinor);
    leftSide.add(rearLeftDoorPanelCrackMajor);
    leftSide.add(rearLeftDoorPanelCrackMinor);
    leftSide.add(rearLeftDoorPanelCorrosionMajor);
    leftSide.add(rearLeftDoorPanelCorrosionMinor);
    leftSide.add(rearLeftDoorPanelPunchesOpenRepaired);
    leftSide.add(rearLeftDoorPanelRepaired);
    leftSide.add(rearLeftDoorPanelReplaced);
    var trueBool = leftSide.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int rearSideIssueCheck() {
    rearSide.clear();
    rearSide.add(dickeyDoorPanelBendDentMajor);
    rearSide.add(dickeyDoorPanelBendDentMinor);
    rearSide.add(dickeyDoorPanelCrackMajor);
    rearSide.add(dickeyDoorPanelCrackMinor);
    rearSide.add(dickeyDoorPanelCorrosionMajor);
    rearSide.add(dickeyDoorPanelCorrosionMinor);
    rearSide.add(dickeyDoorPanelHammerRepairedMajor);
    rearSide.add(dickeyDoorPanelHammerRepairedMinor);
    rearSide.add(dickeyDoorPanelPunchesOpenRepaired);
    rearSide.add(dickeyDoorPanelReplaced);
    rearSide.add(dickeyLeftStayRodShockerBendDentMajor);
    rearSide.add(dickeyLeftStayRodShockerBendDentMinor);
    rearSide.add(dickeyLeftStayRodShockerCrackMajor);
    rearSide.add(dickeyLeftStayRodShockerCrackMinor);
    rearSide.add(dickeyLeftStayRodShockerCorrosionMajor);
    rearSide.add(dickeyLeftStayRodShockerCorrosionMinor);
    rearSide.add(dickeyLeftStayRodShockerHammerRepairedMajor);
    rearSide.add(dickeyLeftStayRodShockerHammerRepairedMinor);
    rearSide.add(dickeyLeftStayRodShockerPunchesOpenRepaired);
    rearSide.add(dickeyLeftStayRodShockerReplaced);
    rearSide.add(dickeyRightStayRodShockerBendDentMajor);
    rearSide.add(dickeyRightStayRodShockerBendDentMinor);
    rearSide.add(dickeyRightStayRodShockerCrackMajor);
    rearSide.add(dickeyRightStayRodShockerCrackMinor);
    rearSide.add(dickeyRightStayRodShockerCorrosionMajor);
    rearSide.add(dickeyRightStayRodShockerCorrosionMinor);
    rearSide.add(dickeyRightStayRodShockerHammerRepairedMajor);
    rearSide.add(dickeyRightStayRodShockerHammerRepairedMinor);
    rearSide.add(dickeyRightStayRodShockerPunchesOpenRepaired);
    rearSide.add(dickeyRightStayRodShockerReplaced);
    rearSide.add(leftTailLightAssemblyBendDentMajor);
    rearSide.add(leftTailLightAssemblyCrackMajor);
    rearSide.add(leftTailLightAssemblyCrackMinor);
    rearSide.add(leftTailLightAssemblyCorrosionMajor);
    rearSide.add(leftTailLightAssemblyCorrosionMinor);
    rearSide.add(leftTailLightAssemblyHammerRepairedMajor);
    rearSide.add(leftTailLightAssemblyHammerRepairedMinor);
    rearSide.add(leftTailLightAssemblyPaintMisMatch);
    rearSide.add(leftTailLightAssemblyPunchesOpenRepaired);
    rearSide.add(leftTailLightAssemblyRepainted);
    rearSide.add(leftTailLightAssemblyReplaced);
    rearSide.add(leftTailLightAssemblyScratchesMajor);
    rearSide.add(leftTailLightAssemblyScratchesMinor);
    rearSide.add(leftTailLightAssemblyWrapping);
    rearSide.add(rearBumperPanelBendDentMajor);
    rearSide.add(rearBumperPanelCrackMajor);
    rearSide.add(rearBumperPanelCrackMinor);
    rearSide.add(rearBumperPanelCorrosionMajor);
    rearSide.add(rearBumperPanelCorrosionMinor);
    rearSide.add(rearBumperPanelHammerRepairedMajor);
    rearSide.add(rearBumperPanelHammerRepairedMinor);
    rearSide.add(rearBumperPanelPaintMisMatch);
    rearSide.add(rearBumperPanelPunchesOpenRepaired);
    rearSide.add(rearBumperPanelRepainted);
    rearSide.add(rearBumperPanelReplaced);
    rearSide.add(rearBumperPanelScratchesMajor);
    rearSide.add(rearBumperPanelScratchesMinor);
    rearSide.add(rearBumperPanelWrapping);
    rearSide.add(rearRegistrationPlateBendDentMajor);
    rearSide.add(rearRegistrationPlateCrackMajor);
    rearSide.add(rearRegistrationPlateCrackMinor);
    rearSide.add(rearRegistrationPlateCorrosionMajor);
    rearSide.add(rearRegistrationPlateCorrosionMinor);
    rearSide.add(rearRegistrationPlateHammerRepairedMajor);
    rearSide.add(rearRegistrationPlateHammerRepairedMinor);
    rearSide.add(rearRegistrationPlatePaintMisMatch);
    rearSide.add(rearRegistrationPlatePunchesOpenRepaired);
    rearSide.add(rearRegistrationPlateRepainted);
    rearSide.add(rearRegistrationPlateReplaced);
    rearSide.add(rearRegistrationPlateScratchesMajor);
    rearSide.add(rearRegistrationPlateScratchesMinor);
    rearSide.add(rearRegistrationPlateWrapping);
    rearSide.add(rearWindshieldGlassBendDentMajor);
    rearSide.add(rearWindshieldGlassCrackMajor);
    rearSide.add(rearWindshieldGlassCrackMinor);
    rearSide.add(rearWindshieldGlassCorrosionMajor);
    rearSide.add(rearWindshieldGlassCorrosionMinor);
    rearSide.add(rearWindshieldGlassHammerRepairedMajor);
    rearSide.add(rearWindshieldGlassHammerRepairedMinor);
    rearSide.add(rearWindshieldGlassPaintMisMatch);
    rearSide.add(rearWindshieldGlassPunchesOpenRepaired);
    rearSide.add(rearWindshieldGlassRepainted);
    rearSide.add(rearWindshieldGlassReplaced);
    rearSide.add(rearWindshieldGlassScratchesMajor);
    rearSide.add(rearWindshieldGlassScratchesMinor);
    rearSide.add(rearWindshieldGlassWrapping);
    rearSide.add(rightTailLightAssemblyBendDentMajor);
    rearSide.add(rightTailLightAssemblyCrackMajor);
    rearSide.add(rightTailLightAssemblyCrackMinor);
    rearSide.add(rightTailLightAssemblyCorrosionMajor);
    rearSide.add(rightTailLightAssemblyCorrosionMinor);
    rearSide.add(rightTailLightAssemblyHammerRepairedMajor);
    rearSide.add(rightTailLightAssemblyHammerRepairedMinor);
    rearSide.add(rightTailLightAssemblyPaintMisMatch);
    rearSide.add(rightTailLightAssemblyPunchesOpenRepaired);
    rearSide.add(rightTailLightAssemblyRepainted);
    rearSide.add(rightTailLightAssemblyReplaced);
    rearSide.add(rightTailLightAssemblyScratchesMajor);
    rearSide.add(rightTailLightAssemblyScratchesMinor);
    rearSide.add(rightTailLightAssemblyWrapping);
    rearSide.add(dickeyBackPanelBendDentMajor);
    rearSide.add(dickeyBackPanelBendDentMinor);
    rearSide.add(dickeyBackPanelCrackMajor);
    rearSide.add(dickeyBackPanelCrackMinor);
    rearSide.add(dickeyBackPanelCorrosionMajor);
    rearSide.add(dickeyBackPanelCorrosionMinor);
    rearSide.add(dickeyBackPanelHammerRepairedMajor);
    rearSide.add(dickeyBackPanelHammerRepairedMinor);
    rearSide.add(dickeyBackPanelPaintMisMatch);
    rearSide.add(dickeyBackPanelPunchesOpenRepaired);
    rearSide.add(dickeyBackPanelReplaced);
    rearSide.add(dickeyFloorBendDentMajor);
    rearSide.add(dickeyFloorBendDentMinor);
    rearSide.add(dickeyFloorCrackMajor);
    rearSide.add(dickeyFloorCrackMinor);
    rearSide.add(dickeyFloorCorrosionMajor);
    rearSide.add(dickeyFloorCorrosionMinor);
    rearSide.add(dickeyFloorHammerRepairedMajor);
    rearSide.add(dickeyFloorHammerRepairedMinor);
    rearSide.add(dickeyFloorPaintMisMatch);
    rearSide.add(dickeyFloorPunchesOpenRepaired);
    rearSide.add(dickeyFloorReplaced);
    rearSide.add(dickeyLeftLegBendDentMajor);
    rearSide.add(dickeyLeftLegBendDentMinor);
    rearSide.add(dickeyLeftLegCrackMajor);
    rearSide.add(dickeyLeftLegCrackMinor);
    rearSide.add(dickeyLeftLegCorrosionMajor);
    rearSide.add(dickeyLeftLegCorrosionMinor);
    rearSide.add(dickeyLeftLegHammerRepairedMajor);
    rearSide.add(dickeyLeftLegHammerRepairedMinor);
    rearSide.add(dickeyLeftLegPaintMisMatch);
    rearSide.add(dickeyLeftLegPunchesOpenRepaired);
    rearSide.add(dickeyLeftLegRepaired);
    rearSide.add(dickeyLeftLegReplaced);
    rearSide.add(dickeyRightLegBendDentMajor);
    rearSide.add(dickeyRightLegBendDentMinor);
    rearSide.add(dickeyRightLegCrackMajor);
    rearSide.add(dickeyRightLegCrackMinor);
    rearSide.add(dickeyRightLegCorrosionMajor);
    rearSide.add(dickeyRightLegCorrosionMinor);
    rearSide.add(dickeyRightLegHammerRepairedMajor);
    rearSide.add(dickeyRightLegHammerRepairedMinor);
    rearSide.add(dickeyRightLegPaintMisMatch);
    rearSide.add(dickeyRightLegPunchesOpenRepaired);
    rearSide.add(dickeyRightLegRepaired);
    rearSide.add(dickeyRightLegReplaced);
    rearSide.add(leftDickeySidewallBendDentMajor);
    rearSide.add(leftDickeySidewallBendDentMinor);
    rearSide.add(leftDickeySidewallCrackMajor);
    rearSide.add(leftDickeySidewallCrackMinor);
    rearSide.add(leftDickeySidewallCorrosionMajor);
    rearSide.add(leftDickeySidewallCorrosionMinor);
    rearSide.add(leftDickeySidewallPunchesOpenRepaired);
    rearSide.add(leftDickeySidewallSealantMissingCrackRepaired);
    rearSide.add(leftDickeySidewallReplaced);
    rearSide.add(rightDickeySidewallBendDentMajor);
    rearSide.add(rightDickeySidewallBendDentMinor);
    rearSide.add(rightDickeySidewallCrackMajor);
    rearSide.add(rightDickeySidewallCrackMinor);
    rearSide.add(rightDickeySidewallCorrosionMajor);
    rearSide.add(rightDickeySidewallCorrosionMinor);
    rearSide.add(rightDickeySidewallPunchesOpenRepaired);
    rearSide.add(rightDickeySidewallSealantMissingCrackRepaired);
    rearSide.add(rightDickeySidewallReplaced);
    rearSide.add(leftDickeyStrutTowerBendDentMajor);
    rearSide.add(leftDickeyStrutTowerBendDentMinor);
    rearSide.add(leftDickeyStrutTowerCrackMajor);
    rearSide.add(leftDickeyStrutTowerCrackMinor);
    rearSide.add(leftDickeyStrutTowerCorrosionMajor);
    rearSide.add(leftDickeyStrutTowerCorrosionMinor);
    rearSide.add(leftDickeyStrutTowerPunchesOpenRepaired);
    rearSide.add(leftDickeyStrutTowerSealantMissingCrackRepaired);
    rearSide.add(leftDickeyStrutTowerReplaced);
    rearSide.add(rightDickeyStrutTowerBendDentMajor);
    rearSide.add(rightDickeyStrutTowerBendDentMinor);
    rearSide.add(rightDickeyStrutTowerCrackMajor);
    rearSide.add(rightDickeyStrutTowerCrackMinor);
    rearSide.add(rightDickeyStrutTowerCorrosionMajor);
    rearSide.add(rightDickeyStrutTowerCorrosionMinor);
    rearSide.add(rightDickeyStrutTowerPunchesOpenRepaired);
    rearSide.add(rightDickeyStrutTowerSealantMissingCrackRepaired);
    rearSide.add(rightDickeyStrutTowerReplaced);
    rearSide.add(roofPanelAftermarketDualTonePaint);
    rearSide.add(roofPanelAftermarketSunroofFitment);
    rearSide.add(roofPanelMultipleDentsDentMajor);
    rearSide.add(roofPanelMultipleDentsDentMinor);
    rearSide.add(roofPanelCorrosionMajor);
    rearSide.add(roofPanelCorrosionMinor);
    rearSide.add(roofPanelExternalHoleTear);
    rearSide.add(roofPanelPaintDefective);
    rearSide.add(roofPanelPaintMisMatch);
    rearSide.add(roofPanelRepainted);
    rearSide.add(roofPanelRepaired);
    rearSide.add(roofPanelScratchesMajor);
    rearSide.add(roofPanelScratchesMinor);
    rearSide.add(roofPanelSealantMissing);
    rearSide.add(roofPanelWrapping);
    rearSide.add(roofPanelReplaced);
    rearSide.add(spareTyreAvailable);
    var trueBool = rearSide.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int rightSideIssueCheck() {
    rightSide.clear();
    rightSide.add(frontRightDoorPanelBendDentMajor);
    rightSide.add(frontRightDoorPanelBendDentMinor);
    rightSide.add(frontRightDoorPanelCrackMajor);
    rightSide.add(frontRightDoorPanelCrackMinor);
    rightSide.add(frontRightDoorPanelCorrosionMajor);
    rightSide.add(frontRightDoorPanelCorrosionMinor);
    rightSide.add(frontRightDoorPanelPunchesOpenRepaired);
    rightSide.add(frontRightDoorPanelRepaired);
    rightSide.add(frontRightDoorPanelReplaced);
    rightSide.add(rightFenderLiningBendDentMajor);
    rightSide.add(rightFenderLiningBendDentMinor);
    rightSide.add(rightFenderLiningCrackMajor);
    rightSide.add(rightFenderLiningCrackMinor);
    rightSide.add(rightFenderLiningCorrosionMajor);
    rightSide.add(rightFenderLiningCorrosionMinor);
    rightSide.add(rightFenderLiningPunchesOpenRepaired);
    rightSide.add(rightFenderLiningRepaired);
    rightSide.add(rightFenderLiningReplaced);
    rightSide.add(rightFenderPanelBendDentMajor);
    rightSide.add(rightFenderPanelBendDentMinor);
    rightSide.add(rightFenderPanelCrackMajor);
    rightSide.add(rightFenderPanelCrackMinor);
    rightSide.add(rightFenderPanelCorrosionMajor);
    rightSide.add(rightFenderPanelCorrosionMinor);
    rightSide.add(rightFenderPanelPunchesOpenRepaired);
    rightSide.add(rightFenderPanelRepaired);
    rightSide.add(rightFenderPanelReplaced);
    rightSide.add(rightSvmAssemblyBendDentMajor);
    rightSide.add(rightSvmAssemblyBendDentMinor);
    rightSide.add(rightSvmAssemblyCrackMajor);
    rightSide.add(rightSvmAssemblyCrackMinor);
    rightSide.add(rightSvmAssemblyCorrosionMajor);
    rightSide.add(rightSvmAssemblyCorrosionMinor);
    rightSide.add(rightSvmAssemblyPunchesOpenRepaired);
    rightSide.add(rightSvmAssemblyRepaired);
    rightSide.add(rightSvmAssemblyReplaced);
    rightSide.add(frontRightMechanicalExhaustSystem);
    rightSide.add(frontWheelDriveBendDentMajor);
    rightSide.add(frontWheelDriveBendDentMinor);
    rightSide.add(frontWheelDriveCrackMajor);
    rightSide.add(frontWheelDriveCrackMinor);
    rightSide.add(frontWheelDriveCorrosionMajor);
    rightSide.add(frontWheelDriveCorrosionMinor);
    rightSide.add(frontWheelDrivePunchesOpenRepaired);
    rightSide.add(frontWheelDriveRepaired);
    rightSide.add(frontWheelDriveReplaced);
    rightSide.add(fourWheelDriveBendDentMajor);
    rightSide.add(fourWheelDriveBendDentMinor);
    rightSide.add(fourWheelDriveCrackMajor);
    rightSide.add(fourWheelDriveCrackMinor);
    rightSide.add(fourWheelDriveCorrosionMajor);
    rightSide.add(fourWheelDriveCorrosionMinor);
    rightSide.add(fourWheelDriveHammerRepairedMajor);
    rightSide.add(fourWheelDriveHammerRepairedMinor);
    rightSide.add(fourWheelDrivePunchesOpenRepaired);
    rightSide.add(fourWheelDriveRepaired);
    rightSide.add(fourWheelDriveReplaced);
    rightSide.add(frontRightBrakeAssemblyBendDentMajor);
    rightSide.add(frontRightBrakeAssemblyBendDentMinor);
    rightSide.add(frontRightBrakeAssemblyCrackMajor);
    rightSide.add(frontRightBrakeAssemblyCrackMinor);
    rightSide.add(frontRightBrakeAssemblyCorrosionMajor);
    rightSide.add(frontRightBrakeAssemblyCorrosionMinor);
    rightSide.add(frontRightBrakeAssemblyHammerRepairedMajor);
    rightSide.add(frontRightBrakeAssemblyHammerRepairedMinor);
    rightSide.add(frontRightBrakeAssemblyPunchesOpenRepaired);
    rightSide.add(frontRightBrakeAssemblyRepaired);
    rightSide.add(frontRightBrakeAssemblyReplaced);
    rightSide.add(frontRightTyreAssemblyBendDentMajor);
    rightSide.add(frontRightTyreAssemblyBendDentMinor);
    rightSide.add(frontRightTyreAssemblyCrackMajor);
    rightSide.add(frontRightTyreAssemblyCrackMinor);
    rightSide.add(frontRightTyreAssemblyCorrosionMajor);
    rightSide.add(frontRightTyreAssemblyCorrosionMinor);
    rightSide.add(frontRightTyreAssemblyHammerRepairedMajor);
    rightSide.add(frontRightTyreAssemblyHammerRepairedMinor);
    rightSide.add(frontRightTyreAssemblyPunchesOpenRepaired);
    rightSide.add(frontRightTyreAssemblyRepaired);
    rightSide.add(frontRightTyreAssemblyReplaced);
    rightSide.add(frontRightSuspensionFrontJumpingRodAssembly);
    rightSide.add(frontRightSuspensionFrontRightLinkRod);
    rightSide.add(frontRightSuspensionFrontRightLowerControlArmAssembly);
    rightSide.add(frontRightSuspensionFrontRightStrutAssembly);
    rightSide.add(rightMechanicalBendDentMajor);
    rightSide.add(rightMechanicalBendDentMinor);
    rightSide.add(rightMechanicalCrackMajor);
    rightSide.add(rightMechanicalCrackMinor);
    rightSide.add(rightMechanicalCorrosionMajor);
    rightSide.add(rightMechanicalCorrosionMinor);
    rightSide.add(rightMechanicalHammerRepairedMajor);
    rightSide.add(rightMechanicalHammerRepairedMinor);
    rightSide.add(rightMechanicalPaintMisMatch);
    rightSide.add(rightMechanicalPunchesOpenRepaired);
    rightSide.add(rightMechanicalRepainted);
    rightSide.add(rightMechanicalReplaced);
    rightSide.add(rightMechanicalScratchesMajor);
    rightSide.add(rightMechanicalScratchesMinor);
    rightSide.add(rightMechanicalWrapping);
    rightSide.add(rearRightDoorChannelBendDentMajor);
    rightSide.add(rearRightDoorChannelBendDentMinor);
    rightSide.add(rearRightDoorChannelCrackMajor);
    rightSide.add(rearRightDoorChannelCrackMinor);
    rightSide.add(rearRightDoorChannelCorrosionMajor);
    rightSide.add(rearRightDoorChannelCorrosionMinor);
    rightSide.add(rearRightDoorChannelHammerRepairedMajor);
    rightSide.add(rearRightDoorChannelHammerRepairedMinor);
    rightSide.add(rearRightDoorChannelPaintMisMatch);
    rightSide.add(rearRightDoorChannelPunchesOpenRepaired);
    rightSide.add(rearRightDoorChannelRepainted);
    rightSide.add(rearRightDoorChannelReplaced);
    rightSide.add(rearRightDoorChannelScratchesMajor);
    rightSide.add(rearRightDoorChannelScratchesMinor);
    rightSide.add(rearRightDoorChannelWrapping);
    rightSide.add(rearRightFloorPanBendDentMajor);
    rightSide.add(rearRightFloorPanBendDentMinor);
    rightSide.add(rearRightFloorPanCrackMajor);
    rightSide.add(rearRightFloorPanCrackMinor);
    rightSide.add(rearRightFloorPanCorrosionMajor);
    rightSide.add(rearRightFloorPanCorrosionMinor);
    rightSide.add(rearRightFloorPanHammerRepairedMajor);
    rightSide.add(rearRightFloorPanHammerRepairedMinor);
    rightSide.add(rearRightFloorPanPaintMisMatch);
    rightSide.add(rearRightFloorPanPunchesOpenRepaired);
    rightSide.add(rearRightFloorPanRepainted);
    rightSide.add(rearRightFloorPanReplaced);
    rightSide.add(rearRightFloorPanScratchesMajor);
    rightSide.add(rearRightFloorPanScratchesMinor);
    rightSide.add(rearRightFloorPanWrapping);
    rightSide.add(rearRightWheelHouseBendDentMajor);
    rightSide.add(rearRightWheelHouseBendDentMinor);
    rightSide.add(rearRightWheelHouseCrackMajor);
    rightSide.add(rearRightWheelHouseCrackMinor);
    rightSide.add(rearRightWheelHouseCorrosionMajor);
    rightSide.add(rearRightWheelHouseCorrosionMinor);
    rightSide.add(rearRightWheelHouseHammerRepairedMajor);
    rightSide.add(rearRightWheelHouseHammerRepairedMinor);
    rightSide.add(rearRightWheelHousePaintMisMatch);
    rightSide.add(rearRightWheelHousePunchesOpenRepaired);
    rightSide.add(rearRightWheelHouseRepainted);
    rightSide.add(rearRightWheelHouseReplaced);
    rightSide.add(rearRightWheelHouseScratchesMajor);
    rightSide.add(rearRightWheelHouseScratchesMinor);
    rightSide.add(rearRightWheelHouseWrapping);
    rightSide.add(rightFloorPanChannelBendDentMajor);
    rightSide.add(rightFloorPanChannelBendDentMinor);
    rightSide.add(rightFloorPanChannelCrackMajor);
    rightSide.add(rightFloorPanChannelCrackMinor);
    rightSide.add(rightFloorPanChannelCorrosionMajor);
    rightSide.add(rightFloorPanChannelCorrosionMinor);
    rightSide.add(rightFloorPanChannelHammerRepairedMajor);
    rightSide.add(rightFloorPanChannelHammerRepairedMinor);
    rightSide.add(rightFloorPanChannelPaintMisMatch);
    rightSide.add(rightFloorPanChannelPunchesOpenRepaired);
    rightSide.add(rightFloorPanChannelRepainted);
    rightSide.add(rightFloorPanChannelReplaced);
    rightSide.add(rightFloorPanChannelScratchesMajor);
    rightSide.add(rightFloorPanChannelScratchesMinor);
    rightSide.add(rightFloorPanChannelWrapping);
    rightSide.add(rightPillarBBendDentMajor);
    rightSide.add(rightPillarBBendDentMinor);
    rightSide.add(rightPillarBCrackMajor);
    rightSide.add(rightPillarBCrackMinor);
    rightSide.add(rightPillarBCorrosionMajor);
    rightSide.add(rightPillarBCorrosionMinor);
    rightSide.add(rightPillarBHammerRepairedMajor);
    rightSide.add(rightPillarBHammerRepairedMinor);
    rightSide.add(rightPillarBPaintMisMatch);
    rightSide.add(rightPillarBPunchesOpenRepaired);
    rightSide.add(rightPillarBRepainted);
    rightSide.add(rightPillarBReplaced);
    rightSide.add(rightPillarBScratchesMajor);
    rightSide.add(rightPillarBScratchesMinor);
    rightSide.add(rightPillarBWrapping);
    rightSide.add(rightPillarCBendDentMajor);
    rightSide.add(rightPillarCBendDentMinor);
    rightSide.add(rightPillarCCrackMajor);
    rightSide.add(rightPillarCCrackMinor);
    rightSide.add(rightPillarCCorrosionMajor);
    rightSide.add(rightPillarCCorrosionMinor);
    rightSide.add(rightPillarCHammerRepairedMajor);
    rightSide.add(rightPillarCHammerRepairedMinor);
    rightSide.add(rightPillarCPaintMisMatch);
    rightSide.add(rightPillarCPunchesOpenRepaired);
    rightSide.add(rightPillarCRepainted);
    rightSide.add(rightPillarCReplaced);
    rightSide.add(rightPillarCScratchesMajor);
    rightSide.add(rightPillarCScratchesMinor);
    rightSide.add(rightPillarCWrapping);
    rightSide.add(rightRunningBoardCrack);
    rightSide.add(rightRunningBoardCorrosionMajor);
    rightSide.add(rightRunningBoardCorrosionMinor);
    rightSide.add(rightRunningBoardPaintDefective);
    rightSide.add(rightRunningBoardPaintMisMatch);
    rightSide.add(rightRunningBoardPunchesOpenRepaired);
    rightSide.add(rightRunningBoardRepainted);
    rightSide.add(rightRunningBoardReplaced);
    var trueBool = rightSide.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  int testDriveIssueCheck() {
    testDrive.clear();
    testDrive.add(testDriveSteeringHealth);
    testDrive.add(testDriveClutchPedalVibration);
    testDrive.add(testDriveNoiseFromTurbocharger);
    testDrive.add(testDriveFrontBrakeNoiseVibration);
    testDrive.add(testDriveIdleStartStopNotWorking);
    testDrive.add(testDriveRearBrakeNoiseVibration);
    var trueBool = testDrive.where((element) => element == false);
    setState(() {});
    return trueBool.length;
  }

  // // // Load existing data if serialNumber is provided
  // void _loadCarData() async {
  //   setState(() {
  //     _mfgYearMonthController.text = widget.carDetails.manfYear.toString();
  //     _carMakeController.text = widget.carDetails.brand.toString();
  //     _carModelController.text = widget.carDetails.model.toString();
  //     _fuelTypeController.text = widget.carDetails.fuelType.toString();
  //     _transmissionController.text = widget.carDetails.transmission.toString();
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Returning false disables the back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inspection'),
          automaticallyImplyLeading: false,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildCarDetailsPage(), // Car Details Page
            _buildNewInspectionPage(), // Inspection Page
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Car Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Inspection',
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the Car Details section
  Widget _buildCarDetailsPage() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCardExpansionTile('RC Details', [
            _buildTextField(
              _rcNumberController,
              'RC Number',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Your RC Number';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    if (selectedRcImage == null) {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        setState(() {
                          _selectedRcImage = File(image.path);
                        });
                        final result = await uploadImage(
                          imageVar: image,
                          imageRef:
                              'inspection/${widget.carDetails.serialNumber}/car_doc/rc_details',
                        );
                        if (result.isNotEmpty) {
                          setState(() {
                            selectedRcImage = result.toString();
                            log("message ${selectedRcImage}");
                          });
                        }
                      }
                    }
                  },
                  child: _selectedRcImage != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_selectedRcImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: const Center(
                            child: Text(
                              "Upload Image",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ]),
          _buildCardExpansionTile('Car Details', [
            _buildTextField(
              _mfgYearMonthController,
              'Manufacturing Year/Month',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Manufacturing Year/Month';
                }
                return null;
              },
            ),
            _buildTextField(
              _carMakeController,
              'Car Make',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Car Make';
                }
                return null;
              },
            ),
            _buildTextField(
              _carModelController,
              'Car Model',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Car Model';
                }
                return null;
              },
            ),
            _buildTextField(
              _fuelTypeController,
              'Fuel Type',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Fuel Type';
                }
                return null;
              },
            ),
            _buildTextField(
              _transmissionController,
              'Transmission Type',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Transmission Type';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    if (selectedCarImage == null) {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        setState(() {
                          _selectedCarImage = File(image.path);
                        });
                        final result = await uploadImage(
                          imageVar: image,
                          imageRef:
                              'inspection/${widget.carDetails.serialNumber}/car_doc/car_details',
                        );
                        if (result.isNotEmpty) {
                          setState(() {
                            selectedCarImage = result.toString();
                            log("message ${selectedCarImage}");
                          });
                        }
                      }
                    }
                  },
                  child: _selectedCarImage != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_selectedCarImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: const Center(
                            child: Text(
                              "Upload Image",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ]),
          _buildCardExpansionTile('Other Details', [
            _buildTextField(
              _ownersController,
              'Number of Owners',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Number of Owners';
                }
                return null;
              },
              isNumber: true,
            ),
            _buildTextField(
              _numberOfKeyController,
              'Number of Keys',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Number of Keys';
                }
                return null;
              },
            ),
            _buildTextField(
              _engineNumberController,
              'Engine Number',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Engine Number';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: const Text(
                'Chassis Number OK',
              ),
              value: _isChassisNumberOk,
              onChanged: (val) {
                setState(() {
                  _isChassisNumberOk = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    if (selectedChassisNumberImage == null) {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        setState(() {
                          _selectedChassisNumberImage = File(image.path);
                        });
                        final result = await uploadImage(
                          imageVar: image,
                          imageRef:
                              'inspection/${widget.carDetails.serialNumber}/car_doc/other_details/chassis_number_image/',
                        );
                        if (result.isNotEmpty) {
                          setState(() {
                            selectedChassisNumberImage = result.toString();
                            log("message ${selectedChassisNumberImage}");
                          });
                        }
                      }
                    }
                  },
                  child: _selectedChassisNumberImage != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_selectedChassisNumberImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: const Center(
                            child: Text(
                              "Upload Image",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SwitchListTile(
              title: const Text(
                'HSRP Available',
              ),
              value: _hsrpAvailable,
              onChanged: (val) {
                setState(() {
                  _hsrpAvailable = val;
                });
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: _selectedOtherImages.length + 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _selectedOtherImages.length <= index
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () async {
                                  _pickImage();
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Upload Image",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedOtherImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ]),
          _buildCardExpansionTile('Registration Details', [
            _buildTextField(
              _registrationYearMonthController,
              'Registration Year/Month',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Registration Year/Month';
                }
                return null;
              },
              isNumber: true,
            ),
          ]),
          ElevatedButton(
            onPressed: () {
              if (_rcNumberController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Your RC Number");
              } else if (_selectedRcImage == null) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please selcted rc image");
              } else if (_mfgYearMonthController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Enter Manufacturing Year/Month");
              } else if (_carMakeController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Car Make");
              } else if (_carModelController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Car Model");
              } else if (_fuelTypeController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Fuel Type");
              } else if (_transmissionController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Transmission Type");
              } else if (_selectedCarImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted car details image");
              } else if (_ownersController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Number of Owners");
              } else if (_numberOfKeyController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Number of Keys");
              } else if (_engineNumberController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Engine Number");
              } else if (_selectedChassisNumberImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted chassis number image");
              } else if (_selectedOtherImages.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please selcted other image");
              } else if (_registrationYearMonthController.text.isEmpty) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Enter Registration Year/Month");
              }
              if (_formKey.currentState!.validate()) {
                _saveCarDetails();
              }
            },
            child: const Text('Save Car Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<File> imageList,
    TextEditingController commentsController,
    Function(List<File>, String) onPickImage,
  ) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.keyboard_arrow_down),
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageList.length + 1,
            itemBuilder: (context, index) {
              if (index == imageList.length && imageList.length < 15) {
                return GestureDetector(
                  onTap: () => onPickImage(imageList,
                      title), // Pass the image list and section title
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text("Add Image"),
                    ),
                  ),
                );
              } else if (index < imageList.length) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(imageList[index]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: commentsController,
          decoration: InputDecoration(
            labelText: "$title Remarks",
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // void _showSuccessDialog(BuildContext context, String message) {
  //   print('success dialog');
  //   showDialog(
  //     context: context,
  //     barrierDismissible:
  //         false, // Prevents closing the dialog by tapping outside
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Row(
  //           children: [
  //             Icon(
  //               Icons.check_circle, // Tick icon
  //               color: Colors.green,
  //             ),
  //             SizedBox(width: 10),
  //             Text("Success"),
  //           ],
  //         ),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildNewInspectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpandableSection(
            title: "Interior",
            images: _interiorImages,
            commentsController: _interiorCommentsController,
            onPickImage: _pickImage,
            isExpanded: _isInteriorExpanded,
            onToggle: () {
              setState(() {
                _isInteriorExpanded = !_isInteriorExpanded;
              });
            },
          ),
          _buildExpandableSection(
            title: "Exterior",
            images: _exteriorImages,
            commentsController: _exteriorCommentsController,
            onPickImage: _pickImage,
            isExpanded: _isExteriorExpanded,
            onToggle: () {
              setState(() {
                _isExteriorExpanded = !_isExteriorExpanded;
              });
            },
          ),
          _buildExpandableSection(
            title: "Extra",
            images: _extraImages,
            commentsController: _extraCommentsController,
            onPickImage: _pickImage,
            isExpanded: _isExtraExpanded,
            onToggle: () {
              setState(() {
                _isExtraExpanded = !_isExtraExpanded;
              });
            },
          ),
          _buildExpandableSection(
            title: "Test Drive",
            images: _testDriveImages,
            commentsController: _testDriveCommentsController,
            onPickImage: _pickImage,
            isExpanded: _isTestDriveExpanded,
            onToggle: () {
              setState(() {
                _isTestDriveExpanded = !_isTestDriveExpanded;
              });
            },
          ),
          _isUploading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () {
                    // Validate that each section has at least one image and remarks
                    if (_interiorImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please capture at least one image in the Interior Section."),
                        ),
                      );
                      return;
                    }
                    if (_interiorCommentsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please enter remarks for the Interior Section."),
                        ),
                      );
                      return;
                    }
                    if (_exteriorImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please capture at least one image in the Exterior Section."),
                        ),
                      );
                      return;
                    }
                    if (_exteriorCommentsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please enter remarks for the Exterior Section."),
                        ),
                      );
                      return;
                    }
                    if (_extraImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please capture at least one image in the Extra Section."),
                        ),
                      );
                      return;
                    }
                    if (_extraCommentsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please enter remarks for the Extra Section."),
                        ),
                      );
                      return;
                    }
                    // Validate Test Drive section
                    if (_testDriveImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please capture at least one image in the Test Drive Section."),
                        ),
                      );
                      return;
                    }
                    if (_testDriveCommentsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please enter remarks for the Test Drive Section."),
                        ),
                      );
                      return;
                    }
                    // Open remarks options modal
                    _showRemarksOptions(context);
                  },
                  child: Text('Save Inspection Details'),
                ),
        ],
      ),
    );
  }

  void _showRemarksOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // This makes sure the modal adjusts with the keyboard
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjusts for keyboard height
            ),
            child: Form(
              key: _formBottomKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Remarks TextField
                    _buildTextField(
                      _reMarksController,
                      'Remark',
                      (value) {
                        if (value!.isEmpty) {
                          return 'Enter Remark';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Submit Button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isUploading // Prevents multiple taps
                              ? null // Disable button when uploading
                              : () async {
                                  if (_formBottomKey.currentState!.validate()) {
                                    // Set uploading state to true
                                    setState(() {
                                      _isUploading = true;
                                    });

                                    // Get the serial number (replace with your logic)
                                    String serialNumber = widget
                                        .carDetails.serialNumber
                                        .toString(); // Replace with actual serial number

                                    try {
                                      // Save remark to Realtime Database
                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child(
                                              'inspection/$serialNumber/remark')
                                          .set(_reMarksController.text);

                                      // Update the lead status to 4
                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child(
                                              'leads/$serialNumber/leadStatus')
                                          .set(4); // Change leadStatus to 4

                                      // Save data for each section
                                      await _saveSectionData(
                                          "interior",
                                          _interiorImages,
                                          _interiorCommentsController);
                                      await _saveSectionData(
                                          "exterior",
                                          _exteriorImages,
                                          _exteriorCommentsController);
                                      await _saveSectionData(
                                          "extra",
                                          _extraImages,
                                          _extraCommentsController);

                                      // Show success notification
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Inspection done successfully!"),
                                          duration: Duration(
                                              seconds:
                                                  8), // Display for 8 seconds
                                        ),
                                      );

                                      // Wait for the Snackbar to be dismissed (optional)
                                      await Future.delayed(Duration(
                                          seconds: 8)); // Optional delay

                                      // Navigate back to the homepage
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    } catch (e) {
                                      // Handle errors
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Error saving inspection data: $e"),
                                        ),
                                      );
                                    } finally {
                                      // Reset uploading state
                                      setState(() {
                                        _isUploading =
                                            false; // End uploading state
                                      });
                                    }
                                  }
                                },
                          child: const Text('Submit'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // void _showReMarksOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled:
  //         true, // This makes sure the modal adjusts with the keyboard
  //     builder: (context) {
  //       return SingleChildScrollView(
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context)
  //                 .viewInsets
  //                 .bottom, // Adjusts for keyboard height
  //           ),
  //           child: Form(
  //             key: _formBottomKey,
  //             child: Container(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // First TextField
  //                   const SizedBox(height: 14.0),
  //                   _buildTextField(
  //                     _reMarksController,
  //                     'Remark',
  //                     (value) {
  //                       if (value!.isEmpty) {
  //                         return 'Enter Remark';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 16.0),

  //                   // Submit Button
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         if (_formBottomKey.currentState!.validate()) {
  //                           _saveCarInspection();
  //                         }
  //                       },
  //                       child: const Text('Submit'),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _saveCarInspection() {
    // Here you would handle the logic to save the remarks
    // For example:
    String remarks = _reMarksController.text;

    // Assuming you want to save remarks associated with the current section
    // Save or process the remarks according to your needs
    // You can also validate or show messages as needed

    // After saving remarks, proceed to save the inspection data
    // Call a method to save all sections data
    _saveInspectionData();

    // Close the modal after saving
    Navigator.pop(context);
  }

  // Helper method to create text fields
  Widget _buildTextField(TextEditingController controller, String labelText,
      String? Function(String?)? validator,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        onChanged: (value) {
          setState(() {});
        },
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: labelText),
      ),
    );
  }

  // Helper method to create sections with an expandable tile
  Widget _buildExpansionSubTile(
    String title,
    List<Widget> children,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // No border radius
          side: BorderSide.none, // No border
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        children: children,
      ),
    );
  }

  // Helper method to create sections with an expandable tile
  Widget _buildExpansionTile(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // No border radius
          side: BorderSide.none, // No border
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        children: children,
      ),
    );
  }

  // Helper method to create sections with an expandable tile
  Widget _buildCardExpansionTile(String title, List<Widget> children,
      {int? count = 0}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Circular border radius
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // No border radius
              side: BorderSide.none, // No border
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                count == 0
                    ? SizedBox.shrink()
                    : Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                count.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}

Widget _buildExpandableSection({
  required String title,
  required List<File> images,
  required TextEditingController commentsController,
  required Function onPickImage,
  required bool isExpanded,
  required VoidCallback onToggle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: onToggle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: isExpanded ? null : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Here you can add your logic to display the images
            Wrap(
              spacing: 8.0,
              children: images.map((image) {
                return Image.file(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () => onPickImage(), // Call your image picking method
              child: Text('Add Image'),
            ),
            TextField(
              controller: commentsController,
              decoration: InputDecoration(labelText: 'Remarks for $title'),
            ),
            SizedBox(height: 8.0),
            Divider(),
          ],
        ),
      ),
    ],
  );
}
