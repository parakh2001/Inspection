// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';
// import '../widgets/task_card.dart';
// import 'package:firebase_database/firebase_database.dart';
// class Homepage extends StatefulWidget {
//   const Homepage({super.key});
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
// class _HomepageState extends State<Homepage> {
//   final DatabaseReference _leadsRef = FirebaseDatabase.instance.ref('leads');
//   List<Map<String, dynamic>> leads = [];
//   late List<bool> isLoading;
//   int completedTasksCount = 0;
//   @override
//   void initState() {
//     super.initState();
//     isLoading = List<bool>.filled(0, false);
//     _fetchLeadsWithRankL3();
//   }
//   void _fetchLeadsWithRankL3() async {
//     setState(() {
//       isLoading = List<bool>.filled(1, true);
//     });
//     DataSnapshot snapshot = await _leadsRef.get();
//     if (snapshot.exists) {
//       Map<String, dynamic> leadsData = snapshot.value as Map<String, dynamic>;
//       List<Map<String, dynamic>> leadsWithL3 = [];
//       leadsData.forEach((key, value) {
//         if (value['lead_rank'] == 'L3') {
//           leadsWithL3.add({
//             'key': key,
//             'car_id': value['car_id'],
//             'customer_id': value['customer_id'],
//             ...value,
//           });
//         }
//       });
//       setState(() {
//         leads = leadsWithL3;
//         isLoading = List<bool>.filled(leads.length, false);
//       });
//     } else {
//       print('No leads found');
//       setState(() {
//         leads = [];
//         isLoading = [];
//       });
//     }
//   }
//   void _makeCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       print('Could not make the call');
//     }
//   }

//   void _sendWhatsAppMessage(String phoneNumber) async {
//     final Uri whatsappUri = Uri(
//       scheme: 'https',
//       host: 'api.whatsapp.com',
//       path: 'send',
//       queryParameters: {
//         'phone': phoneNumber,
//       },
//     );
//     if (await canLaunchUrl(whatsappUri)) {
//       await launchUrl(whatsappUri);
//     } else {
//       print('Could not send WhatsApp message');
//     }
//   }

//   void _showSalespersonDetails(String name, String contact) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Salesperson: $name'),
//           content: Text('Contact: $contact'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _startInspection(int index) async {
//     setState(() {
//       isLoading[index] = true;
//     });

//     String leadId = leads[index]['key'];
//     DataSnapshot snapshot = await _leadsRef.child(leadId).get();
//     if (snapshot.exists) {
//       Map<String, dynamic> leadDetails = snapshot.value as Map<String, dynamic>;
//       if (leadDetails['lead_rank'] == 'L3') {
//         Navigator.pushNamed(
//           context,
//           '/inspection',
//           arguments: leadDetails,
//         );
//         setState(() {
//           completedTasksCount++;
//           leads.removeAt(index);
//         });
//       } else {
//         print('Lead rank is not L3');
//       }
//     } else {
//       print('Lead not found');
//     }

//     setState(() {
//       isLoading[index] = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upcoming Tasks'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF4568DC), Color(0xFFB06AB3)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30.0),
//                   bottomRight: Radius.circular(30.0),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.drive_eta,
//                     size: 48,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(width: 16.0),
//                   Expanded(
//                     child: Text(
//                       'Gowaggon',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/settings');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, '/login', (route) => false);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: leads.isEmpty
//           ? const Center(
//               child: Text('No tasks available'),
//             )
//           : ListView.builder(
//               itemCount: leads.length,
//               itemBuilder: (context, index) {
//                 final lead = leads[index];
//                 return TaskCard(
//                   task: {
//                     'key': lead['key'], // Lead ID
//                     'car_id': lead['car_id'], // Car ID
//                     'customer_id': lead['customer_id'], // Customer ID
//                     // add more fields if needed
//                   },
//                   onCall: () => _makeCall(lead['mobile'] ?? ''),
//                   onWhatsApp: () => _sendWhatsAppMessage(lead['mobile'] ?? ''),
//                   onSalespersonDetails: () => _showSalespersonDetails(
//                     lead['salespersonName'] ?? '',
//                     lead['salespersonContact'] ?? '',
//                   ),
//                   onStartInspection: () => _startInspection(index),
//                   isLoading: isLoading[index],
//                 );
//               },
//             ),
//     );
//   }
// }