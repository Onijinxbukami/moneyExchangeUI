import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/charts_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/selectionButton.dart';
import 'package:flutter_application_1/features/home_page/screens/exchang_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/location_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = 'EN';
  String? selectedButton;

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
      backgroundColor: const Color(0xFF433883),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Transfer Money Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: isMobile ? 8 : 16,
                  ),
                  child: _buildTransferMoneySection(),
                ),

                // Content Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: isMobile ? 8 : 16,
                  ),
                  child: _buildContent(),
                ),

                // Footer Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: isMobile ? 8 : 16,
                  ),
                  child: _buildFooter(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF6610F2), // Màu nền của header
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            height: 0,
            fit: BoxFit.contain,
          ),

          // Menu Items (Language Selector + Login/Signup)
          Row(
            children: [
              // Language Dropdown
              DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: Colors.white,
                items: ['EN', 'BN', 'ES', 'NL']
                    .map(
                      (lang) => DropdownMenuItem(
                        value: lang,
                        child: Row(
                          children: [
                            Image.asset(
                                'assets/images/lang.png', // Đường dẫn tới icon của bạn
                                height: 20, // Độ cao của icon
                                width: 20, // Độ rộng của icon
                                fit: BoxFit.contain,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              lang,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              const SizedBox(width: 16),

              // LOGIN Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // SIGN UP Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.signup);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5732C6),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            // Dynamic content based on the selected button
            if (selectedButton == 'Convert') ExchangeForm(),
            if (selectedButton == 'Send') SendMoneyForm(),
            if (selectedButton == 'Charts') ChartForm(),
            if (selectedButton == 'Near me') LocationForm(),
            const SizedBox(height: 40),
          ],
        ),
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
                  label: 'Convert',
                  onPressed: () {
                    _onButtonPressed('Convert');
                  },
                  isSelected: selectedButton == 'Convert',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.security,
                  label: 'Send',
                  onPressed: () {
                    _onButtonPressed('Send');
                  },
                  isSelected: selectedButton == 'Send',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.payment,
                  label: 'Charts',
                  onPressed: () {
                    _onButtonPressed('Charts');
                  },
                  isSelected: selectedButton == 'Charts',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 12.0), // Khoảng cách giữa các nút
                child: OptionButton(
                  icon: Icons.notifications,
                  label: 'Near me',
                  onPressed: () {
                    _onButtonPressed('Near me');
                  },
                  isSelected: selectedButton == 'Near me',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required bool isMobile,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Tính toán kích thước nút dựa vào màn hình
    double buttonWidth =
        (screenWidth / 2) - 12; // Giảm khoảng cách giữa các nút (24 -> 12)

    // Điều kiện để giảm kích thước nút trên màn hình nhỏ
    if (screenWidth < 360) {
      buttonWidth = (screenWidth / 2) - 8; // Giảm khoảng cách cho màn hình nhỏ
    }

    return SizedBox(
      width: buttonWidth.clamp(100, 180), // Giới hạn chiều rộng
      child: OptionButton(
        icon: icon,
        label: label,
        onPressed: () {
          _onButtonPressed(label);
        },
        isSelected: selectedButton == label,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Paylio",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Secure and fast payment solutions for your business and personal needs.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.facebook, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.back_hand, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.book, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferMoneySection() {
    return Container(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600
            ? 32
            : 16, // Điều chỉnh padding cho màn hình rộng
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width > 600
                  ? 24
                  : 16, // Điều chỉnh khoảng cách dưới tiêu đề
            ),
            child: Text(
              'Transfer money across borders',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600
                    ? 32
                    : 24, // Điều chỉnh font-size cho các thiết bị lớn
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Features list (Dùng Wrap thay vì Row để hiển thị tính năng linh hoạt hơn trên cả mobile và web)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: MediaQuery.of(context).size.width > 600
                ? 40
                : 20, // Điều chỉnh khoảng cách giữa các item
            runSpacing: MediaQuery.of(context).size.width > 600
                ? 24
                : 16, // Khoảng cách giữa các dòng
            children: [
              _buildFeatureItemWithImage(
                  'assets/images/feature-icon-1.png', 'Fast & hassle-free'),
              _buildFeatureItemWithImage('assets/images/feature-icon-2.png',
                  'Trusted by over 3M customers'),
              _buildFeatureItemWithImage(
                  'assets/images/feature-icon-3.png', 'Global 24/7 support'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItemWithImage(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath,
              width: MediaQuery.of(context).size.width > 600 ? 30 : 24,
              height: MediaQuery.of(context).size.width > 600
                  ? 30
                  : 24), // Điều chỉnh kích thước hình ảnh
          SizedBox(
              width: MediaQuery.of(context).size.width > 600
                  ? 16
                  : 8), // Khoảng cách giữa icon và văn bản
          Text(
            text,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600
                  ? 18
                  : 16, // Điều chỉnh font-size cho các thiết bị lớn
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
