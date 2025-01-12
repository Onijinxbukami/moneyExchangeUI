import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/screens/payment_settings_screen.dart';

import 'package:flutter_application_1/features/user_profile/screens/security_settings_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/sideBar_screens.dart';
import 'package:flutter_application_1/features/user_profile/screens/selectionButton.dart';
import 'package:flutter_application_1/features/user_profile/screens/notification_setting_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/header_field.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? selectedButton;

  // Function to handle button press and toggle selection
  void _onButtonPressed(String buttonLabel) {
    setState(() {
      if (selectedButton == buttonLabel) {
        selectedButton = null;
      } else {
        selectedButton = buttonLabel;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(),
          // User Information Area
          Expanded(
            child: Column(
              children: [
                // Header Section
                HeaderWidget(),
                // Content Section
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the main content area based on the selected button
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(), // Profile section
          const SizedBox(height: 20),
          if (selectedButton == 'Account') _buildAccountSettings(),
          if (selectedButton == 'Security') const SecuritySettings(),
          if (selectedButton == 'Payment Methods') PaymentSettings(),
          if (selectedButton == 'Notification') const NotificationSetting(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const SizedBox(width: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.account_circle,
              label: 'Account',
              onPressed: () {
                _onButtonPressed('Account');
              },
              isSelected: selectedButton == 'Account',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.security,
              label: 'Security',
              onPressed: () {
                _onButtonPressed('Security');
              },
              isSelected: selectedButton == 'Security',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.payment,
              label: 'Payment Methods',
              onPressed: () {
                _onButtonPressed('Payment Methods');
              },
              isSelected: selectedButton == 'Payment Methods',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.notifications,
              label: 'Notification',
              onPressed: () {
                _onButtonPressed('Notification');
              },
              isSelected: selectedButton == 'Notification',
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  // Account settings form
  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 10, // Column spacing
          runSpacing: 10, // Row spacing
          children: [
            _buildTextField('Last Name', 'Enter your Last Name'),
            _buildTextField('First Name', 'Enter your First Name'),
            _buildTextField('Phone Number', 'Enter your Phone Number'),
            _buildTextField('Email', 'Enter your Email'),
            _buildTextField('Password', 'Enter your Password',
                obscureText: true),
          ],
        ),
      ],
    );
  }

  // Helper function for creating text fields
  Widget _buildTextField(String label, String hint,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: const Color.fromARGB(255, 232, 228, 240),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
        ),
      ],
    );
  }

  // Placeholder widget for payment methods settings

}
