import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class NewInspectionPage extends StatefulWidget {
  final String serialNumber;

  NewInspectionPage({required this.serialNumber});

  @override
  _NewInspectionPageState createState() => _NewInspectionPageState();
}

class _NewInspectionPageState extends State<NewInspectionPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _commentsController = TextEditingController();
  List<File> _interiorImages = [];
  bool _isUploading = false;

  // Firebase Database reference
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('inspection');

  // Firebase Storage reference
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to pick images from the camera
  Future<void> _pickImage() async {
    if (_interiorImages.length < 15) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _interiorImages.add(File(image.path));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum 15 images allowed")),
      );
    }
  }

  // Function to upload images and save comments to Firebase
  Future<void> _saveInspectionData() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Save comments to Firebase Realtime Database
      final String comment = _commentsController.text;
      await _databaseReference
          .child(
              'inspection/${widget.serialNumber}/car_health/interior/comments')
          .set(comment);

      // Upload each image to Firebase Storage
      for (int i = 0; i < _interiorImages.length; i++) {
        File image = _interiorImages[i];
        String imageRef =
            'inspection/${widget.serialNumber}/car_health/interior/interior_image_$i.jpg';

        // Upload image to Firebase Storage
        await _storage.ref(imageRef).putFile(image);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inspection data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving inspection data: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Interior Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interior Section - Capture up to 15 Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _interiorImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _interiorImages.length &&
                      _interiorImages.length < 15) {
                    return GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(child: Text("Add Image")),
                      ),
                    );
                  } else if (index < _interiorImages.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_interiorImages[index]),
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
              controller: _commentsController,
              decoration: InputDecoration(
                labelText: "Write Comments",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
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
}
