import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/screens/payment_settings_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/security_settings_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/sideBar_screens.dart';
import 'package:flutter_application_1/features/user_profile/screens/notification_setting_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/header_field.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
        title: const Text('Welcome !!!'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.account_circle), text: 'Account'),
            Tab(icon: Icon(Icons.security), text: 'Security'),
            Tab(icon: Icon(Icons.payment), text: 'Payment'),
            //Tab(icon: Icon(Icons.notifications), text: 'Notification'),
          ],
        ),
      ),
      drawer: isMobile ? Sidebar() : null,
      body: Row(
        children: [
          if (!isMobile) Sidebar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAccountSettings(),
                const SecuritySettings(),
                PaymentSettings(),
                //const NotificationSetting(),
              ],
            ),
          ),
        ],
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
