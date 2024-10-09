import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/car_doc.dart';

class CarDetailsPage extends StatefulWidget {
  final String? carId; // If editing existing data, carId should be passed
  const CarDetailsPage({Key? key, this.carId}) : super(key: key);

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late DatabaseReference _database;
  late FirebaseStorage _storage;
  int _selectedIndex = 0; // To keep track of the selected page
  final TextEditingController _rcNumberController = TextEditingController();
  final TextEditingController _mfgYearMonthController = TextEditingController();
  final TextEditingController _carMakeController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _ownersController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();

  bool _hsrpAvailable = false;
  bool _isChassisNumberOk = false;
  String _rcImageUrl = ''; // URL for the RC image
  String _engineImageUrl = ''; // URL for the engine image
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('inspection');
    _storage = FirebaseStorage.instance;
    if (widget.carId != null) {
      _loadCarData();
    }
  }

  // Load existing data if carId is provided
  void _loadCarData() async {
    if (widget.carId != null) {
      final dataSnapshot = await _database.child(widget.carId!).get();
      if (dataSnapshot.exists) {
        final carData = CarDoc.fromMap(dataSnapshot.value as Map);
        setState(() {
          _rcNumberController.text = carData.rcDetails.rcNumber;
          _mfgYearMonthController.text = carData.carDetails.mfgYearMonth;
          _carMakeController.text = carData.carDetails.carMake;
          _carModelController.text = carData.carDetails.carModel;
          _fuelTypeController.text = carData.carDetails.fuelType;
          _transmissionController.text = carData.carDetails.transmission;
          _ownersController.text = carData.others.owners.toString();
          _engineNumberController.text = carData.others.engineNumber;
          _hsrpAvailable = carData.others.hsrpAvailable;
          _isChassisNumberOk = carData.others.isChassisNumberOk;
          _rcImageUrl = carData.rcDetails.rcImage; // Load existing image URL
          _engineImageUrl =
              carData.others.engineImage; // Load existing engine image URL
        });
      }
    }
  }

  // Method to capture and upload an image
  Future<void> _captureImage(bool isRc) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final file = File(image.path);
      String filePath =
          '/inspection/car_doc/images/${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        final ref = _storage.ref().child(filePath);
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();

        setState(() {
          if (isRc) {
            _rcImageUrl = downloadUrl; // Update RC image URL
          } else {
            _engineImageUrl = downloadUrl; // Update engine image URL
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image Uploaded!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  // Save data to Firebase
  void _saveCarDetails() async {
    final newCarDoc = CarDoc(
      rcDetails: RcDetails(
        rcNumber: _rcNumberController.text,
        rcImage: _rcImageUrl, // Save the RC image URL
      ),
      carDetails: CarDetails(
        mfgYearMonth: _mfgYearMonthController.text,
        carMake: _carMakeController.text,
        carModel: _carModelController.text,
        fuelType: _fuelTypeController.text,
        transmission: _transmissionController.text,
        images: 'https://someimageurl.com',
      ),
      registrationDetails: RegistrationDetails(
        registrationYearMonth: _mfgYearMonthController.text,
      ),
      others: Others(
        owners: int.parse(_ownersController.text),
        hsrpAvailable: _hsrpAvailable,
        engineNumber: _engineNumberController.text,
        isChassisNumberOk: _isChassisNumberOk,
        chassisNumberImage: 'https://someimageurl.com',
        noOfKeys: 2,
        images: ['https://someimageurl.com'],
        engineImage: _engineImageUrl, // Save the engine image URL
      ),
    );
    if (widget.carId != null) {
      await _database.child(widget.carId!).set(newCarDoc.toMap());
    } else {
      await _database.push().set(newCarDoc.toMap());
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Car Details Saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCarDetailsPage(),
          _buildInspectionPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildExpansionTile('RC Details', [
          _buildTextField(_rcNumberController, 'RC Number'),
          // Button to capture RC image
          ElevatedButton(
            onPressed: () => _captureImage(true), // Capture RC image
            child: const Text('Capture RC Image'),
          ),
          if (_rcImageUrl.isNotEmpty) ...[
            Image.network(_rcImageUrl,
                height: 150, fit: BoxFit.cover), // Display RC image
          ],
        ]),
        _buildExpansionTile('Car Details', [
          _buildTextField(_mfgYearMonthController, 'Manufacturing Year/Month'),
          _buildTextField(_carMakeController, 'Car Make'),
          _buildTextField(_carModelController, 'Car Model'),
          _buildTextField(_fuelTypeController, 'Fuel Type'),
          _buildTextField(_transmissionController, 'Transmission Type'),
        ]),
        _buildExpansionTile('Other Details', [
          _buildTextField(_ownersController, 'Number of Owners',
              isNumber: true),
          _buildTextField(_engineNumberController, 'Engine Number'),
          // Button to capture Engine image
          ElevatedButton(
            onPressed: () => _captureImage(false), // Capture engine image
            child: const Text('Capture Engine Image'),
          ),
          if (_engineImageUrl.isNotEmpty) ...[
            Image.network(_engineImageUrl,
                height: 150, fit: BoxFit.cover), // Display engine image
          ],
          SwitchListTile(
            title: const Text('HSRP Available'),
            value: _hsrpAvailable,
            onChanged: (val) {
              setState(() {
                _hsrpAvailable = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Chassis Number OK'),
            value: _isChassisNumberOk,
            onChanged: (val) {
              setState(() {
                _isChassisNumberOk = val;
              });
            },
          ),
        ]),
        ElevatedButton(
          onPressed: _saveCarDetails, // Save button
          child: const Text('Save Details'),
        ),
      ],
    );
  }

  // Build an ExpansionTile for better UI organization
  Widget _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title),
      children: children,
    );
  }

  // Build a text field with controller and label
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
    );
  }

  // Method to build the Inspection page
  Widget _buildInspectionPage() {
    return Center(
      child: const Text('Inspection Page'),
    );
  }
}
