import 'package:flutter/material.dart';

class HardwareStatusPage extends StatelessWidget {
  const HardwareStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hardware Status Management")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600; // Responsive breakpoint

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Top Stats Row ----------
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _StatCard(
                      icon: Icons.devices,
                      title: "Total Devices",
                      value: "2",
                      color: Colors.blue,
                    ),
                    _StatCard(
                      icon: Icons.wifi,
                      title: "Online Devices",
                      value: "2",
                      color: Colors.green,
                    ),
                    _StatCard(
                      icon: Icons.qr_code_scanner,
                      title: "Daily Scans",
                      value: "0",
                      color: Colors.purple,
                    ),
                    _StatCard(
                      icon: Icons.health_and_safety,
                      title: "System Health",
                      value: "95%",
                      color: Colors.red,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- Device Management Header ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Device Management",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {},
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Device"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ---------- Search & Filter ----------
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search devices by ID or location...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
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
                  ],
                ),
                const SizedBox(height: 20),

                // ---------- Devices Table or Cards ----------
                isWide
                    ? _DeviceTable(devices: demoDevices) // Table for wide screen
                    : Column(
                        children: demoDevices
                            .map((d) => _DeviceCard(device: d))
                            .toList(),
                      ), // Cards for small screen
              ],
            ),
          );
        },
      ),
    );
  }
}

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

// Sample demo data
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

// Stat Card
class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Device Table (for desktop/tablet)
class _DeviceTable extends StatelessWidget {
  final List<Device> devices;
  const _DeviceTable({required this.devices});

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
          DataCell(LinearProgressIndicator(
            value: d.performance / 100,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
          )),
          DataCell(Row(
            children: const [
              Icon(Icons.settings, size: 18),
              SizedBox(width: 8),
              Icon(Icons.restart_alt, size: 18),
              SizedBox(width: 8),
              Icon(Icons.delete, color: Colors.red, size: 18),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}

// Device Card (for mobile)
class _DeviceCard extends StatelessWidget {
  final Device device;
  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                Text(device.status),
              ],
            ),
            Text("Last Active: ${device.lastActive}"),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: device.performance / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.settings, size: 18),
                SizedBox(width: 8),
                Icon(Icons.restart_alt, size: 18),
                SizedBox(width: 8),
                Icon(Icons.delete, color: Colors.red, size: 18),
              ],
            )
          ],
        ),
      ),
    );
  }
}
