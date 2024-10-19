import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspection/model/car_details.dart';
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
  File? _selectedRcImage;
  File? _selectedCarImage;
  File? _selectedChassisNumberImage;

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

  Widget _buildSection(
    String title,
    List<File> imageList,
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

      // Show upload progress if needed (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
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

  void _saveCarInspection() async {
    DatabaseReference carAuctionRef =
        FirebaseDatabase.instance.ref('car_auction');
    final newCarDoc = CarDetails(
      serialNumber: widget.carDetails.serialNumber,
      reMarks: _reMarksController.text,
      carDoc: carDoc,
    );
    ElevatedButton(
      onPressed: () async {
        // Show the "Car Inspection Saved!" message immediately
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Car Inspection Saved!')),
        );
        try {
          // Save the car details to Firebase
          await _database
              .child(widget.carDetails.serialNumber.toString())
              .set(newCarDoc.toMap());
          // Send data to the API
          await sendDataToApi();
          // Optionally, show another message if everything succeeds
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Car details successfully saved!')),
          );
        } catch (error) {
          // Show error message if something fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save data: $error')),
          );
        }
      },
      child: const Text('Submit'),
    );
    Navigator.pop(context);
    Navigator.pop(context);
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

  Future<void> _saveSectionData(String sectionName, List<File> images,
      TextEditingController commentsController) async {
    try {
      // Save comments to Firebase Realtime Database
      final String comment = commentsController.text;
      await _database
          .child(
              '${widget.carDetails.serialNumber}/car_health/$sectionName/comments')
          .set(comment);

      // Upload each image to Firebase Storage
      for (int i = 0; i < images.length; i++) {
        File image = images[i];
        String imageRef =
            'inspection/${widget.carDetails.serialNumber}/car_health/$sectionName/${sectionName}_image_$i.jpg';

        // Upload image to Firebase Storage
        await storage.ref(imageRef).putFile(image);
      }
    } catch (e) {
      throw e; // Throw the error to catch in the main method
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

    try {
      // Save Interior Section
      await _saveSectionData(
          'interior', _interiorImages, _interiorCommentsController);

      // Save Exterior Section
      await _saveSectionData(
          'exterior', _exteriorImages, _exteriorCommentsController);

      // Save Extra Section
      await _saveSectionData('extra', _extraImages, _extraCommentsController);

      // Save Test Drive Section (added this section)
      await _saveSectionData(
          'test_drive', _testDriveImages, _testDriveCommentsController);
      _showFinalVerdictOptions(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inspection data saved successfully!")),
      );
    } catch (e) {
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
                          if (_finalVerdictController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please enter a verdict")),
                            );
                            return;
                          }

                          // Save the final verdict
                          await _saveFinalVerdict();

                          // Update the lead status
                          await _updateLeadStatus(
                              widget.carDetails.leadStatus, 4);

                          // Pop all pages until you reach the home page
                          Navigator.popUntil(
                              context, ModalRoute.withName('/homePage'));
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

  Future<void> _updateLeadStatus(int serialNumber, int newStatus) async {
    try {
      await _database
          .child('leads_data/$serialNumber/leadStatus')
          .set(newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lead status updated to $newStatus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating lead status: $e")),
      );
    }
  }

  Future<void> _saveFinalVerdict() async {
    try {
      final String verdict = _finalVerdictController.text;

      // Save final verdict to Firebase
      await _database
          .child('${widget.carDetails.serialNumber}/car_health/final_verdict')
          .set(verdict);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Final verdict saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving final verdict: $e")),
      );
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
                ? Center(child: CircularProgressIndicator())
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
    );
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
