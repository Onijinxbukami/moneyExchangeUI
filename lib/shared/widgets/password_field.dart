import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/features/signUp/signup_service.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final TextEditingController _passwordController = TextEditingController();
  String? _passwordError;
  final ValidationService _validationService = ValidationService();

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _passwordError = _validationService.validatePassword(password);
    });
  }

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Password input field
        TextField(
          controller: _passwordController,
          obscureText: _isObscured,
          onChanged: (value) =>
              _validatePassword(), // Kiểm tra password khi nhập
          decoration: inputFieldDecoration.copyWith(
            hintText: "Enter Your Password",
            errorText: _passwordError, // Hiển thị lỗi nếu có
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured; // Toggle visibility
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
