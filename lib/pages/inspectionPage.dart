import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
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
  bool _inspectionCanceled = false;
  bool _inspectionRescheduled = false;
  Future<void> _getImage(String side) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _images[side] = File(pickedFile.path);
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
    Navigator.pop(context); // Navigate back to the homepage
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Inspection'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF485563), Color(0xFF29323C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  onPressed: _isPreviousImageCaptured(side)
                                      ? () => _getImage(side)
                                      : null,
                                  child: Text(
                                    'Capture $side Image',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(_images[side]!),
                                ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _rescheduleInspection,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Reschedule',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _cancelInspection,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _allImagesCaptured()
                  ? () {
                      Navigator.pushNamed(context, '/finalverdict');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _allImagesCaptured()
                    ? const Color(0xFF7B42F6)
                    : Colors.grey,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text(
                'Final Verdict',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}