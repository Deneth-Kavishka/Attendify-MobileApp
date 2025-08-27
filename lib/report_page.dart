import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 600;

    // Dummy Data
    final int totalReports = 24;
    final double attendanceRate = 87.3;
    final double hardwareUptime = 96.8;
    final int systemEvents = 12;

    final List<Map<String, dynamic>> quickReports = [
      {
        'title': 'Attendance Summary',
        'subtitle': "This week’s attendance overview",
        'icon': Icons.assignment,
        'color': Colors.blue,
      },
      {
        'title': 'Hardware Status',
        'subtitle': "ESP32-CAM & RFID performance",
        'icon': Icons.memory,
        'color': Colors.green,
      },
      {
        'title': 'Exam Eligibility',
        'subtitle': "75% threshold analysis",
        'icon': Icons.school,
        'color': Colors.purple,
      },
      {
        'title': 'Custom Report',
        'subtitle': "Build custom report",
        'icon': Icons.settings,
        'color': Colors.orange,
      },
    ];

    final List<Map<String, dynamic>> reportHistory = [
      {
        'title': 'Weekly Attendance Report',
        'date': 'Aug 25, 2025',
        'icon': Icons.insert_chart,
      },
      {
        'title': 'Exam Eligibility Report',
        'date': 'Aug 20, 2025',
        'icon': Icons.school,
      },
      {
        'title': 'System Health Report',
        'date': 'Aug 18, 2025',
        'icon': Icons.computer,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Reports & Analytics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Refreshing reports...")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Top Analytics Cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _analyticsCard(
                  title: "Total Reports",
                  value: "$totalReports",
                  icon: Icons.article,
                  color: Colors.blue,
                  subtitle: "+5 this week",
                ),
                _analyticsCard(
                  title: "Attendance Rate",
                  value: "${attendanceRate.toStringAsFixed(1)}%",
                  icon: Icons.show_chart,
                  color: Colors.green,
                  subtitle: "+2.4% from last week",
                ),
                _analyticsCard(
                  title: "Hardware Uptime",
                  value: "${hardwareUptime.toStringAsFixed(1)}%",
                  icon: Icons.storage,
                  color: Colors.purple,
                  subtitle: "3/3 online",
                ),
                _analyticsCard(
                  title: "System Events",
                  value: "$systemEvents",
                  icon: Icons.notifications,
                  color: Colors.orange,
                  subtitle: "3 today",
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ✅ Quick Report Generator
            _buildSectionTitle("Quick Report Generator"),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95, // 🔥 prevents overflow
              ),
              itemCount: quickReports.length,
              itemBuilder: (context, index) {
                final report = quickReports[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${report['title']} clicked")),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(report['icon'],
                              size: 40, color: report['color']),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              report['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Text(
                              report['subtitle'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ✅ Reports History
            _buildSectionTitle("Reports History"),
            Column(
              children: reportHistory.map((report) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(report['icon'], color: Colors.deepPurple),
                    title: Text(report['title']),
                    subtitle: Text("Generated on ${report['date']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Downloading ${report['title']}...")),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper for analytics cards
  Widget _analyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    if (subtitle != null)
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
