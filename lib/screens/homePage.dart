import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inspection/model/evaluator.dart';
import 'package:inspection/model/leadNew.dart';
import 'package:inspection/pages/carDetails.dart';
import 'package:inspection/pages/loginPage.dart';
import 'package:inspection/screens/profilePage.dart';
import 'package:inspection/screens/settingsPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// import '../model/lead.dart';
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

  late Future<List<Lead>> futureLeads;

  // Get the logged-in user's email
  String? getCurrentUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<List<Lead>> fetchLeads() async {
    final response = await http.get(
      Uri.parse('https://gowaggon.com/crm/api/leadlist'),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> leadList = data['data'];

      // Get today's date in YYYY-MM-DD format
      String todayDate = DateTime.now().toIso8601String().split('T')[0];

      // Filter leads where booking_date is equal to today
      final List<Lead> todayLeads = leadList
          .where((lead) => lead['booking_date'] == todayDate)
          .map((lead) => Lead.fromJson(lead))
          .toList();

      return todayLeads; // Return filtered list
    } else {
      throw Exception('Failed to load leads');
    }
  }

  @override
  void initState() {
    super.initState();
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
        SnackBar(content: Text('Error updating lead status: $e')),
      );
    }
  }

  Future<void> _contactSalesperson(String salespersonId) async {
    // Example implementation: Open the phone dialer
    final Uri url = Uri(scheme: 'tel', path: 'salesperson_phone_number');
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

  Widget _buildTransmissionIcon(String? transmission) {
    return Icon(
      transmission == 'Automatic' ? Icons.autorenew : Icons.drive_eta,
      color: Colors.blue,
    );
  }

  // Future<List<Lead>> _fetchLeads() async {
  //   try {
  //     final dataSnapshot = await _database.once();
  //     final data = dataSnapshot.snapshot.value;
  //     List<Lead> leads = [];
  //     if (data != null) {
  //       List<Future<void>> futures = [];
  //       // Handle map or list cases separately
  //       if (data is Map<dynamic, dynamic>) {
  //         for (var entry in data.entries) {
  //           final leadData = Map<String, dynamic>.from(entry.value);
  //           String customerId = leadData['customer_id'].toString();
  //           String carId = leadData['car_id'].toString();
  //           futures.add(
  //             FirebaseDatabase.instance
  //                 .ref('customer/$customerId')
  //                 .once()
  //                 .then((customerSnapshot) {
  //               final customerData = customerSnapshot.snapshot.value != null
  //                   ? Map<String, dynamic>.from(
  //                       customerSnapshot.snapshot.value as Map)
  //                   : {};
  //               return customerData;
  //             }).then((customerData) {
  //               return FirebaseDatabase.instance
  //                   .ref('cars/$carId')
  //                   .once()
  //                   .then((carSnapshot) {
  //                 final carData = carSnapshot.snapshot.value != null
  //                     ? Map<String, dynamic>.from(
  //                         carSnapshot.snapshot.value as Map)
  //                     : {};
  //
  //                 // Create a Lead instance
  //                 Lead lead = Lead.fromJson(leadData, customerData, carData);
  //
  //                 // Check if lead is L3
  //                 if (lead.leadRank == 'L3') {
  //                   String evaluationDate = lead.evaluationDate.toString();
  //                   DateTime today = DateTime.now();
  //                   String todayDate = today.toString();
  //
  //                   // Check if the evaluation date is today
  //                   if (evaluationDate != todayDate) {
  //                     if (evaluator?.evaluatorLocation
  //                             ?.contains(lead.customerCity) ??
  //                         false) {
  //                       print(evaluationDate);
  //                       leads.add(lead);
  //                     }
  //                   }
  //                 }
  //               });
  //             }),
  //           );
  //         }
  //       } else if (data is List) {
  //         for (var leadItem in data) {
  //           if (leadItem is Map) {
  //             final leadData = Map<String, dynamic>.from(leadItem);
  //             String customerId = leadData['customer_id'].toString();
  //             String carId = leadData['car_id'].toString();
  //
  //             futures.add(
  //               FirebaseDatabase.instance
  //                   .ref('customer/$customerId')
  //                   .once()
  //                   .then((customerSnapshot) {
  //                 final customerData = customerSnapshot.snapshot.value != null
  //                     ? Map<String, dynamic>.from(
  //                         customerSnapshot.snapshot.value as Map)
  //                     : {};
  //                 return customerData;
  //               }).then((customerData) {
  //                 return FirebaseDatabase.instance
  //                     .ref('cars/$carId')
  //                     .once()
  //                     .then((carSnapshot) {
  //                   final carData = carSnapshot.snapshot.value != null
  //                       ? Map<String, dynamic>.from(
  //                           carSnapshot.snapshot.value as Map)
  //                       : {};
  //
  //                   // Create a Lead instance
  //                   Lead lead = Lead.fromJson(leadData, customerData, carData);
  //
  //                   // Check if lead is L3
  //                   if (lead.leadRank == 'L3') {
  //                     DateTime? evaluationDate = lead.evaluationDate;
  //                     DateTime today = DateTime.now();
  //
  //                     // Check if the evaluation date is today
  //                     if (evaluationDate != null &&
  //                         evaluationDate.year == today.year &&
  //                         evaluationDate.month == today.month &&
  //                         evaluationDate.day == today.day) {
  //                       if (evaluator?.evaluatorLocation
  //                               ?.contains(lead.customerCity) ??
  //                           false) {
  //                         leads.add(lead);
  //                       }
  //                     }
  //                   }
  //                 });
  //               }),
  //             );
  //           }
  //         }
  //       }
  //
  //       // Wait for all futures to complete
  //       await Future.wait(futures);
  //     }
  //     return leads;
  //   } catch (e, stackTrace) {
  //     debugPrint('Error fetching leads: $e');
  //     debugPrint('Stack trace: $stackTrace');
  //     rethrow;
  //   }
  // }

  // Future<List<Lead>> fetchLeads() async {
  //   final response = await http.get(
  //     Uri.parse('https://gowaggon.com/crm/api/leadlist'),
  //   );
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     final List<dynamic> leadList = data['data'];

  //     return leadList.map((lead) => Lead.fromJson(lead)).toList();
  //   } else {
  //     throw Exception('Failed to load leads');
  //   }
  // }

  Future<void> _refreshLeads() async {
    await fetchEvaluatorByEmail();
    setState(() {
      _futureLeads = fetchLeads();
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
              onPressed: _refreshLeads,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  children: [
                    Icon(Icons.directions_car, size: 50, color: Colors.white),
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
                title: Text('Profile', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings', style: TextStyle(fontSize: 16)),
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
                title: Text('Logout', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
        ),
        body: loadingEvaluatorData
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
                                                      lead.bookingDate,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Evaluation Time: ${lead.bookingTime}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                icon:
                                                    const Icon(Icons.more_vert),
                                                onSelected: (String value) {
                                                  // Handle the selected option here
                                                  if (value == 'reschedule') {
                                                    // Add your reschedule logic here
                                                    print('Reschedule tapped');
                                                  } else if (value ==
                                                      'cancel') {
                                                    // Add your cancel logic here
                                                    print('Cancel tapped');
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    PopupMenuItem<String>(
                                                      value: 'reschedule',
                                                      child: Text('Reschedule'),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      value: 'cancel',
                                                      child: Text('Cancel'),
                                                    ),
                                                  ];
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
                                                        fontSize: 14),
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
                                                        fontSize: 14),
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
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => CarDetailsPage(carDetails: lead.serialNumber),
                                              //   ),
                                              // );
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
