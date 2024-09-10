import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});
  @override
  _InspectionPageState createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  final ImagePicker _picker = ImagePicker();
  Map<String, File?> _images = {
    'Front': null,
    'Back': null,
    'Left Side': null,
    'Right Side': null,
  };
  File? _rcImage;
  bool _inspectionCanceled = false;
  bool _inspectionRescheduled = false;
  int _currentIndex = 0;
  String _transmission = 'Automatic';
  String _fuelType = 'Petrol';
  DateTime? _selectedDate;

  Future<void> _getImage(String side) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          if (side == 'RC') {
            _rcImage = File(pickedFile.path);
          } else {
            _images[side] = File(pickedFile.path);
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  bool _allImagesCaptured() {
    return !_inspectionCanceled &&
        !_inspectionRescheduled &&
        _images.values.every((image) => image != null);
  }

  bool _isPreviousImageCaptured(String currentKey) {
    List<String> keys = _images.keys.toList();
    int currentIndex = keys.indexOf(currentKey);
    if (currentIndex == 0) {
      return true;
    }
    String previousKey = keys[currentIndex - 1];
    return _images[previousKey] != null;
  }

  void _rescheduleInspection() {
    setState(() {
      _inspectionRescheduled = true;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inspection rescheduled'),
      ),
    );
  }

  void _cancelInspection() {
    setState(() {
      _inspectionCanceled = true;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspection cancelled')),
    );
  }

  Future<void> _saveCarDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'rcDetails', 'RC details here'); // Replace with actual RC details
    await prefs.setString('make', 'Make here'); // Replace with actual make
    await prefs.setString('model', 'Model here'); // Replace with actual model
    await prefs.setString(
        'variant', 'Variant here'); // Replace with actual variant
    if (_selectedDate != null) {
      await prefs.setString(
          'makeYearMonth', '${_selectedDate!.year}/${_selectedDate!.month}');
    }
    await prefs.setString('transmission', _transmission);
    await prefs.setString('fuelType', _fuelType);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Car details saved')),
    );
  }

  Widget _buildCarDetailsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Car Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _getImage('RC'),
            child: _rcImage == null
                ? Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 50, color: Colors.grey),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_rcImage!),
                  ),
          ),
          const SizedBox(height: 20),
          _buildTextField('RC Details', Icons.article),
          const SizedBox(height: 20),
          _buildTextField('Make', Icons.business),
          const SizedBox(height: 20),
          _buildTextField('Model', Icons.directions_car),
          const SizedBox(height: 20),
          _buildTextField('Variant', Icons.build),
          const SizedBox(height: 20),
          const Text(
            'Make Year/Month',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                setState(() {
                  _selectedDate = selectedDate;
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: _selectedDate == null
                      ? 'Select date'
                      : '${_selectedDate!.year}/${_selectedDate!.month}',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Transmission',
            style: TextStyle(fontSize: 18),
          ),
          DropdownButton<String>(
            value: _transmission,
            icon: const Icon(Icons.settings_input_component),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _transmission = newValue!;
              });
            },
            items: <String>['Automatic', 'Manual']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fuel Type',
            style: TextStyle(fontSize: 18),
          ),
          DropdownButton<String>(
            value: _fuelType,
            icon: const Icon(Icons.local_gas_station),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _fuelType = newValue!;
              });
            },
            items: <String>['Petrol', 'Diesel', 'CNG']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveCarDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: const Text(
              'Save Car Details',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to build text fields with icons
  Widget _buildTextField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Build the "Inspection" page
  Widget _buildInspectionPage() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: _images.keys.map((side) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$side View',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4568DC),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _images[side] == null
                          ? GestureDetector(
                              onTap: () {
                                if (_isPreviousImageCaptured(side)) {
                                  _getImage(side);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Capture previous images first'),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_images[side]!),
                            ),
                      const SizedBox(height: 8),
                      if (_images.values.every((image) => image != null))
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_allImagesCaptured()) {
                                setState(() {
                                  _inspectionCanceled = false;
                                  _inspectionRescheduled = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InspectionConfirmationPage(
                                      rcImage: _rcImage,
                                      images: _images,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _rescheduleInspection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Reschedule'),
              ),
              ElevatedButton(
                onPressed: _cancelInspection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inspection Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Car Details'),
              Tab(text: 'Inspection'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCarDetailsPage(),
            _buildInspectionPage(),
          ],
        ),
      ),
    );
  }
}

class InspectionConfirmationPage extends StatelessWidget {
  final File? rcImage;
  final Map<String, File?> images;

  const InspectionConfirmationPage({
    Key? key,
    required this.rcImage,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Confirmation'),
      ),
      body: Center(
        child: Text('Inspection confirmed!'),
      ),
    );
  }
}
