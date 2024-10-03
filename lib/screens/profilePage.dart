import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Get the logged-in user's email
  String? getCurrentUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  // Fetch the evaluator details based on the logged-in email
  Future<Map<String, dynamic>> fetchEvaluatorByEmail(String email) async {
    final databaseReference = FirebaseDatabase.instance.ref('evaluator');
    final snapshot = await databaseReference.once();

    if (snapshot.snapshot.value != null && snapshot.snapshot.value is Map) {
      final Map<Object?, Object?> evaluators =
          snapshot.snapshot.value as Map<Object?, Object?>;

      // Iterate through the evaluators to find a match by email
      for (var entry in evaluators.entries) {
        final Map<Object?, Object?> evaluatorData =
            entry.value as Map<Object?, Object?>;

        if (evaluatorData['evaluator_email'] == email) {
          // Convert Map<Object?, Object?> to Map<String, dynamic>
          final Map<String, dynamic> evaluator = evaluatorData
              .map((key, value) => MapEntry(key.toString(), value));

          return evaluator;
        }
      }
      throw Exception('Evaluator with email $email not found');
    } else {
      throw Exception('No evaluators found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? email = getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4568DC), Color(0xFFB06AB3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB06AB3), Color(0xFF4568DC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: email == null
            ? const Center(
                child: Text('User not logged in'),
              )
            : FutureBuilder<Map<String, dynamic>>(
                future: fetchEvaluatorByEmail(email),
                builder: (context, evaluatorSnapshot) {
                  if (evaluatorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (evaluatorSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${evaluatorSnapshot.error}'),
                    );
                  } else if (!evaluatorSnapshot.hasData) {
                    return const Center(
                      child: Text('No evaluator found'),
                    );
                  }

                  final evaluator = evaluatorSnapshot.data!;
                  final String evaluatorId = evaluator['evaluator_id'] ??
                      'N/A'; // Dynamic evaluator_id

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evaluator['evaluator_name'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'ID: $evaluatorId', // Use dynamic evaluator_id
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ProfileDetail(
                                icon: Icons.task_alt,
                                title: 'Total Tasks',
                                value: evaluator['total_tasks'].toString(),
                              ),
                              const Divider(),
                              ProfileDetail(
                                icon: Icons.phone,
                                title: 'Mobile Number',
                                value: evaluator['evaluator_contact_number'] ??
                                    'N/A',
                              ),
                              const Divider(),
                              ProfileDetail(
                                icon: Icons.cake,
                                title: 'Age',
                                value: evaluator['evaluator_age'].toString(),
                              ),
                              const Divider(),
                              ProfileDetail(
                                icon: Icons.location_on,
                                title: 'Cities',
                                value:
                                    _getCities(evaluator['evaluator_location']),
                              ),
                              const Divider(),
                              ProfileDetail(
                                icon: Icons.email,
                                title: 'Email Id',
                                value: evaluator['evaluator_email'] ?? 'N/A',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _getCities(dynamic locations) {
    if (locations == null) {
      return 'No cities available';
    }
    if (locations is List<dynamic>) {
      return locations.map((city) => city.toString()).join(', ');
    }
    if (locations is String) {
      return locations;
    }
    return 'Unknown format';
  }
}

class ProfileDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const ProfileDetail({
    required this.icon,
    required this.title,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16.0),
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
