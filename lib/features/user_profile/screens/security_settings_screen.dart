import 'package:flutter/material.dart';

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({Key? key}) : super(key: key);

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Two Factor Authentication
          _buildTwoFactorAuthentication(),
          const SizedBox(height: 20),
          // Change Password
          _buildChangePassword(),
          const SizedBox(height: 20),
          // Additional Security
          _buildAdditionalSecurity(),
          const SizedBox(height: 20),
          // Your Devices
          _buildYourDevices(),
        ],
      ),
    );
  }

  Widget _buildTwoFactorAuthentication() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Two Factor Authentication',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Two-Factor Authentication (2FA) can be used to help protect your account.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Handle enable action
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePassword() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
              'You can always change your password for security reasons or reset your password in case you forgot it.'),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // Handle forgot password
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          _buildPasswordField('Current password'),
          _buildPasswordField('New password'),
          _buildPasswordField('Confirm New password'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle update password action
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: true,
    );
  }

  Widget _buildAdditionalSecurity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSecurityOption('SMS recovery', 'Number ending with 1234',
            'Disable SMS', Colors.redAccent),
        const SizedBox(height: 15),
        _buildSecurityOption('Authenticator App', 'Google Authenticator',
            'Configure', Colors.blue),
        const SizedBox(height: 15),
        _buildSecurityOption('SSL Certificate', 'Secure Sockets Layer',
            'Configure', Colors.green),
      ],
    );
  }

  Widget _buildSecurityOption(
      String title, String subtitle, String buttonText, Color buttonColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor, 
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
            ),
            onPressed: () {
              // Handle button action
            },
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourDevices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your devices',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Log out on all devices',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildDeviceItem(
            'Iphone 13 Pro Max', 'New York City · June 20 at 14:00', 'Log out'),
        const SizedBox(height: 15),
        _buildDeviceItem(
            'iPad Pro', 'New York City · June 20 at 14:00', 'Log out'),
        const SizedBox(height: 15),
        _buildDeviceItem(
            'iMac OSX', 'New York City · June 20 at 14:00', 'Log out'),
      ],
    );
  }

  Widget _buildDeviceItem(
      String deviceName, String deviceDetails, String buttonText) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.device_hub, color: Colors.blue),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      deviceDetails,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Dynamic color for the button
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Handle log out action
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
