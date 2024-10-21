import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspection/model/car_details.dart';
import 'package:inspection/services/inspection_service.dart';
// import 'package:inspection/model/lead.dart';
import '../model/new_lead.dart';
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
  double _uploadProgress = 0.0; // Progress starts at 0.0
  int _selectedIndex = 0; // To keep track of the selected page
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
  final TextEditingController _reMarksController = TextEditingController();
  final TextEditingController _carFairPriceController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  CarDoc? carDoc;

  ///rc details
  final TextEditingController _rcNumberController = TextEditingController();
  List<File> imageList = []; // Initialize as an empty list

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
    if (sectionImages.length < 15) {
      final XFile? image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
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
                (imageList.length < 15
                    ? 1
                    : 0), // Conditionally add an extra slot for "Add Image"
            itemBuilder: (context, index) {
              // If we are at the last index and haven't reached 15 images yet, show "Upload Image"
              if (index == imageList.length && imageList.length < 15) {
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
                return Container(); // Handle any other cases gracefully
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

  Future<String> uploadCarDetailsImage({
    required XFile imageVar,
    required String imageRef,
  }) async {
    final File file = File(imageVar.path); // Convert XFile to File
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference reference = storage.ref('$imageRef/$fileName');

    try {
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

  Future<List<String>> _uploadImages(
      List<File> images, String sectionName, String serialNumber) async {
    List<String> downloadUrls = [];

    try {
      for (var image in images) {
        print("Uploading image from: ${image.path}");

        // Convert File to XFile if needed
        XFile xfile = XFile(image.path);

        // Upload image and get the download URL
        String downloadUrl = await uploadImage(
          imageVar: xfile,
          imageRef: 'inspection/$serialNumber/car_health/$sectionName',
        );

        // Add the download URL to the list
        downloadUrls.add(downloadUrl);

        print("Uploaded image to: $downloadUrl");
      }
    } catch (e) {
      print("Error uploading images for $sectionName: $e");
    }

    return downloadUrls;
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
// function to send Data to PostAPI

  // Future<void> sendDataToApi() async {
  //   // Define the URL for the API
  //   final url = Uri.parse('https://gowaggon.com/crm/api/PostInspection');
  //   final newCarDoc = CarDetails(
  //     serialNumber: widget.carDetails.serialNumber,
  //     reMarks: _reMarksController.text,
  //     carDoc: carDoc,
  //   );
  //   // Prepare the data from newCarDoc
  //   // Assuming newCarDoc is an object with a toMap method to convert it to a Map
  //   Map<String, dynamic> requestBody = newCarDoc.toMap();
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json', // Specify the content type
  //       },
  //       body: jsonEncode(requestBody), // Encode the Map to JSON
  //     );

  //     // Check the response status
  //     if (response.statusCode == 200) {
  //       // Successfully sent the data
  //       print('Data sent successfully: ${response.body}');
  //     } else {
  //       // Handle the error response
  //       print('Failed to send data: ${response.statusCode}, ${response.body}');
  //     }
  //   } catch (error) {
  //     // Handle any exceptions
  //     print('Error occurred: $error');
  //   }
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

  Future<void> _saveSectionData(String sectionName, List<File> images,
      TextEditingController commentsController, String serialNumber) async {
    try {
      List<String> imageUrls =
          await _uploadImages(images, sectionName, serialNumber);

      // Prepare section data
      final sectionData = {
        'comments': commentsController.text,
        'images': imageUrls,
      };

      // Reference to the section in Realtime Database
      DatabaseReference sectionRef = FirebaseDatabase.instance
          .ref('inspection/$serialNumber/car_health/$sectionName');

      print("Saving data for $sectionName: $sectionData");

      await sectionRef.set(sectionData);

      print("$sectionName data saved successfully");
    } catch (e) {
      print("Error saving $sectionName data: $e");
    }
  }

  Future<void> _saveInspectionData() async {
    setState(() {
      _isUploading = true;
    });

    // Check if all required fields are filled
    if (_interiorCommentsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill Interior Comments")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_exteriorCommentsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill Exterior Comments")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_extraCommentsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill Extra Comments")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_beforeTestDriveKmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter Before Test Drive KM")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_afterTestDriveKmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter After Test Drive KM")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_testDriveCommentsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill Test Drive Comments")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    // If any image sections are mandatory, you can add checks here
    if (_interiorImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please upload images for the Interior Section")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_exteriorImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please upload images for the Exterior Section")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_extraImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload images for the Extra Section")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }

    if (_testDriveImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please upload images for the Test Drive Section")),
      );
      setState(() {
        _isUploading = false;
      });
      return;
    }
    String serialNumber =
        widget.carDetails.serialNumber.toString(); // Car's serial number

    try {
      // Save Interior Section
      await _saveSectionData(
        'interior', // Section name
        _interiorImages, // List of images for the interior section
        _interiorCommentsController, // Comments controller for the interior section
        serialNumber, // Car's serial number
      );

      // Save Exterior Section
      await _saveSectionData(
        'exterior',
        _exteriorImages,
        _exteriorCommentsController,
        serialNumber,
      );

      // Save Extra Section
      await _saveSectionData(
        'extra',
        _extraImages,
        _extraCommentsController,
        serialNumber,
      );

      // Save Test Drive Section
      await _saveSectionData(
        'test_drive',
        _testDriveImages,
        _testDriveCommentsController,
        serialNumber,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Inspection data saved successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Show final verdict options after successful data save
      _showFinalVerdictOptions(context);
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving inspection data: $e"),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _savefinalVerdictSerialNumber() async {
    try {
      // Define the database reference based on the serial number
      DatabaseReference carHealthRef = FirebaseDatabase.instance
          .ref()
          .child('inspection')
          .child(widget.carDetails.serialNumber.toString())
          .child('car_health');

      DatabaseReference serialNumberRef = FirebaseDatabase.instance
          .ref()
          .child('inspection')
          .child(widget.carDetails.serialNumber.toString());

      // Prepare the data to be saved
      Map<String, dynamic> carHealthData = {
        'finalVerdict': _finalVerdictController.text,
      };

      Map<String, dynamic> serialNumberData = {
        'serial_number': widget.carDetails.serialNumber,
      };

      // Insert final verdict in inspection/$serialNumber/car_health
      await carHealthRef.update(carHealthData);

      // Insert serial number in inspection/$serialNumber/serial_number
      await serialNumberRef.update(serialNumberData);

      print("Data saved successfully in car_health and serial_number");
    } catch (e) {
      print('Error saving inspection data: $e');
      throw e; // Throw the error to handle it in the submit button's try-catch block
    }
  }

  void _showFinalVerdictOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Adjusts for keyboard height
      builder: (context) {
        return SingleChildScrollView(
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
                    // Final Verdict TextField
                    TextFormField(
                      controller: _finalVerdictController,
                      decoration: InputDecoration(
                        labelText: 'Final Verdict',
                        hintText: 'Enter your final verdict',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a verdict';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Check if the verdict text field is empty
                          if (_finalVerdictController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter a verdict"),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          try {
                            // Save inspection data to Firebase
                            await _saveInspectionData();
                            await _savefinalVerdictSerialNumber();
                            InspectionService inspectionService =
                                InspectionService();
                            int serialNumber = widget.carDetails.serialNumber;
                            await inspectionService
                                .postInspectionData(serialNumber);
                            // Success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Inspection data and final verdict submitted successfully"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 5),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error submitting data: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
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

  //This function is not working(as of 20-10-24 5:40am)
  // Future<void> _updateLeadStatus(int serialNumber, int newStatus) async {
  //   try {
  //     // Set the path for the other database reference
  //     final DatabaseReference otherDatabaseRef =
  //         FirebaseDatabase.instance.ref('leads_data/$serialNumber/leadStatus');
  //     print(
  //         "Updating leadStatus at path: leads_data/$serialNumber/leadStatus with value: $newStatus");
  //     await otherDatabaseRef.set(newStatus);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //             "Lead status updated to $newStatus of the lead with serial number $serialNumber"),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error updating lead status in the other database: $e"),
  //       ),
  //     );
  //   }
  // }

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
                  keyboardType:
                      TextInputType.number, // Ensure only numbers are input
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _afterTestDriveKmController,
                  decoration: InputDecoration(
                    labelText: "After Test Drive KM",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.number, // Ensure only numbers are input
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

// Helper function to build image section
  Widget _buildImageSection(List<File> imageList, String sectionName) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length + (imageList.length < 15 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == imageList.length && imageList.length < 15) {
            return GestureDetector(
              onTap: () {
                _pickImage(imageList, sectionName);
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text("Add Image"),
                ),
              ),
            );
          } else if (index < imageList.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // Remove the image when clicked
                  _removeImage(index);
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Remove button (icon or text)
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _removeImage(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
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
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);

                      if (image != null) {
                        setState(() {
                          _selectedRcImage = XFile(image.path);
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
                              image: FileImage(File(_selectedRcImage!.path)),
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
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);

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
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);

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
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        _selectedRcImage = image;
      });
    }
  }

  Future<void> pickCarImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        _selectedCarImage = image;
      });
    }
  }

  Future<void> pickChassisNumberImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      setState(() {
        _selectedChassisNumberImage = image;
      });
    }
  }
// function to save CarDetailsPage in firebase

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  void _saveCarDetails() async {
    try {
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

      if (_selectedRcImage != null) {
        rcImageUrl = await uploadCarDetailsImage(
          imageVar: _selectedRcImage!,
          imageRef:
              'inspection/${widget.carDetails.serialNumber}/car_doc/rc_details',
        );
      }

      if (_selectedCarImage != null) {
        carImageUrl = await uploadCarDetailsImage(
          imageVar: _selectedCarImage!,
          imageRef:
              'inspection/${widget.carDetails.serialNumber}/car_doc/car_details',
        );
      }

      if (_selectedChassisNumberImage != null) {
        chassisNumberImageUrl = await uploadCarDetailsImage(
          imageVar: _selectedChassisNumberImage!,
          imageRef:
              'inspection/${widget.carDetails.serialNumber}/car_doc/other_details/chassis_number_image',
        );
      }

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

      await dbRef
          .child("inspection/${widget.carDetails.serialNumber}")
          .set(carDetailsData);

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
