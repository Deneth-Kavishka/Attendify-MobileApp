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

  // Hardware Configuration
  String _selectedResolution = "VGA (640x480)";
  final _frameRateController = TextEditingController(text: "10");
  final _imageQualityController = TextEditingController(text: "10");
  final _faceRecognitionThresholdController = TextEditingController(
    text: "0.8",
  );
  bool _faceDetectionEnabled = true;
  bool _autoRestartCamEnabled = false;

  // RFID Settings
  String _selectedReadRange = "Medium (3-7 cm)";
  final _scanIntervalController = TextEditingController(text: "2");
  final _duplicateCardDelayController = TextEditingController(text: "3");
  String _selectedSignalStrength = "High";
  bool _autoRestartRFIDEnabled = false;

  final List<String> _readRanges = [
    "Short (1-3 cm)",
    "Medium (3-7 cm)",
    "Long (7-15 cm)",
  ];
  final List<String> _signalStrengths = ["Low", "Medium", "High"];

  // Network Settings
  final _connectionTimeoutController = TextEditingController(text: "10");
  final _retryAttemptsController = TextEditingController(text: "3");
  bool _dataEncryptionEnabled = true;
  bool _dataCompressionEnabled = true;

  final List<String> _resolutions = [
    "VGA (640x480)",
    "SVGA (800x600)",
    "XGA (1024x768)",
    "UXGA (1600x1200)",
  ];

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
    _frameRateController.dispose();
    _imageQualityController.dispose();
    _faceRecognitionThresholdController.dispose();
    _scanIntervalController.dispose();
    _duplicateCardDelayController.dispose();
    _connectionTimeoutController.dispose();
    _retryAttemptsController.dispose();
    super.dispose();
  }

  // ---------------- Helpers ----------------
  String _formatDate(DateTime dt) {
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
    TextInputType keyboardType = TextInputType.number,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: value,
      items: items.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: onChanged,
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

  // ---------------- Hardware Tab ----------------
  Widget _buildHardwareTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSubsectionCard(
            title: "ESP32-CAM Settings",
            icon: Icons.camera_alt,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: "Camera Resolution",
                      value: _selectedResolution,
                      items: _resolutions,
                      onChanged: (val) {
                        setState(() => _selectedResolution = val!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Frame Rate (FPS)",
                      controller: _frameRateController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Image Quality (1-63, lower = better)",
                      controller: _imageQualityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Face Recognition Threshold",
                      controller: _faceRecognitionThresholdController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              _buildSwitchTile(
                title: "Face Detection",
                subtitle: "Enable automatic face detection",
                value: _faceDetectionEnabled,
                onChanged: (val) {
                  setState(() => _faceDetectionEnabled = val);
                },
              ),
              _buildSwitchTile(
                title: "Auto Restart",
                subtitle: "Automatically restart on errors",
                value: _autoRestartCamEnabled,
                onChanged: (val) {
                  setState(() => _autoRestartCamEnabled = val);
                },
              ),
            ],
          ),
          _buildSubsectionCard(
            title: "RFID Reader Settings",
            icon: Icons.credit_card,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: "Read Range",
                      value: _selectedReadRange,
                      items: _readRanges,
                      onChanged: (val) {
                        setState(() => _selectedReadRange = val!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Scan Interval (seconds)",
                      controller: _scanIntervalController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Duplicate Card Delay (seconds)",
                      controller: _duplicateCardDelayController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      label: "Signal Strength",
                      value: _selectedSignalStrength,
                      items: _signalStrengths,
                      onChanged: (val) {
                        setState(() => _selectedSignalStrength = val!);
                      },
                    ),
                  ),
                ],
              ),
              _buildSwitchTile(
                title: "Auto Restart",
                subtitle: "Automatically restart on errors",
                value: _autoRestartRFIDEnabled,
                onChanged: (val) {
                  setState(() => _autoRestartRFIDEnabled = val);
                },
              ),
            ],
          ),
          _buildSubsectionCard(
            title: "Network Settings",
            icon: Icons.network_check,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Connection Timeout (seconds)",
                      controller: _connectionTimeoutController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Retry Attempts",
                      controller: _retryAttemptsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _buildSwitchTile(
                title: "Data Encryption",
                subtitle: "Encrypt data transmission",
                value: _dataEncryptionEnabled,
                onChanged: (val) {
                  setState(() => _dataEncryptionEnabled = val);
                },
              ),
              _buildSwitchTile(
                title: "Data Compression",
                subtitle: "Compress transmitted data",
                value: _dataCompressionEnabled,
                onChanged: (val) {
                  setState(() => _dataCompressionEnabled = val);
                },
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
                    _selectedResolution = "VGA (640x480)";
                    _frameRateController.text = "10";
                    _imageQualityController.text = "10";
                    _faceRecognitionThresholdController.text = "0.8";
                    _faceDetectionEnabled = true;
                    _autoRestartCamEnabled = false;

                    _selectedReadRange = "Medium (3-7 cm)";
                    _scanIntervalController.text = "2";
                    _duplicateCardDelayController.text = "3";
                    _selectedSignalStrength = "High";
                    _autoRestartRFIDEnabled = true;

                    _connectionTimeoutController.text = "10";
                    _retryAttemptsController.text = "3";
                    _dataEncryptionEnabled = true;
                    _dataCompressionEnabled = true;
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
                      content: Text("Hardware settings saved successfully"),
                    ),
                  );
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Save & Update Hardware",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubsectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
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
              const Text(
                "User Management",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text("Manage user accounts, roles, and permissions"),
              const SizedBox(height: 12),

              // Summary
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

              // Actions
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

              // Table
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
                                          Text(
                                            entry.value['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            entry.value['email'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(entry.value['role'])),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: entry.value['status']
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () =>
                                                _openEditUser(entry.key),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(
                                                () =>
                                                    _users.removeAt(entry.key),
                                              );
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

  // ---------------- Maintenance Tab ----------------
  Widget _buildMaintenanceTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSectionCard(
                title: "Database Backup",
                children: [
                  const Text("Last backup: Yesterday at 3:00 AM"),
                  const Text(
                    "Automatic backups run daily at 3:00 AM",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Backup created successfully"),
                          ),
                        );
                      },
                      child: const Text(
                        "Create Backup Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              _buildSectionCard(
                title: "System Maintenance",
                children: [
                  ListTile(
                    title: const Text("Clean System Logs"),
                    subtitle: const Text(
                      "Remove old log files and free up space",
                    ),
                    trailing: OutlinedButton(
                      child: const Text("Clean Logs"),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    title: const Text("Optimize Database"),
                    subtitle: const Text(
                      "Optimize database tables and indexes",
                    ),
                    trailing: OutlinedButton(
                      child: const Text("Optimize Now"),
                      onPressed: () {},
                    ),
                  ),
                  ListTile(
                    title: const Text("System Health Check"),
                    subtitle: const Text("Run comprehensive diagnostics"),
                    trailing: OutlinedButton(
                      child: const Text("Run Diagnostics"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              _buildSectionCard(
                title: "System Information",
                children: [
                  _infoRow("System Version", "SmartTrack v2.1.0", isMobile),
                  _infoRow("Uptime", "7 days, 14 hours", isMobile),
                  _infoRow("Database Size", "45.7 MB", isMobile),
                  _infoRow("Connected Devices", "8 devices online", isMobile),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String key, String value, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(value, style: const TextStyle(color: Colors.grey)),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(value, style: const TextStyle(color: Colors.grey)),
              ],
            ),
    );
  }

  // ---------------- Main Build ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "System Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
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
                          child: _buildDropdownField(
                            label: "Timezone",
                            value: _selectedTimezone,
                            items: _timezones,
                            onChanged: (val) {
                              setState(() => _selectedTimezone = val!);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: "Date Format",
                            value: _selectedDateFormat,
                            items: _dateFormats,
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
          _buildHardwareTab(),

          // ---------------- Users Tab ----------------
          _buildUsersTab(),

          // ---------------- Maintenance Tab ----------------
          _buildMaintenanceTab(),
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
                    DropdownMenuItem(
                      value: 'Lecturer',
                      child: Text('Lecturer'),
                    ),
                    DropdownMenuItem(value: 'Student', child: Text('Student')),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() => _role = val!);
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text("Active Status"),
                  value: _status,
                  onChanged: (val) {
                    setState(() => _status = val);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'role': _role,
                'status': _status,
              });
            }
          },
          child: Text(widget.existing == null ? "Add User" : "Save Changes"),
        ),
      ],
    );
  }
}
