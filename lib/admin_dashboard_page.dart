import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Placeholder data
  final int totalStudents = 350;
  final int studentsPresentToday = 210;
  final double attendanceCutoff = 75.0;
  final double currentEligibilityRate = 78.5;

  int notificationCount = 3;
  String currentDateTime = "";

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    final String formattedDateTime = DateFormat(
      'EEE, MMM d, yyyy • hh:mm a',
    ).format(DateTime.now());
    setState(() {
      currentDateTime = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Smart Attendance\nManagement System',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.people,
              text: 'Students',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              text: 'Lecturers',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.class_,
              text: 'Classes',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.check_circle,
              text: 'Attendance',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.school,
              text: 'Exam Eligibility',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.memory,
              text: 'Hardware Status',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.bar_chart,
              text: 'Reports',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ✅ Custom Top Navigation Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Menu + Welcome
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Welcome, Administrator",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Center: Date & Time
                Text(
                  currentDateTime,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),

                // Right: Notifications + Profile
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              notificationCount = 0; // Clear notifications
                            });
                          },
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                notificationCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.deepPurple),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Dashboard Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildDashboardCard(
                          title: 'Total Students',
                          value: totalStudents.toString(),
                          icon: Icons.people,
                          color: Colors.blue.shade300,
                        ),
                        _buildDashboardCard(
                          title: 'Present Today',
                          value: studentsPresentToday.toString(),
                          icon: Icons.check_circle_outline,
                          color: Colors.green.shade300,
                        ),
                        _buildDashboardCard(
                          title: 'Exam Eligibility',
                          value:
                              '${currentEligibilityRate.toStringAsFixed(1)}%',
                          icon: Icons.school,
                          color: Colors.amber.shade300,
                        ),
                        _buildDashboardCard(
                          title: 'Attendance Cutoff',
                          value: '${attendanceCutoff.toStringAsFixed(0)}%',
                          icon: Icons.percent,
                          color: Colors.red.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Live Attendance Feed',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLiveFeedCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveFeedCard() {
    final List<Map<String, String>> recentScans = [
      {'name': 'John Doe', 'time': '10:01 AM'},
      {'name': 'Jane Smith', 'time': '10:02 AM'},
      {'name': 'Peter Jones', 'time': '10:03 AM'},
      {'name': 'Sarah Lee', 'time': '10:04 AM'},
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Scans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...recentScans.map(
              (scan) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(scan['name']!, style: const TextStyle(fontSize: 16)),
                    Text(
                      scan['time']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
