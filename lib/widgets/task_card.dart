import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Map<String, String> task;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onSalespersonDetails;
  final VoidCallback onStartInspection;
  final bool isLoading;

  const TaskCard({
    required this.task,
    required this.onCall,
    required this.onWhatsApp,
    required this.onSalespersonDetails,
    required this.onStartInspection,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData getTransmissionIcon(String type) {
      return type == 'Automatic' ? Icons.directions_car : Icons.settings;
    }

    IconData getFuelIcon(String variant) {
      switch (variant) {
        case 'Petrol':
          return Icons.local_gas_station;
        case 'Diesel':
          return Icons.ev_station;
        case 'CNG':
          return Icons.nature;
        default:
          return Icons.error;
      }
    }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Location: ${task['location']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Car: ${task['car']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Model: ${task['model']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(getTransmissionIcon(task['transmission']!),
                        color: Colors.black87),
                    const SizedBox(width: 8.0),
                    Text(
                      task['transmission']!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(getFuelIcon(task['variant']!), color: Colors.black87),
                    const SizedBox(width: 8.0),
                    Text(
                      task['variant']!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onCall,
                      icon: const Icon(Icons.phone, color: Color(0xFF3498DB)),
                    ),
                    IconButton(
                      onPressed: onWhatsApp,
                      icon: const Icon(Icons.message, color: Color(0xFF25D366)),
                    ),
                    IconButton(
                      onPressed: onSalespersonDetails,
                      icon: const Icon(Icons.info, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : onStartInspection,
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text('Start Inspection'),
        ),
      ],
    );
  }
}
