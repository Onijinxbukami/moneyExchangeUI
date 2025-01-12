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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildTransferMoneySection(),
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
    return Center(
      // Center the entire content of the Row
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink Row to fit its children
        mainAxisAlignment:
            MainAxisAlignment.center, // Center children horizontally
        children: [
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

  Widget _buildTransferMoneySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Transfer money across borders',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Features list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Image.asset(imagePath, width: 24, height: 24), // Icon image
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
