import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _examEligibilityController = TextEditingController(text: "75");
  final _sessionTimeoutController = TextEditingController(text: "30");
  final _maxLoginAttemptsController = TextEditingController(text: "5");

  // System Behavior toggles
  bool _autoBackup = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _maintenanceMode = false;

  // Display Settings
  String _selectedTimezone = "UTC";
  String _selectedDateFormat = "MM/DD/YYYY";

  final List<String> _timezones = ["UTC", "GMT", "EST", "CST", "PST"];
  final List<String> _dateFormats = ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY-MM-DD"];

  // ---------------- User Management Data ----------------
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'John Admin',
      'email': 'admin@smartrack.com',
      'role': 'Admin',
      'status': true,
      'lastLogin': '8/26/2025',
    },
    {
      'name': 'Sarah Lecturer',
      'email': 'sarah@university.edu',
      'role': 'Lecturer',
      'status': true,
      'lastLogin': '8/26/2025',
    },
    {
      'name': 'Mike Student',
      'email': 'mike@student.edu',
      'role': 'Student',
      'status': true,
      'lastLogin': '8/26/2025',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _examEligibilityController.dispose();
    _sessionTimeoutController.dispose();
    _maxLoginAttemptsController.dispose();
    super.dispose();
  }

  // ---------------- Helpers ----------------
  String _formatDate(DateTime dt) {
    // Simple M/D/YYYY (no intl dependency)
    return "${dt.month}/${dt.day}/${dt.year}";
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepPurple,
    );
  }

  // ---------------- Users Tab ----------------
  Widget _buildUsersTab() {
    int adminCount = _users.where((u) => u['role'] == 'Admin').length;
    int lecturerCount = _users.where((u) => u['role'] == 'Lecturer').length;
    int studentCount = _users.where((u) => u['role'] == 'Student').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("User Management",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Manage user accounts, roles, and permissions"),
              const SizedBox(height: 12),

              // Summary chips/cards responsive
              if (isMobile)
                Column(
                  children: [
                    _summaryCard("Administrators", adminCount, Colors.blue),
                    _summaryCard("Lecturers", lecturerCount, Colors.green),
                    _summaryCard("Students", studentCount, Colors.purple),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _summaryCard("Administrators", adminCount, Colors.blue),
                    _summaryCard("Lecturers", lecturerCount, Colors.green),
                    _summaryCard("Students", studentCount, Colors.purple),
                  ],
                ),

              const SizedBox(height: 12),

              // Actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.group),
                    label: const Text("Bulk Actions"),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    label: const Text(
                      "Add User",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _openAddUser,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Data table with both vertical & horizontal scroll
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isMobile ? 600 : constraints.maxWidth,
                        ),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("User")),
                            DataColumn(label: Text("Role")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Last Login")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: _users
                              .asMap()
                              .entries
                              .map(
                                (entry) => DataRow(
                                  cells: [
                                    DataCell(
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(entry.value['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(entry.value['email'],
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(entry.value['role'])),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: entry.value['status']
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          entry.value['status']
                                              ? "Active"
                                              : "Inactive",
                                          style: TextStyle(
                                            color: entry.value['status']
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(entry.value['lastLogin'])),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.orange),
                                            onPressed: () =>
                                                _openEditUser(entry.key),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() =>
                                                  _users.removeAt(entry.key));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddUser() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _UserDialog(),
    );

    if (result != null) {
      // Add lastLogin for new users (today)
      result['lastLogin'] = _formatDate(DateTime.now());
      setState(() => _users.add(result));
    }
  }

  void _openEditUser(int index) async {
    final existing = _users[index];
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _UserDialog(existing: existing),
    );

    if (result != null) {
      // Preserve lastLogin for edits
      result['lastLogin'] = existing['lastLogin'];
      setState(() => _users[index] = result);
    }
  }

  Widget _summaryCard(String title, int count, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              "$count",
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Main Build ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Settings"),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "System"),
            Tab(text: "Hardware"),
            Tab(text: "Users"),
            Tab(text: "Maintenance"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ---------------- System Tab ----------------
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSectionCard(
                  title: "Attendance Settings",
                  children: [
                    _buildTextField(
                      label: "Exam Eligibility Threshold (%)",
                      controller: _examEligibilityController,
                      helper:
                          "Minimum attendance percentage required for exam eligibility",
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "Security Settings",
                  children: [
                    _buildTextField(
                      label: "Session Timeout (minutes)",
                      controller: _sessionTimeoutController,
                    ),
                    _buildTextField(
                      label: "Maximum Login Attempts",
                      controller: _maxLoginAttemptsController,
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "System Behavior",
                  children: [
                    _buildSwitchTile(
                      title: "Automatic Backup",
                      subtitle: "Enable daily automatic backups",
                      value: _autoBackup,
                      onChanged: (val) {
                        setState(() => _autoBackup = val);
                      },
                    ),
                    _buildSwitchTile(
                      title: "Email Notifications",
                      subtitle: "Send system alerts via email",
                      value: _emailNotifications,
                      onChanged: (val) {
                        setState(() => _emailNotifications = val);
                      },
                    ),
                    _buildSwitchTile(
                      title: "SMS Notifications",
                      subtitle: "Send critical alerts via SMS",
                      value: _smsNotifications,
                      onChanged: (val) {
                        setState(() => _smsNotifications = val);
                      },
                    ),
                    _buildSwitchTile(
                      title: "Maintenance Mode",
                      subtitle: "Put system in maintenance mode",
                      value: _maintenanceMode,
                      onChanged: (val) {
                        setState(() => _maintenanceMode = val);
                      },
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "Display Settings",
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedTimezone,
                            decoration: InputDecoration(
                              labelText: "Timezone",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _timezones
                                .map(
                                  (tz) => DropdownMenuItem(
                                    value: tz,
                                    child: Text(tz),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() => _selectedTimezone = val!);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedDateFormat,
                            decoration: InputDecoration(
                              labelText: "Date Format",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _dateFormats
                                .map(
                                  (fmt) => DropdownMenuItem(
                                    value: fmt,
                                    child: Text(fmt),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() => _selectedDateFormat = val!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _autoBackup = true;
                          _emailNotifications = true;
                          _smsNotifications = false;
                          _maintenanceMode = false;
                          _selectedTimezone = "UTC";
                          _selectedDateFormat = "MM/DD/YYYY";
                          _examEligibilityController.text = "75";
                          _sessionTimeoutController.text = "30";
                          _maxLoginAttemptsController.text = "5";
                        });
                      },
                      child: const Text("Reset Changes"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Settings saved successfully"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Save Configuration",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------- Hardware Tab ----------------
          const Center(
            child: Text(
              "Hardware settings coming soon...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),

          // ---------------- Users Tab ----------------
          _buildUsersTab(),

          // ---------------- Maintenance Tab ----------------
          const Center(
            child: Text(
              "Maintenance settings coming soon...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Add/Edit User Dialog ----------------
class _UserDialog extends StatefulWidget {
  const _UserDialog({this.existing});
  final Map<String, dynamic>? existing;

  @override
  State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _role = 'Student';
  bool _status = true;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _nameController.text = widget.existing!['name'] ?? '';
      _emailController.text = widget.existing!['email'] ?? '';
      _role = widget.existing!['role'] ?? 'Student';
      _status = widget.existing!['status'] ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) => "${dt.month}/${dt.day}/${dt.year}";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.existing == null ? "Add User" : "Edit User"),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Enter a name" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Enter an email";
                    }
                    final email = v.trim();
                    final ok = RegExp(r"^[^@]+@[^@]+\.[^@]+$").hasMatch(email);
                    return ok ? null : "Enter a valid email";
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _role,
                  items: const [
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'Lecturer', child: Text('Lecturer')),
                    DropdownMenuItem(value: 'Student', child: Text('Student')),
                  ],
                  onChanged: (v) => setState(() => _role = v ?? 'Student'),
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Active"),
                  value: _status,
                  onChanged: (v) => setState(() => _status = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: Text(widget.existing == null ? "Save" : "Update"),
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;

            final map = <String, dynamic>{
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'role': _role,
              'status': _status,
              // If adding, set now; if editing, keep original (caller may overwrite)
              'lastLogin': widget.existing?['lastLogin'] ??
                  _formatDate(DateTime.now()),
            };

            Navigator.of(context).pop(map);
          },
        ),
      ],
    );
  }
}
