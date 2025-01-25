import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({super.key});

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _identificationNumberController =
      TextEditingController();
  final TextEditingController _passportNumberController =
      TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  Uint8List? _idFrontPhoto;
  Uint8List? _idRearPhoto;
  Uint8List? _passportPhoto;
  final ImagePicker _picker = ImagePicker();
  bool _showIdentificationField = false;
  bool _showPassportField = false;
  final List<Map<String, String>> nationalities = [
    {"name": "American"},
    {"name": "British"},
    {"name": "Canadian"},
    {"name": "Chinese"},
    {"name": "French"},
    {"name": "German"},
    {"name": "Indian"},
    {"name": "Japanese"},
    {"name": "Korean"},
    {"name": "Vietnamese"},
  ];
  List<Map<String, String>> filteredNationalities = [];

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nationalityController.dispose();
    _identificationNumberController.dispose();
    _passportNumberController.dispose();
    _bankCodeController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  void filterNationalities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNationalities = [];
      } else {
        filteredNationalities = nationalities
            .where((nationality) => nationality['name']!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
    if (filteredNationalities.isNotEmpty) {
      _showNationalityDialog();
    }
  }

  void _showNationalityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Nationality'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filteredNationalities.map((nationality) {
              return ListTile(
                title: Text(nationality['name']!),
                onTap: () {
                  setState(() {
                    _nationalityController.text = nationality['name']!;
                    filteredNationalities = [];
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(String photoType) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      setState(() {
        if (photoType == 'idFront') {
          _idFrontPhoto = imageBytes;
        } else if (photoType == 'idRear') {
          _idRearPhoto = imageBytes;
        } else if (photoType == 'passport') {
          _passportPhoto = imageBytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return DefaultTabController(
      length: 2, // Length of tabs
      child: Scaffold(
        backgroundColor: Colors.white, // Set background color to white
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            backgroundColor: Colors.white, // AppBar background color to white
            elevation: 0, // Remove shadow from AppBar

            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Account Details',
                ),
                Tab(
                  text: 'Bank Details',
                ),
              ],
              indicatorColor: Colors.blue, // Indicator color for active tab
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // TabBarView should take up all available space, use Expanded
              Expanded(
                child: TabBarView(
                  children: [
                    // Wrap content with SingleChildScrollView to handle overflow
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildAccountSettings(), // Your content here
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildBankSetting(),
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

  Widget _buildBankSetting() {
    return Column(
      // Removed the extra SingleChildScrollView
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTextField(
              'Bank Code',
              'Enter your Bank Code',
              controller: _bankCodeController,
            ),
            _buildTextField(
              'Bank Name',
              'Enter your Bank Name',
              controller: _bankNameController,
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Handle account update
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4743C9),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Update',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      // Removed the extra SingleChildScrollView
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTextField(
              'Last Name',
              'Enter your Last Name',
              controller: _lastNameController,
            ),
            _buildTextField(
              'First Name',
              'Enter your First Name',
              controller: _firstNameController,
            ),
            _buildConditionalTextField(
              label: 'Identification Number',
              hint: 'Enter your Identification Number',
              isVisible: _showIdentificationField,
              onCheckboxChanged: (bool? value) {
                setState(() {
                  _showIdentificationField = value ?? false;
                });
              },
              controller: _identificationNumberController,
            ),
            _buildConditionalTextField(
              label: 'Passport Number',
              hint: 'Enter your Passport Number',
              isVisible: _showPassportField,
              onCheckboxChanged: (bool? value) {
                setState(() {
                  _showPassportField = value ?? false;
                });
              },
              controller: _passportNumberController,
            ),
            _buildPhotoUploader(
              title: 'ID Front Photo',
              photoBytes: _idFrontPhoto,
              photoType: 'idFront',
            ),
            _buildPhotoUploader(
              title: 'ID Rear Photo',
              photoBytes: _idRearPhoto,
              photoType: 'idRear',
            ),
            _buildPhotoUploader(
              title: 'Passport Photo',
              photoBytes: _passportPhoto,
              photoType: 'passport',
            ),
            const Text('Nationality',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _nationalityController,
              onChanged: (value) {
                print('TextField value: $value'); // Debug log
                filterNationalities(value); // Gọi hàm lọc
              },
              decoration: InputDecoration(
                hintText: 'Enter your Nationality',
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            _buildTextField(
              'Address',
              'Enter your Address',
              controller: _addressController,
            ),
            _buildTextField(
              'Phone Number',
              'Enter your Phone Number',
              controller: _phoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone Number is required';
                }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return 'Phone Number must contain only digits';
                }
                return null;
              },
            ),
            _buildTextField(
              'Email',
              'Enter your Email',
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Show the password change dialog when the button is pressed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Change Password'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Old Password TextField
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Old Password',
                          hintText: 'Enter your old password',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // New Password TextField
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter your new password',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Cancel'),
                    ),
                    // Submit button
                    ElevatedButton(
                      onPressed: () {
                        // Handle password change logic here
                        Navigator.of(context)
                            .pop(); // Close the dialog after submitting
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4743C9),
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4743C9),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Handle account update
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4743C9),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Update',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionalTextField({
    required String label,
    required String hint,
    required bool isVisible,
    required ValueChanged<bool?> onCheckboxChanged,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: isVisible,
              onChanged: (value) {
                onCheckboxChanged(value);
              },
              activeColor: Colors.blueAccent,
            ),
          ],
        ),
        if (isVisible) ...[
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              fillColor: Colors.grey.shade100,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPhotoUploader({
    required String title,
    required Uint8List? photoBytes,
    required String photoType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Edit') {
                  _pickImage(photoType);
                } else if (value == 'Remove') {
                  setState(() {
                    if (photoType == 'idFront') {
                      _idFrontPhoto = null;
                    } else if (photoType == 'idRear') {
                      _idRearPhoto = null;
                    } else if (photoType == 'passport') {
                      _passportPhoto = null;
                    }
                  });
                }
              },
              icon: Icon(
                photoBytes == null ? Icons.upload_file : Icons.more_vert,
                color: photoBytes == null ? Colors.blue : Colors.green,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              elevation: 4,
              itemBuilder: (context) => [
                if (photoBytes != null)
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit Photo'),
                      ],
                    ),
                  ),
                if (photoBytes != null)
                  PopupMenuItem(
                    value: 'Remove',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Remove Photo'),
                      ],
                    ),
                  ),
                if (photoBytes == null)
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: const [
                        Icon(Icons.upload_file, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Upload Photo'),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (photoBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              photoBytes,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
