import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspection/model/car_details.dart';
import 'package:inspection/services/inspection_service.dart';
import 'package:intl/intl.dart';
import '../model/new_lead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarDetailsPage extends StatefulWidget {
  final Lead carDetails;
  const CarDetailsPage({Key? key, required this.carDetails}) : super(key: key);
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late DatabaseReference _database;
  double _uploadProgress = 0.0;
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final _formInspectionKey = GlobalKey<FormState>();
  final _formBottomKey = GlobalKey<FormState>();
  List<File> _interiorImages = [];
  List<File> _exteriorImages = [];
  List<File> _extraImages = [];
  final _interiorCommentsController = TextEditingController();
  final _exteriorCommentsController = TextEditingController();
  final _extraCommentsController = TextEditingController();
  final TextEditingController _beforeTestDriveKmController =
      TextEditingController();
  final TextEditingController _afterTestDriveKmController =
      TextEditingController();
  final TextEditingController _finalVerdictController = TextEditingController();
  bool _isUploading = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  // Text controllers for car details
  final TextEditingController _mfgYearMonthController = TextEditingController();
  final TextEditingController _carMakeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _ownersController = TextEditingController();
  final TextEditingController _numberOfKeyController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  CarDoc? carDoc;

  ///rc details
  final TextEditingController _rcNumberController = TextEditingController();
  List<File> imageList = [];
  //video
  final TextEditingController engineNoiseVideo = TextEditingController();
  final TextEditingController testDriveVideo = TextEditingController();
  //extra parts
  final TextEditingController extraParts = TextEditingController();
  //Registration details
  final TextEditingController _registrationYearMonthController =
      TextEditingController();
  bool _hsrpAvailable = false;
  bool _isChassisNumberOk = false;
  final ImagePicker picker = ImagePicker();
  XFile? _selectedRcImage;
  XFile? _selectedCarImage;
  XFile? _selectedChassisNumberImage;
  List<File> _selectedOtherImages = [];
  //Image String
  String? selectedRcImage;
  String? selectedCarImage;
  String? selectedChassisNumberImage;
  List<String> selectedOtherImages = [];
  List<String> selectedAllImages = [];
  List<File> _testDriveImages = [];
  TextEditingController _testDriveCommentsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('inspection');
  }

  Future<void> _pickImage(List<File> sectionImages, String sectionName) async {
    if (sectionImages.length < 20) {
      final XFile? image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
      if (image != null) {
        setState(() {
          sectionImages.add(File(image.path));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maximum 20 images allowed for $sectionName section"),
        ),
      );
    }
  }

  Widget _buildSection(
    String title,
    TextEditingController commentsController,
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
            itemCount: imageList.length +
                (imageList.length < 20
                    ? 1
                    : 0), // Conditionally add an extra slot for "Add Image"
            itemBuilder: (context, index) {
              // If we are at the last index and haven't reached 20 images yet, show "Upload Image"
              if (index == imageList.length && imageList.length < 20) {
                return GestureDetector(
                  onTap: () {
                    _pickImage(imageList, title);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: const Center(
                      child: Text(
                        "Upload Image",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              }
              // Else, display the images
              else if (index < imageList.length) {
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

  Future<String> uploadCarDetailsImage({
    required XFile imageVar,
    required String imageRef,
  }) async {
    final File file = File(imageVar.path);
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference reference = storage.ref('$imageRef/$fileName');
    try {
      // Check if the image already exists
      ListResult existingFiles = await storage.ref(imageRef).listAll();
      bool fileAlreadyExists =
          existingFiles.items.any((item) => item.name == fileName);
      // If the file already exists, get and return its download URL
      if (fileAlreadyExists) {
        return await reference.getDownloadURL();
      }
      // Proceed with uploading if the file does not exist
      final UploadTask uploadTask = reference.putFile(file);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });
      final TaskSnapshot taskSnapshot = await uploadTask;
      if (taskSnapshot.bytesTransferred == taskSnapshot.totalBytes) {
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('Image upload failed: Incomplete transfer.');
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<String> uploadImage({
    required XFile imageVar,
    required String imageRef,
  }) async {
    final File file = File(imageVar.path);
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference reference = storage.ref('$imageRef/$fileName');
    try {
      final UploadTask uploadTask = reference.putFile(file);
      // Track the progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      });
      // Wait for the upload to complete
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

  Future<List<String>> _uploadImages(
    List<File> images,
    String sectionName,
    String serialNumber,
    List<String> existingImageUrls,
  ) async {
    // Copy existing URLs to avoid duplicates
    List<String> imageUrls = List<String>.from(existingImageUrls);
    // Map each image upload to a future
    List<Future<String>> uploadFutures = images.map((image) async {
      // Upload image if not already uploaded
      String imageUrl = await uploadImage(
        imageVar: XFile(image.path),
        imageRef: 'inspection/$serialNumber/car_health/$sectionName',
      );
      if (!imageUrls.contains(imageUrl)) {
        imageUrls.add(imageUrl);
      }
      return imageUrl;
    }).toList();
    // Wait for all uploads to complete
    await Future.wait(uploadFutures);
    return imageUrls;
  }

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

  Future<void> _saveSectionData({
    required String sectionName,
    required List<File> images,
    required TextEditingController commentsController,
    required String serialNumber,
  }) async {
    try {
      // Reference to the section in Realtime Database
      DatabaseReference sectionRef = FirebaseDatabase.instance
          .ref('inspection/$serialNumber/car_health/$sectionName');
      // Retrieve existing image URLs, if any
      final sectionSnapshot = await sectionRef.get();
      List<String> existingImageUrls = [];
      if (sectionSnapshot.exists) {
        final existingData =
            Map<String, dynamic>.from(sectionSnapshot.value as Map);
        if (existingData.containsKey('images')) {
          existingImageUrls = List<String>.from(existingData['images']);
        }
      }
      // Upload images, avoiding duplicates
      List<String> imageUrls = await _uploadImages(
          images, sectionName, serialNumber, existingImageUrls);
      // Prepare section data with updated image URLs
      final sectionData = {
        'comments': commentsController.text,
        'images': imageUrls,
      };
      print("Saving data for $sectionName: $sectionData");
      await sectionRef.set(sectionData);
      print("$sectionName data saved successfully");
    } catch (e) {
      print("Error saving $sectionName data: $e");
      throw Exception("Error saving $sectionName data");
    }
  }

  Future<void> _saveInspectionData() async {
    setState(() {
      _isUploading = true;
    });
    try {
      // Validate fields and images for each section
      await _validateFieldsAndImages();
      String serialNumber = widget.carDetails.serialNumber.toString();
      // Save each section
      await _saveSectionData(
        sectionName: 'interior',
        images: _interiorImages,
        commentsController: _interiorCommentsController,
        serialNumber: serialNumber,
      );
      await _saveSectionData(
        sectionName: 'exterior',
        images: _exteriorImages,
        commentsController: _exteriorCommentsController,
        serialNumber: serialNumber,
      );
      await _saveSectionData(
        sectionName: 'extra',
        images: _extraImages,
        commentsController: _extraCommentsController,
        serialNumber: serialNumber,
      );
      await _saveSectionData(
        sectionName: 'test_drive',
        images: _testDriveImages,
        commentsController: _testDriveCommentsController,
        serialNumber: serialNumber,
      );
      // Save Test Drive KM readings
      await _saveTestDriveKm(serialNumber);
      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Inspection data saved successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      // Show final verdict options
      _showFinalVerdictOptions(context);
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving inspection data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _validateFieldsAndImages() async {
    if (_interiorCommentsController.text.isEmpty) {
      throw "Please fill Interior Comments";
    }
    if (_exteriorCommentsController.text.isEmpty) {
      throw "Please fill Exterior Comments";
    }
    if (_extraCommentsController.text.isEmpty) {
      throw "Please fill Extra Comments";
    }
    if (_beforeTestDriveKmController.text.isEmpty) {
      throw "Please enter Before Test Drive KM";
    }
    if (_afterTestDriveKmController.text.isEmpty) {
      throw "Please enter After Test Drive KM";
    }
    if (_testDriveCommentsController.text.isEmpty) {
      throw "Please fill Test Drive Comments";
    }
    if (_interiorImages.isEmpty) {
      throw "Please upload images for the Interior Section";
    }
    if (_exteriorImages.isEmpty) {
      throw "Please upload images for the Exterior Section";
    }
    if (_extraImages.isEmpty) {
      throw "Please upload images for the Extra Section";
    }
    if (_testDriveImages.isEmpty) {
      throw "Please upload images for the Test Drive Section";
    }
  }

  Future<void> _saveTestDriveKm(String serialNumber) async {
    DatabaseReference testDriveRef = FirebaseDatabase.instance
        .ref('inspection/$serialNumber/car_health/test_drive');
    final testDriveData = {
      'before_test_drive_km': _beforeTestDriveKmController.text,
      'after_test_drive_km': _afterTestDriveKmController.text,
    };
    await testDriveRef.set(testDriveData);
  }

  Future<void> _savefinalVerdictSerialNumber() async {
    try {
      // Define the database reference based on the serial number
      DatabaseReference carHealthRef = FirebaseDatabase.instance
          .ref()
          .child('inspection')
          .child(
            widget.carDetails.serialNumber.toString(),
          )
          .child('car_health');
      DatabaseReference serialNumberRef =
          FirebaseDatabase.instance.ref().child('inspection').child(
                widget.carDetails.serialNumber.toString(),
              );
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      Map<String, dynamic> carHealthData = {
        'finalVerdict': _finalVerdictController.text,
        'inspectionDateTime': formattedDate,
      };
      Map<String, dynamic> serialNumberData = {
        'serial_number': widget.carDetails.serialNumber,
      };
      await carHealthRef.update(carHealthData);
      await serialNumberRef.update(serialNumberData);
      print("Data saved successfully saved in carHealthData");
    } catch (e) {
      print('Error saving inspection data: $e');
      throw e;
    }
  }

  bool _isLoading = false;
  void _showFinalVerdictOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height, // Full screen height
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false, // Remove default back button
                title: Text('Add Final Verdict'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context); // Close modal
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _finalVerdictController,
                            maxLines: null, // Allow multiline input
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Final Verdict',
                              hintText: 'Enter your final verdict',
                            ),
                            onChanged: (value) {
                              // Check if the input is empty and set the first bullet point
                              if (value.isEmpty) {
                                _finalVerdictController.value =
                                    TextEditingValue(
                                  text:
                                      '• ', // Start with a bullet point if input is empty
                                  selection: TextSelection.collapsed(
                                      offset:
                                          2), // Place cursor after the bullet point
                                );
                              } else if (value.endsWith('\n')) {
                                // If the last character is a newline, add a bullet point on the new line
                                String formattedValue =
                                    value.trimRight() + '\n• ';
                                _finalVerdictController.value =
                                    TextEditingValue(
                                  text: formattedValue,
                                  selection: TextSelection.collapsed(
                                      offset: formattedValue.length),
                                );
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a verdict';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            width: double.infinity,
                            child: _isLoading
                                ? Column(
                                    children: [
                                      Text(
                                          "Uploading... ${(_uploadProgress * 100).toInt()}%"),
                                      LinearProgressIndicator(
                                          value: _uploadProgress),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            // Validation checks
                                            if (_rcNumberController
                                                .text.isEmpty) {
                                              showErrorSnackBar(
                                                  context: context,
                                                  errorMsg: "Enter RC Number");
                                              return;
                                            } else if (_selectedRcImage ==
                                                null) {
                                              showErrorSnackBar(
                                                  context: context,
                                                  errorMsg:
                                                      "Please upload RC image");
                                              return;
                                            }
                                            // Add other validation checks as needed
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            try {
                                              // Save inspection data to Firebase
                                              await _savefinalVerdictSerialNumber();
                                              int serialNumber = widget
                                                  .carDetails.serialNumber;
                                              InspectionService
                                                  inspectionService =
                                                  InspectionService();
                                              // Call postInspectionData only once
                                              print(
                                                  'before post inspection function');
                                              await inspectionService
                                                  .postInspectionData(
                                                      serialNumber);
                                              print(
                                                  'after post inspection function');
                                              // Delete all leads
                                              print(
                                                  'before delete all leads function');
                                              await deleteAllLeads();
                                              print(
                                                  'after delete all leads function');
                                              // Success message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Inspection data and final verdict submitted successfully"),
                                                  backgroundColor: Colors.green,
                                                  duration:
                                                      Duration(seconds: 5),
                                                ),
                                              );
                                              // Navigate to the home page
                                              Navigator.pop(context);
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/home',
                                                (Route<dynamic> route) =>
                                                    false, // Remove all previous routes
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Error submitting data: $e"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } finally {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                    child: Text('Submit'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // bool _isUploadingVideo = false;
  // double _videoUploadProgress = 0.0;
  // // Function to capture video
  // XFile? _capturedVideo;
  // Future<void> _captureVideo() async {
  //   try {
  //     final XFile? video = await picker.pickVideo(
  //       source: ImageSource.camera,
  //       maxDuration: Duration(seconds: 15),
  //     );
  //     if (video != null) {
  //       setState(() {
  //         _capturedVideo = video;
  //       });
  //     }
  //   } catch (e) {
  //     print("Error capturing video: $e");
  //   }
  // }
  // Future<void> _uploadVideoToFirebase(XFile video) async {
  //   setState(() {
  //     _isUploadingVideo = true;
  //   });
  //   final storageRef = FirebaseStorage.instance.ref().child(
  //       'inspection/${widget.carDetails.serialNumber}/car_health/engine/video/${DateTime.now().millisecondsSinceEpoch}.mp4');
  //   final uploadTask = storageRef.putFile(File(video.path));
  //   uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //     setState(() {
  //       _videoUploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
  //     });
  //   });
  //   await uploadTask.whenComplete(() async {
  //     final videoUrl = await storageRef.getDownloadURL();
  //     _saveVideoUrlToDatabase(videoUrl);
  //     setState(() {
  //       _isUploadingVideo = false;
  //       _capturedVideo = null; // Clear the video after upload
  //     });
  //   }).catchError((error) {
  //     print("Failed to upload video: $error");
  //     setState(() {
  //       _isUploadingVideo = false;
  //     });
  //   });
  // }
  // // Function to save the video URL in Firebase Realtime Database
  // Future<void> _saveVideoUrlToDatabase(String url) async {
  //   final serialNumber = widget.carDetails.serialNumber;
  //   final dbRef = FirebaseDatabase.instance
  //       .ref('inspection/$serialNumber/car_health/engine');
  //   await dbRef.set({'video': url});
  // }
  File? _engineVideoFile;
  Future<void> _captureEngineVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 10));

    if (pickedFile != null) {
      setState(() {
        _engineVideoFile = File(pickedFile.path);
      });
    }
  }

// Function to upload video to Firebase Storage
  Future<void> _uploadEngineVideo() async {
    if (_engineVideoFile == null) return;

    try {
      setState(() => _isUploading = true);

      final ref = FirebaseStorage.instance.ref(
          'inspection/${widget.carDetails.serialNumber}/car_health/engine/video');
      final uploadTask = ref.putFile(_engineVideoFile!);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        });
      });

      final TaskSnapshot taskSnapshot = await uploadTask;
      final videoUrl = await taskSnapshot.ref.getDownloadURL();
      DatabaseReference videoSave =
          FirebaseDatabase.instance.ref().child('inspection').child(
                widget.carDetails.serialNumber.toString(),
              );
      // Save video URL to Firebase Realtime Database
      await videoSave.ref
          .child('/car_health/engine')
          .update({'video_url': videoUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Engine Video Uploaded Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Upload Engine Video: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Widget _buildNewInspectionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interior Section
            ExpansionTile(
              title: Text(
                'Interior Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                SizedBox(height: 10),
                _buildImageSection(_interiorImages, "Interior Section"),
                SizedBox(height: 20),
                TextField(
                  controller: _interiorCommentsController,
                  decoration: InputDecoration(
                    labelText: "Interior Comments",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
              ],
            ),
            // Exterior Section
            ExpansionTile(
              title: Text(
                'Exterior Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                SizedBox(height: 10),
                _buildImageSection(_exteriorImages, "Exterior Section"),
                SizedBox(height: 20),
                TextField(
                  controller: _exteriorCommentsController,
                  decoration: InputDecoration(
                    labelText: "Exterior Comments",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
              ],
            ),
            // Extra Section
            ExpansionTile(
              title: Text(
                'Extra Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                SizedBox(height: 10),
                _buildImageSection(_extraImages, "Extra Section"),
                SizedBox(height: 20),
                TextField(
                  controller: _extraCommentsController,
                  decoration: InputDecoration(
                    labelText: "Extra Comments",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Engine Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _captureEngineVideo,
                  icon: Icon(Icons.videocam),
                  label: Text('Capture Engine Video'),
                ),
                SizedBox(height: 10),
                if (_engineVideoFile != null)
                  ElevatedButton.icon(
                    onPressed: _uploadEngineVideo,
                    icon: Icon(Icons.cloud_upload),
                    label: Text('Upload Engine Video'),
                  ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 20),

            // Test Drive Section
            ExpansionTile(
              title: Text(
                'Test Drive Section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                SizedBox(height: 10),
                _buildImageSection(_testDriveImages, "Test Drive Section"),
                SizedBox(height: 20),
                // New text fields for Before and After Test Drive KM
                TextField(
                  controller: _beforeTestDriveKmController,
                  decoration: InputDecoration(
                    labelText: "Before Test Drive KM",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _afterTestDriveKmController,
                  decoration: InputDecoration(
                    labelText: "After Test Drive KM",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _testDriveCommentsController,
                  decoration: InputDecoration(
                    labelText: "Test Drive Comments",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 20),
            _isUploading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value:
                                  _uploadProgress, // Shows progress from 0 to 1
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.purple), // Custom color
                              strokeWidth: 8.0, // Custom width
                              backgroundColor:
                                  Colors.grey[300], // Background for the circle
                            ),
                            // Overlay text for percentage
                            Text(
                              '${(_uploadProgress * 100).toStringAsFixed(0)}%', // Shows percentage
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .purple, // Text color matching progress
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Uploading...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors
                                .grey[700], // Friendly text below the progress
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _saveInspectionData,
                    child: Text('Save Inspection Data'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteAllLeads() async {
    final DatabaseReference leadsRef =
        FirebaseDatabase.instance.ref('leads_data');
    print('this is deleteAllLeads method');
    try {
      // Delete all leads data in the 'leads_data' node
      await leadsRef.remove();
      print("All leads have been deleted successfully.");
    } catch (error) {
      print("Failed to delete leads: $error");
      // Handle error, such as showing a notification or SnackBar to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete leads: $error"),
        backgroundColor: Colors.red,
      ));
    }
  }

// Helper function to build image section
  Widget _buildImageSection(List<File> imageList, String sectionName) {
    return SizedBox(
      height: 120, // Increased height for better spacing
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length + (imageList.length < 20 ? 1 : 0),
        itemBuilder: (context, index) {
          // "Add Image" Button
          if (index == imageList.length && imageList.length < 20) {
            return GestureDetector(
              onTap: () {
                _pickImage(imageList, sectionName);
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Change to a color that stands out
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        "Add Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          // Display existing images
          else if (index < imageList.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  // Optional: Show a larger version of the image when clicked
                  // _showImagePreview(imageList[index]);
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageList[index]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    // Enhanced Remove Button
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                        onPressed: () {
                          _removeImage(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(); // Empty container for padding
          }
        },
      ),
    );
  }

// Method to remove an image from the list
// This function is not tested as of 5:47am 20-10-2024
  void _removeImage(int index) {
    setState(() {
      if (index >= 0 && index < imageList.length) {
        print("Removing image at index: $index"); // Debug print
        imageList.removeAt(index);
      } else {
        print("Index out of range: $index");
      }
    });
  }

  Future<void> _pickCarDetailsImage() async {
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
              'inspection/${widget.carDetails.serialNumber}/car_doc/other_details/images/$fileName');
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

  // Method to build the Car Details section
  Widget _buildCarDetailsPage() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCardExpansionTile(
            'RC Details',
            [
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
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 10);
                        if (image != null) {
                          setState(
                            () {
                              _selectedRcImage = XFile(image.path);
                            },
                          );
                          final result = await uploadImage(
                            imageVar: image,
                            imageRef:
                                'inspection/${widget.carDetails.serialNumber}/car_doc/rc_details',
                          );
                          if (result.isNotEmpty) {
                            setState(
                              () {
                                selectedRcImage = result.toString();
                                log("message ${selectedRcImage}");
                              },
                            );
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
                                image: FileImage(
                                  File(_selectedRcImage!.path),
                                ),
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
            ],
          ),
          _buildCardExpansionTile(
            'Car Details',
            [
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
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 10);

                        if (image != null) {
                          setState(() {
                            _selectedCarImage = XFile(image.path);
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
                                image: FileImage(File(_selectedCarImage!.path)),
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
            ],
          ),
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
              isNumber: true,
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
                setState(
                  () {
                    _isChassisNumberOk = val;
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    if (selectedChassisNumberImage == null) {
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 10);
                      if (image != null) {
                        setState(() {
                          _selectedChassisNumberImage = XFile(image.path);
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
                              image: FileImage(
                                  File(_selectedChassisNumberImage!.path)),
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

  Future<void> pickRcImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (image != null) {
      setState(() {
        _selectedRcImage = image;
      });
    }
  }

  Future<void> pickCarImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (image != null) {
      setState(() {
        _selectedCarImage = image;
      });
    }
  }

  Future<void> pickChassisNumberImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (image != null) {
      setState(() {
        _selectedChassisNumberImage = image;
      });
    }
  }

  void _saveCarDetails() async {
    try {
      // Check for empty fields before saving
      if (_carMakeController.text.isEmpty ||
          _carModelController.text.isEmpty ||
          _fuelTypeController.text.isEmpty ||
          _mfgYearMonthController.text.isEmpty ||
          _transmissionController.text.isEmpty ||
          _engineNumberController.text.isEmpty ||
          _numberOfKeyController.text.isEmpty ||
          _ownersController.text.isEmpty ||
          _rcNumberController.text.isEmpty ||
          _registrationYearMonthController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all the required fields.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );
      String? rcImageUrl;
      String? carImageUrl;
      String? chassisNumberImageUrl;
      // Upload images if selected
      if (_selectedRcImage != null) {
        rcImageUrl = await uploadCarDetailsImage(
          imageVar: _selectedRcImage!,
          imageRef: 'inspection/${widget.carDetails.serialNumber}/rc_details',
        );
      }
      if (_selectedCarImage != null) {
        carImageUrl = await uploadCarDetailsImage(
          imageVar: _selectedCarImage!,
          imageRef: 'inspection/${widget.carDetails.serialNumber}/car_details',
        );
      }
      if (_selectedChassisNumberImage != null) {
        chassisNumberImageUrl = await uploadCarDetailsImage(
          imageVar: _selectedChassisNumberImage!,
          imageRef:
              'inspection/${widget.carDetails.serialNumber}/other_details/chassis_number_image',
        );
      }
      // Prepare car details data
      Map<String, dynamic> carDetailsData = {
        "car_doc": {
          "car_details": {
            "car_make": _carMakeController.text,
            "car_model": _carModelController.text,
            "fuel_type": _fuelTypeController.text,
            "images": carImageUrl,
            "mfg_year_month": _mfgYearMonthController.text,
            "transmission": _transmissionController.text,
          },
          "others": {
            "chassisNumberImage": chassisNumberImageUrl,
            "engine_number": _engineNumberController.text,
            "hsrp_available": _hsrpAvailable,
            "isChassisNumberOk": _isChassisNumberOk,
            "noOfKeys": int.parse(_numberOfKeyController.text),
            "owners": int.parse(_ownersController.text),
          },
          "rc_details": {
            "rc_image": rcImageUrl,
            "rc_number": _rcNumberController.text,
          },
          "registration_details": {
            "registration_year_month": _registrationYearMonthController.text,
          },
        }
      };
      // Save the car details to Firebase
      // await _database.ref
      //     .child('${widget.carDetails.serialNumber}')
      //     .set(carDetailsData);
      DatabaseReference carDocRef =
          FirebaseDatabase.instance.ref().child('inspection').child(
                widget.carDetails.serialNumber.toString(),
              );
      await carDocRef.set(carDetailsData);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Car Details Saved Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Save Car Details: $e')),
      );
    }
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
