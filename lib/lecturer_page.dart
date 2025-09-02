import 'package:flutter/material.dart';

class LecturerPage extends StatefulWidget {
  const LecturerPage({super.key});

  @override
  State<LecturerPage> createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {
  final List<Map<String, String>> lecturers = [];
  List<Map<String, String>> filteredLecturers = [];

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  String? department;
  final TextEditingController additionalController = TextEditingController();

  // Search & filter controllers
  final TextEditingController searchController = TextEditingController();
  String selectedStatus = "All";
  String selectedDepartment = "All";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    filteredLecturers = List.from(lecturers);
  }

  void _showAddLecturerForm({Map<String, String>? lecturer, int? index}) {
    if (lecturer != null) {
      fullNameController.text = lecturer['name'] ?? '';
      emailController.text = lecturer['email'] ?? '';
      mobileController.text = lecturer['mobile'] ?? '';
      specializationController.text = lecturer['specialization'] ?? '';
      department = lecturer['department'];
      additionalController.text = lecturer['additional'] ?? '';
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecturer == null ? "Add New Lecturer" : "Edit Lecturer",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text("Basic Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: fullNameController,
                    decoration: _inputDecoration("Full Name *"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter full name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: mobileController,
                    decoration: _inputDecoration("Mobile Number *"),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Enter mobile number";
                      final mobileRegex = RegExp(r'^\d{10}$');
                      if (!mobileRegex.hasMatch(val)) return "Enter valid 10-digit mobile number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration("Email *"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Enter email";
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(val)) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Academic Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: department,
                    decoration: _inputDecoration("Department *"),
                    items: const [
                      DropdownMenuItem(
                          value: "CS", child: Text("Computer Science")),
                      DropdownMenuItem(
                          value: "IT", child: Text("Information Technology")),
                      DropdownMenuItem(
                          value: "Math", child: Text("Mathematics")),
                    ],
                    onChanged: (val) => setState(() => department = val),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Select department" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: specializationController,
                    decoration: _inputDecoration("Specialization *"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter specialization" : null,
                  ),
                  const SizedBox(height: 20),
                  const Text("Additional Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: additionalController,
                    maxLines: 3,
                    decoration: _inputDecoration("Additional Details"),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (lecturer != null && index != null) {
                            setState(() {
                              lecturers[index] = {
                                "name": fullNameController.text,
                                "email": emailController.text,
                                "mobile": mobileController.text,
                                "department": department ?? "N/A",
                                "specialization": specializationController.text,
                                "status": lecturer['status'] ?? "Active",
                                "additional": additionalController.text
                              };
                            });
                          } else {
                            setState(() {
                              lecturers.add({
                                "name": fullNameController.text,
                                "email": emailController.text,
                                "mobile": mobileController.text,
                                "department": department ?? "N/A",
                                "specialization": specializationController.text,
                                "status": "Active",
                                "additional": additionalController.text
                              });
                            });
                          }
                          _applyFilters();
                          fullNameController.clear();
                          emailController.clear();
                          mobileController.clear();
                          specializationController.clear();
                          additionalController.clear();
                          department = null;
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        lecturer == null ? "Save Lecturer" : "Update Lecturer",
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _applyFilters() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredLecturers = lecturers.where((lecturer) {
        final matchesSearch = lecturer['name']!.toLowerCase().contains(query) ||
            lecturer['email']!.toLowerCase().contains(query) ||
            lecturer['department']!.toLowerCase().contains(query) ||
            lecturer['specialization']!.toLowerCase().contains(query);

        final matchesStatus =
            selectedStatus == "All" || lecturer['status'] == selectedStatus;
        final matchesDepartment =
            selectedDepartment == "All" || lecturer['department'] == selectedDepartment;

        return matchesSearch && matchesStatus && matchesDepartment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lecturer Management"),
        backgroundColor: const Color(0xFF6A11CB),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              onPressed: () => _showAddLecturerForm(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add New Lecturer", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard("Total Lecturers", "${lecturers.length}", Colors.blue.shade100, Icons.people, Colors.blue),
                buildStatCard("Active Lecturers",
                    "${lecturers.where((e) => e['status'] == 'Active').length}", Colors.green.shade100, Icons.check_circle, Colors.green),
                buildStatCard("With Classes", "0", Colors.purple.shade100, Icons.class_, Colors.purple),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard("Departments", "${lecturers.map((e) => e['department']).toSet().length}", Colors.orange.shade100, Icons.apartment, Colors.orange),
                buildStatCard("Inactive", "${lecturers.where((e) => e['status'] == 'Inactive').length}", Colors.red.shade100, Icons.cancel, Colors.red),
              ],
            ),
            const SizedBox(height: 20),

            // Search & Filter Section
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: "Search (name, email, dept, specialization)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (_) => _applyFilters(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        value: selectedStatus,
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All Status")),
                          DropdownMenuItem(value: "Active", child: Text("Active")),
                          DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
                        ],
                        onChanged: (val) {
                          selectedStatus = val!;
                          _applyFilters();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        value: selectedDepartment,
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All Departments")),
                          DropdownMenuItem(value: "CS", child: Text("Computer Science")),
                          DropdownMenuItem(value: "IT", child: Text("Information Technology")),
                          DropdownMenuItem(value: "Math", child: Text("Mathematics")),
                        ],
                        onChanged: (val) {
                          selectedDepartment = val!;
                          _applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Lecturer Table
            Text("Lecturer Details (${filteredLecturers.length})",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                  columns: const [
                    DataColumn(label: Text("LECTURER")),
                    DataColumn(label: Text("DEPARTMENT")),
                    DataColumn(label: Text("SPECIALIZATION")),
                    DataColumn(label: Text("MOBILE")),
                    DataColumn(label: Text("STATUS")),
                    DataColumn(label: Text("ACTIONS")),
                  ],
                  rows: filteredLecturers.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> lecturer = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(lecturer["name"] ?? "")),
                      DataCell(Text(lecturer["department"] ?? "")),
                      DataCell(Text(lecturer["specialization"] ?? "")),
                      DataCell(Text(lecturer["mobile"] ?? "")),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: lecturer["status"] == "Active"
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          lecturer["status"] ?? "",
                          style: TextStyle(
                              color: lecturer["status"] == "Active" ? Colors.green : Colors.red),
                        ),
                      )),
                      DataCell(Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showAddLecturerForm(lecturer: lecturer, index: index)),
                          IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  lecturers.removeAt(index);
                                  _applyFilters();
                                });
                              }),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard(
      String title, String value, Color bgColor, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 10),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22, color: iconColor)),
              const SizedBox(height: 6),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }
}
