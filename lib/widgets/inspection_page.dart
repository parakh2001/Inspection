// import 'package:flutter/material.dart';
// final _formKey = GlobalKey<FormState>();
// final _formInspectionKey = GlobalKey<FormState>();
// final _formBottomKey = GlobalKey<FormState>();
// Widget _buildInspectionPage() {
//   return Form(
//     key: _formInspectionKey,
//     child: ListView(
//       padding: const EdgeInsets.all(16.0),
//       children: [
//         _buildCardExpansionTile('Battery', count: batteryIssueCheck(), [
//           SwitchListTile(
//             title: const Text(
//               'Aftermarket fitment',
//             ),
//             value: battryAfterMarketFitment,
//             onChanged: (val) {
//               setState(() {
//                 battryAfterMarketFitment = val;
//               });
//             },
//           ),
//           SwitchListTile(
//             title: const Text(
//               'Leakage',
//             ),
//             value: battryLeakage,
//             onChanged: (val) {
//               setState(() {
//                 battryLeakage = val;
//               });
//             },
//           ),
//           SwitchListTile(
//             title: const Text(
//               'Damaged',
//             ),
//             value: battryDamaged,
//             onChanged: (val) {
//               setState(() {
//                 battryDamaged = val;
//               });
//             },
//           ),
//           SwitchListTile(
//             title: const Text(
//               'Wrong size',
//             ),
//             value: battryWrongSize,
//             onChanged: (val) {
//               setState(() {
//                 battryWrongSize = val;
//               });
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: GestureDetector(
//                 onTap: () async {
//                   if (selectedBatteryImage == null) {
//                     final XFile? image =
//                         await picker.pickImage(source: ImageSource.camera);
//                     if (image != null) {
//                       setState(() {
//                         _selectedBatteryImage = File(image.path);
//                       });
//                       final result = await uploadImage(
//                         imageVar: image,
//                         imageRef:
//                             'inspection/${widget.carDetails.serialNumber}/car_health/battery',
//                       );
//                       if (result.isNotEmpty) {
//                         setState(() {
//                           selectedBatteryImage = result.toString();
//                           selectedAllImages.add(result);
//                           log("message ${selectedBatteryImage}");
//                         });
//                       }
//                     }
//                   }
//                 },
//                 child: _selectedBatteryImage != null
//                     ? Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           image: DecorationImage(
//                             image: FileImage(_selectedBatteryImage!),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       )
//                     : Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(width: 1, color: Colors.grey),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             "Upload Image",
//                             style: TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ]),
//         _buildCardExpansionTile('Engine', count: engineIssueCheck(), [
//           _buildExpansionTile('Static engine on', [
//             _buildExpansionSubTile('Check for at gear box leakages', [
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from at gearbox housing',
//                 ),
//                 value: leakageFromAtGearboxHousing,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromAtGearboxHousing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from at input shaft',
//                 ),
//                 value: leakageFromAtInputShaft,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromAtInputShaft = val;
//                   });
//                 },
//               ),
//             ]),
//             _buildExpansionSubTile('Check for engine leakages', [
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from engine block',
//                 ),
//                 value: leakageFromEngineBlock,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromEngineBlock = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from exhaust manifold',
//                 ),
//                 value: leakageFromExhaustManifold,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromExhaustManifold = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from turbocharger',
//                 ),
//                 value: leakageFromTurbocharger,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromTurbocharger = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from metal timing',
//                 ),
//                 value: leakageFromMetalTiming,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromMetalTiming = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Seepage from engine timing',
//                 ),
//                 value: seepageFromEngineTiming,
//                 onChanged: (val) {
//                   setState(() {
//                     seepageFromEngineTiming = val;
//                   });
//                 },
//               ),
//             ]),
//             _buildExpansionSubTile('Check for engine performances', [
//               SwitchListTile(
//                 title: const Text(
//                   'Back compression in engine',
//                 ),
//                 value: backCompressionInEngine,
//                 onChanged: (val) {
//                   setState(() {
//                     backCompressionInEngine = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Overheating due to radiator system',
//                 ),
//                 value: overheaingDueToRadiatorSystem,
//                 onChanged: (val) {
//                   setState(() {
//                     overheaingDueToRadiatorSystem = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Overheating in engine',
//                 ),
//                 value: overheatingInEngine,
//                 onChanged: (val) {
//                   setState(() {
//                     overheatingInEngine = val;
//                   });
//                 },
//               ),
//             ]),
//             _buildExpansionSubTile('Check for manual gear box leakages', [
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from 5th gear housing',
//                 ),
//                 value: leakageFrom5ThGearHousing,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFrom5ThGearHousing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from drive axle',
//                 ),
//                 value: leakageFromDriveAxle,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromDriveAxle = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from mt gearbox housing',
//                 ),
//                 value: leakageFromMtGearboxHousing,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromMtGearboxHousing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Leakage from mt input shaft',
//                 ),
//                 value: leakageFromMtInputShaft,
//                 onChanged: (val) {
//                   setState(() {
//                     leakageFromMtInputShaft = val;
//                   });
//                 },
//               ),
//             ]),
//             // _buildExpansionTile('Video', [
//             //   _buildTextField(
//             //     engineNoiseVideo,
//             //     'Engine noise video',
//             //     (value) {
//             //       if (value!.isEmpty) {
//             //         return 'Enter noise video';
//             //       }
//             //       return null;
//             //     },
//             //   ),
//             //   _buildTextField(
//             //     testDriveVideo,
//             //     'Test drive video',
//             //     (value) {
//             //       if (value!.isEmpty) {
//             //         return 'Enter test drive video';
//             //       }
//             //       return null;
//             //     },
//             //   ),
//             // ]),
//           ]),
//         ]),
//         _buildCardExpansionTile('Extra', [
//           _buildTextField(
//             extraParts,
//             'Extra Parts',
//             (value) {
//               if (value!.isEmpty) {
//                 return 'Enter Extra Parts';
//               }
//               return null;
//             },
//           ),
//         ]),
//         _buildCardExpansionTile('Front Side', count: frontSideIssueCheck(), [
//           _buildExpansionTile('Front exterior 1', [
//             _buildExpansionSubTile('Bonnet panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Alignment out',
//                 ),
//                 value: bonnetAlignmentOut,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetAlignmentOut = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: bonnetCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: bonnetCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: bonnetRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: bonnetReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Sealant missing/crack/repaired',
//                 ),
//                 value: bonnetSealantMissingCrackRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetSealantMissingCrackRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Wrapping',
//                 ),
//                 value: bonnetWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetWrapping = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint defective',
//                 ),
//                 value: bonnetPaintDefective,
//                 onChanged: (val) {
//                   setState(() {
//                     bonnetPaintDefective = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedBonnetImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedBonnetImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_1/bonnet_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedBonnetImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedBonnetImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedBonnetImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedBonnetImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Car key', [
//               SwitchListTile(
//                 title: const Text(
//                   'one key missing',
//                 ),
//                 value: carKeyOneKeyMissing,
//                 onChanged: (val) {
//                   setState(() {
//                     carKeyOneKeyMissing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'No free movement',
//                 ),
//                 value: carKeyNoFreeMovement,
//                 onChanged: (val) {
//                   setState(() {
//                     carKeyNoFreeMovement = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Damaged minor',
//                 ),
//                 value: carKeyDamagedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     carKeyDamagedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Damaged major',
//                 ),
//                 value: carKeyDamagedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     carKeyDamagedMajor = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedCarKeyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedCarKeyImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_1/car_key',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedCarKeyImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedCarKeyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedCarKeyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedCarKeyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Central locking remote housing', [
//               SwitchListTile(
//                 title: const Text(
//                   'one key missing',
//                 ),
//                 value: centralLockingRemoteHousingOneKeyMissing,
//                 onChanged: (val) {
//                   setState(() {
//                     centralLockingRemoteHousingOneKeyMissing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'No free movement',
//                 ),
//                 value: centralLockingRemoteHousingNoFreeMovement,
//                 onChanged: (val) {
//                   setState(() {
//                     centralLockingRemoteHousingNoFreeMovement = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Damaged minor',
//                 ),
//                 value: centralLockingRemoteHousingDamagedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     centralLockingRemoteHousingDamagedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Damaged major',
//                 ),
//                 value: centralLockingRemoteHousingDamagedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     centralLockingRemoteHousingDamagedMajor = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedCentralLockingRemoteHousingImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedCentralLockingRemoteHousingImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_1/central_locking_remote_housing',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedCentralLockingRemoteHousingImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedCentralLockingRemoteHousingImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedCentralLockingRemoteHousingImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedCentralLockingRemoteHousingImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Front bumper grill', [
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontBumperGrillCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperGrillCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontBumperGrillCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperGrillCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: frontBumperGrillScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperGrillScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: frontBumperGrillScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperGrillScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontBumperGrillRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperGrillRepaired = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontBumperGrillImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontBumperGrillImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_1/front_bumper_grill',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontBumperGrillImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontBumperGrillImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontBumperGrillImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedFrontBumperGrillImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Front bumper panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Part missing',
//                 ),
//                 value: frontBumperPanelPartMissing,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperPanelPartMissing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: frontBumperPanelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperPanelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Tab locks screw repaired',
//                 ),
//                 value: frontBumperPanelTabLocksScrewRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperPanelTabLocksScrewRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Wrapping',
//                 ),
//                 value: frontBumperPanelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     frontBumperPanelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontBumperPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontBumperPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_1/front_bumper_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontBumperPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontBumperPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontBumperPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedFrontBumperPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Front registration plate', [
//               SwitchListTile(
//                 title: const Text(
//                   'Part missing',
//                 ),
//                 value: frontRegistrationPlatePartMissing,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRegistrationPlatePartMissing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Aftermarket fitment',
//                 ),
//                 value: frontRegistrationPlateAftermarketFitment,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRegistrationPlateAftermarketFitment = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'damaged major',
//                 ),
//                 value: frontRegistrationPlateDamagedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRegistrationPlateDamagedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'damaged minor',
//                 ),
//                 value: frontRegistrationPlateDamagedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRegistrationPlateDamagedMinor = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontRegistrationPlateImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontRegistrationPlateImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_1/front_registration_plate',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontRegistrationPlateImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontRegistrationPlateImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontRegistrationPlateImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedFrontRegistrationPlateImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Front exterior 2', [
//             _buildExpansionSubTile('Front left fog light housing', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontLeftFogLightHousingBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontLeftFogLightHousingBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontLeftFogLightHousingCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontLeftFogLightHousingCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontLeftFogLightHousingCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontLeftFogLightHousingCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontLeftFogLightHousingPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontLeftFogLightHousingRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontLeftFogLightHousingReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftFogLightHousingReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontLeftFogLightHousingImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontLeftFogLightHousingImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/front_left_fog_light_housing',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontLeftFogLightHousingImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontLeftFogLightHousingImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontLeftFogLightHousingImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedFrontLeftFogLightHousingImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Front right fog light housing', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontRightFogLightHousingBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontRightFogLightHousingBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontRightFogLightHousingCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontRightFogLightHousingCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontRightFogLightHousingCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontRightFogLightHousingCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontRightFogLightHousingPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontRightFogLightHousingRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontRightFogLightHousingReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightFogLightHousingReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontRightFogLightHousingImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontRightFogLightHousingImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/front_right_fog_light_housing',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontRightFogLightHousingImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontRightFogLightHousingImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontRightFogLightHousingImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedFrontRightFogLightHousingImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left DRL', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftDrlBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: leftDrlBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftDrlCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftDrlCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftDrlCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftDrlCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftDrlPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: leftDrlRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftDrlReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftDrlReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftDrlImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftDrlImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/left_DRL',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftDrlImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftDrlImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftDrlImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedLeftDrlImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left headlight assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftHeadlightAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: leftHeadlightAssemblyBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftHeadlightAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftHeadlightAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftHeadlightAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftHeadlightAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftHeadlightAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: leftHeadlightAssemblyRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftHeadlightAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftHeadlightAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftHeadlightAssemblyImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/left_headlight_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftHeadlightAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftHeadlightAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftHeadlightAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedLeftHeadlightAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left headlight housing', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftHeadlightHousingBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: leftHeadlightHousingBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftHeadlightHousingCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftHeadlightHousingCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftHeadlightHousingCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftHeadlightHousingCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftHeadlightHousingPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: leftHeadlightHousingRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftHeadlightHousingReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftHeadlightHousingReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftHeadlightHousingImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftHeadlightHousingImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/left_headlight_housing',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftHeadlightHousingImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftHeadlightHousingImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftHeadlightHousingImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedLeftHeadlightHousingImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right DRL', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightDrlBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightDrlBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightDrlCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightDrlCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightDrlCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightDrlCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightDrlPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rightDrlRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightDrlReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightDrlReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightDrlImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightDrlImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/right_DRL',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightDrlImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightDrlImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightDrlImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedRightDrlImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right headlight assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightHeadlightAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightHeadlightAssemblyBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightHeadlightAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightHeadlightAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightHeadlightAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightHeadlightAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightHeadlightAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rightHeadlightAssemblyRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightHeadlightAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightHeadlightAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightHeadlightAssemblyImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/right_headlight_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightHeadlightAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightHeadlightAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightHeadlightAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRightHeadlightAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right headlight housing', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightHeadlightHousingBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightHeadlightHousingBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightHeadlightHousingCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightHeadlightHousingCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightHeadlightHousingCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightHeadlightHousingCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightHeadlightHousingPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rightHeadlightHousingRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightHeadlightHousingReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightHeadlightHousingReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightHeadlightHousingImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightHeadlightHousingImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_exterior_2/right_headlight_housing',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightHeadlightHousingImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightHeadlightHousingImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightHeadlightHousingImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRightHeadlightHousingImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Front structure 1', [
//             _buildExpansionSubTile('Bolted radiator support', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: boltedRadiatorSupportBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     boltedRadiatorSupportBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: boltedRadiatorSupportBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     boltedRadiatorSupportBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: boltedRadiatorSupportCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     boltedRadiatorSupportCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: boltedRadiatorSupportCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     boltedRadiatorSupportCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: boltedRadiatorSupportCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     boltedRadiatorSupportCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: boltedRadiatorSupportCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     boltedRadiatorSupportCrackMinor = val;
//                   });
//                 },
//               ),
//             ]),
//             _buildExpansionSubTile('Fibre radiator support', [
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: fibreRadiatorSupportCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     fibreRadiatorSupportCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: fibreRadiatorSupportCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     fibreRadiatorSupportCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: fibreRadiatorSupportRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     fibreRadiatorSupportRepaired = val;
//                   });
//                 },
//               ),
//             ]),
//             _buildExpansionSubTile('Front left leg', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontLeftLegBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontLeftLegBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontLeftLegCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontLeftLegCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontLeftLegCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontLeftLegCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontLeftLegPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontLeftLegRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontLeftLegReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontLeftLegReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontLeftLegImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontLeftLegImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_structure_1/front_left_leg',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontLeftLegImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontLeftLegImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontLeftLegImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedFrontLeftLegImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Front right left', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontRightLeftBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontRightLeftBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontRightLeftCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontRightLeftCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontRightLeftCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontRightLeftCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontRightLeftPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontRightLeftRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontRightLeftReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightLeftReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontRightLeftImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontRightLeftImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/front_side/front_structure_1/front_right_leg',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontRightLeftImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontRightLeftImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontRightLeftImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedFrontRightLeftImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Welded radiator support', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: weldedRadiatorSupportBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     weldedRadiatorSupportBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: weldedRadiatorSupportBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     weldedRadiatorSupportBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: weldedRadiatorSupportCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     weldedRadiatorSupportCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: weldedRadiatorSupportCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     weldedRadiatorSupportCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: weldedRadiatorSupportCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     weldedRadiatorSupportCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: weldedRadiatorSupportCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     weldedRadiatorSupportCrackMinor = val;
//                   });
//                 },
//               ),
//             ]),
//           ]),
//         ]),
//         _buildCardExpansionTile('Interior-1', count: interior1IssueCheck(), [
//           _buildExpansionTile('Ac assembly', [
//             SwitchListTile(
//               title: const Text(
//                 'Less effective',
//               ),
//               value: acAssemblyLessEffective,
//               onChanged: (val) {
//                 setState(() {
//                   acAssemblyLessEffective = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Not working',
//               ),
//               value: acAssemblyNotWorking,
//               onChanged: (val) {
//                 setState(() {
//                   acAssemblyNotWorking = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Noise',
//               ),
//               value: acAssemblyNoise,
//               onChanged: (val) {
//                 setState(() {
//                   acAssemblyNoise = val;
//                 });
//               },
//             ),
//           ]),
//           _buildExpansionTile('Air Bags', [
//             SwitchListTile(
//               title: const Text(
//                 'Driver side',
//               ),
//               value: airBagsDriverSide,
//               onChanged: (val) {
//                 setState(() {
//                   airBagsDriverSide = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Passenger side',
//               ),
//               value: airBagsPassengerSide,
//               onChanged: (val) {
//                 setState(() {
//                   airBagsPassengerSide = val;
//                 });
//               },
//             ),
//           ]),
//           _buildExpansionTile('Cluster panel assembly', [
//             SwitchListTile(
//               title: const Text(
//                 'Engine check light',
//               ),
//               value: clusterPanelAssemblyEngineCheckLight,
//               onChanged: (val) {
//                 setState(() {
//                   clusterPanelAssemblyEngineCheckLight = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Abs light',
//               ),
//               value: clusterPanelAssemblyAbsLight,
//               onChanged: (val) {
//                 setState(() {
//                   clusterPanelAssemblyAbsLight = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Automatic transmission light',
//               ),
//               value: clusterPanelAssemblyAutomaticTransmissionLight,
//               onChanged: (val) {
//                 setState(() {
//                   clusterPanelAssemblyAutomaticTransmissionLight = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Srs light',
//               ),
//               value: clusterPanelAssemblySrsLight,
//               onChanged: (val) {
//                 setState(() {
//                   clusterPanelAssemblySrsLight = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Speedometer',
//               ),
//               value: clusterPanelAssemblySpeedometer,
//               onChanged: (val) {
//                 setState(() {
//                   clusterPanelAssemblySpeedometer = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedClusterPanelAssemblyImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedClusterPanelAssemblyImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_1/cluster_panel_assembly',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedClusterPanelAssemblyImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedClusterPanelAssemblyImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedClusterPanelAssemblyImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedClusterPanelAssemblyImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Dashboard assembly', [
//             _buildExpansionSubTile('Ac vent', [
//               SwitchListTile(
//                 title: const Text(
//                   'Working',
//                 ),
//                 value: dashboardAssemblyAcVentWorking,
//                 onChanged: (val) {
//                   setState(() {
//                     dashboardAssemblyAcVentWorking = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Damaged',
//                 ),
//                 value: dashboardAssemblyAcVentDamaged,
//                 onChanged: (val) {
//                   setState(() {
//                     dashboardAssemblyAcVentDamaged = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDashboardAssemblyAcVentImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDashboardAssemblyAcVentImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/Interior_1/seats',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDashboardAssemblyAcVentImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDashboardAssemblyAcVentImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDashboardAssemblyAcVentImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedDashboardAssemblyAcVentImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Ac controls', [
//               SwitchListTile(
//                 title: const Text(
//                   'Working',
//                 ),
//                 value: dashboardAssemblyAcControlsWorking,
//                 onChanged: (val) {
//                   setState(() {
//                     dashboardAssemblyAcControlsWorking = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Damaged',
//                 ),
//                 value: dashboardAssemblyAcControlsDamaged,
//                 onChanged: (val) {
//                   setState(() {
//                     dashboardAssemblyAcControlsDamaged = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDashboardAssemblyAcControlsImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDashboardAssemblyAcControlsImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/Interior_1/seats',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDashboardAssemblyAcControlsImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDashboardAssemblyAcControlsImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDashboardAssemblyAcControlsImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedDashboardAssemblyAcControlsImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Front windshield glass', [
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: frontWindshieldGlassCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontWindshieldGlassCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: frontWindshieldGlassCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontWindshieldGlassCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: frontWindshieldGlassScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontWindshieldGlassScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: frontWindshieldGlassScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontWindshieldGlassScratchesMinor = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedFrontWindshieldGlassImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedFrontWindshieldGlassImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_1/front_windshield_glass',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedFrontWindshieldGlassImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedFrontWindshieldGlassImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedFrontWindshieldGlassImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedFrontWindshieldGlassImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Seats', [
//             SwitchListTile(
//               title: const Text(
//                 'Damaged major',
//               ),
//               value: seatsDamageMajor,
//               onChanged: (val) {
//                 setState(() {
//                   seatsDamageMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Damaged minor',
//               ),
//               value: seatsDamageMinor,
//               onChanged: (val) {
//                 setState(() {
//                   seatsDamageMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Aftermarket fitment',
//               ),
//               value: seatsAftermarketFitment,
//               onChanged: (val) {
//                 setState(() {
//                   seatsAftermarketFitment = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Electronic seat',
//               ),
//               value: seatsElectronicSeat,
//               onChanged: (val) {
//                 setState(() {
//                   seatsElectronicSeat = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedSeatsImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedSeatsImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_1/seats',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedSeatsImage = result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedSeatsImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedSeatsImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(_selectedSeatsImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//         ]),
//         _buildCardExpansionTile('Interior-2', count: interior2IssueCheck(), [
//           _buildExpansionTile('Audio stereo assembly', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: audioStereoAssemblyBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: audioStereoAssemblyCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: audioStereoAssemblyCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: audioStereoAssemblyCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: audioStereoAssemblyCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: audioStereoAssemblyHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: audioStereoAssemblyHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: audioStereoAssemblyPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: audioStereoAssemblyPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: audioStereoAssemblyRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: audioStereoAssemblyReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: audioStereoAssemblyScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: audioStereoAssemblyScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: audioStereoAssemblyWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   audioStereoAssemblyWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedAudioStereoAssemblyImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedAudioStereoAssemblyImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/audio_stereo_assembly',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedAudioStereoAssemblyImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedAudioStereoAssemblyImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedAudioStereoAssemblyImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image:
//                                   FileImage(_selectedAudioStereoAssemblyImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Centre console assembly', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: centreConsoleAssemblyBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: centreConsoleAssemblyCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: centreConsoleAssemblyCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: centreConsoleAssemblyCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: centreConsoleAssemblyCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: centreConsoleAssemblyHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: centreConsoleAssemblyHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: centreConsoleAssemblyPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: centreConsoleAssemblyPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: centreConsoleAssemblyRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: centreConsoleAssemblyReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: centreConsoleAssemblyScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: centreConsoleAssemblyScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: centreConsoleAssemblyWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   centreConsoleAssemblyWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedCentreConsoleAssemblyImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedCentreConsoleAssemblyImage =
//                               File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/centre_console_assembly',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedCentreConsoleAssemblyImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedCentreConsoleAssemblyImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedCentreConsoleAssemblyImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedCentreConsoleAssemblyImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Forward parking sensors', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: forwardParkingSensorsBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: forwardParkingSensorsCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: forwardParkingSensorsCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: forwardParkingSensorsCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: forwardParkingSensorsCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: forwardParkingSensorsHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: forwardParkingSensorsHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: forwardParkingSensorsPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: forwardParkingSensorsPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: forwardParkingSensorsRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: forwardParkingSensorsReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: forwardParkingSensorsScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: forwardParkingSensorsScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: forwardParkingSensorsWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   forwardParkingSensorsWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedForwardParkingSensorsImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedForwardParkingSensorsImage =
//                               File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/forward_parking_sensors',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedForwardParkingSensorsImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedForwardParkingSensorsImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedForwardParkingSensorsImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedForwardParkingSensorsImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Front left door assembly', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: frontLeftDoorAssemblyBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: frontLeftDoorAssemblyCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: frontLeftDoorAssemblyCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: frontLeftDoorAssemblyCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: frontLeftDoorAssemblyCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: frontLeftDoorAssemblyHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: frontLeftDoorAssemblyHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: frontLeftDoorAssemblyPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: frontLeftDoorAssemblyPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: frontLeftDoorAssemblyRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: frontLeftDoorAssemblyReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: frontLeftDoorAssemblyScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: frontLeftDoorAssemblyScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: frontLeftDoorAssemblyWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftDoorAssemblyWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedFrontLeftDoorAssemblyImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedFrontLeftDoorAssemblyImage =
//                               File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/front_left_door_assembly',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedFrontLeftDoorAssemblyImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedFrontLeftDoorAssemblyImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedFrontLeftDoorAssemblyImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedFrontLeftDoorAssemblyImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Front right door assembly', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: frontRightDoorAssemblyBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: frontRightDoorAssemblyCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: frontRightDoorAssemblyCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: frontRightDoorAssemblyCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: frontRightDoorAssemblyCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: frontRightDoorAssemblyHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: frontRightDoorAssemblyHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: frontRightDoorAssemblyPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: frontRightDoorAssemblyPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: frontRightDoorAssemblyRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: frontRightDoorAssemblyReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: frontRightDoorAssemblyScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: frontRightDoorAssemblyScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: frontRightDoorAssemblyWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightDoorAssemblyWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedFrontRightDoorAssemblyImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedFrontRightDoorAssemblyImage =
//                               File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/front_right_door_assembly',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedFrontRightDoorAssemblyImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedFrontRightDoorAssemblyImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedFrontRightDoorAssemblyImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedFrontRightDoorAssemblyImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Reverse parking camera', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: reverseParkingCameraBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: reverseParkingCameraCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: reverseParkingCameraCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: reverseParkingCameraCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: reverseParkingCameraCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: reverseParkingCameraHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: reverseParkingCameraHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: reverseParkingCameraPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: reverseParkingCameraPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: reverseParkingCameraRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: reverseParkingCameraReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: reverseParkingCameraScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: reverseParkingCameraScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: reverseParkingCameraWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingCameraWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedReverseParkingCameraImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedReverseParkingCameraImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/reverse_parking_camera',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedReverseParkingCameraImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedReverseParkingCameraImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedReverseParkingCameraImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedReverseParkingCameraImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Reverse parking sensors', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: reverseParkingSensorsBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: reverseParkingSensorsCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: reverseParkingSensorsCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: reverseParkingSensorsCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: reverseParkingSensorsCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: reverseParkingSensorsHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: reverseParkingSensorsHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: reverseParkingSensorsPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: reverseParkingSensorsPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: reverseParkingSensorsRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: reverseParkingSensorsReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: reverseParkingSensorsScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: reverseParkingSensorsScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: reverseParkingSensorsWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   reverseParkingSensorsWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedReverseParkingSensorsImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedReverseParkingSensorsImage =
//                               File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/Interior_2/reverse_parking_sensors',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedReverseParkingSensorsImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedReverseParkingSensorsImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedReverseParkingSensorsImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(
//                                   _selectedReverseParkingSensorsImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//         ]),
//         _buildCardExpansionTile('Left side', count: leftSideIssueCheck(), [
//           _buildExpansionTile('Front left exterior', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: frontLeftExteriorBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent minor',
//               ),
//               value: frontLeftExteriorBendDentMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorBendDentMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: frontLeftExteriorCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: frontLeftExteriorCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: frontLeftExteriorCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: frontLeftExteriorCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: frontLeftExteriorPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repaired',
//               ),
//               value: frontLeftExteriorRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: frontLeftExteriorReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftExteriorReplaced = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedFrontLeftExteriorImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedFrontLeftExteriorImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_exterior',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedFrontLeftExteriorImage = result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedFrontLeftExteriorImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedFrontLeftExteriorImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image:
//                                   FileImage(_selectedFrontLeftExteriorImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Front left mechanical', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: frontLeftMechanicalBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: frontLeftMechanicalCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: frontLeftMechanicalCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: frontLeftMechanicalCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: frontLeftMechanicalCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: frontLeftMechanicalHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: frontLeftMechanicalHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: frontLeftMechanicalPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: frontLeftMechanicalPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: frontLeftMechanicalRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: frontLeftMechanicalReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: frontLeftMechanicalScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: frontLeftMechanicalScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: frontLeftMechanicalWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   frontLeftMechanicalWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedFrontLeftMechanicalImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedFrontLeftMechanicalImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_mechanical',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedFrontLeftMechanicalImage =
//                                 result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedFrontLeftMechanicalImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedFrontLeftMechanicalImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image:
//                                   FileImage(_selectedFrontLeftMechanicalImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Front left structure', [
//             _buildExpansionSubTile('Left floor pan channel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftFloorPanChannelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftFloorPanChannelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftFloorPanChannelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftFloorPanChannelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftFloorPanChannelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: leftFloorPanChannelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: leftFloorPanChannelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: leftFloorPanChannelPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftFloorPanChannelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: leftFloorPanChannelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftFloorPanChannelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: leftFloorPanChannelScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: leftFloorPanChannelScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: leftFloorPanChannelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFloorPanChannelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftFloorPanChannelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftFloorPanChannelImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/left_floor_pan_channel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftFloorPanChannelImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftFloorPanChannelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftFloorPanChannelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedLeftFloorPanChannelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left pillar B', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftPillarBBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftPillarBCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftPillarBCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftPillarBCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftPillarBCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: leftPillarBHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: leftPillarBHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: leftPillarBPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftPillarBPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: leftPillarBRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftPillarBReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: leftPillarBScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: leftPillarBScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: leftPillarBWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarBWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftPillarBImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftPillarBImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/left_pillar_B',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftPillarBImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftPillarBImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftPillarBImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedLeftPillarBImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left pillar C', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftPillarCBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftPillarCCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftPillarCCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftPillarCCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftPillarCCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: leftPillarCHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: leftPillarCHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: leftPillarCPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftPillarCPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: leftPillarCRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftPillarCReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: leftPillarCScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: leftPillarCScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: leftPillarCWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     leftPillarCWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftPillarCImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftPillarCImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/left_pillar_C',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftPillarCImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftPillarCImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftPillarCImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedLeftPillarCImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left running board', [
//               SwitchListTile(
//                 title: const Text(
//                   'Crack',
//                 ),
//                 value: leftRunningBoardCrack,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardCrack = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftRunningBoardCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftRunningBoardCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint defective',
//                 ),
//                 value: leftRunningBoardPaintDefective,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardPaintDefective = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: leftRunningBoardPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftRunningBoardPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: leftRunningBoardRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftRunningBoardReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftRunningBoardReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftRunningBoardImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftRunningBoardImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/left_running_board',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftRunningBoardImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftRunningBoardImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftRunningBoardImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedLeftRunningBoardImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear left door channel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearLeftDoorChannelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearLeftDoorChannelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearLeftDoorChannelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearLeftDoorChannelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearLeftDoorChannelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearLeftDoorChannelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearLeftDoorChannelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearLeftDoorChannelPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearLeftDoorChannelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearLeftDoorChannelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearLeftDoorChannelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearLeftDoorChannelScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearLeftDoorChannelScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearLeftDoorChannelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorChannelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearLeftDoorChannelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearLeftDoorChannelImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/rear_left_door_channel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearLeftDoorChannelImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearLeftDoorChannelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearLeftDoorChannelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRearLeftDoorChannelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear left floor pan', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearLeftFloorPanBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearLeftFloorPanCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearLeftFloorPanCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearLeftFloorPanCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearLeftFloorPanCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearLeftFloorPanHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearLeftFloorPanHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearLeftFloorPanPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearLeftFloorPanPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearLeftFloorPanRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearLeftFloorPanReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearLeftFloorPanScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearLeftFloorPanScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearLeftFloorPanWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftFloorPanWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearLeftFloorPanImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearLeftFloorPanImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/rear_left_floor_pan',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearLeftFloorPanImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearLeftFloorPanImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearLeftFloorPanImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRearLeftFloorPanImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear left wheel house', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearLeftWheelHouseBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearLeftWheelHouseCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearLeftWheelHouseCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearLeftWheelHouseCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearLeftWheelHouseCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearLeftWheelHouseHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearLeftWheelHouseHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearLeftWheelHousePaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHousePaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearLeftWheelHousePunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHousePunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearLeftWheelHouseRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearLeftWheelHouseReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearLeftWheelHouseScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearLeftWheelHouseScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearLeftWheelHouseWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftWheelHouseWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearLeftWheelHouseImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearLeftWheelHouseImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/front_left_structure/rear_left_wheel_house',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearLeftWheelHouseImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearLeftWheelHouseImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearLeftWheelHouseImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRearLeftWheelHouseImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Rear left exterior', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: rearLeftExteriorBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent minor',
//               ),
//               value: rearLeftExteriorBendDentMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorBendDentMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: rearLeftExteriorCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: rearLeftExteriorCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: rearLeftExteriorCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: rearLeftExteriorCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: rearLeftExteriorPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repaired',
//               ),
//               value: rearLeftExteriorRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: rearLeftExteriorReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftExteriorReplaced = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedRearLeftExteriorImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedRearLeftExteriorImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/left_side/rear_left_exterior',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedRearLeftExteriorImage = result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedRearLeftExteriorImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedRearLeftExteriorImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(_selectedRearLeftExteriorImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Rear left mechanical', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: rearLeftMechanicalBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent minor',
//               ),
//               value: rearLeftMechanicalBendDentMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalBendDentMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: rearLeftMechanicalCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: rearLeftMechanicalCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: rearLeftMechanicalCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: rearLeftMechanicalCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: rearLeftMechanicalPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repaired',
//               ),
//               value: rearLeftMechanicalRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: rearLeftMechanicalReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   rearLeftMechanicalReplaced = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedRearLeftMechanicalImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedRearLeftMechanicalImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/left_side/rear_left_mechanical',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedRearLeftMechanicalImage = result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedRearLeftMechanicalImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedRearLeftMechanicalImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image:
//                                   FileImage(_selectedRearLeftMechanicalImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//           _buildExpansionTile('Rear left structure', [
//             _buildExpansionSubTile('Left fender lining', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftFenderLiningBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: leftFenderLiningBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftFenderLiningCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftFenderLiningCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftFenderLiningCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftFenderLiningCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftFenderLiningPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: leftFenderLiningRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftFenderLiningReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderLiningReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftFenderLiningImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftFenderLiningImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/rear_left_structure/left_fender_lining',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftFenderLiningImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftFenderLiningImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftFenderLiningImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedLeftFenderLiningImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left fender panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftFenderPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: leftFenderPanelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftFenderPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftFenderPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftFenderPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftFenderPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftFenderPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: leftFenderPanelRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftFenderPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftFenderPanelReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftFenderPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftFenderPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/rear_left_structure/left_fender_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftFenderPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftFenderPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftFenderPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedLeftFenderPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left svm assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftSvmAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: leftSvmAssemblyBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftSvmAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftSvmAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftSvmAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftSvmAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftSvmAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: leftSvmAssemblyRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftSvmAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftSvmAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftSvmAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftSvmAssemblyImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/rear_left_structure/left_svm_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftSvmAssemblyImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftSvmAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftSvmAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedLeftSvmAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear left door panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearLeftDoorPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rearLeftDoorPanelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearLeftDoorPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearLeftDoorPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearLeftDoorPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearLeftDoorPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearLeftDoorPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rearLeftDoorPanelRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearLeftDoorPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearLeftDoorPanelReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearLeftDoorPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearLeftDoorPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/left_side/rear_left_structure/rear_left_door_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearLeftDoorPanelImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearLeftDoorPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearLeftDoorPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRearLeftDoorPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//         ]),
//         _buildCardExpansionTile('Rear side', count: rearSideIssueCheck(), [
//           _buildExpansionTile('Rear exterior', [
//             _buildExpansionSubTile('Dickey door panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyDoorPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: dickeyDoorPanelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyDoorPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyDoorPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyDoorPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyDoorPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyDoorPanelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyDoorPanelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyDoorPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyDoorPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyDoorPanelReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyDoorPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyDoorPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/dickey_door_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyDoorPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyDoorPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyDoorPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedDickeyDoorPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Dickey left stay rod shocker', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyLeftStayRodShockerBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: dickeyLeftStayRodShockerBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyLeftStayRodShockerCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyLeftStayRodShockerCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyLeftStayRodShockerCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyLeftStayRodShockerCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyLeftStayRodShockerHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyLeftStayRodShockerHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyLeftStayRodShockerPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyLeftStayRodShockerReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftStayRodShockerReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyLeftStayRodShockerImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyLeftStayRodShockerImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/dickey_left_stay_rod_shocker',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyLeftStayRodShockerImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyLeftStayRodShockerImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyLeftStayRodShockerImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedDickeyLeftStayRodShockerImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Dickey right stay rod shocker', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyRightStayRodShockerBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: dickeyRightStayRodShockerBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyRightStayRodShockerCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyRightStayRodShockerCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyRightStayRodShockerCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyRightStayRodShockerCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyRightStayRodShockerHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyRightStayRodShockerHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyRightStayRodShockerPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyRightStayRodShockerReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightStayRodShockerReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyRightStayRodShockerImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyRightStayRodShockerImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/dickey_right_stay_rod_shocker',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyRightStayRodShockerImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyRightStayRodShockerImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyRightStayRodShockerImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedDickeyRightStayRodShockerImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Left tail light assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: leftTailLightAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: leftTailLightAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: leftTailLightAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: leftTailLightAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: leftTailLightAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: leftTailLightAssemblyHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: leftTailLightAssemblyHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: leftTailLightAssemblyPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: leftTailLightAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: leftTailLightAssemblyRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: leftTailLightAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: leftTailLightAssemblyScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: leftTailLightAssemblyScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: leftTailLightAssemblyWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     leftTailLightAssemblyWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedLeftTailLightAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedLeftTailLightAssemblyImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/left_tail_light_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedLeftTailLightAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedLeftTailLightAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedLeftTailLightAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedLeftTailLightAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear bumper panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearBumperPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearBumperPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearBumperPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearBumperPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearBumperPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearBumperPanelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearBumperPanelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearBumperPanelPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearBumperPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearBumperPanelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearBumperPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearBumperPanelScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearBumperPanelScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearBumperPanelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearBumperPanelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearBumperPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearBumperPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/rear_bumper_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearBumperPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearBumperPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearBumperPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRearBumperPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear registration plate', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearRegistrationPlateBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearRegistrationPlateCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearRegistrationPlateCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearRegistrationPlateCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearRegistrationPlateCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearRegistrationPlateHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearRegistrationPlateHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearRegistrationPlatePaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlatePaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearRegistrationPlatePunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlatePunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearRegistrationPlateRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearRegistrationPlateReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearRegistrationPlateScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearRegistrationPlateScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearRegistrationPlateWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRegistrationPlateWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearRegistrationPlateImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearRegistrationPlateImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/rear_registration_plate',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearRegistrationPlateImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearRegistrationPlateImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearRegistrationPlateImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRearRegistrationPlateImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear windshield glass', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearWindshieldGlassBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearWindshieldGlassCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearWindshieldGlassCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearWindshieldGlassCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearWindshieldGlassCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearWindshieldGlassHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearWindshieldGlassHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearWindshieldGlassPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearWindshieldGlassPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearWindshieldGlassRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearWindshieldGlassReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearWindshieldGlassScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearWindshieldGlassScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearWindshieldGlassWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearWindshieldGlassWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearWindshieldGlassImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearWindshieldGlassImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/rear_windshield_glass',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearWindshieldGlassImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearWindshieldGlassImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearWindshieldGlassImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRearWindshieldGlassImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right tail light assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightTailLightAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightTailLightAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightTailLightAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightTailLightAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightTailLightAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rightTailLightAssemblyHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rightTailLightAssemblyHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rightTailLightAssemblyPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightTailLightAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rightTailLightAssemblyRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightTailLightAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rightTailLightAssemblyScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rightTailLightAssemblyScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rightTailLightAssemblyWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rightTailLightAssemblyWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightTailLightAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightTailLightAssemblyImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/rear_exterior/right_tail_light_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightTailLightAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightTailLightAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightTailLightAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRightTailLightAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Roof structure and root', [
//             _buildExpansionSubTile('Dickey back panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyBackPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: dickeyBackPanelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyBackPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyBackPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyBackPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyBackPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyBackPanelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyBackPanelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyBackPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyBackPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyBackPanelReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyBackPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyBackPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_back_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyBackPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyBackPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyBackPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedDickeyBackPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Dickey Floor', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyFloorBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: dickeyFloorBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyFloorCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyFloorCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyFloorCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyFloorCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyFloorHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyFloorHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyFloorPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyFloorReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyFloorReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyFloorImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyFloorImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_floor',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyFloorImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyFloorImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyFloorImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedDickeyFloorImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Dickey left leg', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyLeftLegBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: dickeyLeftLegBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyLeftLegCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyLeftLegCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyLeftLegCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyLeftLegCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyLeftLegHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyLeftLegHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyLeftLegPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: dickeyLeftLegRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyLeftLegReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyLeftLegReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyLeftLegImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyLeftLegImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_left_leg',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyLeftLegImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyLeftLegImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyLeftLegImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedDickeyLeftLegImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Dickey Right leg', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: dickeyRightLegBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: dickeyRightLegCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: dickeyRightLegCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: dickeyRightLegCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: dickeyRightLegCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: dickeyRightLegHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: dickeyRightLegHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: dickeyRightLegPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: dickeyRightLegPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: dickeyRightLegRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: dickeyRightLegReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     dickeyRightLegReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedDickeyRightLegImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedDickeyRightLegImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_right_leg',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedDickeyRightLegImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedDickeyRightLegImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedDickeyRightLegImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedDickeyRightLegImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Dickey sidewalls', [
//               _buildExpansionSubTile('Left dickey sidewall', [
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent major',
//                   ),
//                   value: leftDickeySidewallBendDentMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallBendDentMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent minor',
//                   ),
//                   value: leftDickeySidewallBendDentMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallBendDentMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion major',
//                   ),
//                   value: leftDickeySidewallCorrosionMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallCorrosionMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion minor',
//                   ),
//                   value: leftDickeySidewallCorrosionMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallCorrosionMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack major',
//                   ),
//                   value: leftDickeySidewallCrackMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallCrackMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack minor',
//                   ),
//                   value: leftDickeySidewallCrackMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallCrackMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Punches open repaired',
//                   ),
//                   value: leftDickeySidewallPunchesOpenRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallPunchesOpenRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Sealant missing crack repaired',
//                   ),
//                   value: leftDickeySidewallSealantMissingCrackRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallSealantMissingCrackRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Replaced',
//                   ),
//                   value: leftDickeySidewallReplaced,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeySidewallReplaced = val;
//                     });
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (selectedLeftDickeySidewallImage == null) {
//                           final XFile? image = await picker.pickImage(
//                               source: ImageSource.camera);

//                           if (image != null) {
//                             setState(() {
//                               _selectedLeftDickeySidewallImage =
//                                   File(image.path);
//                             });
//                             final result = await uploadImage(
//                               imageVar: image,
//                               imageRef:
//                                   'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_sidewalls/left_dickey_sidewall',
//                             );
//                             if (result.isNotEmpty) {
//                               setState(() {
//                                 selectedLeftDickeySidewallImage =
//                                     result.toString();
//                                 selectedAllImages.add(result);
//                                 log("message ${selectedLeftDickeySidewallImage}");
//                               });
//                             }
//                           }
//                         }
//                       },
//                       child: _selectedLeftDickeySidewallImage != null
//                           ? Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: FileImage(
//                                       _selectedLeftDickeySidewallImage!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             )
//                           : Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 border:
//                                     Border.all(width: 1, color: Colors.grey),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "Upload Image",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ]),
//               _buildExpansionSubTile('Right dickey sidewall', [
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent major',
//                   ),
//                   value: rightDickeySidewallBendDentMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallBendDentMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent minor',
//                   ),
//                   value: rightDickeySidewallBendDentMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallBendDentMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion major',
//                   ),
//                   value: rightDickeySidewallCorrosionMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallCorrosionMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion minor',
//                   ),
//                   value: rightDickeySidewallCorrosionMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallCorrosionMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack major',
//                   ),
//                   value: rightDickeySidewallCrackMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallCrackMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack minor',
//                   ),
//                   value: rightDickeySidewallCrackMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallCrackMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Sealant missing crack repaired',
//                   ),
//                   value: rightDickeySidewallSealantMissingCrackRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallSealantMissingCrackRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Punches open repaired',
//                   ),
//                   value: rightDickeySidewallPunchesOpenRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallPunchesOpenRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Replaced',
//                   ),
//                   value: rightDickeySidewallReplaced,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeySidewallReplaced = val;
//                     });
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (selectedRightDickeySidewallImage == null) {
//                           final XFile? image = await picker.pickImage(
//                               source: ImageSource.camera);

//                           if (image != null) {
//                             setState(() {
//                               _selectedRightDickeySidewallImage =
//                                   File(image.path);
//                             });
//                             final result = await uploadImage(
//                               imageVar: image,
//                               imageRef:
//                                   'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_sidewalls/right_dickey_sidewall',
//                             );
//                             if (result.isNotEmpty) {
//                               setState(() {
//                                 selectedRightDickeySidewallImage =
//                                     result.toString();
//                                 selectedAllImages.add(result);
//                                 log("message ${selectedRightDickeySidewallImage}");
//                               });
//                             }
//                           }
//                         }
//                       },
//                       child: _selectedRightDickeySidewallImage != null
//                           ? Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: FileImage(
//                                       _selectedRightDickeySidewallImage!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             )
//                           : Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 border:
//                                     Border.all(width: 1, color: Colors.grey),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "Upload Image",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ]),
//             ]),
//             _buildExpansionSubTile('Dickey strut towers', [
//               _buildExpansionSubTile('Left dickey strut tower', [
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent major',
//                   ),
//                   value: leftDickeyStrutTowerBendDentMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerBendDentMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent minor',
//                   ),
//                   value: leftDickeyStrutTowerBendDentMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerBendDentMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion major',
//                   ),
//                   value: leftDickeyStrutTowerCorrosionMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerCorrosionMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion minor',
//                   ),
//                   value: leftDickeyStrutTowerCorrosionMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerCorrosionMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack major',
//                   ),
//                   value: leftDickeyStrutTowerCrackMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerCrackMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack minor',
//                   ),
//                   value: leftDickeyStrutTowerCrackMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerCrackMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Punches open repaired',
//                   ),
//                   value: leftDickeyStrutTowerPunchesOpenRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerPunchesOpenRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Sealant missing crack repaired',
//                   ),
//                   value: leftDickeyStrutTowerSealantMissingCrackRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerSealantMissingCrackRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Replaced',
//                   ),
//                   value: leftDickeyStrutTowerReplaced,
//                   onChanged: (val) {
//                     setState(() {
//                       leftDickeyStrutTowerReplaced = val;
//                     });
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (selectedLeftDickeyStrutTowerImage == null) {
//                           final XFile? image = await picker.pickImage(
//                               source: ImageSource.camera);

//                           if (image != null) {
//                             setState(() {
//                               _selectedLeftDickeyStrutTowerImage =
//                                   File(image.path);
//                             });
//                             final result = await uploadImage(
//                               imageVar: image,
//                               imageRef:
//                                   'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_strut_towers/left_dickey_strut_tower',
//                             );
//                             if (result.isNotEmpty) {
//                               setState(() {
//                                 selectedLeftDickeyStrutTowerImage =
//                                     result.toString();
//                                 selectedAllImages.add(result);
//                                 log("message ${selectedLeftDickeyStrutTowerImage}");
//                               });
//                             }
//                           }
//                         }
//                       },
//                       child: _selectedLeftDickeyStrutTowerImage != null
//                           ? Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: FileImage(
//                                       _selectedLeftDickeyStrutTowerImage!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             )
//                           : Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 border:
//                                     Border.all(width: 1, color: Colors.grey),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "Upload Image",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ]),
//               _buildExpansionSubTile('Right dickey strut tower', [
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent major',
//                   ),
//                   value: rightDickeyStrutTowerBendDentMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerBendDentMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Bend dent minor',
//                   ),
//                   value: rightDickeyStrutTowerBendDentMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerBendDentMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion major',
//                   ),
//                   value: rightDickeyStrutTowerCorrosionMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerCorrosionMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Corrosion minor',
//                   ),
//                   value: rightDickeyStrutTowerCorrosionMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerCorrosionMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack major',
//                   ),
//                   value: rightDickeyStrutTowerCrackMajor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerCrackMajor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Crack minor',
//                   ),
//                   value: rightDickeyStrutTowerCrackMinor,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerCrackMinor = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Sealant missing crack repaired',
//                   ),
//                   value: rightDickeyStrutTowerSealantMissingCrackRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerSealantMissingCrackRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Punches open repaired',
//                   ),
//                   value: rightDickeyStrutTowerPunchesOpenRepaired,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerPunchesOpenRepaired = val;
//                     });
//                   },
//                 ),
//                 SwitchListTile(
//                   title: const Text(
//                     'Replaced',
//                   ),
//                   value: rightDickeyStrutTowerReplaced,
//                   onChanged: (val) {
//                     setState(() {
//                       rightDickeyStrutTowerReplaced = val;
//                     });
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (selectedRightDickeyStrutTowerImage == null) {
//                           final XFile? image = await picker.pickImage(
//                               source: ImageSource.camera);

//                           if (image != null) {
//                             setState(() {
//                               _selectedRightDickeyStrutTowerImage =
//                                   File(image.path);
//                             });
//                             final result = await uploadImage(
//                               imageVar: image,
//                               imageRef:
//                                   'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/dickey_strut_towers/right_dickey_strut_tower',
//                             );
//                             if (result.isNotEmpty) {
//                               setState(() {
//                                 selectedRightDickeyStrutTowerImage =
//                                     result.toString();
//                                 selectedAllImages.add(result);
//                                 log("message ${selectedRightDickeyStrutTowerImage}");
//                               });
//                             }
//                           }
//                         }
//                       },
//                       child: _selectedRightDickeyStrutTowerImage != null
//                           ? Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: FileImage(
//                                       _selectedRightDickeyStrutTowerImage!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             )
//                           : Container(
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 border:
//                                     Border.all(width: 1, color: Colors.grey),
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "Upload Image",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ]),
//             ]),
//             _buildExpansionSubTile('Roof panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Aftermarket dual tone paint',
//                 ),
//                 value: roofPanelAftermarketDualTonePaint,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelAftermarketDualTonePaint = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Aftermarket sunroof fitment',
//                 ),
//                 value: roofPanelAftermarketSunroofFitment,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelAftermarketSunroofFitment = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: roofPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: roofPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'External hole tear',
//                 ),
//                 value: roofPanelExternalHoleTear,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelExternalHoleTear = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Multiple dents dent minor',
//                 ),
//                 value: roofPanelMultipleDentsDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelMultipleDentsDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Multiple dents dent major',
//                 ),
//                 value: roofPanelMultipleDentsDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelMultipleDentsDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint defective',
//                 ),
//                 value: roofPanelPaintDefective,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelPaintDefective = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: roofPanelPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: roofPanelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: roofPanelRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: roofPanelScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: roofPanelScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Sealant missing',
//                 ),
//                 value: roofPanelSealantMissing,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelSealantMissing = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Wrapping',
//                 ),
//                 value: roofPanelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     roofPanelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRoofPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRoofPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/roof_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRoofPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRoofPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRoofPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedRoofPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Spare tyre assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Spare tyre available',
//                 ),
//                 value: spareTyreAvailable,
//                 onChanged: (val) {
//                   setState(() {
//                     spareTyreAvailable = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedSpareTyreAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedSpareTyreAssemblyImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/roof_structure_and_root/spare_tyre_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedSpareTyreAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedSpareTyreAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedSpareTyreAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedSpareTyreAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//         ]),
//         _buildCardExpansionTile('Right side', count: rightSideIssueCheck(), [
//           _buildExpansionTile('Front right exterior', [
//             _buildExpansionSubTile('Front right door panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontRightDoorPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontRightDoorPanelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontRightDoorPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontRightDoorPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontRightDoorPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontRightDoorPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontRightDoorPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontRightDoorPanelRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontRightDoorPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightDoorPanelReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontRightDoorPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontRightDoorPanelImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_exterior/front_right_door_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontRightDoorPanelImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontRightDoorPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontRightDoorPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedFrontRightDoorPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right fender lining', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightFenderLiningBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightFenderLiningBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightFenderLiningCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightFenderLiningCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightFenderLiningCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightFenderLiningCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightFenderLiningPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rightFenderLiningRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightFenderLiningReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderLiningReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightFenderLiningImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightFenderLiningImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_exterior/right_fender_lining',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightFenderLiningImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightFenderLiningImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightFenderLiningImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRightFenderLiningImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right fender panel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightFenderPanelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightFenderPanelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightFenderPanelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightFenderPanelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightFenderPanelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightFenderPanelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightFenderPanelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rightFenderPanelRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightFenderPanelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFenderPanelReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightFenderPanelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightFenderPanelImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/rear_side/front_right_exterior/right_fender_panel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightFenderPanelImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightFenderPanelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightFenderPanelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRightFenderPanelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right svm assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightSvmAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightSvmAssemblyBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightSvmAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightSvmAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightSvmAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightSvmAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightSvmAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: rightSvmAssemblyRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightSvmAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightSvmAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightSvmAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightSvmAssemblyImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_exterior/right_svm_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightSvmAssemblyImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightSvmAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightSvmAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRightSvmAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Front right mechanical', [
//             SwitchListTile(
//               title: const Text(
//                 'Exhaust system',
//               ),
//               value: frontRightMechanicalExhaustSystem,
//               onChanged: (val) {
//                 setState(() {
//                   frontRightMechanicalExhaustSystem = val;
//                 });
//               },
//             ),
//             _buildExpansionTile('Four wheel drive', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: fourWheelDriveBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: fourWheelDriveBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: fourWheelDriveCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: fourWheelDriveCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: fourWheelDriveCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: fourWheelDriveCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: fourWheelDrivePunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDrivePunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: fourWheelDriveRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: fourWheelDriveReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     fourWheelDriveReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFourWheelDriveImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFourWheelDriveImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_mechanical/four_wheel_drive',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFourWheelDriveImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFourWheelDriveImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFourWheelDriveImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedFourWheelDriveImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionTile('Front right brake assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontRightBrakeAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontRightBrakeAssemblyBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontRightBrakeAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontRightBrakeAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontRightBrakeAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontRightBrakeAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontRightBrakeAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontRightBrakeAssemblyRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontRightBrakeAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightBrakeAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontRightBrakeAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontRightBrakeAssemblyImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_mechanical/front_right_brake_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontRightBrakeAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontRightBrakeAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontRightBrakeAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedFrontRightBrakeAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionTile('Front right suspension', [
//               SwitchListTile(
//                 title: const Text(
//                   'Front jumping rod assembly',
//                 ),
//                 value: frontRightSuspensionFrontJumpingRodAssembly,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightSuspensionFrontJumpingRodAssembly = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Front right link rod',
//                 ),
//                 value: frontRightSuspensionFrontRightLinkRod,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightSuspensionFrontRightLinkRod = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Front right lower control arm assembly',
//                 ),
//                 value: frontRightSuspensionFrontRightLowerControlArmAssembly,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightSuspensionFrontRightLowerControlArmAssembly = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Front right strut assembly',
//                 ),
//                 value: frontRightSuspensionFrontRightStrutAssembly,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightSuspensionFrontRightStrutAssembly = val;
//                   });
//                 },
//               ),
//             ]),
//             _buildExpansionTile('Front right tyre assembly', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontRightTyreAssemblyBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontRightTyreAssemblyBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontRightTyreAssemblyCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontRightTyreAssemblyCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontRightTyreAssemblyCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontRightTyreAssemblyCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontRightTyreAssemblyPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontRightTyreAssemblyRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontRightTyreAssemblyReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontRightTyreAssemblyReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontRightTyreAssemblyImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontRightTyreAssemblyImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_mechanical/front_right_tyre_assembly',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontRightTyreAssemblyImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontRightTyreAssemblyImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontRightTyreAssemblyImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedFrontRightTyreAssemblyImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionTile('Front wheel drive', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: frontWheelDriveBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: frontWheelDriveBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: frontWheelDriveCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: frontWheelDriveCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: frontWheelDriveCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: frontWheelDriveCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: frontWheelDrivePunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDrivePunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repaired',
//                 ),
//                 value: frontWheelDriveRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: frontWheelDriveReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     frontWheelDriveReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedFrontWheelDriveImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedFrontWheelDriveImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/front_right_mechanical/front_wheel_drive',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedFrontWheelDriveImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedFrontWheelDriveImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedFrontWheelDriveImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedFrontWheelDriveImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Rear right structure', [
//             _buildExpansionSubTile('Rear right door channel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearRightDoorChannelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rearRightDoorChannelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearRightDoorChannelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearRightDoorChannelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearRightDoorChannelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearRightDoorChannelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearRightDoorChannelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearRightDoorChannelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearRightDoorChannelPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearRightDoorChannelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearRightDoorChannelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearRightDoorChannelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearRightDoorChannelScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearRightDoorChannelScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearRightDoorChannelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightDoorChannelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearRightDoorChannelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearRightDoorChannelImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/rear_right_door_channel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearRightDoorChannelImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearRightDoorChannelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearRightDoorChannelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRearRightDoorChannelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear right floor pan', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearRightFloorPanBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rearRightFloorPanBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearRightFloorPanCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearRightFloorPanCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearRightFloorPanCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearRightFloorPanCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearRightFloorPanHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearRightFloorPanHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearRightFloorPanPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearRightFloorPanPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearRightFloorPanRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearRightFloorPanReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearRightFloorPanScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearRightFloorPanScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearRightFloorPanWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightFloorPanWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearRightFloorPanImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearRightFloorPanImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/rear_right_floor_pan',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearRightFloorPanImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearRightFloorPanImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearRightFloorPanImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRearRightFloorPanImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Rear right wheel house', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rearRightWheelHouseBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rearRightWheelHouseBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rearRightWheelHouseCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rearRightWheelHouseCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rearRightWheelHouseCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rearRightWheelHouseCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rearRightWheelHouseHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rearRightWheelHouseHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rearRightWheelHousePaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHousePaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rearRightWheelHousePunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHousePunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rearRightWheelHouseRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rearRightWheelHouseReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rearRightWheelHouseScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rearRightWheelHouseScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rearRightWheelHouseWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rearRightWheelHouseWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRearRightWheelHouseImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRearRightWheelHouseImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/rear_right_wheel_house',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRearRightWheelHouseImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRearRightWheelHouseImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRearRightWheelHouseImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRearRightWheelHouseImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right floor pan channel', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightFloorPanChannelBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightFloorPanChannelBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightFloorPanChannelCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightFloorPanChannelCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightFloorPanChannelCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightFloorPanChannelCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rightFloorPanChannelHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rightFloorPanChannelHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rightFloorPanChannelPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightFloorPanChannelPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rightFloorPanChannelRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightFloorPanChannelReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rightFloorPanChannelScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rightFloorPanChannelScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rightFloorPanChannelWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rightFloorPanChannelWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightFloorPanChannelImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightFloorPanChannelImage =
//                                 File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/right_floor_pan_channel',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightFloorPanChannelImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightFloorPanChannelImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightFloorPanChannelImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(
//                                     _selectedRightFloorPanChannelImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right pillar B', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightPillarBBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightPillarBBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightPillarBCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightPillarBCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightPillarBCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightPillarBCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rightPillarBHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rightPillarBHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rightPillarBPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightPillarBPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rightPillarBRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightPillarBReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rightPillarBScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rightPillarBScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rightPillarBWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarBWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightPillarBImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightPillarBImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/right_pillar_B',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightPillarBImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightPillarBImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightPillarBImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedRightPillarBImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right pillar C', [
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent major',
//                 ),
//                 value: rightPillarCBendDentMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCBendDentMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Bend dent minor',
//                 ),
//                 value: rightPillarCBendDentMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCBendDentMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightPillarCCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightPillarCCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack major',
//                 ),
//                 value: rightPillarCCrackMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCCrackMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Crack minor',
//                 ),
//                 value: rightPillarCCrackMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCCrackMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired major',
//                 ),
//                 value: rightPillarCHammerRepairedMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCHammerRepairedMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Hammer repaired minor',
//                 ),
//                 value: rightPillarCHammerRepairedMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCHammerRepairedMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rightPillarCPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightPillarCPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rightPillarCRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightPillarCReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCReplaced = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches major',
//                 ),
//                 value: rightPillarCScratchesMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCScratchesMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Scratches minor',
//                 ),
//                 value: rightPillarCScratchesMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCScratchesMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'wrapping',
//                 ),
//                 value: rightPillarCWrapping,
//                 onChanged: (val) {
//                   setState(() {
//                     rightPillarCWrapping = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightPillarCImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightPillarCImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/right_pillar_c',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightPillarCImage = result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightPillarCImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightPillarCImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: FileImage(_selectedRightPillarCImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//             _buildExpansionSubTile('Right running board', [
//               SwitchListTile(
//                 title: const Text(
//                   'Crack',
//                 ),
//                 value: rightRunningBoardCrack,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardCrack = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion major',
//                 ),
//                 value: rightRunningBoardCorrosionMajor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardCorrosionMajor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Corrosion minor',
//                 ),
//                 value: rightRunningBoardCorrosionMinor,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardCorrosionMinor = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint defective',
//                 ),
//                 value: rightRunningBoardPaintDefective,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardPaintDefective = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Paint mismatch',
//                 ),
//                 value: rightRunningBoardPaintMisMatch,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardPaintMisMatch = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Punches open repaired',
//                 ),
//                 value: rightRunningBoardPunchesOpenRepaired,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardPunchesOpenRepaired = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Repainted',
//                 ),
//                 value: rightRunningBoardRepainted,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardRepainted = val;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text(
//                   'Replaced',
//                 ),
//                 value: rightRunningBoardReplaced,
//                 onChanged: (val) {
//                   setState(() {
//                     rightRunningBoardReplaced = val;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (selectedRightRunningBoardImage == null) {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.camera);

//                         if (image != null) {
//                           setState(() {
//                             _selectedRightRunningBoardImage = File(image.path);
//                           });
//                           final result = await uploadImage(
//                             imageVar: image,
//                             imageRef:
//                                 'inspection/${widget.carDetails.serialNumber}/car_health/right_side/rear_right_structure/right_running_board',
//                           );
//                           if (result.isNotEmpty) {
//                             setState(() {
//                               selectedRightRunningBoardImage =
//                                   result.toString();
//                               selectedAllImages.add(result);
//                               log("message ${selectedRightRunningBoardImage}");
//                             });
//                           }
//                         }
//                       }
//                     },
//                     child: _selectedRightRunningBoardImage != null
//                         ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image:
//                                     FileImage(_selectedRightRunningBoardImage!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(width: 1, color: Colors.grey),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Upload Image",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//           _buildExpansionTile('Right mechanical', [
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent major',
//               ),
//               value: rightMechanicalBendDentMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalBendDentMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Bend dent minor',
//               ),
//               value: rightMechanicalBendDentMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalBendDentMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion major',
//               ),
//               value: rightMechanicalCorrosionMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalCorrosionMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Corrosion minor',
//               ),
//               value: rightMechanicalCorrosionMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalCorrosionMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack major',
//               ),
//               value: rightMechanicalCrackMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalCrackMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Crack minor',
//               ),
//               value: rightMechanicalCrackMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalCrackMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired major',
//               ),
//               value: rightMechanicalHammerRepairedMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalHammerRepairedMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Hammer repaired minor',
//               ),
//               value: rightMechanicalHammerRepairedMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalHammerRepairedMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Paint mismatch',
//               ),
//               value: rightMechanicalPaintMisMatch,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalPaintMisMatch = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Punches open repaired',
//               ),
//               value: rightMechanicalPunchesOpenRepaired,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalPunchesOpenRepaired = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Repainted',
//               ),
//               value: rightMechanicalRepainted,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalRepainted = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Replaced',
//               ),
//               value: rightMechanicalReplaced,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalReplaced = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches major',
//               ),
//               value: rightMechanicalScratchesMajor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalScratchesMajor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Scratches minor',
//               ),
//               value: rightMechanicalScratchesMinor,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalScratchesMinor = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'wrapping',
//               ),
//               value: rightMechanicalWrapping,
//               onChanged: (val) {
//                 setState(() {
//                   rightMechanicalWrapping = val;
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (selectedRightMechanicalImage == null) {
//                       final XFile? image =
//                           await picker.pickImage(source: ImageSource.camera);

//                       if (image != null) {
//                         setState(() {
//                           _selectedRightMechanicalImage = File(image.path);
//                         });
//                         final result = await uploadImage(
//                           imageVar: image,
//                           imageRef:
//                               'inspection/${widget.carDetails.serialNumber}/car_health/right_side/right_right_mechanical',
//                         );
//                         if (result.isNotEmpty) {
//                           setState(() {
//                             selectedRightMechanicalImage = result.toString();
//                             selectedAllImages.add(result);
//                             log("message ${selectedRightMechanicalImage}");
//                           });
//                         }
//                       }
//                     }
//                   },
//                   child: _selectedRightMechanicalImage != null
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: FileImage(_selectedRightMechanicalImage!),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 100,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(width: 1, color: Colors.grey),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Upload Image",
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ]),
//         ]),
//         _buildCardExpansionTile('Test Drive', count: testDriveIssueCheck(), [
//           SwitchListTile(
//             title: const Text(
//               'Steering health',
//             ),
//             value: testDriveSteeringHealth,
//             onChanged: (val) {
//               setState(() {
//                 testDriveSteeringHealth = val;
//               });
//             },
//           ),
//           _buildExpansionTile('Accelerate to check clutch', [
//             SwitchListTile(
//               title: const Text(
//                 'Clutch pedal vibration',
//               ),
//               value: testDriveClutchPedalVibration,
//               onChanged: (val) {
//                 setState(() {
//                   testDriveClutchPedalVibration = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Noise from turbocharger',
//               ),
//               value: testDriveNoiseFromTurbocharger,
//               onChanged: (val) {
//                 setState(() {
//                   testDriveNoiseFromTurbocharger = val;
//                 });
//               },
//             ),
//           ]),
//           _buildExpansionTile('Apply brakes till car stop', [
//             SwitchListTile(
//               title: const Text(
//                 'Front brake noise vibration',
//               ),
//               value: testDriveFrontBrakeNoiseVibration,
//               onChanged: (val) {
//                 setState(() {
//                   testDriveFrontBrakeNoiseVibration = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Idle start stop not working',
//               ),
//               value: testDriveIdleStartStopNotWorking,
//               onChanged: (val) {
//                 setState(() {
//                   testDriveIdleStartStopNotWorking = val;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text(
//                 'Rear brake noise vibration',
//               ),
//               value: testDriveRearBrakeNoiseVibration,
//               onChanged: (val) {
//                 setState(() {
//                   testDriveRearBrakeNoiseVibration = val;
//                 });
//               },
//             ),
//           ]),
//         ]),
//         ElevatedButton(
//           onPressed: () {
//             if (_selectedBatteryImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted battery image");
//             } else if (_selectedBonnetImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted bonnet image");
//             } else if (extraParts.text.isEmpty) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Enter Extra Parts");
//             } else if (_selectedCarKeyImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted car key image");
//             } else if (_selectedCentralLockingRemoteHousingImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg:
//                       "Please selcted central locking remote housing image");
//             } else if (_selectedFrontBumperGrillImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front bumper grill image");
//             } else if (_selectedFrontBumperPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front bumper panel image");
//             } else if (_selectedFrontRegistrationPlateImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front registration plate image");
//             } else if (_selectedFrontLeftFogLightHousingImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg:
//                       "Please selcted front left fog light housing image");
//             } else if (_selectedFrontRightFogLightHousingImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg:
//                       "Please selcted front right fog light housing image");
//             } else if (_selectedLeftHeadlightAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left headlight assembly image");
//             } else if (_selectedLeftHeadlightHousingImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left headlight housing image");
//             } else if (_selectedLeftDrlImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted left drl image");
//             } else if (_selectedRightHeadlightAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right headlight assembly image");
//             } else if (_selectedRightHeadlightHousingImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right headlight housing image");
//             } else if (_selectedRightDrlImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted right drl image");
//             } else if (_selectedFrontLeftLegImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front left leg image");
//             } else if (_selectedFrontRightLeftImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front right left image");
//             } else if (_selectedClusterPanelAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted cluster panel assembly image");
//             } else if (_selectedDashboardAssemblyAcVentImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted ac Vent image");
//             } else if (_selectedDashboardAssemblyAcControlsImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted ac controls image");
//             } else if (_selectedFrontWindshieldGlassImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front windshield glass image");
//             } else if (_selectedSeatsImage == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please selcted seats image");
//             } else if (_selectedAudioStereoAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted audio stereo assembly image");
//             } else if (_selectedCentreConsoleAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted centre console assembly image");
//             } else if (_selectedForwardParkingSensorsImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted forward parking sensors image");
//             } else if (_selectedFrontRightDoorAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front right Door assembly image");
//             } else if (_selectedFrontLeftDoorAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front left door assembly image");
//             } else if (_selectedReverseParkingCameraImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted reverse parking camera image");
//             } else if (_selectedReverseParkingSensorsImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted reverse parking sensors image");
//             } else if (_selectedFrontLeftExteriorImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front left exterior image");
//             } else if (_selectedFrontLeftMechanicalImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front left mechanical image");
//             } else if (_selectedRearLeftExteriorImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear left exterior image");
//             } else if (_selectedRearLeftMechanicalImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear left mechanical image");
//             } else if (_selectedLeftFloorPanChannelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left floor pan channel image");
//             } else if (_selectedLeftPillarBImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left pillar B image");
//             } else if (_selectedLeftPillarCImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left pillar C image");
//             } else if (_selectedLeftRunningBoardImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left running board image");
//             } else if (_selectedRearLeftFloorPanImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear left floor pan image");
//             } else if (_selectedRearLeftDoorChannelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear left door channel image");
//             } else if (_selectedRearLeftWheelHouseImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear left wheel house image");
//             } else if (_selectedLeftFenderLiningImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left fender lining image");
//             } else if (_selectedLeftFenderPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left fender panel image");
//             } else if (_selectedLeftSvmAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left svm assembly image");
//             } else if (_selectedRearLeftDoorPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear left door panel image");
//             } else if (_selectedDickeyDoorPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted dickey door panel image");
//             } else if (_selectedDickeyLeftStayRodShockerImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg:
//                       "Please selcted dickey left stay rod shocker image");
//             } else if (_selectedDickeyRightStayRodShockerImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg:
//                       "Please selcted dickey right stay rod shocker image");
//             } else if (_selectedLeftTailLightAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left tail light assembly image");
//             } else if (_selectedRearBumperPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear bumper panel image");
//             } else if (_selectedRearWindshieldGlassImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear Windshield glass image");
//             } else if (_selectedRearRegistrationPlateImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear registration plate image");
//             } else if (_selectedRightTailLightAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right tail light assembly image");
//             } else if (_selectedDickeyBackPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted dickey back panel image");
//             } else if (_selectedDickeyFloorImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted dickey floor image");
//             } else if (_selectedDickeyLeftLegImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted dickey left leg image");
//             } else if (_selectedDickeyRightLegImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted dickey right leg image");
//             } else if (_selectedLeftDickeySidewallImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left dickey sidewall image");
//             } else if (_selectedRightDickeySidewallImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear registration plate image");
//             } else if (_selectedLeftDickeyStrutTowerImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted left dickey strut tower image");
//             } else if (_selectedRightDickeyStrutTowerImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right dickey strut tower image");
//             } else if (_selectedRoofPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted roof panel image");
//             } else if (_selectedSpareTyreAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted spare tyre assembly image");
//             } else if (_selectedFrontRightDoorPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front right door panel image");
//             } else if (_selectedRightFenderLiningImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right fender lining image");
//             } else if (_selectedRightFenderPanelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right fender panel image");
//             } else if (_selectedRightSvmAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right svm assembly image");
//             } else if (_selectedFourWheelDriveImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted four wheel drive image");
//             } else if (_selectedFrontRightBrakeAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front right brake assembly image");
//             } else if (_selectedFrontWheelDriveImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front wheel drive image");
//             } else if (_selectedFrontRightTyreAssemblyImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted front right tyre assembly image");
//             } else if (_selectedRightMechanicalImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right mechanical image");
//             } else if (_selectedRearRightDoorChannelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear right door channel image");
//             } else if (_selectedRearRightWheelHouseImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted rear right wheel house image");
//             } else if (_selectedRightFloorPanChannelImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right floor pan channel image");
//             } else if (_selectedRightPillarBImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right pillar B image");
//             } else if (_selectedRightPillarCImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right pillar C image");
//             } else if (_selectedRightRunningBoardImage == null) {
//               return showErrorSnackBar(
//                   context: context,
//                   errorMsg: "Please selcted right running board image");
//             } else if (carDoc == null) {
//               return showErrorSnackBar(
//                   context: context, errorMsg: "Please save car details");
//             }

//             if (_formInspectionKey.currentState!.validate()) {
//               setState(() {
//                 _carFairPriceController.text =
//                     widget.carDetails.serialNumber.toString();
//                 _showReMarksOptions(context);
//               });
//             }
//           },
//           child: const Text('Submit'),
//         ),
//       ],
//     ),
//   );
// }
