import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/lead.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('leads');
  List<Lead> leads = [];

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  Future<Map<dynamic, dynamic>> fetchCustomerData(String customerId) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    final DataSnapshot snapshot = await ref.child('customer/$customerId').get();
    if (snapshot.exists) {
      return snapshot.value as Map<dynamic, dynamic>;
    } else {
      print('No customer data found for $customerId');
      return {};
    }
  }

  Future<void> _fetchLeads() async {
    final snapshot = await _database.once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      List<Lead> fetchedLeads = [];
      for (var entry in data.entries) {
        final leadData = Map<String, dynamic>.from(entry.value);
        String customerId = leadData['customer_id'];
        final customerSnapshot =
            await FirebaseDatabase.instance.ref('customer/$customerId').once();
        final customerData = customerSnapshot.snapshot.value != null
            ? Map<String, dynamic>.from(customerSnapshot.snapshot.value as Map)
            : {};
        String carId = leadData['car_id'];
        final carSnapshot =
            await FirebaseDatabase.instance.ref('cars/$carId').once();
        final carData = carSnapshot.snapshot.value != null
            ? Map<String, dynamic>.from(carSnapshot.snapshot.value as Map)
            : {};
        fetchedLeads.add(Lead.fromJson(leadData, customerData, carData));
      }
      setState(() {
        leads = fetchedLeads;
      });
    }
  }

  void _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchMap(String address) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCarIcon(String fuelType) {
    switch (fuelType) {
      case 'Petrol':
        return Icon(Icons.local_gas_station, color: Colors.red);
      case 'Diesel':
        return Icon(Icons.local_gas_station, color: Colors.green);
      case 'CNG':
        return Icon(Icons.nature_people, color: Colors.orange);
      default:
        return Icon(Icons.error, color: Colors.grey);
    }
  }

  Widget _buildTransmissionIcon(String transmission) {
    return Icon(transmission == 'Automatic' ? Icons.autorenew : Icons.drive_eta,
        color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: leads.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Customer Name:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                    '${lead.customerName}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Evaluation Time: ${lead.evaluationTime}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Customer City: ${lead.customerCity}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          'Customer Address: ${lead.customerAddress}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.blue),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () =>
                                  _launchCaller(lead.customerMobileNumber),
                              child: Text(
                                '${lead.customerMobileNumber}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _launchMap(lead.customerAddress),
                          child: const Text(
                            'View on Google Maps',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const Divider(
                            height: 30, thickness: 1, color: Colors.grey),
                        Text(
                          'Car Details:',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            _buildCarIcon(lead.carFuelType),
                            const SizedBox(width: 10),
                            Text(
                              'Car Number: ${lead.carNumber}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildTransmissionIcon(lead.carTransmission),
                            const SizedBox(width: 10),
                            Text(
                              'Car Model: ${lead.carModel}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            // Add your inspection logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Start Inspection',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
