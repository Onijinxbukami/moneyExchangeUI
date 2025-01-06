import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String _selectedLanguage = 'English (US)';
  int _notificationCount = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search Form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                  hintText: 'Type to search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          // Language Dropdown
          PopupMenuButton<String>(
            initialValue: _selectedLanguage,
            icon: const Icon(Icons.language),
            onSelected: (String value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                'English',
                'Hindi',
                'English (US)',
                'Japanese',
                'Kannada',
                'Lithuanian'
              ].map((String language) {
                return PopupMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList();
            },
          ),
          // Notifications
          IconButton(
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications, // Sử dụng icon thông báo chuẩn
                  size: 30,
                  color: Colors.black, // Màu của icon
                ),
                if (_notificationCount > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$_notificationCount',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _notificationCount = 0; // Clear notifications when clicked
              });
            },
          ),
          // User Profile
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            onSelected: (String value) {
              if (value == 'Settings') {
                // Handle Settings
              } else if (value == 'Logout') {
                // Handle Logout
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                    value: 'Settings', child: Text('Settings')),
                const PopupMenuItem<String>(
                    value: 'Logout', child: Text('Logout')),
              ];
            },
          ),
        ],
      ),
    );
  }
}
