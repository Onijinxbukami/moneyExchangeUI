import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/location_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = 'EN';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            _buildHeader(),

            // TabBar
            Container(
              color: const Color(0xFF5732C6), // Màu nền cho TabBar
              child: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Send', icon: Icon(Icons.security)),
                  Tab(text: 'Near me', icon: Icon(Icons.notifications)),
                ],
              ),
            ),

            // Nội dung tương ứng với từng tab
            Expanded(
              child: TabBarView(
                children: [
 
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0), // Đảm bảo nội dung sát với TabBar
                    child: SendMoneyForm(),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0), // Đảm bảo nội dung sát với TabBar
                    child: LocationForm(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildHeader() {
  return Container(
    color: const Color(0xFF6610F2), // Màu nền của header
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end, // Đẩy các phần tử sang bên phải
      crossAxisAlignment: CrossAxisAlignment.center,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      ],
    ),
  );
}

}
