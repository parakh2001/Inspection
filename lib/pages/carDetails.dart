import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/car_doc.dart';

class CarDetailsPage extends StatefulWidget {
  final String? carId; // If editing existing data, carId should be passed
  const CarDetailsPage({Key? key, this.carId}) : super(key: key);

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late DatabaseReference _database;
  int _selectedIndex = 0; // To keep track of the selected page

  // Text controllers for car details
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

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('inspection');

    if (widget.carId != null) {
      _loadCarData(); // Load data if carId is passed (for editing)
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
        });
      }
    }
  }

  // Save data to Firebase
  void _saveCarDetails() async {
    final newCarDoc = CarDoc(
      rcDetails: RcDetails(
        rcNumber: _rcNumberController.text,
        rcImage:
            'https://someimageurl.com', // Replace with actual logic for image
      ),
      carDetails: CarDetails(
        mfgYearMonth: _mfgYearMonthController.text,
        carMake: _carMakeController.text,
        carModel: _carModelController.text,
        fuelType: _fuelTypeController.text,
        transmission: _transmissionController.text,
        images:
            'https://someimageurl.com', // Replace with actual logic for image
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
        noOfKeys: 2, // Example static data, you can replace
        images: [
          'https://someimageurl.com'
        ], // Replace with logic for multiple images
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildExpansionTile('RC Details', [
          _buildTextField(_rcNumberController, 'RC Number'),
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
          onPressed: _saveCarDetails,
          child: const Text('Save Car Details'),
        ),
      ],
    );
  }

  // Dummy Inspection Page
  Widget _buildInspectionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assignment_turned_in, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text('Inspection Page', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  // Helper method to create text fields
  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  // Helper method to create sections with an expandable tile
  Widget _buildExpansionTile(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.headlineLarge),
        children: children,
      ),
    );
  }
}
