import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inspection/model/car_doc.dart';
import 'package:inspection/model/evaluator.dart';
import 'package:inspection/pages/newCarDetails.dart';
import 'package:inspection/pages/loginPage.dart';
import 'package:inspection/screens/profilePage.dart';
import 'package:inspection/screens/settingsPage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/new_lead.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? evaluatorId;
  // final DatabaseReference _database = FirebaseDatabase.instance.ref('leads');
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

  Future<User?> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  Future<String?> getEvaluatorIdFromUser(User user) async {
    final DatabaseReference evaluatorRef =
        FirebaseDatabase.instance.ref('evaluator');
    final snapshot = await evaluatorRef.once();
    // Check if the snapshot contains any data
    if (snapshot.snapshot.value == null) {
      print("No evaluator data found");
      return null;
    }
    final evaluatorsData = snapshot.snapshot.value as Map<dynamic, dynamic>;
    // Loop through evaluators to find the one that matches the current user's email or uid
    evaluatorsData.forEach((key, value) {
      Map<String, dynamic> evaluator = Map<String, dynamic>.from(value);
      if (evaluator['evaluator_email'] == user.email) {
        evaluatorId = evaluator['evaluator_id'];
      }
    });
    return evaluatorId;
  }

  Future<Map<String, dynamic>?> fetchEvaluatorData(String evaluatorId) async {
    DatabaseReference evaluatorRef =
        FirebaseDatabase.instance.ref('evaluator/$evaluatorId');
    final evaluatorSnapshot = await evaluatorRef.once();
    if (evaluatorSnapshot.snapshot.value == null) {
      print('Evaluator data not found for ID:$evaluatorId');
      return null;
    }
    final evaluatorData = evaluatorSnapshot.snapshot.value;
    if (evaluatorData is Map) {
      return Map<String, dynamic>.from(evaluatorData);
    } else {
      print("Unexpected data structure for evaluation");
      return null;
    }
  }

  //
  Future<List<Lead>> fetchLeads() async {
    // Get the currently logged-in user
    User? user = await getCurrentUser();
    if (user == null) {
      print("No user logged in");
      return [];
    }

    // Get the evaluator ID using the logged-in user's details
    String? evaluatorId = await getEvaluatorIdFromUser(user);
    if (evaluatorId == null) {
      print("Evaluator ID not found for the logged-in user");
      return [];
    }

    // Fetch the evaluator's data
    final DatabaseReference evaluatorRef =
        FirebaseDatabase.instance.ref('evaluator/$evaluatorId');
    final evaluatorSnapshot = await evaluatorRef.once();
    if (evaluatorSnapshot.snapshot.value == null) {
      print("Evaluator data not found");
      return [];
    }

    // Safely check if evaluator data is a Map and extract evaluator locations
    final evaluatorData = evaluatorSnapshot.snapshot.value;
    if (!(evaluatorData is Map &&
        evaluatorData['evaluator_location'] is List)) {
      print("Unexpected data structure for evaluator data");
      return [];
    }

    List<dynamic> evaluatorLocations = evaluatorData['evaluator_location'];

    // Get today's date in the correct format
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Fetch leads data from Firebase
    final DatabaseReference leadsRef =
        FirebaseDatabase.instance.ref('leads_data');
    final leadsSnapshot = await leadsRef.once();
    if (leadsSnapshot.snapshot.value == null) {
      print("No leads data found");
      return [];
    }

    List<Lead> leads = [];

    // Process the leads data (could be Map or List)
    final leadsData = leadsSnapshot.snapshot.value;
    if (leadsData is Map) {
      // If leads data is a Map
      leadsData.forEach((key, value) {
        if (value is Map) {
          Lead lead = Lead.fromJson(Map<String, dynamic>.from(value));
          if (_isLeadValid(lead, evaluatorLocations, todayDate)) {
            leads.add(lead);
          }
        }
      });
    } else if (leadsData is List) {
      // If leads data is a List
      for (var leadData in leadsData) {
        if (leadData is Map) {
          Lead lead = Lead.fromJson(Map<String, dynamic>.from(leadData));
          if (_isLeadValid(lead, evaluatorLocations, todayDate)) {
            leads.add(lead);
          }
        }
      }
    } else {
      print("Unexpected data structure for leads data");
    }

    return leads;
  }

// Helper function to validate a lead
  bool _isLeadValid(
      Lead lead, List<dynamic> evaluatorLocations, String todayDate) {
    return evaluatorLocations.contains(lead.userCity.trim()) &&
        lead.bookingDate == todayDate &&
        lead.leadStatus == 1;
  }

  Future<List<dynamic>> fetchLeadsData() async {
    final response =
        await http.get(Uri.parse('https://gowaggon.com/crm/api/leadlist'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load leads data');
    }
  }

  void _rescheduleAction() {
    // Your logic for rescheduling, e.g., show a date picker
    print("Reschedule clicked");
  }

  void _cancelAction() {
    // Your logic for canceling, e.g., remove the item from the list
    print("Cancel clicked");
  }

  Future<void> storeLeadsData(List<dynamic> leadsData) async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref('leads_data');
    // Iterate through each lead in the provided leadsData
    for (var lead in leadsData) {
      // Check if 'serial_number' exists and is not null
      if (lead['serial_number'] != null) {
        try {
          // Convert serial number to string
          String serialNumber = lead['serial_number'].toString();
          // Use null-aware operators to provide default values if any field is null
          await databaseRef.child(serialNumber).set({
            'serial_number': lead['serial_number'] ?? '',
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
            'sell': lead['sell'] ?? '',
            'transmission': lead['transmission'] ?? '',
            'variant': lead['variant'] ?? '',
            'address': lead['address'] ?? '',
            'landmark': lead['landmark'] ?? '',
            'pincode': lead['pincode'] ?? '',
            'state': lead['state'] ?? '',
            'user_city': lead['user_city'] ?? '',
            'car_price': lead['car_price'] ?? '',
            'leadStatus': lead['leadStatus'],
          });
          print("Lead $serialNumber saved successfully.");
        } catch (e) {
          // Handle any errors that occur during the write operation
          print("Error saving lead ${lead['serial_number']}: $e");
        }
      } else {
        print("Lead does not have a valid serial_number: $lead");
      }
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
    try {
      // Step 2: Fetch new leads from the API
      await fetchEvaluatorByEmail();
      // Step 3: Update the UI by fetching the updated leads data from Firebase
      setState(() {
        _futureLeads = fetchLeads();
      });

      // Optional: Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Leads refreshed successfully."),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      // Handle errors if any
      print("Failed to refresh leads: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to refresh leads: $error"),
        backgroundColor: Colors.red,
      ));
    }
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
              onPressed: _refreshLeads,
            ),
          ],
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.75,
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
                          fontSize:
                              MediaQuery.of(context).size.width < 600 ? 20 : 24,
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
                              : 18)),
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
                                              PopupMenuButton<String>(
                                                icon:
                                                    const Icon(Icons.more_vert),
                                                onSelected: (String result) {
                                                  switch (result) {
                                                    case 'Reschedule':
                                                      _rescheduleAction(); // Call your reschedule function
                                                      break;
                                                    case 'Cancel':
                                                      _cancelAction(); // Call your cancel function
                                                      break;
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String>>[
                                                  const PopupMenuItem<String>(
                                                    value: 'Reschedule',
                                                    child: Text('Reschedule'),
                                                  ),
                                                  const PopupMenuItem<String>(
                                                    value: 'Cancel',
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              )
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
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // Aligns text to the left
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
                                              const SizedBox(height: 5),
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
                                                      fontSize: 11,
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
                                                  ),
                                                ),
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
