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

  void _launchMap(String address) async {
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address is empty')),
      );
      return;
    }

    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch the map')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching map: $e')),
      );
    }
  }

  void _makeCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
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
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Customer Info + 3-dot menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lead.customerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Evaluation Time: ${lead.evaluationTime}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                // Show options or menu
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Customer City: ${lead.customerCity}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),

                        // Car Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildCarIcon(lead.carFuelType),
                                const SizedBox(width: 5),
                                Text(
                                  'Car: ${lead.carModel} (${lead.carCompany})',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildTransmissionIcon(lead.carTransmission),
                                const SizedBox(width: 5),
                                Text(
                                  lead.carVariant,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Address and Contact
                        GestureDetector(
                          onTap: () => _makeCall(lead.customerMobileNumber),
                          child: Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.blue),
                              const SizedBox(width: 5),
                              Text(
                                lead.customerMobileNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _launchMap(lead.customerAddress),
                          child: const Text(
                            'View on Google Maps',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Divider(height: 20, thickness: 1),
                        // Start Inspection Button
                        ElevatedButton(
                          onPressed: () {
                            // Add your inspection logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Start Inspection',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
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
