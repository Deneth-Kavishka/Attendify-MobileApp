import 'package:flutter/material.dart';

class HardwareStatusPage extends StatelessWidget {
  const HardwareStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Hardware Status",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Top Stats ----------
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: const [
                    _StatCard(
                      icon: Icons.devices,
                      title: "Total Devices",
                      value: "2",
                      color1: Colors.blue,
                      color2: Colors.lightBlueAccent,
                    ),
                    _StatCard(
                      icon: Icons.wifi,
                      title: "Online Devices",
                      value: "2",
                      color1: Colors.green,
                      color2: Colors.lightGreen,
                    ),
                    _StatCard(
                      icon: Icons.qr_code_scanner,
                      title: "Daily Scans",
                      value: "0",
                      color1: Colors.purple,
                      color2: Colors.deepPurpleAccent,
                    ),
                    _StatCard(
                      icon: Icons.health_and_safety,
                      title: "System Health",
                      value: "95%",
                      color1: Colors.red,
                      color2: Colors.pinkAccent,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ---------- Device Management ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Device Management",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.blue),
                          onPressed: () {},
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Device"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------- Search & Filter ----------
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search devices by ID or location...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: "All Devices",
                          items: const [
                            DropdownMenuItem(
                                value: "All Devices", child: Text("All Devices")),
                            DropdownMenuItem(
                                value: "ESP32-CAM", child: Text("ESP32-CAM")),
                            DropdownMenuItem(
                                value: "RFID Reader", child: Text("RFID Reader")),
                          ],
                          onChanged: (val) {},
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- Devices ----------
                isWide
                    ? _DeviceTable(devices: demoDevices)
                    : Column(
                        children: demoDevices
                            .map((d) => _DeviceCard(device: d))
                            .toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------- Data Model ----------------
class Device {
  final String name, type, location, status, lastActive;
  final int performance;

  Device({
    required this.name,
    required this.type,
    required this.location,
    required this.status,
    required this.lastActive,
    required this.performance,
  });
}

final demoDevices = [
  Device(
      name: "ESP32_CAM_001",
      type: "ESP32-CAM",
      location: "Room A101",
      status: "Online",
      performance: 67,
      lastActive: "Aug 26, 12:09"),
  Device(
      name: "RFID_READER_001",
      type: "RFID Reader",
      location: "Main Entrance",
      status: "Online",
      performance: 83,
      lastActive: "Aug 26, 12:09"),
];

// ---------------- Widgets ----------------

// Stat Card (Gradient, Rounded)
class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color1, color2;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.white70)),
        ],
      ),
    );
  }
}

// Device Table (Desktop/Tablet)
class _DeviceTable extends StatelessWidget {
  final List<Device> devices;
  const _DeviceTable({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              MaterialStateProperty.all(Colors.blue.shade50),
          columns: const [
            DataColumn(label: Text("Device")),
            DataColumn(label: Text("Type")),
            DataColumn(label: Text("Location")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Last Active")),
            DataColumn(label: Text("Performance")),
            DataColumn(label: Text("Actions")),
          ],
          rows: devices.map((d) {
            return DataRow(cells: [
              DataCell(Text(d.name)),
              DataCell(Text(d.type)),
              DataCell(Text(d.location)),
              DataCell(Row(
                children: [
                  Icon(Icons.circle,
                      size: 12,
                      color: d.status == "Online" ? Colors.green : Colors.red),
                  const SizedBox(width: 5),
                  Text(d.status),
                ],
              )),
              DataCell(Text(d.lastActive)),
              DataCell(SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  value: d.performance / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              )),
              DataCell(Row(
                children: const [
                  Icon(Icons.settings, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Icon(Icons.restart_alt, size: 18, color: Colors.orange),
                  SizedBox(width: 8),
                  Icon(Icons.delete, color: Colors.red, size: 18),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

// Device Card (Mobile)
class _DeviceCard extends StatelessWidget {
  final Device device;
  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(device.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(Icons.devices, color: Colors.blue.shade400),
              ],
            ),
            const SizedBox(height: 8),
            Text("Type: ${device.type}"),
            Text("Location: ${device.location}"),
            Row(
              children: [
                Icon(Icons.circle,
                    size: 12,
                    color: device.status == "Online"
                        ? Colors.green
                        : Colors.red),
                const SizedBox(width: 6),
                Text(device.status,
                    style: TextStyle(
                        color: device.status == "Online"
                            ? Colors.green
                            : Colors.red)),
              ],
            ),
            Text("Last Active: ${device.lastActive}"),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: device.performance / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.settings, size: 20, color: Colors.grey),
                SizedBox(width: 12),
                Icon(Icons.restart_alt, size: 20, color: Colors.orange),
                SizedBox(width: 12),
                Icon(Icons.delete, color: Colors.red, size: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}
