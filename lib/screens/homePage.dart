import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../widgets/task_card.dart';

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
      'model': 'Sedan',
      'transmission': 'Automatic',
      'variant': 'Petrol',
      'salespersonName': 'Alice Johnson',
      'salespersonContact': '+1122334455',
      'evaluationTime': '12:00 PM',
    },
    {
      'name': 'Jane Smith',
      'mobile': '+0987654321',
      'location': 'Los Angeles',
      'car': 'XYZ789',
      'model': 'SUV',
      'transmission': 'Manual',
      'variant': 'Diesel',
      'salespersonName': 'Bob Brown',
      'salespersonContact': '+9988776655',
      'evaluationTime': '1:30 PM',
    },
  ];

  late List<bool> isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = List<bool>.filled(tasks.length, false);
  }

  void _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await canLaunchUrl(phoneUri);
    } else {
      // Handle the error or notify the user
      print('Could not make the call');
    }
  }

  void _sendWhatsAppMessage(String phoneNumber) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': phoneNumber,
      },
    );
    if (await canLaunchUrl(whatsappUri)) {
      await canLaunchUrl(whatsappUri);
    } else {
      // Handle the error or notify the user
      print('Could not send WhatsApp message');
    }
  }

  void _showSalespersonDetails(String name, String contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Salesperson: $name'),
          content: Text('Contact: $contact'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _startInspection(int index) async {
    setState(() {
      isLoading[index] = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading delay
    setState(() {
      isLoading[index] = false;
      completedTasksCount++;
      tasks.removeAt(index); // Remove the completed task
    });
    Navigator.pushNamed(
        context, '/inspection'); // Navigate to the inspection page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Tasks'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '$completedTasksCount/$totalTasks completed',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text('No tasks available'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onCall: () => _makeCall(task['mobile']!),
                  onWhatsApp: () => _sendWhatsAppMessage(task['mobile']!),
                  onSalespersonDetails: () => _showSalespersonDetails(
                      task['salespersonName']!, task['salespersonContact']!),
                  onStartInspection: () => _startInspection(index),
                  isLoading: isLoading[index],
                );
              },
            ),
    );
  }
}
