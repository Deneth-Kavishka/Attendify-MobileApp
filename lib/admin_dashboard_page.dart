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
  int _selectedIndex = 0; // For bottom nav

  // ✅ Sample today’s classes data
  final List<Map<String, dynamic>> todaysClasses = [
    {
      'class': 'Computer Science 101',
      'code': 'CS101',
      'lecturer': 'Dr. Sarah Johnson',
      'time': '10:00 - 11:30 AM',
      'room': 'A101',
      'enrolled': 45,
      'present': 38,
      'attendance': 84,
      'status': 'In Progress',
    },
    {
      'class': 'Mathematics 201',
      'code': 'MATH201',
      'lecturer': 'Prof. Michael Chen',
      'time': '2:00 - 3:30 PM',
      'room': 'B205',
      'enrolled': 32,
      'present': 0,
      'attendance': null,
      'status': 'Scheduled',
    },
    {
      'class': 'Physics 301',
      'code': 'PHY301',
      'lecturer': 'Dr. Emma Williams',
      'time': '8:00 - 9:30 AM',
      'room': 'C102',
      'enrolled': 28,
      'present': 26,
      'attendance': 93,
      'status': 'Completed',
    },
  ];

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

  // ✅ Bottom nav tap handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _showSnack("Add New Student clicked");
        break;
      case 1:
        _showSnack("Create New Class clicked");
        break;
      case 2:
        _showSnack("Generate Report clicked");
        break;
      case 3:
        _showSnack("System Setting clicked");
        break;
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
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
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
            const SizedBox(height: 12),
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
                Text(
                  currentDateTime,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications,
                              color: Colors.white),
                          onPressed: () {
                            setState(() {
                              notificationCount = 0;
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          value: '${currentEligibilityRate.toStringAsFixed(1)}%',
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildLiveFeedCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Hardware Status',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildHardwareStatusCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Today’s Classes Overview',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildTodaysClassesCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Add Student",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: "New Class",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Report",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
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

  Widget _buildHardwareStatusCard() {
    final List<Map<String, dynamic>> hardwareList = [
      {
        'name': 'ESP32-CAM',
        'status': 'Online',
        'icon': Icons.camera_alt,
        'color': Colors.green,
      },
      {
        'name': 'RFID Reader',
        'status': 'Online',
        'icon': Icons.credit_card,
        'color': Colors.green,
      },
      {
        'name': 'Firebase DB',
        'status': 'Connected',
        'icon': Icons.cloud_done,
        'color': Colors.blue,
      },
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
              'Devices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...hardwareList.map(
              (hw) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(hw['icon'], color: hw['color']),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hw['name'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      hw['status'],
                      style: TextStyle(
                        color: hw['color'],
                        fontWeight: FontWeight.bold,
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

  Widget _buildTodaysClassesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Class")),
            DataColumn(label: Text("Lecturer")),
            DataColumn(label: Text("Time")),
            DataColumn(label: Text("Room")),
            DataColumn(label: Text("Enrolled")),
            DataColumn(label: Text("Present")),
            DataColumn(label: Text("Attendance")),
            DataColumn(label: Text("Status")),
          ],
          rows: todaysClasses.map((cls) {
            return DataRow(
              cells: [
                DataCell(Text("${cls['class']} (${cls['code']})")),
                DataCell(Text(cls['lecturer'])),
                DataCell(Text(cls['time'])),
                DataCell(Text(cls['room'])),
                DataCell(Text(cls['enrolled'].toString())),
                DataCell(Text(cls['present'].toString())),
                DataCell(
                  Text(
                    cls['attendance'] != null ? "${cls['attendance']}%" : "-",
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cls['status'] == "Completed"
                          ? Colors.green.shade100
                          : cls['status'] == "In Progress"
                              ? Colors.blue.shade100
                              : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      cls['status'],
                      style: TextStyle(
                        color: cls['status'] == "Completed"
                            ? Colors.green
                            : cls['status'] == "In Progress"
                                ? Colors.blue
                                : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
