import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/charts_screen.dart';
import 'package:flutter_application_1/features/user_profile/selectionButton.dart';
import 'package:flutter_application_1/features/user_profile/screens/notification_setting_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/security_settings_screen.dart';
import 'package:flutter_application_1/features/user_profile/screens/payment_settings_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/exchang_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_screen.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
            _buildFeaturesSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            fit: BoxFit.contain,
          ),
          // Menu Items
          Row(
            children: [
              _buildNavbarItem('Home', onTap: () {}),
              _buildNavbarItem('Send', onTap: () {}),
              _buildNavbarItem('Receive', onTap: () {}),
              _buildNavbarItem('Help', onTap: () {}),
            ],
          ),
          // Language Selector and Buttons
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: Colors.black,
                items: ['EN', 'BN', 'ES', 'NL']
                    .map(
                      (lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(
                          lang,
                          style: const TextStyle(color: Colors.white),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signup);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          const Text(
            "Our Features",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureItem(Icons.send, "Send Payment"),
              _buildFeatureItem(Icons.payment, "Receive Payment"),
              _buildFeatureItem(Icons.help, "Request Payment"),
              _buildFeatureItem(Icons.error, "Have a Problem"),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildContent() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Cănr giữa theo chiều dọc
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều ngang
      children: [
        _buildProfileSection(), // Profile section
        const SizedBox(height: 20),
        // Nội dung thay đổi dựa trên nút được chọn
        if (selectedButton == 'Convert') ExchangeForm(),
        if (selectedButton == 'Send')   SendMoneyForm(),
        if (selectedButton == 'Charts') ChartForm(),
        if (selectedButton == 'Near me') const NotificationSetting(),
        const SizedBox(height: 40), // Khoảng cách dưới cùng
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
              label: 'Convert',
              onPressed: () {
                _onButtonPressed('Convert');
              },
              isSelected: selectedButton == 'Convert',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.security,
              label: 'Send',
              onPressed: () {
                _onButtonPressed('Send');
              },
              isSelected: selectedButton == 'Send',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.payment,
              label: 'Charts',
              onPressed: () {
                _onButtonPressed('Charts');
              },
              isSelected: selectedButton == 'Charts',
            ),
            const SizedBox(width: 20),
            OptionButton(
              icon: Icons.notifications,
              label: 'Near me',
              onPressed: () {
                _onButtonPressed('Near me');
              },
              isSelected: selectedButton == 'Near me',
            ),
          ],
        ),
        const Spacer(),
      ],
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

  // Helper for Navbar Items
  Widget _buildNavbarItem(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Helper for Feature Items
  Widget _buildFeatureItem(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[100],
          radius: 30,
          child: Icon(icon, color: Colors.blue, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
