import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Management"),
        backgroundColor: const Color(0xFF6A11CB),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sync, color: Colors.white),
            label: const Text("Sync Hardware", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Manual Marking"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Stats Cards
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Total Present Today",
                        "5",
                        subtitle: "+13 from yesterday",
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        "Attendance Rate",
                        "100%",
                        subtitle: "Above target",
                        icon: Icons.percent,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Face Recognition",
                        "3",
                        subtitle: "60.0% of total",
                        icon: Icons.face,
                        color: Colors.purple,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        "RFID Scans",
                        "2",
                        subtitle: "40.0% of total",
                        icon: Icons.credit_card,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- Real-Time Attendance Monitor & Device Status
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAttendanceMonitorCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDeviceStatusCard()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildAttendanceMonitorCard(),
                      const SizedBox(height: 12),
                      _buildDeviceStatusCard(),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            // --- Attendance Records Section (Scrollable Table)
            _buildAttendanceRecordsCard(),
          ],
        ),
      ),
    );
  }

  // ----------------- Widgets -----------------

  Widget _buildStatCard(String title, String value,
      {String? subtitle, required IconData icon, required Color color}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceMonitorCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Real-Time Attendance Monitor",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.wifi, color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    TextButton(onPressed: () {}, child: const Text("Refresh")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "LIVE: Hardware devices detecting students in real-time (15 recent detections)",
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            const Divider(),
            _buildAttendanceItem("Unknown Student", "STU002", "Intro to Programming",
                "PRESENT", "12:12:33", 86.7),
            _buildAttendanceItem("Unknown Student", "STU004", "Intro to Programming",
                "LATE", "12:12:24", 89.1),
            _buildAttendanceItem("John Doe", "STU005", "Data Structures", "PRESENT", "12:12:12", 92.3),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(String name, String id, String subject,
      String status, String time, double confidence) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.red),
      title: Text("$name ($id)"),
      subtitle: Text(subject),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(fontSize: 12)),
          Text(status,
              style: TextStyle(
                  color: status == "PRESENT" ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold)),
          Text("${confidence.toStringAsFixed(1)}% confidence",
              style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
        ],
      ),
    );
  }

  Widget _buildDeviceStatusCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hardware Device Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _buildDeviceItem("ESP32-CAM-01", "Main Entrance Camera", "12:12:22", true),
            _buildDeviceItem("RFID-READER-01", "Entrance Card Scanner", "12:12:32", true),
            _buildDeviceItem("ESP32-CAM-02", "Secondary Camera (Hall)", "12:12:18", true),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(String id, String name, String time, bool online) {
    return ListTile(
      leading: Icon(Icons.devices, color: online ? Colors.green : Colors.red),
      title: Text(id),
      subtitle: Text(name),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(online ? Icons.circle : Icons.circle_outlined,
              size: 12, color: online ? Colors.green : Colors.red),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAttendanceRecordsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Attendance Records",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("View and manage all attendance records",
                style: TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 16),

            // --- Filters Row
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search students...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: "All Classes",
                  items: const [
                    DropdownMenuItem(value: "All Classes", child: Text("All Classes")),
                    DropdownMenuItem(value: "Math", child: Text("Math")),
                    DropdownMenuItem(value: "Programming", child: Text("Programming")),
                    DropdownMenuItem(value: "Data Structures", child: Text("Data Structures")),
                    DropdownMenuItem(value: "Networks", child: Text("Networks")),
                  ],
                  onChanged: (_) {},
                ),
                DropdownButton<String>(
                  value: "All Status",
                  items: const [
                    DropdownMenuItem(value: "All Status", child: Text("All Status")),
                    DropdownMenuItem(value: "Present", child: Text("Present")),
                    DropdownMenuItem(value: "Absent", child: Text("Absent")),
                    DropdownMenuItem(value: "Late", child: Text("Late")),
                  ],
                  onChanged: (_) {},
                ),
                DropdownButton<String>(
                  value: "All Methods",
                  items: const [
                    DropdownMenuItem(value: "All Methods", child: Text("All Methods")),
                    DropdownMenuItem(value: "Face Recognition", child: Text("Face Recognition")),
                    DropdownMenuItem(value: "RFID", child: Text("RFID")),
                    DropdownMenuItem(value: "Manual", child: Text("Manual")),
                  ],
                  onChanged: (_) {},
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text("August 26th, 2025"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- Scrollable Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // --- Table Header
                  Row(
                    children: const [
                      _tableCell("Student", bold: true),
                      _tableCell("Class", bold: true),
                      _tableCell("Status", bold: true),
                      _tableCell("Method", bold: true),
                      _tableCell("Time", bold: true),
                      _tableCell("Device", bold: true),
                      _tableCell("Confidence", bold: true),
                    ],
                  ),
                  const Divider(),

                  // --- Table Rows
                  Row(
                    children: const [
                      _tableCell("John Doe (STU001)"),
                      _tableCell("Programming"),
                      _tableCell("Present", color: Colors.green),
                      _tableCell("Face Recognition"),
                      _tableCell("12:12:11"),
                      _tableCell("ESP32-CAM-01"),
                      _tableCell("92.5%"),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: const [
                      _tableCell("Jane Smith (STU002)"),
                      _tableCell("Data Structures"),
                      _tableCell("Late", color: Colors.orange),
                      _tableCell("RFID"),
                      _tableCell("12:15:30"),
                      _tableCell("RFID-READER-01"),
                      _tableCell("88.3%"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Table Cell Helper Widget ---
class _tableCell extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? color;
  const _tableCell(this.text, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // fixed width for scrolling
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}
