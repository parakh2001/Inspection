import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspection/model/car_auction.dart';
import 'package:inspection/model/car_details.dart';
import 'package:inspection/model/lead.dart';
import 'package:uuid/uuid.dart';

class CarDetailsPage extends StatefulWidget {
  final Lead carDetails; // If editing existing data, carId should be passed
  const CarDetailsPage({Key? key, required this.carDetails}) : super(key: key);

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late DatabaseReference _database;
  int _selectedIndex = 0; // To keep track of the selected page
  final _formKey = GlobalKey<FormState>();
  final _formInspectionKey = GlobalKey<FormState>();
  final _formBottomKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  String getInspectionUID = '';
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
  bool acAssemblyBendDentMajor = false;
  bool acAssemblyBendDentMinor = false;
  bool acAssemblyCrackMajor = false;
  bool acAssemblyCrackMinor = false;
  bool acAssemblyCorrosionMajor = false;
  bool acAssemblyCorrosionMinor = false;
  bool acAssemblyHammerRepairedMajor = false;
  bool acAssemblyHammerRepairedMinor = false;
  bool acAssemblyPaintMisMatch = false;
  bool acAssemblyPunchesOpenRepaired = false;
  bool acAssemblyRepainted = false;
  bool acAssemblyReplaced = false;
  bool acAssemblyScratchesMajor = false;
  bool acAssemblyScratchesMinor = false;
  bool acAssemblyWrapping = false;
  //Interior-1 air bags
  bool airBagsBendDentMajor = false;
  bool airBagsBendDentMinor = false;
  bool airBagsCrackMajor = false;
  bool airBagsCrackMinor = false;
  bool airBagsCorrosionMajor = false;
  bool airBagsCorrosionMinor = false;
  bool airBagsHammerRepairedMajor = false;
  bool airBagsHammerRepairedMinor = false;
  bool airBagsPaintMisMatch = false;
  bool airBagsPunchesOpenRepaired = false;
  bool airBagsRepainted = false;
  bool airBagsReplaced = false;
  bool airBagsScratchesMajor = false;
  bool airBagsScratchesMinor = false;
  bool airBagsWrapping = false;
  //Interior-1 Cluster panel assembly
  bool clusterPanelAssemblyBendDentMajor = false;
  bool clusterPanelAssemblyBendDentMinor = false;
  bool clusterPanelAssemblyCrackMajor = false;
  bool clusterPanelAssemblyCrackMinor = false;
  bool clusterPanelAssemblyCorrosionMajor = false;
  bool clusterPanelAssemblyCorrosionMinor = false;
  bool clusterPanelAssemblyHammerRepairedMajor = false;
  bool clusterPanelAssemblyHammerRepairedMinor = false;
  bool clusterPanelAssemblyPaintMisMatch = false;
  bool clusterPanelAssemblyPunchesOpenRepaired = false;
  bool clusterPanelAssemblyRepainted = false;
  bool clusterPanelAssemblyReplaced = false;
  bool clusterPanelAssemblyScratchesMajor = false;
  bool clusterPanelAssemblyScratchesMinor = false;
  bool clusterPanelAssemblyWrapping = false;
  //Interior-1 Dashboard assembly
  bool dashboardAssemblyBendDentMajor = false;
  bool dashboardAssemblyBendDentMinor = false;
  bool dashboardAssemblyCrackMajor = false;
  bool dashboardAssemblyCrackMinor = false;
  bool dashboardAssemblyCorrosionMajor = false;
  bool dashboardAssemblyCorrosionMinor = false;
  bool dashboardAssemblyHammerRepairedMajor = false;
  bool dashboardAssemblyHammerRepairedMinor = false;
  bool dashboardAssemblyPaintMisMatch = false;
  bool dashboardAssemblyPunchesOpenRepaired = false;
  bool dashboardAssemblyRepainted = false;
  bool dashboardAssemblyReplaced = false;
  bool dashboardAssemblyScratchesMajor = false;
  bool dashboardAssemblyScratchesMinor = false;
  bool dashboardAssemblyWrapping = false;
  //Interior-1 Front windshield glass
  bool frontWindshieldGlassBendDentMajor = false;
  bool frontWindshieldGlassBendDentMinor = false;
  bool frontWindshieldGlassCrackMajor = false;
  bool frontWindshieldGlassCrackMinor = false;
  bool frontWindshieldGlassCorrosionMajor = false;
  bool frontWindshieldGlassCorrosionMinor = false;
  bool frontWindshieldGlassHammerRepairedMajor = false;
  bool frontWindshieldGlassHammerRepairedMinor = false;
  bool frontWindshieldGlassPaintMisMatch = false;
  bool frontWindshieldGlassPunchesOpenRepaired = false;
  bool frontWindshieldGlassRepainted = false;
  bool frontWindshieldGlassReplaced = false;
  bool frontWindshieldGlassScratchesMajor = false;
  bool frontWindshieldGlassScratchesMinor = false;
  bool frontWindshieldGlassWrapping = false;
  //Interior-1 seats
  bool seatsBendDentMajor = false;
  bool seatsBendDentMinor = false;
  bool seatsCrackMajor = false;
  bool seatsCrackMinor = false;
  bool seatsCorrosionMajor = false;
  bool seatsCorrosionMinor = false;
  bool seatsHammerRepairedMajor = false;
  bool seatsHammerRepairedMinor = false;
  bool seatsPaintMisMatch = false;
  bool seatsPunchesOpenRepaired = false;
  bool seatsRepainted = false;
  bool seatsReplaced = false;
  bool seatsScratchesMajor = false;
  bool seatsScratchesMinor = false;
  bool seatsWrapping = false;
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
  File? _selectedAcAssemblyImage;
  File? _selectedAirBagsImage;
  File? _selectedClusterPanelAssemblyImage;
  File? _selectedDashboardAssemblyImage;
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
  String? selectedAcAssemblyImage;
  String? selectedAirBagsImage;
  String? selectedClusterPanelAssemblyImage;
  String? selectedDashboardAssemblyImage;
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

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('inspection');
    setState(() {
      getInspectionUID = getUId();
    });
    log("${widget.carDetails.carId}");
    log("getUID ${getInspectionUID}");
    // _loadCarData();
  }

  Future<void> _pickMultiImage() async {
    int maxImages = 5;
    int capturedCount = 0;
  }

  Future<void> _pickImage() async {
    final List<XFile>? image = await picker.pickMultiImage(
      limit: 10,
    );

    if (image != null) {
      setState(() {
        image.forEach(
          (element) {
            _selectedOtherImages.add(File(element.path));
          },
        );
      });
      image.forEach(
        (element) async {
          final File file = File(element.path);
          final String fileName =
              '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final Reference reference = storage.ref(
              'inspection/$getInspectionUID/car_doc/other_details/images/$fileName');
          final UploadTask uploadTask = reference.putFile(file);
          final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
            () {},
          );
          if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            setState(() {
              selectedOtherImages.add(downloadUrl);
            });
            print('Image uploaded successfully: $downloadUrl');
          } else {
            // Image upload failed
            print('Image upload failed');
          }
        },
      );
    }
  }

  Future<String> uploadImage(
      {required XFile imageVar, required imageRef}) async {
    final File file = File(imageVar.path);
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference reference = storage.ref('$imageRef/$fileName');
    final UploadTask uploadTask = reference.putFile(file);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
      () {},
    );
    if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } else {
      // Image upload failed
      print('Image upload failed');
      return '';
    }
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
    var trueBool = engineRating.where((element) => element == true);
    setState(() {});
    return trueBool.length;
  }

  int batteryIssueCheck() {
    battery.clear();
    battery.add(battryLeakage);
    battery.add(battryWrongSize);
    battery.add(battryDamaged);
    battery.add(battryAfterMarketFitment);
    var trueBool = battery.where((element) => element == true);
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
    var trueBool = frontSide.where((element) => element == true);
    setState(() {});
    return trueBool.length;
  }

  int interior1IssueCheck() {
    interior1.clear();
    interior1.add(acAssemblyBendDentMajor);
    interior1.add(acAssemblyBendDentMinor);
    interior1.add(acAssemblyCrackMajor);
    interior1.add(acAssemblyCrackMinor);
    interior1.add(acAssemblyCorrosionMajor);
    interior1.add(acAssemblyCorrosionMinor);
    interior1.add(acAssemblyHammerRepairedMajor);
    interior1.add(acAssemblyHammerRepairedMinor);
    interior1.add(acAssemblyPaintMisMatch);
    interior1.add(acAssemblyPunchesOpenRepaired);
    interior1.add(acAssemblyRepainted);
    interior1.add(acAssemblyReplaced);
    interior1.add(acAssemblyScratchesMajor);
    interior1.add(acAssemblyScratchesMinor);
    interior1.add(acAssemblyWrapping);
    interior1.add(airBagsBendDentMajor);
    interior1.add(airBagsBendDentMinor);
    interior1.add(airBagsCrackMajor);
    interior1.add(airBagsCrackMinor);
    interior1.add(airBagsCorrosionMajor);
    interior1.add(airBagsCorrosionMinor);
    interior1.add(airBagsHammerRepairedMajor);
    interior1.add(airBagsHammerRepairedMinor);
    interior1.add(airBagsPaintMisMatch);
    interior1.add(airBagsPunchesOpenRepaired);
    interior1.add(airBagsRepainted);
    interior1.add(airBagsReplaced);
    interior1.add(airBagsScratchesMajor);
    interior1.add(airBagsScratchesMinor);
    interior1.add(airBagsWrapping);
    interior1.add(clusterPanelAssemblyBendDentMajor);
    interior1.add(clusterPanelAssemblyBendDentMinor);
    interior1.add(clusterPanelAssemblyCrackMajor);
    interior1.add(clusterPanelAssemblyCrackMinor);
    interior1.add(clusterPanelAssemblyCorrosionMajor);
    interior1.add(clusterPanelAssemblyCorrosionMinor);
    interior1.add(clusterPanelAssemblyHammerRepairedMajor);
    interior1.add(clusterPanelAssemblyHammerRepairedMinor);
    interior1.add(clusterPanelAssemblyPaintMisMatch);
    interior1.add(clusterPanelAssemblyPunchesOpenRepaired);
    interior1.add(clusterPanelAssemblyRepainted);
    interior1.add(clusterPanelAssemblyReplaced);
    interior1.add(clusterPanelAssemblyScratchesMajor);
    interior1.add(clusterPanelAssemblyScratchesMinor);
    interior1.add(clusterPanelAssemblyWrapping);
    interior1.add(dashboardAssemblyBendDentMajor);
    interior1.add(dashboardAssemblyBendDentMinor);
    interior1.add(dashboardAssemblyCrackMajor);
    interior1.add(dashboardAssemblyCrackMinor);
    interior1.add(dashboardAssemblyCorrosionMajor);
    interior1.add(dashboardAssemblyCorrosionMinor);
    interior1.add(dashboardAssemblyHammerRepairedMajor);
    interior1.add(dashboardAssemblyHammerRepairedMinor);
    interior1.add(dashboardAssemblyPaintMisMatch);
    interior1.add(dashboardAssemblyPunchesOpenRepaired);
    interior1.add(dashboardAssemblyRepainted);
    interior1.add(dashboardAssemblyReplaced);
    interior1.add(dashboardAssemblyScratchesMajor);
    interior1.add(dashboardAssemblyScratchesMinor);
    interior1.add(dashboardAssemblyWrapping);
    interior1.add(frontWindshieldGlassBendDentMajor);
    interior1.add(frontWindshieldGlassBendDentMinor);
    interior1.add(frontWindshieldGlassCrackMajor);
    interior1.add(frontWindshieldGlassCrackMinor);
    interior1.add(frontWindshieldGlassCorrosionMajor);
    interior1.add(frontWindshieldGlassCorrosionMinor);
    interior1.add(frontWindshieldGlassHammerRepairedMajor);
    interior1.add(frontWindshieldGlassHammerRepairedMinor);
    interior1.add(frontWindshieldGlassPaintMisMatch);
    interior1.add(frontWindshieldGlassPunchesOpenRepaired);
    interior1.add(frontWindshieldGlassRepainted);
    interior1.add(frontWindshieldGlassReplaced);
    interior1.add(frontWindshieldGlassScratchesMajor);
    interior1.add(frontWindshieldGlassScratchesMinor);
    interior1.add(frontWindshieldGlassWrapping);
    interior1.add(seatsBendDentMajor);
    interior1.add(seatsBendDentMinor);
    interior1.add(seatsCrackMajor);
    interior1.add(seatsCrackMinor);
    interior1.add(seatsCorrosionMajor);
    interior1.add(seatsCorrosionMinor);
    interior1.add(seatsHammerRepairedMajor);
    interior1.add(seatsHammerRepairedMinor);
    interior1.add(seatsPaintMisMatch);
    interior1.add(seatsPunchesOpenRepaired);
    interior1.add(seatsRepainted);
    interior1.add(seatsReplaced);
    interior1.add(seatsScratchesMajor);
    interior1.add(seatsScratchesMinor);
    interior1.add(seatsWrapping);
    var trueBool = interior1.where((element) => element == true);
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
    var trueBool = interior2.where((element) => element == true);
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
    var trueBool = leftSide.where((element) => element == true);
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
    var trueBool = rearSide.where((element) => element == true);
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
    var trueBool = rightSide.where((element) => element == true);
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
    var trueBool = testDrive.where((element) => element == true);
    setState(() {});
    return trueBool.length;
  }

  // // // Load existing data if carId is provided
  // void _loadCarData() async {
  //   setState(() {
  //     _mfgYearMonthController.text  = widget.carDetails.carBuild.toString();
  //     _carMakeController.text  = widget.carDetails.carCompany;
  //     _carModelController.text  = widget.carDetails.carModel;
  //     _fuelTypeController.text  = widget.carDetails.carFueltype;
  //     _transmissionController.text  = widget.carDetails.carTransmission;
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
          noOfKeys: int.tryParse(_numberOfKeyController
              .text), // Example static data, you can replace
          images: selectedOtherImages, // Replace with logic for multiple images
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Car Details Saved!')),
    );
  }

  void _saveCarInspection() async {
    DatabaseReference carAuctionRef =
        FirebaseDatabase.instance.ref('car_auction');
    await engineRatingCheck();
    num engineRatingValue = 0.0;
    num carPrice = _carFairPriceController.text.isEmpty
        ? num.parse(widget.carDetails.carCarPrice)
        : num.parse(_carFairPriceController.text);
    setState(() {
      var trueBool = engineRating.where(
        (element) => element == true,
      );
      engineRatingValue = (trueBool.length * 5) / 14;
    });

    final DateTime newStartTime = DateTime.now();
    final DateTime newEndTime = newStartTime.add(const Duration(hours: 2));

    final newCarDoc = CarDetails(
      carId: widget.carDetails.carId,
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
            images: selectedAcAssemblyImage,
            replaced: acAssemblyReplaced,
            crackMajor: acAssemblyCrackMajor,
            crackMinor: acAssemblyCrackMinor,
            corrosionMinor: acAssemblyCorrosionMinor,
            corrosionMajor: acAssemblyCrackMajor,
            bendDentMajor: acAssemblyBendDentMajor,
            punchesOpenRepaired: acAssemblyPunchesOpenRepaired,
            repainted: acAssemblyRepainted,
            hammerRepairedMajor: acAssemblyHammerRepairedMajor,
            hammerRepairedMinor: acAssemblyHammerRepairedMinor,
            wrapping: acAssemblyWrapping,
            scratchesMinor: acAssemblyScratchesMinor,
            scratchesMajor: acAssemblyScratchesMajor,
            paintMismatch: acAssemblyPaintMisMatch,
          ),
          airbags: AcAssembly(
            images: selectedAirBagsImage,
            replaced: airBagsReplaced,
            crackMajor: airBagsCrackMajor,
            crackMinor: airBagsCrackMinor,
            corrosionMinor: airBagsCorrosionMinor,
            corrosionMajor: airBagsCrackMajor,
            bendDentMajor: airBagsBendDentMajor,
            punchesOpenRepaired: airBagsPunchesOpenRepaired,
            repainted: airBagsRepainted,
            hammerRepairedMajor: airBagsHammerRepairedMajor,
            hammerRepairedMinor: airBagsHammerRepairedMinor,
            wrapping: airBagsWrapping,
            scratchesMinor: airBagsScratchesMinor,
            scratchesMajor: airBagsScratchesMajor,
            paintMismatch: airBagsPaintMisMatch,
          ),
          clusterPanelAssembly: AcAssembly(
            images: selectedClusterPanelAssemblyImage,
            replaced: clusterPanelAssemblyReplaced,
            crackMajor: clusterPanelAssemblyCrackMajor,
            crackMinor: clusterPanelAssemblyCrackMinor,
            corrosionMinor: clusterPanelAssemblyCorrosionMinor,
            corrosionMajor: clusterPanelAssemblyCrackMajor,
            bendDentMajor: clusterPanelAssemblyBendDentMajor,
            punchesOpenRepaired: clusterPanelAssemblyPunchesOpenRepaired,
            repainted: clusterPanelAssemblyRepainted,
            hammerRepairedMajor: clusterPanelAssemblyHammerRepairedMajor,
            hammerRepairedMinor: clusterPanelAssemblyHammerRepairedMinor,
            wrapping: clusterPanelAssemblyWrapping,
            scratchesMinor: clusterPanelAssemblyScratchesMinor,
            scratchesMajor: clusterPanelAssemblyScratchesMajor,
            paintMismatch: clusterPanelAssemblyPaintMisMatch,
          ),
          dashboardAssembly: AcAssembly(
            images: selectedDashboardAssemblyImage,
            replaced: acAssemblyReplaced,
            crackMajor: dashboardAssemblyCrackMajor,
            crackMinor: dashboardAssemblyCrackMinor,
            corrosionMinor: dashboardAssemblyCorrosionMinor,
            corrosionMajor: dashboardAssemblyCrackMajor,
            bendDentMajor: dashboardAssemblyBendDentMajor,
            punchesOpenRepaired: dashboardAssemblyPunchesOpenRepaired,
            repainted: dashboardAssemblyRepainted,
            hammerRepairedMajor: dashboardAssemblyHammerRepairedMajor,
            hammerRepairedMinor: dashboardAssemblyHammerRepairedMinor,
            wrapping: dashboardAssemblyWrapping,
            scratchesMinor: dashboardAssemblyScratchesMinor,
            scratchesMajor: dashboardAssemblyScratchesMajor,
            paintMismatch: dashboardAssemblyPaintMisMatch,
          ),
          frontWindshieldGlass: AcAssembly(
            images: selectedFrontWindshieldGlassImage,
            replaced: frontWindshieldGlassReplaced,
            crackMajor: frontWindshieldGlassCrackMajor,
            crackMinor: frontWindshieldGlassCrackMinor,
            corrosionMinor: frontWindshieldGlassCorrosionMinor,
            corrosionMajor: frontWindshieldGlassCrackMajor,
            bendDentMajor: frontWindshieldGlassBendDentMajor,
            punchesOpenRepaired: frontWindshieldGlassPunchesOpenRepaired,
            repainted: frontWindshieldGlassRepainted,
            hammerRepairedMajor: frontWindshieldGlassHammerRepairedMajor,
            hammerRepairedMinor: frontWindshieldGlassHammerRepairedMinor,
            wrapping: frontWindshieldGlassWrapping,
            scratchesMinor: frontWindshieldGlassScratchesMinor,
            scratchesMajor: frontWindshieldGlassScratchesMajor,
            paintMismatch: frontWindshieldGlassPaintMisMatch,
          ),
          seats: AcAssembly(
            images: selectedSeatsImage,
            replaced: seatsReplaced,
            crackMajor: seatsCrackMajor,
            crackMinor: seatsCrackMinor,
            corrosionMinor: seatsCorrosionMinor,
            corrosionMajor: seatsCrackMajor,
            bendDentMajor: seatsBendDentMajor,
            punchesOpenRepaired: seatsPunchesOpenRepaired,
            repainted: seatsRepainted,
            hammerRepairedMajor: seatsHammerRepairedMajor,
            hammerRepairedMinor: seatsHammerRepairedMinor,
            wrapping: seatsWrapping,
            scratchesMinor: seatsScratchesMinor,
            scratchesMajor: seatsScratchesMajor,
            paintMismatch: seatsPaintMisMatch,
          ),
        ),
        interior2: Interior2(
          audioStereoAssembly: AcAssembly(
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
          centreConsoleAssembly: AcAssembly(
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
          forwardParkingSensors: AcAssembly(
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
          frontLeftDoorAssembly: AcAssembly(
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
          frontRightDoorAssembly: AcAssembly(
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
          reverseParkingCamera: AcAssembly(
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
          reverseParkingSensors: AcAssembly(
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
          frontLeftMechanical: AcAssembly(
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
            leftFloorPanChannel: AcAssembly(
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
            leftPillarB: AcAssembly(
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
            leftPillarC: AcAssembly(
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
            rearLeftDoorChannel: AcAssembly(
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
            rearLeftFloorPan: AcAssembly(
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
            rearLeftWheelHouse: AcAssembly(
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
            leftTailLightAssembly: AcAssembly(
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
            rearBumperPanel: AcAssembly(
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
            rearRegistrationPlate: AcAssembly(
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
            rearWindshieldGlass: AcAssembly(
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
            rightTailLightAssembly: AcAssembly(
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
            rearRightDoorChannel: AcAssembly(
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
            rearRightFloorPan: AcAssembly(
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
            rearRightWheelHouse: AcAssembly(
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
            rightFloorPanChannel: AcAssembly(
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
            rightPillarB: AcAssembly(
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
            rightPillarC: AcAssembly(
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
          rightRightMechanical: AcAssembly(
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

    final carAuction = CarAuction(
      id: getInspectionUID,
      isPurchased: false,
      endTime: newEndTime.millisecondsSinceEpoch,
      startTime: newStartTime.millisecondsSinceEpoch,
      auctionCount: 1,
      auctionStatus: true,
      carImages: selectedAllImages,
      imagePath: selectedAllImages.first,
      coolDownHours: 1,
      isFinalized: false,
      isOcb: false,
      isRcTransfer: false,
      variant: widget.carDetails.carFueltype,
      clientLocation: widget.carDetails.customerCity,
      companyName: widget.carDetails.carCompany,
      model: widget.carDetails.carModel,
      transmission: widget.carDetails.carTransmission,
      carPrice: carPrice,
      commissionPrice: carPrice * 0.12,
      engineRating: engineRatingValue,
      manufacturingYear: widget.carDetails.carBuild.toString(),
      totalDistance: num.tryParse(widget.carDetails.carDistanceTravelled),
      rtoNumber: widget.carDetails.carNumber,
      maxBidPrice: num.tryParse(widget.carDetails.carCarPrice * 2),
      highestBid: 0.0,
    );

    await _database.child(getInspectionUID).set(newCarDoc.toMap());
    await carAuctionRef.child(getInspectionUID).set(carAuction.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Car Inspection Saved!')),
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String getUId() {
    const uuid = Uuid();
    return uuid.v1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCarDetailsPage(), // Car Details Page
          _buildInspectionPage(), // Inspection Page
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
                              'inspection/$getInspectionUID/car_doc/rc_details',
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
                              'inspection/$getInspectionUID/car_doc/car_details',
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
                              'inspection/$getInspectionUID/car_doc/other_details/chassis_number_image/',
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

  // Dummy Inspection Page
  Widget _buildInspectionPage() {
    return Form(
      key: _formInspectionKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCardExpansionTile('Battery', count: batteryIssueCheck(), [
            SwitchListTile(
              title: const Text(
                'Aftermarket fitment',
              ),
              value: battryAfterMarketFitment,
              onChanged: (val) {
                setState(() {
                  battryAfterMarketFitment = val;
                });
              },
            ),
            SwitchListTile(
              title: const Text(
                'Leakage',
              ),
              value: battryLeakage,
              onChanged: (val) {
                setState(() {
                  battryLeakage = val;
                });
              },
            ),
            SwitchListTile(
              title: const Text(
                'Damaged',
              ),
              value: battryDamaged,
              onChanged: (val) {
                setState(() {
                  battryDamaged = val;
                });
              },
            ),
            SwitchListTile(
              title: const Text(
                'Wrong size',
              ),
              value: battryWrongSize,
              onChanged: (val) {
                setState(() {
                  battryWrongSize = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    if (selectedBatteryImage == null) {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        setState(() {
                          _selectedBatteryImage = File(image.path);
                        });
                        final result = await uploadImage(
                          imageVar: image,
                          imageRef:
                              'inspection/$getInspectionUID/car_health/battery',
                        );
                        if (result.isNotEmpty) {
                          setState(() {
                            selectedBatteryImage = result.toString();
                            selectedAllImages.add(result);
                            log("message ${selectedBatteryImage}");
                          });
                        }
                      }
                    }
                  },
                  child: _selectedBatteryImage != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_selectedBatteryImage!),
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
          _buildCardExpansionTile('Engine', count: engineIssueCheck(), [
            _buildExpansionTile('Static engine on', [
              _buildExpansionTile('Check for at gear box leakages', [
                SwitchListTile(
                  title: const Text(
                    'Leakage from at gearbox housing',
                  ),
                  value: leakageFromAtGearboxHousing,
                  onChanged: (val) {
                    setState(() {
                      leakageFromAtGearboxHousing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from at input shaft',
                  ),
                  value: leakageFromAtInputShaft,
                  onChanged: (val) {
                    setState(() {
                      leakageFromAtInputShaft = val;
                    });
                  },
                ),
              ]),
              _buildExpansionTile('Check for engine leakages', [
                SwitchListTile(
                  title: const Text(
                    'Leakage from engine block',
                  ),
                  value: leakageFromEngineBlock,
                  onChanged: (val) {
                    setState(() {
                      leakageFromEngineBlock = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from exhaust manifold',
                  ),
                  value: leakageFromExhaustManifold,
                  onChanged: (val) {
                    setState(() {
                      leakageFromExhaustManifold = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from turbocharger',
                  ),
                  value: leakageFromTurbocharger,
                  onChanged: (val) {
                    setState(() {
                      leakageFromTurbocharger = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from metal timing',
                  ),
                  value: leakageFromMetalTiming,
                  onChanged: (val) {
                    setState(() {
                      leakageFromMetalTiming = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Seepage from engine timing',
                  ),
                  value: seepageFromEngineTiming,
                  onChanged: (val) {
                    setState(() {
                      seepageFromEngineTiming = val;
                    });
                  },
                ),
              ]),
              _buildExpansionTile('Check for engine performances', [
                SwitchListTile(
                  title: const Text(
                    'Back compression in engine',
                  ),
                  value: backCompressionInEngine,
                  onChanged: (val) {
                    setState(() {
                      backCompressionInEngine = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Overheating due to radiator system',
                  ),
                  value: overheaingDueToRadiatorSystem,
                  onChanged: (val) {
                    setState(() {
                      overheaingDueToRadiatorSystem = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Overheating in engine',
                  ),
                  value: overheatingInEngine,
                  onChanged: (val) {
                    setState(() {
                      overheatingInEngine = val;
                    });
                  },
                ),
              ]),
              _buildExpansionTile('Check for manual gear box leakages', [
                SwitchListTile(
                  title: const Text(
                    'Leakage from 5th gear housing',
                  ),
                  value: leakageFrom5ThGearHousing,
                  onChanged: (val) {
                    setState(() {
                      leakageFrom5ThGearHousing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from drive axle',
                  ),
                  value: leakageFromDriveAxle,
                  onChanged: (val) {
                    setState(() {
                      leakageFromDriveAxle = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from mt gearbox housing',
                  ),
                  value: leakageFromMtGearboxHousing,
                  onChanged: (val) {
                    setState(() {
                      leakageFromMtGearboxHousing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Leakage from mt input shaft',
                  ),
                  value: leakageFromMtInputShaft,
                  onChanged: (val) {
                    setState(() {
                      leakageFromMtInputShaft = val;
                    });
                  },
                ),
              ]),
              // _buildExpansionTile('Video', [
              //   _buildTextField(
              //     engineNoiseVideo,
              //     'Engine noise video',
              //     (value) {
              //       if (value!.isEmpty) {
              //         return 'Enter noise video';
              //       }
              //       return null;
              //     },
              //   ),
              //   _buildTextField(
              //     testDriveVideo,
              //     'Test drive video',
              //     (value) {
              //       if (value!.isEmpty) {
              //         return 'Enter test drive video';
              //       }
              //       return null;
              //     },
              //   ),
              // ]),
            ]),
          ]),
          _buildCardExpansionTile('Extra', [
            _buildTextField(
              extraParts,
              'Extra Parts',
              (value) {
                if (value!.isEmpty) {
                  return 'Enter Extra Parts';
                }
                return null;
              },
            ),
          ]),
          _buildCardExpansionTile('Front Side', count: frontSideIssueCheck(), [
            _buildExpansionTile('Front exterior 1', [
              _buildExpansionTile('Bonnet panel', [
                SwitchListTile(
                  title: const Text(
                    'Alignment out',
                  ),
                  value: bonnetAlignmentOut,
                  onChanged: (val) {
                    setState(() {
                      bonnetAlignmentOut = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: bonnetCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      bonnetCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: bonnetCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      bonnetCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: bonnetRepainted,
                  onChanged: (val) {
                    setState(() {
                      bonnetRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: bonnetReplaced,
                  onChanged: (val) {
                    setState(() {
                      bonnetReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Sealant missing/crack/repaired',
                  ),
                  value: bonnetSealantMissingCrackRepaired,
                  onChanged: (val) {
                    setState(() {
                      bonnetSealantMissingCrackRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Wrapping',
                  ),
                  value: bonnetWrapping,
                  onChanged: (val) {
                    setState(() {
                      bonnetWrapping = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint defective',
                  ),
                  value: bonnetPaintDefective,
                  onChanged: (val) {
                    setState(() {
                      bonnetPaintDefective = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedBonnetImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedBonnetImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_1/bonnet_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedBonnetImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedBonnetImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedBonnetImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedBonnetImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Car key', [
                SwitchListTile(
                  title: const Text(
                    'one key missing',
                  ),
                  value: carKeyOneKeyMissing,
                  onChanged: (val) {
                    setState(() {
                      carKeyOneKeyMissing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'No free movement',
                  ),
                  value: carKeyNoFreeMovement,
                  onChanged: (val) {
                    setState(() {
                      carKeyNoFreeMovement = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Damaged minor',
                  ),
                  value: carKeyDamagedMinor,
                  onChanged: (val) {
                    setState(() {
                      carKeyDamagedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Damaged major',
                  ),
                  value: carKeyDamagedMajor,
                  onChanged: (val) {
                    setState(() {
                      carKeyDamagedMajor = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedCarKeyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedCarKeyImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_1/car_key',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedCarKeyImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedCarKeyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedCarKeyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedCarKeyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Central locking remote housing', [
                SwitchListTile(
                  title: const Text(
                    'one key missing',
                  ),
                  value: centralLockingRemoteHousingOneKeyMissing,
                  onChanged: (val) {
                    setState(() {
                      centralLockingRemoteHousingOneKeyMissing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'No free movement',
                  ),
                  value: centralLockingRemoteHousingNoFreeMovement,
                  onChanged: (val) {
                    setState(() {
                      centralLockingRemoteHousingNoFreeMovement = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Damaged minor',
                  ),
                  value: centralLockingRemoteHousingDamagedMinor,
                  onChanged: (val) {
                    setState(() {
                      centralLockingRemoteHousingDamagedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Damaged major',
                  ),
                  value: centralLockingRemoteHousingDamagedMajor,
                  onChanged: (val) {
                    setState(() {
                      centralLockingRemoteHousingDamagedMajor = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedCentralLockingRemoteHousingImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedCentralLockingRemoteHousingImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_1/central_locking_remote_housing',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedCentralLockingRemoteHousingImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedCentralLockingRemoteHousingImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedCentralLockingRemoteHousingImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedCentralLockingRemoteHousingImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front bumper grill', [
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontBumperGrillCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontBumperGrillCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontBumperGrillCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontBumperGrillCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: frontBumperGrillScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      frontBumperGrillScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: frontBumperGrillScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      frontBumperGrillScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontBumperGrillRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontBumperGrillRepaired = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontBumperGrillImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontBumperGrillImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_1/front_bumper_grill',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontBumperGrillImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontBumperGrillImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontBumperGrillImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontBumperGrillImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front bumper panel', [
                SwitchListTile(
                  title: const Text(
                    'Part missing',
                  ),
                  value: frontBumperPanelPartMissing,
                  onChanged: (val) {
                    setState(() {
                      frontBumperPanelPartMissing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: frontBumperPanelRepainted,
                  onChanged: (val) {
                    setState(() {
                      frontBumperPanelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Tab locks screw repaired',
                  ),
                  value: frontBumperPanelTabLocksScrewRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontBumperPanelTabLocksScrewRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Wrapping',
                  ),
                  value: frontBumperPanelWrapping,
                  onChanged: (val) {
                    setState(() {
                      frontBumperPanelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontBumperPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontBumperPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_1/front_bumper_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontBumperPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontBumperPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontBumperPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontBumperPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front registration plate', [
                SwitchListTile(
                  title: const Text(
                    'Part missing',
                  ),
                  value: frontRegistrationPlatePartMissing,
                  onChanged: (val) {
                    setState(() {
                      frontRegistrationPlatePartMissing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Aftermarket fitment',
                  ),
                  value: frontRegistrationPlateAftermarketFitment,
                  onChanged: (val) {
                    setState(() {
                      frontRegistrationPlateAftermarketFitment = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'damaged major',
                  ),
                  value: frontRegistrationPlateDamagedMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRegistrationPlateDamagedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'damaged minor',
                  ),
                  value: frontRegistrationPlateDamagedMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRegistrationPlateDamagedMinor = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontRegistrationPlateImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontRegistrationPlateImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_1/front_registration_plate',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontRegistrationPlateImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontRegistrationPlateImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontRegistrationPlateImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontRegistrationPlateImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Front exterior 2', [
              _buildExpansionTile('Front left fog light housing', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontLeftFogLightHousingBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontLeftFogLightHousingBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontLeftFogLightHousingCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontLeftFogLightHousingCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontLeftFogLightHousingCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontLeftFogLightHousingCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontLeftFogLightHousingPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontLeftFogLightHousingRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontLeftFogLightHousingReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontLeftFogLightHousingReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontLeftFogLightHousingImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontLeftFogLightHousingImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/front_left_fog_light_housing',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontLeftFogLightHousingImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontLeftFogLightHousingImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontLeftFogLightHousingImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontLeftFogLightHousingImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front right fog light housing', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontRightFogLightHousingBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontRightFogLightHousingBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontRightFogLightHousingCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontRightFogLightHousingCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontRightFogLightHousingCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontRightFogLightHousingCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontRightFogLightHousingPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontRightFogLightHousingRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontRightFogLightHousingReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontRightFogLightHousingReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontRightFogLightHousingImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontRightFogLightHousingImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/front_right_fog_light_housing',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontRightFogLightHousingImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontRightFogLightHousingImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontRightFogLightHousingImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontRightFogLightHousingImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left DRL', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftDrlBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftDrlBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: leftDrlBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      leftDrlBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftDrlCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftDrlCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftDrlCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftDrlCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftDrlCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftDrlCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftDrlCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftDrlCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftDrlPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftDrlPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: leftDrlRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftDrlRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftDrlReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftDrlReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftDrlImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftDrlImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/left_DRL',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftDrlImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftDrlImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftDrlImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedLeftDrlImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left headlight assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftHeadlightAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: leftHeadlightAssemblyBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftHeadlightAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftHeadlightAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftHeadlightAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftHeadlightAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftHeadlightAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: leftHeadlightAssemblyRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftHeadlightAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightAssemblyReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftHeadlightAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftHeadlightAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/left_headlight_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftHeadlightAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftHeadlightAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftHeadlightAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedLeftHeadlightAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left headlight housing', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftHeadlightHousingBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: leftHeadlightHousingBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftHeadlightHousingCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftHeadlightHousingCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftHeadlightHousingCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftHeadlightHousingCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftHeadlightHousingPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: leftHeadlightHousingRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftHeadlightHousingReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftHeadlightHousingReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftHeadlightHousingImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftHeadlightHousingImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/left_headlight_housing',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftHeadlightHousingImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftHeadlightHousingImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftHeadlightHousingImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedLeftHeadlightHousingImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right DRL', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightDrlBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightDrlBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightDrlBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightDrlBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightDrlCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightDrlCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightDrlCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightDrlCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightDrlCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightDrlCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightDrlCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightDrlCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightDrlPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightDrlPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rightDrlRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightDrlRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightDrlReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightDrlReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightDrlImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightDrlImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/right_DRL',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightDrlImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightDrlImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightDrlImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedRightDrlImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right headlight assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightHeadlightAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightHeadlightAssemblyBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightHeadlightAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightHeadlightAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightHeadlightAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightHeadlightAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightHeadlightAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rightHeadlightAssemblyRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightHeadlightAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightAssemblyReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightHeadlightAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightHeadlightAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/right_headlight_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightHeadlightAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightHeadlightAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightHeadlightAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightHeadlightAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right headlight housing', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightHeadlightHousingBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightHeadlightHousingBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightHeadlightHousingCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightHeadlightHousingCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightHeadlightHousingCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightHeadlightHousingCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightHeadlightHousingPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rightHeadlightHousingRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightHeadlightHousingReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightHeadlightHousingReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightHeadlightHousingImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightHeadlightHousingImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_exterior_2/right_headlight_housing',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightHeadlightHousingImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightHeadlightHousingImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightHeadlightHousingImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightHeadlightHousingImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Front structure 1', [
              _buildExpansionTile('Bolted radiator support', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: boltedRadiatorSupportBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      boltedRadiatorSupportBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: boltedRadiatorSupportBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      boltedRadiatorSupportBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: boltedRadiatorSupportCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      boltedRadiatorSupportCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: boltedRadiatorSupportCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      boltedRadiatorSupportCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: boltedRadiatorSupportCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      boltedRadiatorSupportCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: boltedRadiatorSupportCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      boltedRadiatorSupportCrackMinor = val;
                    });
                  },
                ),
              ]),
              _buildExpansionTile('Fibre radiator support', [
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: fibreRadiatorSupportCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      fibreRadiatorSupportCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: fibreRadiatorSupportCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      fibreRadiatorSupportCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: fibreRadiatorSupportRepaired,
                  onChanged: (val) {
                    setState(() {
                      fibreRadiatorSupportRepaired = val;
                    });
                  },
                ),
              ]),
              _buildExpansionTile('Front left leg', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontLeftLegBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontLeftLegBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontLeftLegCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontLeftLegCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontLeftLegCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontLeftLegCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontLeftLegPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontLeftLegRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontLeftLegReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontLeftLegReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontLeftLegImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontLeftLegImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_structure_1/front_left_leg',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontLeftLegImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontLeftLegImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontLeftLegImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedFrontLeftLegImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front right left', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontRightLeftBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontRightLeftBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontRightLeftCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontRightLeftCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontRightLeftCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontRightLeftCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontRightLeftPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontRightLeftRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontRightLeftReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontRightLeftReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontRightLeftImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontRightLeftImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/front_side/front_structure_1/front_right_leg',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontRightLeftImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontRightLeftImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontRightLeftImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedFrontRightLeftImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Welded radiator support', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: weldedRadiatorSupportBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      weldedRadiatorSupportBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: weldedRadiatorSupportBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      weldedRadiatorSupportBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: weldedRadiatorSupportCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      weldedRadiatorSupportCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: weldedRadiatorSupportCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      weldedRadiatorSupportCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: weldedRadiatorSupportCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      weldedRadiatorSupportCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: weldedRadiatorSupportCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      weldedRadiatorSupportCrackMinor = val;
                    });
                  },
                ),
              ]),
            ]),
          ]),
          _buildCardExpansionTile('Interior-1', count: interior1IssueCheck(), [
            _buildExpansionTile('Ac assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: acAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: acAssemblyBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: acAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: acAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: acAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: acAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: acAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: acAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: acAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    acAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: acAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    acAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: acAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    acAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: acAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    acAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: acAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: acAssemblyScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    acAssemblyScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: acAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    acAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedAcAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedAcAssemblyImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_1/ac_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedAcAssemblyImage = result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedAcAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedAcAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_selectedAcAssemblyImage!),
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
            _buildExpansionTile('Air Bags', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: airBagsBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    airBagsBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: airBagsBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    airBagsBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: airBagsCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    airBagsCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: airBagsCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    airBagsCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: airBagsCrackMajor,
                onChanged: (val) {
                  setState(() {
                    airBagsCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: airBagsCrackMinor,
                onChanged: (val) {
                  setState(() {
                    airBagsCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: airBagsHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    airBagsHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: airBagsHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    airBagsHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: airBagsPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    airBagsPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: airBagsPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    airBagsPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: airBagsRepainted,
                onChanged: (val) {
                  setState(() {
                    airBagsRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: airBagsReplaced,
                onChanged: (val) {
                  setState(() {
                    airBagsReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: airBagsScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    airBagsScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: airBagsScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    airBagsScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: airBagsWrapping,
                onChanged: (val) {
                  setState(() {
                    airBagsWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedAirBagsImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedAirBagsImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_1/airBags',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedAirBagsImage = result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedAirBagsImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedAirBagsImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_selectedAirBagsImage!),
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
            _buildExpansionTile('Cluster panel assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: clusterPanelAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: clusterPanelAssemblyBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: clusterPanelAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: clusterPanelAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: clusterPanelAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: clusterPanelAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: clusterPanelAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: clusterPanelAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: clusterPanelAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: clusterPanelAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: clusterPanelAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: clusterPanelAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: clusterPanelAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: clusterPanelAssemblyScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: clusterPanelAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    clusterPanelAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedClusterPanelAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedClusterPanelAssemblyImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_1/cluster_panel_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedClusterPanelAssemblyImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedClusterPanelAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedClusterPanelAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedClusterPanelAssemblyImage!),
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
            _buildExpansionTile('Dashboard assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: dashboardAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: dashboardAssemblyBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: dashboardAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: dashboardAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: dashboardAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: dashboardAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: dashboardAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: dashboardAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: dashboardAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: dashboardAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: dashboardAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: dashboardAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: dashboardAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: dashboardAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: dashboardAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    dashboardAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedDashboardAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedDashboardAssemblyImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_1/dashboard_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedDashboardAssemblyImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedDashboardAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedDashboardAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image:
                                    FileImage(_selectedDashboardAssemblyImage!),
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
            _buildExpansionTile('Front windshield glass', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: frontWindshieldGlassBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: frontWindshieldGlassBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: frontWindshieldGlassCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: frontWindshieldGlassCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: frontWindshieldGlassCrackMajor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: frontWindshieldGlassCrackMinor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: frontWindshieldGlassHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: frontWindshieldGlassHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: frontWindshieldGlassPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: frontWindshieldGlassPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: frontWindshieldGlassRepainted,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: frontWindshieldGlassReplaced,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: frontWindshieldGlassScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: frontWindshieldGlassScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: frontWindshieldGlassWrapping,
                onChanged: (val) {
                  setState(() {
                    frontWindshieldGlassWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedFrontWindshieldGlassImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedFrontWindshieldGlassImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_1/front_windshield_glass',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedFrontWindshieldGlassImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedFrontWindshieldGlassImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedFrontWindshieldGlassImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedFrontWindshieldGlassImage!),
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
            _buildExpansionTile('Seats', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: seatsBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    seatsBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: seatsBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    seatsBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: seatsCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    seatsCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: seatsCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    seatsCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: seatsCrackMajor,
                onChanged: (val) {
                  setState(() {
                    seatsCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: seatsCrackMinor,
                onChanged: (val) {
                  setState(() {
                    seatsCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: seatsHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    seatsHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: seatsHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    seatsHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: seatsPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    seatsPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: seatsPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    seatsPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: seatsRepainted,
                onChanged: (val) {
                  setState(() {
                    seatsRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: seatsReplaced,
                onChanged: (val) {
                  setState(() {
                    seatsReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: seatsScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    seatsScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: seatsScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    seatsScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: seatsWrapping,
                onChanged: (val) {
                  setState(() {
                    seatsWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedSeatsImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedSeatsImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_1/seats',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedSeatsImage = result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedSeatsImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedSeatsImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_selectedSeatsImage!),
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
          ]),
          _buildCardExpansionTile('Interior-2', count: interior2IssueCheck(), [
            _buildExpansionTile('Audio stereo assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: audioStereoAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: audioStereoAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: audioStereoAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: audioStereoAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: audioStereoAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: audioStereoAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: audioStereoAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: audioStereoAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: audioStereoAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: audioStereoAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: audioStereoAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: audioStereoAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: audioStereoAssemblyScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: audioStereoAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    audioStereoAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedAudioStereoAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedAudioStereoAssemblyImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/audio_stereo_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedAudioStereoAssemblyImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedAudioStereoAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedAudioStereoAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedAudioStereoAssemblyImage!),
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
            _buildExpansionTile('Centre console assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: centreConsoleAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: centreConsoleAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: centreConsoleAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: centreConsoleAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: centreConsoleAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: centreConsoleAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: centreConsoleAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: centreConsoleAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: centreConsoleAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: centreConsoleAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: centreConsoleAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: centreConsoleAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: centreConsoleAssemblyScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: centreConsoleAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    centreConsoleAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedCentreConsoleAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedCentreConsoleAssemblyImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/centre_console_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedCentreConsoleAssemblyImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedCentreConsoleAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedCentreConsoleAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedCentreConsoleAssemblyImage!),
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
            _buildExpansionTile('Forward parking sensors', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: forwardParkingSensorsBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: forwardParkingSensorsCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: forwardParkingSensorsCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: forwardParkingSensorsCrackMajor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: forwardParkingSensorsCrackMinor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: forwardParkingSensorsHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: forwardParkingSensorsHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: forwardParkingSensorsPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: forwardParkingSensorsPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: forwardParkingSensorsRepainted,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: forwardParkingSensorsReplaced,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: forwardParkingSensorsScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: forwardParkingSensorsScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: forwardParkingSensorsWrapping,
                onChanged: (val) {
                  setState(() {
                    forwardParkingSensorsWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedForwardParkingSensorsImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedForwardParkingSensorsImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/forward_parking_sensors',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedForwardParkingSensorsImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedForwardParkingSensorsImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedForwardParkingSensorsImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedForwardParkingSensorsImage!),
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
            _buildExpansionTile('Front left door assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: frontLeftDoorAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: frontLeftDoorAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: frontLeftDoorAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: frontLeftDoorAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: frontLeftDoorAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: frontLeftDoorAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: frontLeftDoorAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: frontLeftDoorAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: frontLeftDoorAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: frontLeftDoorAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: frontLeftDoorAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: frontLeftDoorAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: frontLeftDoorAssemblyScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: frontLeftDoorAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    frontLeftDoorAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedFrontLeftDoorAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedFrontLeftDoorAssemblyImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/front_left_door_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedFrontLeftDoorAssemblyImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedFrontLeftDoorAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedFrontLeftDoorAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedFrontLeftDoorAssemblyImage!),
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
            _buildExpansionTile('Front right door assembly', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: frontRightDoorAssemblyBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: frontRightDoorAssemblyCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: frontRightDoorAssemblyCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: frontRightDoorAssemblyCrackMajor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: frontRightDoorAssemblyCrackMinor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: frontRightDoorAssemblyHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: frontRightDoorAssemblyHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: frontRightDoorAssemblyPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: frontRightDoorAssemblyPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: frontRightDoorAssemblyRepainted,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: frontRightDoorAssemblyReplaced,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: frontRightDoorAssemblyScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: frontRightDoorAssemblyScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: frontRightDoorAssemblyWrapping,
                onChanged: (val) {
                  setState(() {
                    frontRightDoorAssemblyWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedFrontRightDoorAssemblyImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedFrontRightDoorAssemblyImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/front_right_door_assembly',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedFrontRightDoorAssemblyImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedFrontRightDoorAssemblyImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedFrontRightDoorAssemblyImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedFrontRightDoorAssemblyImage!),
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
            _buildExpansionTile('Reverse parking camera', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: reverseParkingCameraBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: reverseParkingCameraCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: reverseParkingCameraCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: reverseParkingCameraCrackMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: reverseParkingCameraCrackMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: reverseParkingCameraHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: reverseParkingCameraHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: reverseParkingCameraPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: reverseParkingCameraPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: reverseParkingCameraRepainted,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: reverseParkingCameraReplaced,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: reverseParkingCameraScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: reverseParkingCameraScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: reverseParkingCameraWrapping,
                onChanged: (val) {
                  setState(() {
                    reverseParkingCameraWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedReverseParkingCameraImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedReverseParkingCameraImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/reverse_parking_camera',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedReverseParkingCameraImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedReverseParkingCameraImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedReverseParkingCameraImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedReverseParkingCameraImage!),
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
            _buildExpansionTile('Reverse parking sensors', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: reverseParkingSensorsBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: reverseParkingSensorsCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: reverseParkingSensorsCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: reverseParkingSensorsCrackMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: reverseParkingSensorsCrackMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: reverseParkingSensorsHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: reverseParkingSensorsHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: reverseParkingSensorsPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: reverseParkingSensorsPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: reverseParkingSensorsRepainted,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: reverseParkingSensorsReplaced,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: reverseParkingSensorsScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: reverseParkingSensorsScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: reverseParkingSensorsWrapping,
                onChanged: (val) {
                  setState(() {
                    reverseParkingSensorsWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedReverseParkingSensorsImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedReverseParkingSensorsImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/Interior_2/reverse_parking_sensors',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedReverseParkingSensorsImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedReverseParkingSensorsImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedReverseParkingSensorsImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedReverseParkingSensorsImage!),
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
          ]),
          _buildCardExpansionTile('Left si de', count: leftSideIssueCheck(), [
            _buildExpansionTile('Front left exterior', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: frontLeftExteriorBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: frontLeftExteriorBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: frontLeftExteriorCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: frontLeftExteriorCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: frontLeftExteriorCrackMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: frontLeftExteriorCrackMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: frontLeftExteriorPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repaired',
                ),
                value: frontLeftExteriorRepaired,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: frontLeftExteriorReplaced,
                onChanged: (val) {
                  setState(() {
                    frontLeftExteriorReplaced = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedFrontLeftExteriorImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedFrontLeftExteriorImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/left_side/front_left_exterior',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedFrontLeftExteriorImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedFrontLeftExteriorImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedFrontLeftExteriorImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image:
                                    FileImage(_selectedFrontLeftExteriorImage!),
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
            _buildExpansionTile('Front left mechanical', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: frontLeftMechanicalBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: frontLeftMechanicalCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: frontLeftMechanicalCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: frontLeftMechanicalCrackMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: frontLeftMechanicalCrackMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: frontLeftMechanicalHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: frontLeftMechanicalHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: frontLeftMechanicalPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: frontLeftMechanicalPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: frontLeftMechanicalRepainted,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: frontLeftMechanicalReplaced,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: frontLeftMechanicalScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: frontLeftMechanicalScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: frontLeftMechanicalWrapping,
                onChanged: (val) {
                  setState(() {
                    frontLeftMechanicalWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedFrontLeftMechanicalImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedFrontLeftMechanicalImage =
                                File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/left_side/front_left_mechanical',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedFrontLeftMechanicalImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedFrontLeftMechanicalImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedFrontLeftMechanicalImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedFrontLeftMechanicalImage!),
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
            _buildExpansionTile('Front left structure', [
              _buildExpansionTile('Left floor pan channel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftFloorPanChannelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftFloorPanChannelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftFloorPanChannelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftFloorPanChannelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftFloorPanChannelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: leftFloorPanChannelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: leftFloorPanChannelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: leftFloorPanChannelPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftFloorPanChannelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: leftFloorPanChannelRepainted,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftFloorPanChannelReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: leftFloorPanChannelScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: leftFloorPanChannelScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: leftFloorPanChannelWrapping,
                  onChanged: (val) {
                    setState(() {
                      leftFloorPanChannelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftFloorPanChannelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftFloorPanChannelImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/left_floor_pan_channel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftFloorPanChannelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftFloorPanChannelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftFloorPanChannelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedLeftFloorPanChannelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left pillar B', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftPillarBBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftPillarBCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftPillarBCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftPillarBCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftPillarBCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: leftPillarBHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: leftPillarBHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: leftPillarBPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftPillarBPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: leftPillarBRepainted,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftPillarBReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: leftPillarBScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: leftPillarBScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: leftPillarBWrapping,
                  onChanged: (val) {
                    setState(() {
                      leftPillarBWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftPillarBImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftPillarBImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/left_pillar_B',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftPillarBImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftPillarBImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftPillarBImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedLeftPillarBImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left pillar C', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftPillarCBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftPillarCCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftPillarCCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftPillarCCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftPillarCCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: leftPillarCHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: leftPillarCHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: leftPillarCPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftPillarCPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: leftPillarCRepainted,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftPillarCReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: leftPillarCScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: leftPillarCScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: leftPillarCWrapping,
                  onChanged: (val) {
                    setState(() {
                      leftPillarCWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftPillarCImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftPillarCImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/left_pillar_C',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftPillarCImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftPillarCImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftPillarCImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedLeftPillarCImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left running board', [
                SwitchListTile(
                  title: const Text(
                    'Crack',
                  ),
                  value: leftRunningBoardCrack,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardCrack = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftRunningBoardCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftRunningBoardCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint defective',
                  ),
                  value: leftRunningBoardPaintDefective,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardPaintDefective = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: leftRunningBoardPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftRunningBoardPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: leftRunningBoardRepainted,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftRunningBoardReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftRunningBoardReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftRunningBoardImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftRunningBoardImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/left_running_board',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftRunningBoardImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftRunningBoardImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftRunningBoardImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedLeftRunningBoardImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear left door channel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearLeftDoorChannelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearLeftDoorChannelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearLeftDoorChannelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearLeftDoorChannelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearLeftDoorChannelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearLeftDoorChannelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearLeftDoorChannelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearLeftDoorChannelPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearLeftDoorChannelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearLeftDoorChannelRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearLeftDoorChannelReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearLeftDoorChannelScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearLeftDoorChannelScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearLeftDoorChannelWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorChannelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearLeftDoorChannelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearLeftDoorChannelImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/rear_left_door_channel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearLeftDoorChannelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearLeftDoorChannelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearLeftDoorChannelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearLeftDoorChannelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear left floor pan', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearLeftFloorPanBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearLeftFloorPanCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearLeftFloorPanCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearLeftFloorPanCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearLeftFloorPanCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearLeftFloorPanHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearLeftFloorPanHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearLeftFloorPanPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearLeftFloorPanPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearLeftFloorPanRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearLeftFloorPanReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearLeftFloorPanScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearLeftFloorPanScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearLeftFloorPanWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearLeftFloorPanWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearLeftFloorPanImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearLeftFloorPanImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/rear_left_floor_pan',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearLeftFloorPanImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearLeftFloorPanImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearLeftFloorPanImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearLeftFloorPanImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear left wheel house', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearLeftWheelHouseBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearLeftWheelHouseCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearLeftWheelHouseCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearLeftWheelHouseCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearLeftWheelHouseCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearLeftWheelHouseHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearLeftWheelHouseHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearLeftWheelHousePaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHousePaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearLeftWheelHousePunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHousePunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearLeftWheelHouseRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearLeftWheelHouseReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearLeftWheelHouseScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearLeftWheelHouseScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearLeftWheelHouseWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearLeftWheelHouseWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearLeftWheelHouseImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearLeftWheelHouseImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/front_left_structure/rear_left_wheel_house',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearLeftWheelHouseImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearLeftWheelHouseImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearLeftWheelHouseImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearLeftWheelHouseImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Rear left exterior', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: rearLeftExteriorBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: rearLeftExteriorBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: rearLeftExteriorCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: rearLeftExteriorCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: rearLeftExteriorCrackMajor,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: rearLeftExteriorCrackMinor,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: rearLeftExteriorPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repaired',
                ),
                value: rearLeftExteriorRepaired,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: rearLeftExteriorReplaced,
                onChanged: (val) {
                  setState(() {
                    rearLeftExteriorReplaced = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedRearLeftExteriorImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedRearLeftExteriorImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/left_side/rear_left_exterior',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedRearLeftExteriorImage = result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedRearLeftExteriorImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedRearLeftExteriorImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image:
                                    FileImage(_selectedRearLeftExteriorImage!),
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
            _buildExpansionTile('Rear left mechanical', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: rearLeftMechanicalBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: rearLeftMechanicalBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: rearLeftMechanicalCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: rearLeftMechanicalCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: rearLeftMechanicalCrackMajor,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: rearLeftMechanicalCrackMinor,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: rearLeftMechanicalPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repaired',
                ),
                value: rearLeftMechanicalRepaired,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: rearLeftMechanicalReplaced,
                onChanged: (val) {
                  setState(() {
                    rearLeftMechanicalReplaced = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedRearLeftMechanicalImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedRearLeftMechanicalImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/left_side/rear_left_mechanical',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedRearLeftMechanicalImage =
                                  result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedRearLeftMechanicalImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedRearLeftMechanicalImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(
                                    _selectedRearLeftMechanicalImage!),
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
            _buildExpansionTile('Rear left structure', [
              _buildExpansionTile('Left fender lining', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftFenderLiningBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: leftFenderLiningBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftFenderLiningCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftFenderLiningCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftFenderLiningCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftFenderLiningCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftFenderLiningPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: leftFenderLiningRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftFenderLiningReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftFenderLiningReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftFenderLiningImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftFenderLiningImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/rear_left_structure/left_fender_lining',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftFenderLiningImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftFenderLiningImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftFenderLiningImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedLeftFenderLiningImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left fender panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftFenderPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: leftFenderPanelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftFenderPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftFenderPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftFenderPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftFenderPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftFenderPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: leftFenderPanelRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftFenderPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftFenderPanelReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftFenderPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftFenderPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/rear_left_structure/left_fender_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftFenderPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftFenderPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftFenderPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedLeftFenderPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left svm assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftSvmAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: leftSvmAssemblyBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftSvmAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftSvmAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftSvmAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftSvmAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftSvmAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: leftSvmAssemblyRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftSvmAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftSvmAssemblyReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftSvmAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftSvmAssemblyImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/rear_left_structure/left_svm_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftSvmAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftSvmAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftSvmAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedLeftSvmAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear left door panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearLeftDoorPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rearLeftDoorPanelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearLeftDoorPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearLeftDoorPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearLeftDoorPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearLeftDoorPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearLeftDoorPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rearLeftDoorPanelRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearLeftDoorPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearLeftDoorPanelReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearLeftDoorPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearLeftDoorPanelImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/left_side/rear_left_structure/rear_left_door_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearLeftDoorPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearLeftDoorPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearLeftDoorPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearLeftDoorPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
          ]),
          _buildCardExpansionTile('Rear side', count: rearSideIssueCheck(), [
            _buildExpansionTile('Rear exterior', [
              _buildExpansionTile('Dickey door panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyDoorPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: dickeyDoorPanelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyDoorPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyDoorPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyDoorPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyDoorPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyDoorPanelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyDoorPanelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyDoorPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyDoorPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyDoorPanelReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyDoorPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyDoorPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/dickey_door_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyDoorPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyDoorPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyDoorPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedDickeyDoorPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Dickey left stay rod shocker', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyLeftStayRodShockerBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: dickeyLeftStayRodShockerBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyLeftStayRodShockerCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyLeftStayRodShockerCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyLeftStayRodShockerCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyLeftStayRodShockerCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyLeftStayRodShockerHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyLeftStayRodShockerHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyLeftStayRodShockerPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyLeftStayRodShockerReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftStayRodShockerReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyLeftStayRodShockerImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyLeftStayRodShockerImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/dickey_left_stay_rod_shocker',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyLeftStayRodShockerImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyLeftStayRodShockerImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyLeftStayRodShockerImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedDickeyLeftStayRodShockerImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Dickey right stay rod shocker', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyRightStayRodShockerBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: dickeyRightStayRodShockerBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyRightStayRodShockerCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyRightStayRodShockerCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyRightStayRodShockerCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyRightStayRodShockerCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyRightStayRodShockerHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyRightStayRodShockerHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyRightStayRodShockerPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyRightStayRodShockerReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightStayRodShockerReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyRightStayRodShockerImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyRightStayRodShockerImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/dickey_right_stay_rod_shocker',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyRightStayRodShockerImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyRightStayRodShockerImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyRightStayRodShockerImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedDickeyRightStayRodShockerImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Left tail light assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: leftTailLightAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: leftTailLightAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: leftTailLightAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: leftTailLightAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: leftTailLightAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: leftTailLightAssemblyHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: leftTailLightAssemblyHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: leftTailLightAssemblyPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: leftTailLightAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: leftTailLightAssemblyRepainted,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: leftTailLightAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: leftTailLightAssemblyScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: leftTailLightAssemblyScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: leftTailLightAssemblyWrapping,
                  onChanged: (val) {
                    setState(() {
                      leftTailLightAssemblyWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedLeftTailLightAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedLeftTailLightAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/left_tail_light_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedLeftTailLightAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedLeftTailLightAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedLeftTailLightAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedLeftTailLightAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear bumper panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearBumperPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearBumperPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearBumperPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearBumperPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearBumperPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearBumperPanelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearBumperPanelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearBumperPanelPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearBumperPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearBumperPanelRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearBumperPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearBumperPanelScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearBumperPanelScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearBumperPanelWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearBumperPanelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearBumperPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearBumperPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/rear_bumper_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearBumperPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearBumperPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearBumperPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedRearBumperPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear registration plate', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearRegistrationPlateBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearRegistrationPlateCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearRegistrationPlateCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearRegistrationPlateCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearRegistrationPlateCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearRegistrationPlateHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearRegistrationPlateHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearRegistrationPlatePaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlatePaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearRegistrationPlatePunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlatePunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearRegistrationPlateRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearRegistrationPlateReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearRegistrationPlateScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearRegistrationPlateScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearRegistrationPlateWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearRegistrationPlateWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearRegistrationPlateImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearRegistrationPlateImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/rear_registration_plate',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearRegistrationPlateImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearRegistrationPlateImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearRegistrationPlateImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearRegistrationPlateImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear windshield glass', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearWindshieldGlassBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearWindshieldGlassCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearWindshieldGlassCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearWindshieldGlassCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearWindshieldGlassCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearWindshieldGlassHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearWindshieldGlassHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearWindshieldGlassPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearWindshieldGlassPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearWindshieldGlassRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearWindshieldGlassReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearWindshieldGlassScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearWindshieldGlassScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearWindshieldGlassWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearWindshieldGlassWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearWindshieldGlassImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearWindshieldGlassImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/rear_windshield_glass',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearWindshieldGlassImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearWindshieldGlassImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearWindshieldGlassImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearWindshieldGlassImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right tail light assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightTailLightAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightTailLightAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightTailLightAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightTailLightAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightTailLightAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rightTailLightAssemblyHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rightTailLightAssemblyHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rightTailLightAssemblyPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightTailLightAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rightTailLightAssemblyRepainted,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightTailLightAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rightTailLightAssemblyScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rightTailLightAssemblyScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rightTailLightAssemblyWrapping,
                  onChanged: (val) {
                    setState(() {
                      rightTailLightAssemblyWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightTailLightAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightTailLightAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/rear_exterior/right_tail_light_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightTailLightAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightTailLightAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightTailLightAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightTailLightAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Roof structure and root', [
              _buildExpansionTile('Dickey back panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyBackPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: dickeyBackPanelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyBackPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyBackPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyBackPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyBackPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyBackPanelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyBackPanelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyBackPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyBackPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyBackPanelReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyBackPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyBackPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_back_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyBackPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyBackPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyBackPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedDickeyBackPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Dickey Floor', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyFloorBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: dickeyFloorBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyFloorCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyFloorCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyFloorCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyFloorCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyFloorHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyFloorHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyFloorPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyFloorReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyFloorReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyFloorImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyFloorImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_floor',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyFloorImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyFloorImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyFloorImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedDickeyFloorImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Dickey left leg', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyLeftLegBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: dickeyLeftLegBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyLeftLegCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyLeftLegCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyLeftLegCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyLeftLegCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyLeftLegHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyLeftLegHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyLeftLegPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: dickeyLeftLegRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyLeftLegReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyLeftLegReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyLeftLegImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyLeftLegImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_left_leg',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyLeftLegImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyLeftLegImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyLeftLegImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedDickeyLeftLegImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Dickey Right leg', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: dickeyRightLegBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: dickeyRightLegCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: dickeyRightLegCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: dickeyRightLegCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: dickeyRightLegCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: dickeyRightLegHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: dickeyRightLegHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: dickeyRightLegPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: dickeyRightLegPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: dickeyRightLegRepaired,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: dickeyRightLegReplaced,
                  onChanged: (val) {
                    setState(() {
                      dickeyRightLegReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedDickeyRightLegImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedDickeyRightLegImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_right_leg',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedDickeyRightLegImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedDickeyRightLegImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedDickeyRightLegImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedDickeyRightLegImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Dickey sidewalls', [
                _buildExpansionTile('Left dickey sidewall', [
                  SwitchListTile(
                    title: const Text(
                      'Bend dent major',
                    ),
                    value: leftDickeySidewallBendDentMajor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallBendDentMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Bend dent minor',
                    ),
                    value: leftDickeySidewallBendDentMinor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallBendDentMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion major',
                    ),
                    value: leftDickeySidewallCorrosionMajor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallCorrosionMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion minor',
                    ),
                    value: leftDickeySidewallCorrosionMinor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallCorrosionMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack major',
                    ),
                    value: leftDickeySidewallCrackMajor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallCrackMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack minor',
                    ),
                    value: leftDickeySidewallCrackMinor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallCrackMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Punches open repaired',
                    ),
                    value: leftDickeySidewallPunchesOpenRepaired,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallPunchesOpenRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Sealant missing crack repaired',
                    ),
                    value: leftDickeySidewallSealantMissingCrackRepaired,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallSealantMissingCrackRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Replaced',
                    ),
                    value: leftDickeySidewallReplaced,
                    onChanged: (val) {
                      setState(() {
                        leftDickeySidewallReplaced = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () async {
                          if (selectedLeftDickeySidewallImage == null) {
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);

                            if (image != null) {
                              setState(() {
                                _selectedLeftDickeySidewallImage =
                                    File(image.path);
                              });
                              final result = await uploadImage(
                                imageVar: image,
                                imageRef:
                                    'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_sidewalls/left_dickey_sidewall',
                              );
                              if (result.isNotEmpty) {
                                setState(() {
                                  selectedLeftDickeySidewallImage =
                                      result.toString();
                                  selectedAllImages.add(result);
                                  log("message ${selectedLeftDickeySidewallImage}");
                                });
                              }
                            }
                          }
                        },
                        child: _selectedLeftDickeySidewallImage != null
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(
                                        _selectedLeftDickeySidewallImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
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
                _buildExpansionTile('Right dickey sidewall', [
                  SwitchListTile(
                    title: const Text(
                      'Bend dent major',
                    ),
                    value: rightDickeySidewallBendDentMajor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallBendDentMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Bend dent minor',
                    ),
                    value: rightDickeySidewallBendDentMinor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallBendDentMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion major',
                    ),
                    value: rightDickeySidewallCorrosionMajor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallCorrosionMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion minor',
                    ),
                    value: rightDickeySidewallCorrosionMinor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallCorrosionMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack major',
                    ),
                    value: rightDickeySidewallCrackMajor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallCrackMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack minor',
                    ),
                    value: rightDickeySidewallCrackMinor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallCrackMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Sealant missing crack repaired',
                    ),
                    value: rightDickeySidewallSealantMissingCrackRepaired,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallSealantMissingCrackRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Punches open repaired',
                    ),
                    value: rightDickeySidewallPunchesOpenRepaired,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallPunchesOpenRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Replaced',
                    ),
                    value: rightDickeySidewallReplaced,
                    onChanged: (val) {
                      setState(() {
                        rightDickeySidewallReplaced = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () async {
                          if (selectedRightDickeySidewallImage == null) {
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);

                            if (image != null) {
                              setState(() {
                                _selectedRightDickeySidewallImage =
                                    File(image.path);
                              });
                              final result = await uploadImage(
                                imageVar: image,
                                imageRef:
                                    'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_sidewalls/right_dickey_sidewall',
                              );
                              if (result.isNotEmpty) {
                                setState(() {
                                  selectedRightDickeySidewallImage =
                                      result.toString();
                                  selectedAllImages.add(result);
                                  log("message ${selectedRightDickeySidewallImage}");
                                });
                              }
                            }
                          }
                        },
                        child: _selectedRightDickeySidewallImage != null
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(
                                        _selectedRightDickeySidewallImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
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
              ]),
              _buildExpansionTile('Dickey strut towers', [
                _buildExpansionTile('Left dickey strut tower', [
                  SwitchListTile(
                    title: const Text(
                      'Bend dent major',
                    ),
                    value: leftDickeyStrutTowerBendDentMajor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerBendDentMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Bend dent minor',
                    ),
                    value: leftDickeyStrutTowerBendDentMinor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerBendDentMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion major',
                    ),
                    value: leftDickeyStrutTowerCorrosionMajor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerCorrosionMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion minor',
                    ),
                    value: leftDickeyStrutTowerCorrosionMinor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerCorrosionMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack major',
                    ),
                    value: leftDickeyStrutTowerCrackMajor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerCrackMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack minor',
                    ),
                    value: leftDickeyStrutTowerCrackMinor,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerCrackMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Punches open repaired',
                    ),
                    value: leftDickeyStrutTowerPunchesOpenRepaired,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerPunchesOpenRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Sealant missing crack repaired',
                    ),
                    value: leftDickeyStrutTowerSealantMissingCrackRepaired,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerSealantMissingCrackRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Replaced',
                    ),
                    value: leftDickeyStrutTowerReplaced,
                    onChanged: (val) {
                      setState(() {
                        leftDickeyStrutTowerReplaced = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () async {
                          if (selectedLeftDickeyStrutTowerImage == null) {
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);

                            if (image != null) {
                              setState(() {
                                _selectedLeftDickeyStrutTowerImage =
                                    File(image.path);
                              });
                              final result = await uploadImage(
                                imageVar: image,
                                imageRef:
                                    'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_strut_towers/left_dickey_strut_tower',
                              );
                              if (result.isNotEmpty) {
                                setState(() {
                                  selectedLeftDickeyStrutTowerImage =
                                      result.toString();
                                  selectedAllImages.add(result);
                                  log("message ${selectedLeftDickeyStrutTowerImage}");
                                });
                              }
                            }
                          }
                        },
                        child: _selectedLeftDickeyStrutTowerImage != null
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(
                                        _selectedLeftDickeyStrutTowerImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
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
                _buildExpansionTile('Right dickey strut tower', [
                  SwitchListTile(
                    title: const Text(
                      'Bend dent major',
                    ),
                    value: rightDickeyStrutTowerBendDentMajor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerBendDentMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Bend dent minor',
                    ),
                    value: rightDickeyStrutTowerBendDentMinor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerBendDentMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion major',
                    ),
                    value: rightDickeyStrutTowerCorrosionMajor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerCorrosionMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Corrosion minor',
                    ),
                    value: rightDickeyStrutTowerCorrosionMinor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerCorrosionMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack major',
                    ),
                    value: rightDickeyStrutTowerCrackMajor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerCrackMajor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Crack minor',
                    ),
                    value: rightDickeyStrutTowerCrackMinor,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerCrackMinor = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Sealant missing crack repaired',
                    ),
                    value: rightDickeyStrutTowerSealantMissingCrackRepaired,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerSealantMissingCrackRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Punches open repaired',
                    ),
                    value: rightDickeyStrutTowerPunchesOpenRepaired,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerPunchesOpenRepaired = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Replaced',
                    ),
                    value: rightDickeyStrutTowerReplaced,
                    onChanged: (val) {
                      setState(() {
                        rightDickeyStrutTowerReplaced = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () async {
                          if (selectedRightDickeyStrutTowerImage == null) {
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);

                            if (image != null) {
                              setState(() {
                                _selectedRightDickeyStrutTowerImage =
                                    File(image.path);
                              });
                              final result = await uploadImage(
                                imageVar: image,
                                imageRef:
                                    'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/dickey_strut_towers/right_dickey_strut_tower',
                              );
                              if (result.isNotEmpty) {
                                setState(() {
                                  selectedRightDickeyStrutTowerImage =
                                      result.toString();
                                  selectedAllImages.add(result);
                                  log("message ${selectedRightDickeyStrutTowerImage}");
                                });
                              }
                            }
                          }
                        },
                        child: _selectedRightDickeyStrutTowerImage != null
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(
                                        _selectedRightDickeyStrutTowerImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
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
              ]),
              _buildExpansionTile('Roof panel', [
                SwitchListTile(
                  title: const Text(
                    'Aftermarket dual tone paint',
                  ),
                  value: roofPanelAftermarketDualTonePaint,
                  onChanged: (val) {
                    setState(() {
                      roofPanelAftermarketDualTonePaint = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Aftermarket sunroof fitment',
                  ),
                  value: roofPanelAftermarketSunroofFitment,
                  onChanged: (val) {
                    setState(() {
                      roofPanelAftermarketSunroofFitment = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: roofPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      roofPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: roofPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      roofPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'External hole tear',
                  ),
                  value: roofPanelExternalHoleTear,
                  onChanged: (val) {
                    setState(() {
                      roofPanelExternalHoleTear = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Multiple dents dent minor',
                  ),
                  value: roofPanelMultipleDentsDentMinor,
                  onChanged: (val) {
                    setState(() {
                      roofPanelMultipleDentsDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Multiple dents dent major',
                  ),
                  value: roofPanelMultipleDentsDentMajor,
                  onChanged: (val) {
                    setState(() {
                      roofPanelMultipleDentsDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint defective',
                  ),
                  value: roofPanelPaintDefective,
                  onChanged: (val) {
                    setState(() {
                      roofPanelPaintDefective = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: roofPanelPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      roofPanelPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: roofPanelRepainted,
                  onChanged: (val) {
                    setState(() {
                      roofPanelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: roofPanelRepaired,
                  onChanged: (val) {
                    setState(() {
                      roofPanelRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: roofPanelScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      roofPanelScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: roofPanelScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      roofPanelScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Sealant missing',
                  ),
                  value: roofPanelSealantMissing,
                  onChanged: (val) {
                    setState(() {
                      roofPanelSealantMissing = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Wrapping',
                  ),
                  value: roofPanelWrapping,
                  onChanged: (val) {
                    setState(() {
                      roofPanelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRoofPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRoofPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/roof_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRoofPanelImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRoofPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRoofPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedRoofPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Spare tyre assembly', [
                SwitchListTile(
                  title: const Text(
                    'Spare tyre available',
                  ),
                  value: spareTyreAvailable,
                  onChanged: (val) {
                    setState(() {
                      spareTyreAvailable = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedSpareTyreAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedSpareTyreAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/roof_structure_and_root/spare_tyre_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedSpareTyreAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedSpareTyreAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedSpareTyreAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedSpareTyreAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
          ]),
          _buildCardExpansionTile('Right side', count: rightSideIssueCheck(), [
            _buildExpansionTile('Front right exterior', [
              _buildExpansionTile('Front right door panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontRightDoorPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontRightDoorPanelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontRightDoorPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontRightDoorPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontRightDoorPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontRightDoorPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontRightDoorPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontRightDoorPanelRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontRightDoorPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontRightDoorPanelReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontRightDoorPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontRightDoorPanelImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_exterior/front_right_door_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontRightDoorPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontRightDoorPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontRightDoorPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontRightDoorPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right fender lining', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightFenderLiningBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightFenderLiningBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightFenderLiningCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightFenderLiningCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightFenderLiningCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightFenderLiningCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightFenderLiningPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rightFenderLiningRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightFenderLiningReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightFenderLiningReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightFenderLiningImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightFenderLiningImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_exterior/right_fender_lining',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightFenderLiningImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightFenderLiningImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightFenderLiningImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightFenderLiningImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right fender panel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightFenderPanelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightFenderPanelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightFenderPanelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightFenderPanelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightFenderPanelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightFenderPanelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightFenderPanelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rightFenderPanelRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightFenderPanelReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightFenderPanelReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightFenderPanelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightFenderPanelImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/rear_side/front_right_exterior/right_fender_panel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightFenderPanelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightFenderPanelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightFenderPanelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightFenderPanelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right svm assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightSvmAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightSvmAssemblyBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightSvmAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightSvmAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightSvmAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightSvmAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightSvmAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: rightSvmAssemblyRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightSvmAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightSvmAssemblyReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightSvmAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightSvmAssemblyImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_exterior/right_svm_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightSvmAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightSvmAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightSvmAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightSvmAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Front right mechanical', [
              SwitchListTile(
                title: const Text(
                  'Exhaust system',
                ),
                value: frontRightMechanicalExhaustSystem,
                onChanged: (val) {
                  setState(() {
                    frontRightMechanicalExhaustSystem = val;
                  });
                },
              ),
              _buildExpansionTile('Four wheel drive', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: fourWheelDriveBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: fourWheelDriveBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: fourWheelDriveCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: fourWheelDriveCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: fourWheelDriveCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: fourWheelDriveCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: fourWheelDrivePunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDrivePunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: fourWheelDriveRepaired,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: fourWheelDriveReplaced,
                  onChanged: (val) {
                    setState(() {
                      fourWheelDriveReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFourWheelDriveImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFourWheelDriveImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_mechanical/four_wheel_drive',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFourWheelDriveImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFourWheelDriveImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFourWheelDriveImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedFourWheelDriveImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front right brake assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontRightBrakeAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontRightBrakeAssemblyBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontRightBrakeAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontRightBrakeAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontRightBrakeAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontRightBrakeAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontRightBrakeAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontRightBrakeAssemblyRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontRightBrakeAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontRightBrakeAssemblyReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontRightBrakeAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontRightBrakeAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_mechanical/front_right_brake_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontRightBrakeAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontRightBrakeAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontRightBrakeAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontRightBrakeAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front right suspension', [
                SwitchListTile(
                  title: const Text(
                    'Front jumping rod assembly',
                  ),
                  value: frontRightSuspensionFrontJumpingRodAssembly,
                  onChanged: (val) {
                    setState(() {
                      frontRightSuspensionFrontJumpingRodAssembly = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Front right link rod',
                  ),
                  value: frontRightSuspensionFrontRightLinkRod,
                  onChanged: (val) {
                    setState(() {
                      frontRightSuspensionFrontRightLinkRod = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Front right lower control arm assembly',
                  ),
                  value: frontRightSuspensionFrontRightLowerControlArmAssembly,
                  onChanged: (val) {
                    setState(() {
                      frontRightSuspensionFrontRightLowerControlArmAssembly =
                          val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Front right strut assembly',
                  ),
                  value: frontRightSuspensionFrontRightStrutAssembly,
                  onChanged: (val) {
                    setState(() {
                      frontRightSuspensionFrontRightStrutAssembly = val;
                    });
                  },
                ),
              ]),
              _buildExpansionTile('Front right tyre assembly', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontRightTyreAssemblyBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontRightTyreAssemblyBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontRightTyreAssemblyCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontRightTyreAssemblyCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontRightTyreAssemblyCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontRightTyreAssemblyCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontRightTyreAssemblyPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontRightTyreAssemblyRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontRightTyreAssemblyReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontRightTyreAssemblyReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontRightTyreAssemblyImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontRightTyreAssemblyImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_mechanical/front_right_tyre_assembly',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontRightTyreAssemblyImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontRightTyreAssemblyImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontRightTyreAssemblyImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedFrontRightTyreAssemblyImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Front wheel drive', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: frontWheelDriveBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: frontWheelDriveBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: frontWheelDriveCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: frontWheelDriveCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: frontWheelDriveCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: frontWheelDriveCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: frontWheelDrivePunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDrivePunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repaired',
                  ),
                  value: frontWheelDriveRepaired,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: frontWheelDriveReplaced,
                  onChanged: (val) {
                    setState(() {
                      frontWheelDriveReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedFrontWheelDriveImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedFrontWheelDriveImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/front_right_mechanical/front_wheel_drive',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedFrontWheelDriveImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedFrontWheelDriveImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedFrontWheelDriveImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      FileImage(_selectedFrontWheelDriveImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Rear right structure', [
              _buildExpansionTile('Rear right door channel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearRightDoorChannelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rearRightDoorChannelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearRightDoorChannelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearRightDoorChannelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearRightDoorChannelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearRightDoorChannelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearRightDoorChannelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearRightDoorChannelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearRightDoorChannelPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearRightDoorChannelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearRightDoorChannelRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearRightDoorChannelReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearRightDoorChannelScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearRightDoorChannelScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearRightDoorChannelWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearRightDoorChannelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearRightDoorChannelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearRightDoorChannelImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/rear_right_door_channel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearRightDoorChannelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearRightDoorChannelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearRightDoorChannelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearRightDoorChannelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear right floor pan', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearRightFloorPanBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rearRightFloorPanBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearRightFloorPanCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearRightFloorPanCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearRightFloorPanCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearRightFloorPanCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearRightFloorPanHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearRightFloorPanHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearRightFloorPanPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearRightFloorPanPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearRightFloorPanRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearRightFloorPanReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearRightFloorPanScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearRightFloorPanScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearRightFloorPanWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearRightFloorPanWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearRightFloorPanImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearRightFloorPanImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/rear_right_floor_pan',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearRightFloorPanImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearRightFloorPanImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearRightFloorPanImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearRightFloorPanImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Rear right wheel house', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rearRightWheelHouseBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rearRightWheelHouseBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rearRightWheelHouseCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rearRightWheelHouseCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rearRightWheelHouseCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rearRightWheelHouseCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rearRightWheelHouseHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rearRightWheelHouseHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rearRightWheelHousePaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHousePaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rearRightWheelHousePunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHousePunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rearRightWheelHouseRepainted,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rearRightWheelHouseReplaced,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rearRightWheelHouseScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rearRightWheelHouseScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rearRightWheelHouseWrapping,
                  onChanged: (val) {
                    setState(() {
                      rearRightWheelHouseWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRearRightWheelHouseImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRearRightWheelHouseImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/rear_right_wheel_house',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRearRightWheelHouseImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRearRightWheelHouseImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRearRightWheelHouseImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRearRightWheelHouseImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right floor pan channel', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightFloorPanChannelBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightFloorPanChannelBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightFloorPanChannelCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightFloorPanChannelCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightFloorPanChannelCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightFloorPanChannelCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rightFloorPanChannelHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rightFloorPanChannelHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rightFloorPanChannelPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightFloorPanChannelPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rightFloorPanChannelRepainted,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightFloorPanChannelReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rightFloorPanChannelScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rightFloorPanChannelScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rightFloorPanChannelWrapping,
                  onChanged: (val) {
                    setState(() {
                      rightFloorPanChannelWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightFloorPanChannelImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightFloorPanChannelImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/right_floor_pan_channel',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightFloorPanChannelImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightFloorPanChannelImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightFloorPanChannelImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightFloorPanChannelImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right pillar B', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightPillarBBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightPillarBBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightPillarBCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightPillarBCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightPillarBCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightPillarBCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rightPillarBHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rightPillarBHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rightPillarBPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightPillarBPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rightPillarBRepainted,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightPillarBReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rightPillarBScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rightPillarBScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rightPillarBWrapping,
                  onChanged: (val) {
                    setState(() {
                      rightPillarBWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightPillarBImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightPillarBImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/right_pillar_B',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightPillarBImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightPillarBImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightPillarBImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedRightPillarBImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right pillar C', [
                SwitchListTile(
                  title: const Text(
                    'Bend dent major',
                  ),
                  value: rightPillarCBendDentMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCBendDentMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Bend dent minor',
                  ),
                  value: rightPillarCBendDentMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCBendDentMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightPillarCCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightPillarCCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack major',
                  ),
                  value: rightPillarCCrackMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCCrackMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Crack minor',
                  ),
                  value: rightPillarCCrackMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCCrackMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired major',
                  ),
                  value: rightPillarCHammerRepairedMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCHammerRepairedMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Hammer repaired minor',
                  ),
                  value: rightPillarCHammerRepairedMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCHammerRepairedMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rightPillarCPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightPillarCPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rightPillarCRepainted,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightPillarCReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCReplaced = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches major',
                  ),
                  value: rightPillarCScratchesMajor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCScratchesMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Scratches minor',
                  ),
                  value: rightPillarCScratchesMinor,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCScratchesMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'wrapping',
                  ),
                  value: rightPillarCWrapping,
                  onChanged: (val) {
                    setState(() {
                      rightPillarCWrapping = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightPillarCImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightPillarCImage = File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/right_pillar_c',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightPillarCImage = result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightPillarCImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightPillarCImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_selectedRightPillarCImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
              _buildExpansionTile('Right running board', [
                SwitchListTile(
                  title: const Text(
                    'Crack',
                  ),
                  value: rightRunningBoardCrack,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardCrack = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion major',
                  ),
                  value: rightRunningBoardCorrosionMajor,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardCorrosionMajor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Corrosion minor',
                  ),
                  value: rightRunningBoardCorrosionMinor,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardCorrosionMinor = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint defective',
                  ),
                  value: rightRunningBoardPaintDefective,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardPaintDefective = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Paint mismatch',
                  ),
                  value: rightRunningBoardPaintMisMatch,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardPaintMisMatch = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Punches open repaired',
                  ),
                  value: rightRunningBoardPunchesOpenRepaired,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardPunchesOpenRepaired = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Repainted',
                  ),
                  value: rightRunningBoardRepainted,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardRepainted = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Replaced',
                  ),
                  value: rightRunningBoardReplaced,
                  onChanged: (val) {
                    setState(() {
                      rightRunningBoardReplaced = val;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        if (selectedRightRunningBoardImage == null) {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              _selectedRightRunningBoardImage =
                                  File(image.path);
                            });
                            final result = await uploadImage(
                              imageVar: image,
                              imageRef:
                                  'inspection/$getInspectionUID/car_health/right_side/rear_right_structure/right_running_board',
                            );
                            if (result.isNotEmpty) {
                              setState(() {
                                selectedRightRunningBoardImage =
                                    result.toString();
                                selectedAllImages.add(result);
                                log("message ${selectedRightRunningBoardImage}");
                              });
                            }
                          }
                        }
                      },
                      child: _selectedRightRunningBoardImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(
                                      _selectedRightRunningBoardImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
            ]),
            _buildExpansionTile('Right mechanical', [
              SwitchListTile(
                title: const Text(
                  'Bend dent major',
                ),
                value: rightMechanicalBendDentMajor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalBendDentMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Bend dent minor',
                ),
                value: rightMechanicalBendDentMinor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalBendDentMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion major',
                ),
                value: rightMechanicalCorrosionMajor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalCorrosionMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Corrosion minor',
                ),
                value: rightMechanicalCorrosionMinor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalCorrosionMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack major',
                ),
                value: rightMechanicalCrackMajor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalCrackMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Crack minor',
                ),
                value: rightMechanicalCrackMinor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalCrackMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired major',
                ),
                value: rightMechanicalHammerRepairedMajor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalHammerRepairedMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Hammer repaired minor',
                ),
                value: rightMechanicalHammerRepairedMinor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalHammerRepairedMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Paint mismatch',
                ),
                value: rightMechanicalPaintMisMatch,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalPaintMisMatch = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Punches open repaired',
                ),
                value: rightMechanicalPunchesOpenRepaired,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalPunchesOpenRepaired = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Repainted',
                ),
                value: rightMechanicalRepainted,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalRepainted = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Replaced',
                ),
                value: rightMechanicalReplaced,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalReplaced = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches major',
                ),
                value: rightMechanicalScratchesMajor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalScratchesMajor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Scratches minor',
                ),
                value: rightMechanicalScratchesMinor,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalScratchesMinor = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'wrapping',
                ),
                value: rightMechanicalWrapping,
                onChanged: (val) {
                  setState(() {
                    rightMechanicalWrapping = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedRightMechanicalImage == null) {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);

                        if (image != null) {
                          setState(() {
                            _selectedRightMechanicalImage = File(image.path);
                          });
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/$getInspectionUID/car_health/right_side/right_right_mechanical',
                          );
                          if (result.isNotEmpty) {
                            setState(() {
                              selectedRightMechanicalImage = result.toString();
                              selectedAllImages.add(result);
                              log("message ${selectedRightMechanicalImage}");
                            });
                          }
                        }
                      }
                    },
                    child: _selectedRightMechanicalImage != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image:
                                    FileImage(_selectedRightMechanicalImage!),
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
          ]),
          _buildCardExpansionTile('Test Drive', count: testDriveIssueCheck(), [
            SwitchListTile(
              title: const Text(
                'Steering health',
              ),
              value: testDriveSteeringHealth,
              onChanged: (val) {
                setState(() {
                  testDriveSteeringHealth = val;
                });
              },
            ),
            _buildExpansionTile('Accelerate to check clutch', [
              SwitchListTile(
                title: const Text(
                  'Clutch pedal vibration',
                ),
                value: testDriveClutchPedalVibration,
                onChanged: (val) {
                  setState(() {
                    testDriveClutchPedalVibration = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Noise from turbocharger',
                ),
                value: testDriveNoiseFromTurbocharger,
                onChanged: (val) {
                  setState(() {
                    testDriveNoiseFromTurbocharger = val;
                  });
                },
              ),
            ]),
            _buildExpansionTile('Apply brakes till car stop', [
              SwitchListTile(
                title: const Text(
                  'Front brake noise vibration',
                ),
                value: testDriveFrontBrakeNoiseVibration,
                onChanged: (val) {
                  setState(() {
                    testDriveFrontBrakeNoiseVibration = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Idle start stop not working',
                ),
                value: testDriveIdleStartStopNotWorking,
                onChanged: (val) {
                  setState(() {
                    testDriveIdleStartStopNotWorking = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(
                  'Rear brake noise vibration',
                ),
                value: testDriveRearBrakeNoiseVibration,
                onChanged: (val) {
                  setState(() {
                    testDriveRearBrakeNoiseVibration = val;
                  });
                },
              ),
            ]),
          ]),
          ElevatedButton(
            onPressed: () {
              if (_selectedBatteryImage == null) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please selcted battery image");
              } else if (_selectedBonnetImage == null) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please selcted bonnet image");
              } else if (extraParts.text.isEmpty) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Enter Extra Parts");
              } else if (_selectedCarKeyImage == null) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please selcted car key image");
              } else if (_selectedCentralLockingRemoteHousingImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg:
                        "Please selcted central locking remote housing image");
              } else if (_selectedFrontBumperGrillImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front bumper grill image");
              } else if (_selectedFrontBumperPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front bumper panel image");
              } else if (_selectedFrontRegistrationPlateImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front registration plate image");
              } else if (_selectedFrontLeftFogLightHousingImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg:
                        "Please selcted front left fog light housing image");
              } else if (_selectedFrontRightFogLightHousingImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg:
                        "Please selcted front right fog light housing image");
              } else if (_selectedLeftHeadlightAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left headlight assembly image");
              } else if (_selectedLeftHeadlightHousingImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left headlight housing image");
              } else if (_selectedLeftDrlImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left drl image");
              } else if (_selectedRightHeadlightAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right headlight assembly image");
              } else if (_selectedRightHeadlightHousingImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right headlight housing image");
              } else if (_selectedRightDrlImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right drl image");
              } else if (_selectedFrontLeftLegImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front left leg image");
              } else if (_selectedFrontRightLeftImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front right left image");
              } else if (_selectedAcAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted ac assembly image");
              } else if (_selectedAirBagsImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted air bags image");
              } else if (_selectedClusterPanelAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted cluster panel assembly image");
              } else if (_selectedDashboardAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted dashboard assembly image");
              } else if (_selectedFrontWindshieldGlassImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front windshield glass image");
              } else if (_selectedSeatsImage == null) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please selcted seats image");
              } else if (_selectedAudioStereoAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted audio stereo assembly image");
              } else if (_selectedCentreConsoleAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted centre console assembly image");
              } else if (_selectedForwardParkingSensorsImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted forward parking sensors image");
              } else if (_selectedFrontRightDoorAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front right Door assembly image");
              } else if (_selectedFrontLeftDoorAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front left door assembly image");
              } else if (_selectedReverseParkingCameraImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted reverse parking camera image");
              } else if (_selectedReverseParkingSensorsImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted reverse parking sensors image");
              } else if (_selectedFrontLeftExteriorImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front left exterior image");
              } else if (_selectedFrontLeftMechanicalImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front left mechanical image");
              } else if (_selectedRearLeftExteriorImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear left exterior image");
              } else if (_selectedRearLeftMechanicalImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear left mechanical image");
              } else if (_selectedLeftFloorPanChannelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left floor pan channel image");
              } else if (_selectedLeftPillarBImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left pillar B image");
              } else if (_selectedLeftPillarCImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left pillar C image");
              } else if (_selectedLeftRunningBoardImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left running board image");
              } else if (_selectedRearLeftFloorPanImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear left floor pan image");
              } else if (_selectedRearLeftDoorChannelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear left door channel image");
              } else if (_selectedRearLeftWheelHouseImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear left wheel house image");
              } else if (_selectedLeftFenderLiningImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left fender lining image");
              } else if (_selectedLeftFenderPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left fender panel image");
              } else if (_selectedLeftSvmAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left svm assembly image");
              } else if (_selectedRearLeftDoorPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear left door panel image");
              } else if (_selectedDickeyDoorPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted dickey door panel image");
              } else if (_selectedDickeyLeftStayRodShockerImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg:
                        "Please selcted dickey left stay rod shocker image");
              } else if (_selectedDickeyRightStayRodShockerImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg:
                        "Please selcted dickey right stay rod shocker image");
              } else if (_selectedLeftTailLightAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left tail light assembly image");
              } else if (_selectedRearBumperPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear bumper panel image");
              } else if (_selectedRearWindshieldGlassImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear Windshield glass image");
              } else if (_selectedRearRegistrationPlateImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear registration plate image");
              } else if (_selectedRightTailLightAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right tail light assembly image");
              } else if (_selectedDickeyBackPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted dickey back panel image");
              } else if (_selectedDickeyFloorImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted dickey floor image");
              } else if (_selectedDickeyLeftLegImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted dickey left leg image");
              } else if (_selectedDickeyRightLegImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted dickey right leg image");
              } else if (_selectedLeftDickeySidewallImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left dickey sidewall image");
              } else if (_selectedRightDickeySidewallImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear registration plate image");
              } else if (_selectedLeftDickeyStrutTowerImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted left dickey strut tower image");
              } else if (_selectedRightDickeyStrutTowerImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right dickey strut tower image");
              } else if (_selectedRoofPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted roof panel image");
              } else if (_selectedSpareTyreAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted spare tyre assembly image");
              } else if (_selectedFrontRightDoorPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front right door panel image");
              } else if (_selectedRightFenderLiningImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right fender lining image");
              } else if (_selectedRightFenderPanelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right fender panel image");
              } else if (_selectedRightSvmAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right svm assembly image");
              } else if (_selectedFourWheelDriveImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted four wheel drive image");
              } else if (_selectedFrontRightBrakeAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg:
                        "Please selcted front right brake assembly image");
              } else if (_selectedFrontWheelDriveImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front wheel drive image");
              } else if (_selectedFrontRightTyreAssemblyImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted front right tyre assembly image");
              } else if (_selectedRightMechanicalImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right mechanical image");
              } else if (_selectedRearRightDoorChannelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear right door channel image");
              } else if (_selectedRearRightWheelHouseImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted rear right wheel house image");
              } else if (_selectedRightFloorPanChannelImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right floor pan channel image");
              } else if (_selectedRightPillarBImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right pillar B image");
              } else if (_selectedRightPillarCImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right pillar C image");
              } else if (_selectedRightRunningBoardImage == null) {
                return showErrorSnackBar(
                    context: context,
                    errorMsg: "Please selcted right running board image");
              } else if (carDoc == null) {
                return showErrorSnackBar(
                    context: context, errorMsg: "Please save car details");
              }

              if (_formInspectionKey.currentState!.validate()) {
                setState(() {
                  _carFairPriceController.text =
                      widget.carDetails.carCarPrice.toString();
                  _showReMarksOptions(context);
                });
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showReMarksOptions(BuildContext context) {
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
                    // First TextField
                    _buildTextField(
                      _carFairPriceController,
                      'Car Fair Price',
                      isNumber: true,
                      (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 14.0),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formBottomKey.currentState!.validate()) {
                            _saveCarInspection();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
  Widget _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius
        side: BorderSide.none, // No border
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: children,
    );
  }

  // Helper method to create sections with an expandable tile
  Widget _buildCardExpansionTile(String title, List<Widget> children,
      {int? count = 0}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            count.toString(),
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
    );
  }
}
