import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddNewStudentPage extends StatefulWidget {
  const AddNewStudentPage({super.key});

  @override
  State<AddNewStudentPage> createState() => _AddNewStudentPageState();
}

class _AddNewStudentPageState extends State<AddNewStudentPage> {
  final _formKey = GlobalKey<FormState>();

  List<PlatformFile> _selectedImages = [];

  // For RFID selection
  String _rfidOption = "none";
  final TextEditingController _rfidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text(
          "Student Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 88, 28, 167),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _SectionCard(
                title: "Basic Information",
                color: Colors.white,
                icon: Icons.info,
                children: [
                  _ResponsiveRow(
                    children: [
                      _buildTextField("Full Name *", "Enter full name",
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Full name is required";
                        }
                        return null;
                      }),
                      _buildTextField("Email Address *", "student@university.edu",
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      }),
                    ],
                  ),
                  _ResponsiveRow(
                    children: [
                      _buildTextField("Student ID *", "e.g., STU2024001",
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Student ID is required";
                        }
                        return null;
                      }),
                      _buildDropdown("Department *", [
                        "Computer Science",
                        "Engineering",
                        "Business",
                        "Mathematics",
                        "Arts",
                      ]),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _SectionCard(
                title: "Personal Information",
                color: Colors.white,
                icon: Icons.person,
                children: [
                  _ResponsiveRow(
                    children: [
                      _buildTextField(
                        "National Identity Card (NIC) *",
                        "e.g., 200012345678 or 991234567V",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NIC is required";
                          }
                          final nicRegex =
                              RegExp(r'^(\d{12}|\d{9}[vV])$'); // 12 digits or 9 + V
                          if (!nicRegex.hasMatch(value)) {
                            return "Invalid NIC format";
                          }
                          return null;
                        },
                      ),
                      _buildTextField("Mobile Number *", "e.g., +94 77 123 4567",
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mobile number is required";
                        }
                        final phoneRegex = RegExp(r'^(\+94|0)\d{9}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter valid Sri Lankan mobile number";
                        }
                        return null;
                      }),
                    ],
                  ),
                  _ResponsiveRow(
                    children: [
                      _buildDropdown("Gender *", ["Male", "Female", "Other"]),
                      _buildDatePicker(context, "Date of Birth *"),
                    ],
                  ),
                  _buildTextField("Address", "Complete residential address",
                      maxLines: 2),
                  _ResponsiveRow(
                    children: [
                      _buildTextField("Guardian Name", "Parent/Guardian full name"),
                      _buildTextField("Guardian Contact", "Guardian mobile number"),
                    ],
                  ),
                  _buildTextField("Emergency Contact", "Emergency contact number"),
                ],
              ),

              const SizedBox(height: 20),

              _SectionCard(
                title: "Academic Information",
                color: Colors.white,
                icon: Icons.school,
                children: [
                  _ResponsiveRow(
                    children: [
                      _buildTextField("Enrollment Year *", "2025",
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enrollment year is required";
                        }
                        return null;
                      }),
                      _buildTextField("Batch", "e.g., 2024A, 2024B"),
                      _buildDropdown("Current Semester", [
                        "Semester 1",
                        "Semester 2",
                        "Semester 3",
                        "Semester 4",
                      ]),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _SectionCard(
                title: "RFID Card Assignment",
                color: Colors.white,
                icon: Icons.credit_card,
                children: [
                  Column(
                    children: [
                      RadioListTile(
                        title: const Text("No RFID Card (Face Recognition Only)"),
                        value: "none",
                        groupValue: _rfidOption,
                        onChanged: (val) {
                          setState(() => _rfidOption = val!);
                        },
                      ),
                      RadioListTile(
                        title: const Text("Generate New RFID Card"),
                        value: "generate",
                        groupValue: _rfidOption,
                        onChanged: (val) {
                          setState(() => _rfidOption = val!);
                        },
                      ),
                      RadioListTile(
                        title: const Text("Enter Manually"),
                        value: "manual",
                        groupValue: _rfidOption,
                        onChanged: (val) {
                          setState(() => _rfidOption = val!);
                        },
                      ),
                      if (_rfidOption == "manual")
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: TextFormField(
                            controller: _rfidController,
                            decoration: InputDecoration(
                              labelText: "RFID Number",
                              hintText: "Enter RFID manually",
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (_rfidOption == "manual" &&
                                  (value == null || value.isEmpty)) {
                                return "RFID number is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      RadioListTile(
                        title: const Text("Scan RFID Card"),
                        value: "scan",
                        groupValue: _rfidOption,
                        onChanged: (val) {
                          setState(() => _rfidOption = val!);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _SectionCard(
                title: "Face Recognition Training Setup",
                color: Colors.white,
                icon: Icons.camera_alt,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📌 Face Recognition Requirements:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 6),
                        Text("• Minimum 10 images required for accurate recognition"),
                        Text("• Maximum 15 images allowed"),
                        Text("• Use clear, well-lit photos facing directly at camera"),
                        Text("• Vary slight angles and expressions for better training"),
                        Text("• Remove glasses, hats, or coverings if possible"),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Face Training Images (${_selectedImages.length}/15) * (Min: 10)",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: _selectedImages.isEmpty
                                    ? "No files chosen"
                                    : "${_selectedImages.length} file(s) selected",
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _pickFiles,
                            child: const Text("Choose Files"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_selectedImages.isNotEmpty)
                        Container(
                          height: 120,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ListView.builder(
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Text(
                                "• ${_selectedImages[index].name}",
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text("Training Data Progress",
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _selectedImages.isEmpty
                            ? 0
                            : _selectedImages.length / 15,
                        backgroundColor: Colors.grey.shade300,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${_selectedImages.length}/10 minimum",
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedImages.length < 10
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                  const Text("Active Student"),
                  const SizedBox(width: 8),
                  const Text(
                    "(Student can access the system and mark attendance)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color.fromARGB(255, 76, 28, 121),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Register Student",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedImages.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please upload at least 10 images for face recognition."),
                          ),
                        );
                      } else {
                        // ✅ Handle form submission with valid data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Form Submitted Successfully ✅"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        if (result.files.length > 15) {
          _selectedImages = result.files.sublist(0, 15);
        } else {
          _selectedImages = result.files;
        }
      });
    }
  }

  static Widget _buildTextField(String label, String hint,
      {int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: (val) {},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select $label";
        }
        return null;
      },
    );
  }

  static Widget _buildDatePicker(BuildContext context, String label) {
    final controller = TextEditingController();
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: "mm/dd/yyyy",
        suffixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Date of Birth is required";
        }
        return null;
      },
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime(2000),
        );
        if (pickedDate != null) {
          controller.text =
              "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
        }
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  const _ResponsiveRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return Row(
          children: children
              .map((child) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 12),
                      child: child,
                    ),
                  ))
              .toList(),
        );
      } else {
        return Column(
          children: children
              .map((child) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: child,
                  ))
              .toList(),
        );
      }
    });
  }
}
