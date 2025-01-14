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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6610F2),
        leading: isMobile
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
      ),
      drawer: isMobile ? Sidebar() : null,
      body: Row(
        children: [
          if (!isMobile) Sidebar(),
          Expanded(
            child: Column(
              children: [
                HeaderWidget(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          if (selectedButton == 'Payment') PaymentSettings(),
          if (selectedButton == 'Notification') const NotificationSetting(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: isMobile
              ? 60.0
              : 80.0, // Điều chỉnh chiều cao cho phù hợp với thiết bị di động
          child: ListView(
            scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.account_circle,
                  label: 'Account',
                  onPressed: () {
                    _onButtonPressed('Account');
                  },
                  isSelected: selectedButton == 'Account',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.security,
                  label: 'Security',
                  onPressed: () {
                    _onButtonPressed('Security');
                  },
                  isSelected: selectedButton == 'Security',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.payment,
                  label: 'Payment',
                  onPressed: () {
                    _onButtonPressed('Payment');
                  },
                  isSelected: selectedButton == 'Payment',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.notifications,
                  label: 'Notification',
                  onPressed: () {
                    _onButtonPressed('Notification');
                  },
                  isSelected: selectedButton == 'Notification',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Account settings form
  Widget _buildAccountSettings() {
    return SingleChildScrollView(
      // Cho phép cuộn theo chiều dọc
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Wrap(
            spacing: 10, // Khoảng cách giữa các trường dữ liệu
            runSpacing:
                10, // Khoảng cách giữa các trường dữ liệu khi xuống dòng
            children: [
              _buildTextField('Last Name', 'Enter your Last Name'),
              _buildTextField('First Name', 'Enter your First Name'),
              _buildTextField('Phone Number', 'Enter your Phone Number'),
              _buildTextField('Email', 'Enter your Email'),
              _buildTextField('Password', 'Enter your Password',
                  obscureText: true),
            ],
          ),
          const SizedBox(height: 20), // Khoảng cách giữa form và nút update
          ElevatedButton(
            onPressed: () {
              // Xử lý cập nhật tài khoản
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF4743C9), // Màu nền giống nút login
              padding: const EdgeInsets.symmetric(
                  horizontal: 80, vertical: 16), // Padding giống
              minimumSize: const Size(double.infinity,
                  56), // Chiều rộng tự động, chiều cao tối thiểu
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Bo tròn góc giống nút login
              ),
            ),
            child: const Text(
              'Update', // Nội dung nút
              style: TextStyle(
                fontSize: 16, // Kích thước chữ giống nút login
                fontWeight: FontWeight.bold, // Đậm chữ
                color: Colors.white, // Màu chữ trắng
              ),
            ),
          )
        ],
      ),
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
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
