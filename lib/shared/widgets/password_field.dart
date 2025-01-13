import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/features/auth/signUp/signup_service.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController; // Controller từ widget cha
  final String hintText; // Placeholder cho TextField
  final ValidationService?
      validationService; // Dịch vụ kiểm tra mật khẩu tùy chọn

  const PasswordField({
    super.key,
    required this.passwordController,
    this.hintText = "Enter Your Password", // Giá trị mặc định
    this.validationService,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  String? _passwordError;
  bool _isObscured = true;

  void _validatePassword() {
    // Sử dụng validation service nếu được cung cấp
    final validationService = widget.validationService ?? ValidationService();
    final password = widget.passwordController.text;
    setState(() {
      _passwordError = validationService.validatePassword(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller:
              widget.passwordController, // Controller được truyền từ ngoài
          obscureText: _isObscured,
          onChanged: (value) => _validatePassword(),
          decoration: inputFieldDecoration.copyWith(
            hintText: widget.hintText, // Placeholder tùy chỉnh
            errorText: _passwordError, // Hiển thị lỗi nếu có
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured; // Toggle chế độ ẩn/hiện mật khẩu
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
