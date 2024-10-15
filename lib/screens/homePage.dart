import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inspection/model/evaluator.dart';
import 'package:inspection/pages/carDetails.dart';
import 'package:inspection/pages/loginPage.dart';
import 'package:inspection/screens/profilePage.dart';
import 'package:inspection/screens/settingsPage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/new_lead.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('leads');
  late Future<List<Lead>> _futureLeads;
  Evaluator? evaluator;
  final User? user = FirebaseAuth.instance.currentUser;
  bool loadingEvaluatorData = false;

  // Get the logged-in user's email
  String? getCurrentUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  @override
  void initState() {
    super.initState();
    saveLeadsToFirebase();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await fetchEvaluatorByEmail();
      },
    );
    _futureLeads = fetchLeads();
  }

  // Fetch the evaluator details based on the logged-in email
  Future<void> fetchEvaluatorByEmail() async {
    setState(() {
      loadingEvaluatorData = true;
    });
    final databaseReference = FirebaseDatabase.instance.ref('evaluator');
    final snapshot = await databaseReference.once();
    if (snapshot.snapshot.value != null && snapshot.snapshot.value is Map) {
      final Map<Object?, Object?> evaluators =
          snapshot.snapshot.value as Map<Object?, Object?>;
      // Iterate through the evaluators to find a match by email
      for (var entry in evaluators.entries) {
        final Map<Object?, Object?> evaluatorData =
            entry.value as Map<Object?, Object?>;
        if (evaluatorData['evaluator_email'] == getCurrentUserEmail()) {
          // Convert Map<Object?, Object?> to Map<String, dynamic>
          Map<String, dynamic> evaluatorUserData = evaluatorData
              .map((key, value) => MapEntry(key.toString(), value));
          evaluator = Evaluator.fromJson(jsonEncode(evaluatorUserData));
        }
      }
      setState(() {
        loadingEvaluatorData = false;
      });
    }
    setState(() {
      loadingEvaluatorData = false;
    });
  }

  Future<void> _updateLeadStatus(String leadId, String newStatus) async {
    try {
      await _database.child(leadId).update({
        'lead_status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lead status updated to $newStatus')),
      );
      _refreshLeads(); // Refresh leads after status update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating lead status: $e'),
        ),
      );
    }
  }

  Future<void> _contactSalesperson(String salespersonId) async {
    // Example implementation: Open the phone dialer
    final Uri url = Uri(
        scheme: 'tel',
        path: 'salesperson_phone_number'); // Replace with actual logic
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch contact')),
      );
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

  Widget _buildCarIcon(String? fuelType) {
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

  Widget _buildTransmissionIcon(String? transmission) {
    return Icon(
      transmission == 'Automatic' ? Icons.autorenew : Icons.drive_eta,
      color: Colors.blue,
    );
  }

  Future<List<Lead>> fetchLeads() async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref('leads_data');
    final snapshot = await databaseRef.once();

    final leadsData = snapshot.snapshot.value as Map<dynamic, dynamic>;
    List<Lead> leads = [];

    leadsData.forEach((key, value) {
      leads.add(Lead.fromJson(Map<String, dynamic>.from(value)));
    });

    return leads;
  }

  Future<List<dynamic>> fetchLeadsData() async {
    final response =
        await http.get(Uri.parse('https://gowaggon.com/crm/api/leadlist'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data']; // Assuming 'data' is the key for your array
    } else {
      throw Exception('Failed to load leads data');
    }
  }

  Future<void> storeLeadsData(List<dynamic> leadsData) async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref('leads_data');

    for (var lead in leadsData) {
      String serialNumber = lead['serial_number'].toString();

      // Use null-aware operators or provide default values if null
      await databaseRef.child(serialNumber).set({
        'serial_number':
            lead['serial_number'] ?? '', // Provide default empty string if null
        'booking_date': lead['booking_date'] ?? '',
        'date': lead['date'] ?? '',
        'booking_slot': lead['booking_slot'] ?? '',
        'mobile_number': lead['mobile_number'] ?? '',
        'brand': lead['brand'] ?? '',
        'fuel_type': lead['fuel_type'] ?? '',
        'km': lead['km'] ?? '',
        'manf_year': lead['manf_year'] ?? '',
        'model': lead['model'] ?? '',
        'owner': lead['owner'] ?? '',
        'rto_loc': lead['rto_loc'] ?? '',
        'sell': lead['sell'] ?? '', // Assuming 'sell' can be nullable
        'transmission': lead['transmission'] ?? '',
        'variant': lead['variant'] ?? '',
        'address': lead['address'] ?? '',
        'landmark': lead['landmark'] ?? '',
        'pincode': lead['pincode'] ?? '',
        'state': lead['state'] ?? '',
        'user_city': lead['user_city'] ?? '',
        'car_price':
            lead['car_price'] ?? '', // Provide a default value for car_price
      });
    }
  }

  void saveLeadsToFirebase() async {
    try {
      List<dynamic> leadsData = await fetchLeadsData();
      await storeLeadsData(leadsData);
      print('Leads saved successfully!');
    } catch (e) {
      print('Failed to save leads: $e');
    }
  }

  Future<void> _refreshLeads() async {
    await fetchEvaluatorByEmail();
    setState(() {
      _futureLeads =
          fetchLeads(); // Refresh leads by calling the fetch function again
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inspection'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshLeads, // Refresh button
            ),
          ],
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width *
              0.75, // Set drawer width to 75% of screen width
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Gowaggon',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 20
                              : 24, // Adjust font size for smaller screens
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 16
                              : 18)), // Responsive font size
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 16
                              : 18)), // Responsive font size
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width < 600 ? 16 : 18),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: loadingEvaluatorData == true
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<List<Lead>>(
                future: _futureLeads,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final leads = snapshot.data ?? [];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Upcoming Leads: ${leads.length} of 7',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: leads.isEmpty
                            ? const Center(child: Text('No upcoming leads'))
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Evaluation Time: ${lead.bookingSlot}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon:
                                                    const Icon(Icons.more_vert),
                                                onPressed: () {
                                                  // Show options or menu
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'City: ${lead.userCity}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.directions_car,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Car: ${lead.model} (${lead.brand})',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  _buildTransmissionIcon(
                                                      lead.transmission),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    lead.variant,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () =>
                                                _makeCall(lead.mobileNumber),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.phone,
                                                    color: Colors.blue),
                                                const SizedBox(width: 5),
                                                Text(
                                                  lead.mobileNumber,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blueAccent,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () =>
                                                _launchMap(lead.address),
                                            child: const Text(
                                              'View on Google Maps',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueAccent,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Divider(
                                              height: 20, thickness: 1),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Navigate to the Inspection Page
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CarDetailsPage(
                                                          carDetails: lead,
                                                        )),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              'Start Inspection',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
