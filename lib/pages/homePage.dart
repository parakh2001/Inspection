import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final int totalTasks = 7;
  int completedTasksCount = 0;
  final List<Map<String, String>> tasks = [
    {
      'name': 'John Doe',
      'mobile': '+1234567890',
      'location': 'New York',
      'car': 'ABC123',
      'salespersonName': 'Alice Johnson',
      'salespersonContact': '+1122334455',
      'evaluationTime': '12:00 PM',
    },
    {
      'name': 'Jane Smith',
      'mobile': '+0987654321',
      'location': 'Los Angeles',
      'car': 'XYZ789',
      'salespersonName': 'Bob Brown',
      'salespersonContact': '+9988776655',
      'evaluationTime': '1:30 PM',
    },
    // Add more tasks here if needed
  ];
  late List<bool> isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = List<bool>.filled(tasks.length, false);
  }

  void _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to make call')),
      );
    }
  }

  void _sendWhatsAppMessage(String phoneNumber) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {'phone': phoneNumber},
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to send WhatsApp message')),
      );
    }
  }

  void _startInspection(int index) async {
    setState(() {
      isLoading[index] = true;
    });

    // Simulate a delay for the loading process (replace with actual logic)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading[index] = false;
      completedTasksCount++;
      tasks.removeAt(index);
    });
    Navigator.pushNamed(context, '/inspection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upcoming Tasks (${tasks.length})',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF485563), Color(0xFF29323C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF485563), Color(0xFF29323C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: completedTasksCount / totalTasks,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
              const SizedBox(height: 8.0),
              Text(
                '$completedTasksCount of $totalTasks tasks completed',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          color: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Client: ${task['name']}',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      task['evaluationTime']!,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${task['mobile']}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Location: ${task['location']}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Car Number: ${task['car']}',
                                  style: const TextStyle(
                                    fontSize: 18.0, // Increased font size
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.phone,
                                          color: Colors.green),
                                      onPressed: () =>
                                          _makeCall(task['mobile']!),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.message,
                                          color: Colors.green),
                                      onPressed: () =>
                                          _sendWhatsAppMessage(task['mobile']!),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.location_on,
                                          color: Colors.blue),
                                      onPressed: () async {
                                        final Uri locationUri = Uri(
                                          scheme: 'geo',
                                          path: '0,0',
                                          queryParameters: {
                                            'q': task['location']
                                          },
                                        );
                                        if (await canLaunchUrl(locationUri)) {
                                          await launchUrl(locationUri);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Unable to view location'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.person,
                                          color: Colors
                                              .orange), // Salesperson icon
                                      onPressed: () {
                                        final salespersonName =
                                            task['salespersonName'] ??
                                                'Unknown';
                                        final salespersonContact =
                                            task['salespersonContact'] ??
                                                'Unknown';
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Salesperson: $salespersonName'),
                                              content: Text(
                                                  'Contact: $salespersonContact'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading[index]
                                        ? null
                                        : () => _startInspection(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB06AB3),
                                    ),
                                    child: isLoading[index]
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        : const Text('Start Inspection'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
