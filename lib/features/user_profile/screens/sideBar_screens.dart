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
          _buildSidebarItem(
            icon: Icons.person,
            title: 'Transaction History',
            onTap: () {
              Navigator.pushNamed(context, Routes.history);
            },
            isSelected: _selectedItem == 'Transaction',
          ),
          _buildSidebarItem(
            icon: Icons.money,
            title: 'Deposite',
            onTap: () {
              Navigator.pushNamed(context, Routes.deposite);
            },
            isSelected: _selectedItem == 'Deposite',
          ),
          _buildSidebarItem(
            icon: Icons.expand,
            title: 'Exchange',
            onTap: () {
              Navigator.pushNamed(context, Routes.moneyexchange);
            },
            isSelected: _selectedItem == 'Exchange',
          ),
          _buildSidebarItem(
            icon: Icons.money_off,
            title: 'Withdraw Money',
            onTap: () {
              _onItemTap('Withdraw Money');
            },
            isSelected: _selectedItem == 'Withdraw Money',
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
