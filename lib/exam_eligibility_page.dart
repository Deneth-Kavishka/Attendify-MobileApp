import 'package:flutter/material.dart';

class ExamEligibilityPage extends StatefulWidget {
  const ExamEligibilityPage({super.key});

  @override
  State<ExamEligibilityPage> createState() => _ExamEligibilityPageState();
}

class _ExamEligibilityPageState extends State<ExamEligibilityPage> {
  final double attendanceCutoff = 75.0;

  // ✅ Sample student data
  final List<Map<String, dynamic>> students = [
    {"id": "S001", "name": "John Doe", "attendance": 82.0, "class": "CS101"},
    {"id": "S002", "name": "Jane Smith", "attendance": 68.0, "class": "CS101"},
    {
      "id": "S003",
      "name": "Peter Johnson",
      "attendance": 91.0,
      "class": "MATH201",
    },
    {"id": "S004", "name": "Sarah Lee", "attendance": 72.0, "class": "PHY301"},
    {
      "id": "S005",
      "name": "Michael Chen",
      "attendance": 76.0,
      "class": "MATH201",
    },
  ];

  String selectedClass = "All Classes";
  String searchQuery = "";
  String eligibilityFilter = "All Students";

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;

    // ✅ Filter students
    List<Map<String, dynamic>> filteredStudents = students.where((student) {
      double att = student["attendance"];
      bool eligible = att >= attendanceCutoff;

      if (selectedClass != "All Classes" && student["class"] != selectedClass)
        return false;
      if (eligibilityFilter == "Eligible" && !eligible) return false;
      if (eligibilityFilter == "Not Eligible" && eligible) return false;
      if (searchQuery.isNotEmpty &&
          !student["name"].toLowerCase().contains(searchQuery.toLowerCase()) &&
          !student["id"].toLowerCase().contains(searchQuery.toLowerCase()))
        return false;

      return true;
    }).toList();

    // ✅ Stats
    int eligibleCount = students
        .where((s) => s["attendance"] >= attendanceCutoff)
        .length;
    int riskCount = students
        .where((s) => s["attendance"] < attendanceCutoff)
        .length;
    double avgAttendance =
        students.map((s) => s["attendance"]).reduce((a, b) => a + b) /
        students.length;
    int activeClasses = students.map((s) => s["class"]).toSet().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Eligibility Management"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Stats Row
            isWide
                ? Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          "Exam Eligible",
                          "$eligibleCount",
                          "≥75% attendance",
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          "At Risk",
                          "$riskCount",
                          "<75% attendance",
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          "Average Attendance",
                          "${avgAttendance.toStringAsFixed(1)}%",
                          "All students",
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          "Active Classes",
                          "$activeClasses",
                          "Being monitored",
                          Colors.purple,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildStatCard(
                        "Exam Eligible",
                        "$eligibleCount",
                        "≥75% attendance",
                        Colors.green,
                      ),
                      _buildStatCard(
                        "At Risk",
                        "$riskCount",
                        "<75% attendance",
                        Colors.red,
                      ),
                      _buildStatCard(
                        "Average Attendance",
                        "${avgAttendance.toStringAsFixed(1)}%",
                        "All students",
                        Colors.blue,
                      ),
                      _buildStatCard(
                        "Active Classes",
                        "$activeClasses",
                        "Being monitored",
                        Colors.purple,
                      ),
                    ],
                  ),
            const SizedBox(height: 20),

            // ✅ Filters & Bulk Check
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildFilters()),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildBulkCheck()),
                    ],
                  )
                : Column(
                    children: [
                      _buildFilters(),
                      const SizedBox(height: 16),
                      _buildBulkCheck(),
                    ],
                  ),
            const SizedBox(height: 20),

            // ✅ Student Table / List Responsive
            isWide
                ? _buildCard(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 600),
                        child: DataTable(
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Class")),
                            DataColumn(label: Text("Attendance")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: filteredStudents.map((student) {
                            double att = student["attendance"];
                            bool eligible = att >= attendanceCutoff;
                            return DataRow(
                              cells: [
                                DataCell(Text(student["id"])),
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      student["name"],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(student["class"])),
                                DataCell(Text("${att.toStringAsFixed(1)}%")),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: eligible
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      eligible ? "Eligible" : "Not Eligible",
                                      style: TextStyle(
                                        color: eligible
                                            ? Colors.green
                                            : Colors.red,
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
                    ),
                  )
                : Column(
                    children: filteredStudents.map((student) {
                      double att = student["attendance"];
                      bool eligible = att >= attendanceCutoff;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(student["name"]),
                          subtitle: Text(
                            "ID: ${student["id"]} • Class: ${student["class"]} • Attendance: ${att.toStringAsFixed(1)}%",
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: eligible
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              eligible ? "Eligible" : "Not Eligible",
                              style: TextStyle(
                                color: eligible ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  // ✅ Filters
  Widget _buildFilters() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filters & Search",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedClass,
            isExpanded: true,
            items: [
              "All Classes",
              "CS101",
              "MATH201",
              "PHY301",
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => selectedClass = val!),
            decoration: const InputDecoration(
              labelText: "Select Class",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: "Search Students",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() => searchQuery = val),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: eligibilityFilter,
            isExpanded: true,
            items: [
              "All Students",
              "Eligible",
              "Not Eligible",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => eligibilityFilter = val!),
            decoration: const InputDecoration(
              labelText: "Eligibility Filter",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Bulk Check
  Widget _buildBulkCheck() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bulk Eligibility Check",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: "Choose a class",
            isExpanded: true,
            items: [
              "Choose a class",
              "CS101",
              "MATH201",
              "PHY301",
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (_) {},
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bulk eligibility check running..."),
                ),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: const Text("Check Eligibility"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Stat Card
  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}
