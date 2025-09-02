import 'package:attendify/add_new_student_page.dart';
import 'package:attendify/class_page.dart';
import 'package:attendify/new_class_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'hardware_status_page.dart';
import 'exam_eligibility_page.dart';
import 'report_page.dart';
import 'settings_page.dart';
import 'student_page.dart';
import 'lecturer_page.dart';
import 'class_page.dart';
import 'attendance_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final int totalStudents = 350;
  final int studentsPresentToday = 210;
  final double attendanceCutoff = 75.0;
  final double currentEligibilityRate = 78.5;

  final int activeClasses = 15;
  final double avgAttendanceThisWeek = 85.0;
  final int scheduledClassesToday = 5;
  final int unreadAlerts = 3;

  int notificationCount = 3;
  String currentDateTime = "";
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewStudentPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewClassPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          _buildTopNavBar(context),
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
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 2;
                        if (screenWidth > 1200) {
                          crossAxisCount = 4;
                        } else if (screenWidth > 800) {
                          crossAxisCount = 3;
                        }
                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
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
                            _buildDashboardCard(
                              title: 'Active Classes',
                              value: activeClasses.toString(),
                              icon: Icons.class_outlined,
                              color: Colors.cyan.shade300,
                            ),
                            _buildDashboardCard(
                              title: 'Avg. Weekly Attendance',
                              value:
                                  '${avgAttendanceThisWeek.toStringAsFixed(1)}%',
                              icon: Icons.show_chart,
                              color: Colors.purple.shade300,
                            ),
                            _buildDashboardCard(
                              title: 'Classes Scheduled',
                              value: scheduledClassesToday.toString(),
                              icon: Icons.schedule,
                              color: Colors.orange.shade300,
                            ),
                            _buildDashboardCard(
                              title: 'Unread Alerts',
                              value: unreadAlerts.toString(),
                              icon: Icons.warning_amber,
                              color: Colors.deepOrange.shade300,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Live Attendance Feed'),
                    const SizedBox(height: 16),
                    _buildLiveFeedCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Today’s Classes Overview'),
                    const SizedBox(height: 16),
                    _buildTodaysClassesCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'Smart Attendance\nManagement System',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.people,
                  text: 'Students',
                  onTap: () {
                    Navigator.pop(context); // close the drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  text: 'Lecturers',
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LecturerPage(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.class_,
                  text: 'Classes',
                  onTap: () {
                    Navigator.pop(context); // close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassPage(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
  icon: Icons.check_circle,
  text: 'Attendance',
  onTap: () {
    Navigator.pop(context); // close the drawer first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AttendancePage(),
      ),
    );
  },
),

                _buildDrawerItem(
                  icon: Icons.school,
                  text: 'Exam Eligibility',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExamEligibilityPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bar_chart,
                  text: 'Reports',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context) {
    return Container(
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
          Flexible(
            child: Text(
              currentDateTime,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
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
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
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
        BottomNavigationBarItem(icon: Icon(Icons.class_), label: "New Class"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Report"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
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
        padding: const EdgeInsets.all(16),
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
                    Expanded(
                      child: Text(
                        scan['name']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
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
          rows: todaysClasses
              .map(
                (cls) => DataRow(
                  cells: [
                    DataCell(Text("${cls['class']} (${cls['code']})")),
                    DataCell(Text(cls['lecturer'])),
                    DataCell(Text(cls['time'])),
                    DataCell(Text(cls['room'])),
                    DataCell(Text(cls['enrolled'].toString())),
                    DataCell(Text(cls['present'].toString())),
                    DataCell(
                      Text(
                        cls['attendance'] != null
                            ? "${cls['attendance']}%"
                            : "-",
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
