import 'package:flutter/material.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  List<Map<String, dynamic>> classes = [
    {
      "name": "Introduction to Programming",
      "code": "CS101",
      "semester": "Fall 2024",
      "lecturer": "N/A",
      "room": "Room 101",
      "schedule": "Mon, Wed, Fri\n09:00 - 10:30",
      "devices": "0 devices",
      "status": "Active",
    }
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController lecturerController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();

  void _showAddClassDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Class"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Class Name"),
                ),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: "Class Code"),
                ),
                TextField(
                  controller: semesterController,
                  decoration: const InputDecoration(labelText: "Semester"),
                ),
                TextField(
                  controller: lecturerController,
                  decoration: const InputDecoration(labelText: "Lecturer"),
                ),
                TextField(
                  controller: roomController,
                  decoration: const InputDecoration(labelText: "Room"),
                ),
                TextField(
                  controller: scheduleController,
                  decoration: const InputDecoration(labelText: "Schedule"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  classes.add({
                    "name": nameController.text,
                    "code": codeController.text,
                    "semester": semesterController.text,
                    "lecturer": lecturerController.text,
                    "room": roomController.text,
                    "schedule": scheduleController.text,
                    "devices": "0 devices",
                    "status": "Active",
                  });
                });

                nameController.clear();
                codeController.clear();
                semesterController.clear();
                lecturerController.clear();
                roomController.clear();
                scheduleController.clear();

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Class Management"),
        backgroundColor: const Color(0xFF6A11CB),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _showAddClassDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add New Class",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top Light 3D Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ThreeDSummaryCard(
                    title: "Total Classes",
                    value: "${classes.length}",
                    subtitle: "Registered classes",
                    colors: [Colors.blue.shade100, Colors.blue.shade300],
                    icon: Icons.class_,
                  ),
                  ThreeDSummaryCard(
                    title: "Active Classes",
                    value:
                        "${classes.where((c) => c['status'] == 'Active').length}",
                    subtitle: "Currently running",
                    colors: [Colors.green.shade100, Colors.green.shade300],
                    icon: Icons.check_circle,
                  ),
                  ThreeDSummaryCard(
                    title: "With Devices",
                    value:
                        "${classes.where((c) => c['devices'] != '0 devices').length}",
                    subtitle: "Hardware enabled",
                    colors: [Colors.purple.shade100, Colors.purple.shade300],
                    icon: Icons.devices,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ThreeDSummaryCard(
                    title: "Online Devices",
                    value: "2",
                    subtitle: "Available devices",
                    colors: [Colors.orange.shade100, Colors.orange.shade300],
                    icon: Icons.wifi,
                  ),
                  ThreeDSummaryCard(
                    title: "Inactive",
                    value:
                        "${classes.where((c) => c['status'] != 'Active').length}",
                    subtitle: "Disabled classes",
                    colors: [Colors.red.shade100, Colors.red.shade300],
                    icon: Icons.cancel,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search & Filter Section
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search classes (name, code, room)...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: "All Status",
                    items: const [
                      DropdownMenuItem(
                          value: "All Status", child: Text("All Status")),
                      DropdownMenuItem(value: "Active", child: Text("Active")),
                      DropdownMenuItem(
                          value: "Inactive", child: Text("Inactive")),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: "All Semesters",
                    items: const [
                      DropdownMenuItem(
                          value: "All Semesters", child: Text("All Semesters")),
                      DropdownMenuItem(value: "Fall", child: Text("Fall")),
                      DropdownMenuItem(value: "Spring", child: Text("Spring")),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Classes Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Classes (${classes.length})",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Class")),
                          DataColumn(label: Text("Lecturer & Room")),
                          DataColumn(label: Text("Schedule")),
                          DataColumn(label: Text("Hardware")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: classes.map((cls) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                  "${cls["name"]}\n${cls["code"]} • Semester ${cls["semester"]}")),
                              DataCell(
                                  Text("${cls["lecturer"]}\n${cls["room"]}")),
                              DataCell(Text(cls["schedule"])),
                              DataCell(Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(cls["devices"],
                                    style:
                                        const TextStyle(color: Colors.purple)),
                              )),
                              DataCell(Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: cls["status"] == "Active"
                                      ? Colors.green[50]
                                      : Colors.red[50],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(cls["status"],
                                    style: TextStyle(
                                        color: cls["status"] == "Active"
                                            ? Colors.green
                                            : Colors.red)),
                              )),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.visibility,
                                          color: Colors.grey),
                                      onPressed: () {}),
                                  IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          classes.remove(cls);
                                        });
                                      }),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
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

// Light Pastel 3D-Like Summary Card Widget
class ThreeDSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final List<Color> colors;
  final IconData icon;

  const ThreeDSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.colors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
