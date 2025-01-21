import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';

class Sidebar extends StatelessWidget {
  final String _selectedItem = 'Dashboard';

  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSidebarItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              Navigator.pushNamed(context, Routes.userprofile);
            },
            isSelected: _selectedItem == 'Dashboard',
          ),
          const Divider(color: Colors.black),
          _buildSidebarItem(
            icon: Icons.settings,
            title: 'Setting',
            onTap: () {
              _onItemTap('Setting');
            },
            isSelected: _selectedItem == 'Setting',
          ),
          _buildSidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              _onItemTap('Logout');
            },
            isSelected: _selectedItem == 'Logout',
          ),
        ],
      ),
    );
  }

  void _onItemTap(String title) {
    // Update the selected item (you can also use a state management solution)
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.black,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
