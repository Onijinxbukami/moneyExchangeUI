import 'package:flutter/material.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({super.key});

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),
            Expanded(child: _buildAccountSettings()),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildTextField('Last Name', 'Enter your Last Name'),
              _buildTextField('First Name', 'Enter your First Name'),
              _buildTextField('Phone Number', 'Enter your Phone Number'),
              _buildTextField('Email', 'Enter your Email'),
              _buildTextField('Password', 'Enter your Password', obscureText: true),
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
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
