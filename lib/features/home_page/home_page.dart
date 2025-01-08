import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = 'EN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildHeroSection(),
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

  Widget _buildHeroSection() {
    return Container(
      color: Colors.blue[50],
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          const Text(
            "Send & Receive Payments Globally",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "Easily manage your finances and transactions with our secure platform.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Get Started",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(
            'assets/img/hero-image.png', // Replace with your hero image
            height: 300,
            fit: BoxFit.contain,
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
}
