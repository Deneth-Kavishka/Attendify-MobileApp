import 'package:flutter/material.dart';

class NewClassPage extends StatefulWidget {
  const NewClassPage({super.key});

  @override
  State<NewClassPage> createState() => _NewClassPageState();
}

class _NewClassPageState extends State<NewClassPage> {
  // --- Form Controllers (for demonstration) ---
  final TextEditingController _classCodeController =
      TextEditingController(text: "CS101");
  final TextEditingController _classNameController =
      TextEditingController(text: "Introduction to Computer Science");
  final TextEditingController _roomController =
      TextEditingController(text: "Room 101, Building A");
  final TextEditingController _academicYearController =
      TextEditingController(text: "2025");
  final TextEditingController _capacityController =
      TextEditingController(text: "50");
  final TextEditingController _descriptionController =
      TextEditingController(text: "Course description and objectives...");
  final TextEditingController _prerequisitesController = TextEditingController(
      text: "Required courses or knowledge before taking this class...");

  String? _selectedLecturer;
  String? _selectedSemester;

  @override
  void dispose() {
    _classCodeController.dispose();
    _classNameController.dispose();
    _roomController.dispose();
    _academicYearController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
    _prerequisitesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  constraints.maxWidth > 800 ? 800 : constraints.maxWidth * 0.9,
              maxHeight: constraints.maxHeight * 0.9,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Create New Class",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 76, 28, 121)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                  _buildTabBar(),
                  const SizedBox(height: 24),
                  _buildBasicInfoSection(constraints),
                  const SizedBox(height: 30),
                  _buildActionButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem("Basic Info", true),
          _buildTabItem("Schedule", false),
          _buildTabItem("Hardware", false),
          _buildTabItem("Settings", false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: isActive
          ? BoxDecoration(
              color: const Color.fromARGB(255, 76, 28, 121),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            )
          : null,
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BoxConstraints constraints) {
    bool isLargeScreen = constraints.maxWidth > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Class Code & Class Name
        _buildResponsiveRow(
          isLargeScreen,
          [
            _buildTextField("Class Code *", _classCodeController,
                hint: "e.g., CS101"),
            _buildTextField("Class Name *", _classNameController,
                hint: "e.g., Introduction to Computer Science"),
          ],
        ),
        const SizedBox(height: 20),

        // Lecturer & Room
        _buildResponsiveRow(
          isLargeScreen,
          [
            _buildDropdownField(
              "Lecturer *",
              _selectedLecturer,
              ["Dr. Smith", "Prof. Johnson", "Ms. Davis"],
              (String? newValue) {
                setState(() {
                  _selectedLecturer = newValue;
                });
              },
              hint: "Select lecturer",
            ),
            _buildTextField("Room *", _roomController, hint: "e.g., Room 101"),
          ],
        ),
        const SizedBox(height: 20),

        // Semester, Academic Year & Capacity
        _buildResponsiveRow(
          isLargeScreen,
          [
            _buildDropdownField(
              "Semester *",
              _selectedSemester,
              ["Fall 2024", "Spring 2025", "Summer 2025"],
              (String? newValue) {
                setState(() {
                  _selectedSemester = newValue;
                });
              },
              hint: "Select semester",
            ),
            _buildTextField("Academic Year *", _academicYearController,
                hint: "e.g., 2025"),
            _buildTextField("Capacity", _capacityController,
                hint: "e.g., 50", keyboardType: TextInputType.number),
          ],
        ),
        const SizedBox(height: 20),

        // Description
        _buildTextField("Description", _descriptionController,
            hint: "Course description and objectives...", maxLines: 4),
        const SizedBox(height: 20),

        // Prerequisites
        _buildTextField("Prerequisites", _prerequisitesController,
            hint: "Required courses or knowledge before taking this class...",
            maxLines: 3),
      ],
    );
  }

  Widget _buildResponsiveRow(bool isLargeScreen, List<Widget> children) {
    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map((child) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: child,
                  ),
                ))
            .toList(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: child,
                )).toList(),
      );
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 76, 28, 121), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? currentValue,
    List<String> items,
    ValueChanged<String?> onChanged, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 76, 28, 121), width: 2),
            ),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        const SizedBox(width: 15),
        ElevatedButton.icon(
          onPressed: () {
            // Implement class creation logic here
            Navigator.pop(context); // Close dialog after creation
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Create Class",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 76, 28, 121),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
        ),
      ],
    );
  }
}