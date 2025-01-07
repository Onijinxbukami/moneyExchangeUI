import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // Controllers for each text field to manage the state of the inputs
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _onSubmit() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // If the form is valid, handle the data
  //     final lastName = _lastNameController.text;
  //     final firstName = _firstNameController.text;
  //     final phone = _phoneController.text;
  //     final email = _emailController.text;
  //     final password = _passwordController.text;

  //     // Perform your action here, e.g., call an API or save to local storage
  //     print("Last Name: $lastName");
  //     print("First Name: $firstName");
  //     print("Phone: $phone");
  //     print("Email: $email");
  //     print("Password: $password");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Wrap(
                spacing: 10, // Space between columns
                runSpacing: 10, // Space between rows
                children: [
                  _buildTextField('Last Name', 'Enter your Last Name',
                      controller: _lastNameController),
                  _buildTextField('First Name', 'Enter your First Name',
                      controller: _firstNameController),
                  _buildTextField('Phone Number', 'Enter your Phone Number',
                      controller: _phoneController),
                  _buildTextField('Email', 'Enter your Email',
                      controller: _emailController),
                  _buildTextField('Password', 'Enter your Password',
                      controller: _passwordController, obscureText: true),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                // onPressed: _onSubmit,
                onPressed: () {},
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {bool obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            fillColor: const Color.fromARGB(255, 232, 228, 240),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
