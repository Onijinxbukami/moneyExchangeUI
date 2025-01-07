import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/selectionButton.dart';

class ProfileSection extends StatefulWidget {
  final String name;
  final String email;
  final String avatarUrl;
  final String balance;

  const ProfileSection({
    Key? key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.balance,
  }) : super(key: key);

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String selectedButton = 'Account';

  void _onButtonPressed(String button) {
    setState(() {
      selectedButton = button;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.avatarUrl),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectionButton(
              icon: Icons.account_circle,
              label: 'Account',
              onPressed: () => _onButtonPressed('Account'),
              isSelected: selectedButton == 'Account',
            ),
            SelectionButton(
              icon: Icons.security,
              label: 'Security',
              onPressed: () => _onButtonPressed('Security'),
              isSelected: selectedButton == 'Security',
            ),
            SelectionButton(
              icon: Icons.payment,
              label: 'Payment Methods',
              onPressed: () => _onButtonPressed('Payment Methods'),
              isSelected: selectedButton == 'Payment Methods',
            ),
            SelectionButton(
              icon: Icons.notifications,
              label: 'Notification',
              onPressed: () => _onButtonPressed('Notification'),
              isSelected: selectedButton == 'Notification',
            ),
          ],
        ),
      ],
    );
  }
}
