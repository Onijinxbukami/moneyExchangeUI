import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/send_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';

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
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildHeader(),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: LocationForm(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SendMoneyForm(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SettingForm(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF5732C6),
          child: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Near me', icon: Icon(Icons.notifications)),
              Tab(text: 'Send', icon: Icon(Icons.security)),
              Tab(text: 'Setting', icon: Icon(Icons.new_releases)),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildHeader() {
  return Container(
    color: const Color(0xFF6610F2),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: _selectedLanguage,
          dropdownColor: Colors.white,
          items: ['EN', 'VN']
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
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            }

            if (snapshot.hasData) {
              // Lấy thông tin từ Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }

                  if (userSnapshot.hasData) {
                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    return Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          userData['username'] ?? 'User',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  }

                  return const Text(
                    'Error',
                    style: TextStyle(color: Colors.white),
                  );
                },
              );
            }

            // Nếu chưa đăng nhập, hiển thị nút LOGIN
            return GestureDetector(
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
            );
          },
        ),
      ],
    ),
  );
}

}
