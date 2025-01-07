import 'package:flutter/material.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SettingItem(
          icon: Icons.delete,
          title: 'Delete Account',
          onTap: () {
            // Handle delete action
          },
        ),
        SettingItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            // Handle logout action
          },
        ),
      ],
    );
  }
    Widget SettingItem({required IconData icon, required String title, required Null Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      onTap: () {
        // Handle setting item tap
      },
    );
}
}