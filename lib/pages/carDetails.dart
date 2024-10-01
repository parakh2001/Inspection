import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('inspections');

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

  final _formKey = GlobalKey<FormState>();

  Widget _buildCarDetailsPage() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Car Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
            _buildTextField('RC Details', Icons.article, true),
            _buildTextField('Make', Icons.business, true),
            _buildTextField('Model', Icons.directions_car, true),
            _buildTextField('Variant', Icons.build, false),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // _saveCarDetailsToFirebase();
                }
              },
              child: const Text('Save Car Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, bool isRequired) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

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
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ElevatedButton(
          onPressed: _allImagesCaptured()
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inspection completed')),
                  );
                }
              : null,
          child: const Text('Complete Inspection'),
        ),
        ElevatedButton(
          onPressed: _cancelInspection,
          child: const Text('Cancel Inspection'),
        ),
        ElevatedButton(
          onPressed: _rescheduleInspection,
          child: const Text('Reschedule Inspection'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Page'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildCarDetailsPage(),
          _buildInspectionPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Car Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: 'Inspection Page',
          ),
        ],
      ),
    );
  }
}
