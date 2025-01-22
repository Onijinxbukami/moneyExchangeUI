import 'package:flutter/material.dart';

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

  final TextEditingController _identificationNumberController =
      TextEditingController();
  final TextEditingController _passportNumberController =
      TextEditingController();
  final TextEditingController _bankCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();


  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _identificationNumberController.dispose();
    _passportNumberController.dispose();
    _bankCodeController.dispose();
    _bankNameController.dispose();
    super.dispose();
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
            _buildTextField(
              'Identification Number',
              'Enter your Identification Number',
              controller: _identificationNumberController,
            ),
            _buildTextField(
              'Passport Number',
              'Enter your Passport Number',
              controller: _passportNumberController,
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
}
