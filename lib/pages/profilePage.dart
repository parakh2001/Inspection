import 'package:flutter/material.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    // Example user data
    final String photoUrl =
        'https://via.placeholder.com/150'; // Replace with user's photo URL
    final String userName = 'John Doe'; // Replace with user's name
    final String userId = 'ID123456'; // Replace with user's unique ID
    final String totalTasks = '15'; // Replace with the actual total tasks
    final String mobile = '+1 234 567 890'; // Replace with user's mobile number
    final String age = '30'; // Replace with user's age
    final String bloodGroup = 'O+'; // Replace with user's blood group
    final String location = 'New York, USA'; // Replace with user's location
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(photoUrl),
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'ID: $userId',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
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
                      value: totalTasks,
                    ),
                    const Divider(),
                    ProfileDetail(
                      icon: Icons.phone,
                      title: 'Mobile',
                      value: mobile,
                    ),
                    const Divider(),
                    ProfileDetail(
                      icon: Icons.cake,
                      title: 'Age',
                      value: age,
                    ),
                    const Divider(),
                    ProfileDetail(
                      icon: Icons.bloodtype,
                      title: 'Blood Group',
                      value: bloodGroup,
                    ),
                    const Divider(),
                    ProfileDetail(
                      icon: Icons.location_on,
                      title: 'Location',
                      value: location,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
