import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> students = [
    {
      "id": "STU001",
      "name": "John Smith",
      "email": "student@attendify.com",
      "nic": "200012345V",
      "status": "Active",
      "rfid": "RFID001",
      "face": "Pending",
      "academic": "N/A",
      "dob": "2000-01-01",
      "address": "Colombo",
    },
    {
      "id": "STU002",
      "name": "Alice Johnson",
      "email": "alice.johnson@university.edu",
      "nic": "200023456V",
      "status": "Active",
      "rfid": "RFID002",
      "face": "Pending",
      "academic": "Computer Science",
      "dob": "2001-05-10",
      "address": "Kandy",
    },
  ];

  String searchText = "";
  String selectedStatus = "All Status";
  final statusOptions = ["All Status", "Active", "Inactive"];

  // --- Form Controllers for Add Student ---
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nicCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  String statusCtrl = "Active";

  void openAddStudentDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add New Student"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Full Name"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter name" : null,
                  ),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter email";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(val)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nicCtrl,
                    decoration: const InputDecoration(labelText: "NIC"),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Enter NIC";
                      }
                      final nicRegex = RegExp(r'^(\d{12}|\d{9}[vV])$');
                      if (!nicRegex.hasMatch(val)) {
                        return "Invalid NIC format";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dobCtrl,
                    decoration: const InputDecoration(
                      labelText: "Date of Birth",
                    ),
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1980),
                        lastDate: DateTime(2025),
                        initialDate: DateTime(2000),
                      );
                      if (picked != null) {
                        dobCtrl.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
                    validator: (val) => val == null || val.isEmpty
                        ? "Select date of birth"
                        : null,
                  ),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(labelText: "Address"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter address" : null,
                  ),
                  DropdownButtonFormField(
                    value: statusCtrl,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: ["Active", "Inactive"].map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        statusCtrl = val!;
                      });
                    },
                    validator: (val) =>
                        val == null || val.isEmpty ? "Select status" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    students.add({
                      "id":
                          "STU${(students.length + 1).toString().padLeft(3, "0")}",
                      "name": nameCtrl.text,
                      "email": emailCtrl.text,
                      "nic": nicCtrl.text,
                      "dob": dobCtrl.text,
                      "address": addressCtrl.text,
                      "status": statusCtrl,
                      "rfid": "-",
                      "face": "Pending",
                      "academic": "N/A",
                    });
                  });
                  Navigator.pop(ctx);
                  nameCtrl.clear();
                  emailCtrl.clear();
                  nicCtrl.clear();
                  dobCtrl.clear();
                  addressCtrl.clear();
                  statusCtrl = "Active";
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStudents = students.where((student) {
      final matchesSearch =
          student["name"].toLowerCase().contains(searchText.toLowerCase()) ||
          student["id"].toLowerCase().contains(searchText.toLowerCase()) ||
          student["email"].toLowerCase().contains(searchText.toLowerCase()) ||
          student["nic"].toLowerCase().contains(searchText.toLowerCase());

      final matchesStatus = selectedStatus == "All Status"
          ? true
          : student["status"] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    int total = students.length;
    int active = students.where((s) => s["status"] == "Active").length;
    int inactive = students.where((s) => s["status"] == "Inactive").length;
    int rfid = students.where((s) => s["rfid"] != "-").length;
    int face = students
        .where((s) => s["face"] != "-" && s["face"] != "Pending")
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
        backgroundColor: const Color(0xFF6A11CB),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: openAddStudentDialog,
            icon: const Icon(Icons.add),
            label: const Text("Add New Student"),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                statCard(
                  Icons.people,
                  "Total Students",
                  total,
                  "Registered students",
                  Colors.blue,
                ),
                statCard(
                  Icons.check_circle,
                  "Active Students",
                  active,
                  "Currently active",
                  Colors.green,
                ),
                statCard(
                  Icons.face,
                  "Face Enrolled",
                  face,
                  "Face recognition ready",
                  Colors.purple,
                ),
                statCard(
                  Icons.credit_card,
                  "RFID Enrolled",
                  rfid,
                  "With RFID cards",
                  Colors.orange,
                ),
                statCard(
                  Icons.cancel,
                  "Inactive",
                  inactive,
                  "Deactivated accounts",
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search students (name, ID, email, NIC)...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) => setState(() => searchText = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStatus,
                    items: statusOptions.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedStatus = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 600),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey.shade200,
                  ),
                  columns: const [
                    DataColumn(label: Text("Student")),
                    DataColumn(label: Text("Academic Info")),
                    DataColumn(label: Text("RFID")),
                    DataColumn(label: Text("Face Recognition")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: filteredStudents.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                student["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${student['id']} • ${student['email']}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text("DOB: ${student['dob']}"),
                              Text("Address: ${student['address']}"),
                            ],
                          ),
                        ),
                        DataCell(Text(student["academic"])),
                        DataCell(Text(student["rfid"])),
                        DataCell(
                          Chip(
                            label: Text(student["face"]),
                            backgroundColor: student["face"] == "Pending"
                                ? Colors.yellow.shade100
                                : Colors.green.shade100,
                          ),
                        ),
                        DataCell(
                          Chip(
                            label: Text(student["status"]),
                            backgroundColor: student["status"] == "Active"
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Viewing ${student['name']}"),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(
    IconData icon,
    String title,
    int count,
    String subtitle,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Clicked on $title")));
      },
      borderRadius: BorderRadius.circular(16),
      splashColor: color.withOpacity(0.2),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 6,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              "$count",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
