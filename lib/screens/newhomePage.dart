// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../model/lead.dart';

// class Homepage extends StatefulWidget {
//   @override
//   _HomepageState createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref('leads');
//   late Future<List<Lead>> _futureLeads;

//   @override
//   void initState() {
//     super.initState();
//     _futureLeads = _fetchLeads(); // Fetch leads initially
//   }

//   void _launchMap(String address) async {
//     if (address.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Address is empty')),
//       );
//       return;
//     }

//     final Uri url = Uri.parse(
//         'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');

//     try {
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not launch the map')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error launching map: $e')),
//       );
//     }
//   }

//   void _makeCall(String phoneNumber) async {
//     final Uri url = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch dialer')),
//       );
//     }
//   }

//   Widget _buildCarIcon(String? fuelType) {
//     switch (fuelType) {
//       case 'Petrol':
//         return Icon(Icons.local_gas_station, color: Colors.red);
//       case 'Diesel':
//         return Icon(Icons.local_gas_station, color: Colors.green);
//       case 'CNG':
//         return Icon(Icons.nature_people, color: Colors.orange);
//       default:
//         return Icon(Icons.error, color: Colors.grey);
//     }
//   }

//   Widget _buildTransmissionIcon(String? transmission) {
//     return Icon(
//       transmission == 'Automatic' ? Icons.autorenew : Icons.drive_eta,
//       color: Colors.blue,
//     );
//   }

//   Future<List<Lead>> _fetchLeads() async {
//     final dataSnapshot = await _database.once();
//     final data = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

//     List<Lead> leads = [];
//     if (data != null) {
//       List<Future<void>> futures = [];

//       for (var entry in data.entries) {
//         final leadData = Map<String, dynamic>.from(entry.value);
//         String customerId = leadData['customer_id'];
//         String carId = leadData['car_id'];

//         // Fetch customer and car data
//         futures.add(FirebaseDatabase.instance
//             .ref('customer/$customerId')
//             .once()
//             .then((customerSnapshot) {
//           final customerData = customerSnapshot.snapshot.value != null
//               ? Map<String, dynamic>.from(
//                   customerSnapshot.snapshot.value as Map)
//               : {};
//           return customerData;
//         }).then((customerData) {
//           return FirebaseDatabase.instance
//               .ref('cars/$carId')
//               .once()
//               .then((carSnapshot) {
//             final carData = carSnapshot.snapshot.value != null
//                 ? Map<String, dynamic>.from(carSnapshot.snapshot.value as Map)
//                 : {};
//             Lead lead = Lead.fromJson(leadData, customerData, carData);
//             // Filter leads with lead_rank as 'L3'
//             if (lead.leadRank == 'L3') {
//               leads.add(lead);
//             }
//           });
//         }));
//       }

//       // Wait for all futures to complete
//       await Future.wait(futures);
//     }

//     return leads;
//   }

//   void _refreshLeads() {
//     setState(() {
//       _futureLeads =
//           _fetchLeads(); // Refresh leads by calling the fetch function again
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Inspection'),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: _refreshLeads, // Refresh button
//             ),
//           ],
//         ),
//         body: FutureBuilder<List<Lead>>(
//           future: _futureLeads,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }

//             final leads = snapshot.data ?? [];

//             return Column(
//               children: [
//                 // Lead Count Section (below AppBar)
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Upcoming Leads: ${leads.length} of 7',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: leads.isEmpty
//                       ? const Center(child: Text('No upcoming leads'))
//                       : ListView.builder(
//                           itemCount: leads.length,
//                           itemBuilder: (context, index) {
//                             final lead = leads[index];
//                             return Card(
//                               margin: const EdgeInsets.all(8),
//                               elevation: 4,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Flexible(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 lead.customerName,
//                                                 style: const TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 16,
//                                                   color: Colors.black87,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 'Evaluation Time: ${lead.evaluationTime}',
//                                                 style: const TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.red),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.more_vert),
//                                           onPressed: () {
//                                             // Show options or menu
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'City: ${lead.customerCity}',
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 14),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Icon(Icons.directions_car,
//                                                 color: Colors.blue),
//                                             const SizedBox(width: 5),
//                                             Text(
//                                               'Car: ${lead.carModel} (${lead.carCompany})',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 5),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             _buildTransmissionIcon(
//                                                 lead.carTransmission),
//                                             const SizedBox(width: 5),
//                                             Text(
//                                               lead.carVariant,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 8),
//                                     GestureDetector(
//                                       onTap: () =>
//                                           _makeCall(lead.customerMobileNumber),
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.phone,
//                                               color: Colors.blue),
//                                           const SizedBox(width: 5),
//                                           Text(
//                                             lead.customerMobileNumber,
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.blueAccent,
//                                               decoration:
//                                                   TextDecoration.underline,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     GestureDetector(
//                                       onTap: () =>
//                                           _launchMap(lead.customerAddress),
//                                       child: const Text(
//                                         'View on Google Maps',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.blueAccent,
//                                           decoration: TextDecoration.underline,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Lead Type: ${lead.leadRank}',
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     const Divider(height: 20, thickness: 1),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         // Add your inspection logic here
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.blueAccent,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8, horizontal: 20),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         'Start Inspection',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
