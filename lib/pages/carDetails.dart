import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inspection/pages/inspectionPage.dart';
class CarInspectionApp extends StatefulWidget {
  final Map<String, String> task;
  const CarInspectionApp({super.key, required this.task});
  @override
  _CarInspectionAppState createState() => _CarInspectionAppState();
}
class _CarInspectionAppState extends State<CarInspectionApp> {
  int _selectedIndex = 0;
  DateTime? _selectedDate;
  String? _selectedMakeYear;
  final _rcController = TextEditingController();
  final List<String> _makeYears = [
    '2022/Jan',
    '2022/Feb',
    '2022/Mar',
    '2021/Dec',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget _buildCarDetailsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Car Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _rcController..text = widget.task['car']!,
            decoration: const InputDecoration(labelText: 'RC Details'),
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: _selectedMakeYear,
            items: _makeYears.map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text(year),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedMakeYear = newValue;
              });
            },
            hint: const Text('Select Make Year/Month'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : DateFormat.yMd().format(_selectedDate!),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _presentDatePicker,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionPage() {
    return const InspectionPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Inspection'),
      ),
      body:
          _selectedIndex == 0 ? _buildCarDetailsPage() : _buildInspectionPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Car Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Inspection Page',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
