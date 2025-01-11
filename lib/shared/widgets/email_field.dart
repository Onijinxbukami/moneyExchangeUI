import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/features/signUp/signup_service.dart';

class EmailField extends StatefulWidget {
  final TextEditingController
      emailController; // Controller được truyền từ ngoài
  final String hintText; // Placeholder cho TextField
  final ValidationService? validationService; // Dịch vụ kiểm tra email tùy chọn

  const EmailField({
    Key? key,
    required this.emailController,
    this.hintText = "Enter Your Email", // Giá trị mặc định
    this.validationService,
  }) : super(key: key);

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  String? _emailError;

  void _validateEmail() {
    // Sử dụng validation service nếu được cung cấp
    final validationService = widget.validationService ?? ValidationService();
    final email = widget.emailController.text;
    setState(() {
      _emailError = validationService.validateEmail(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.emailController, // Controller được truyền từ ngoài
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => _validateEmail(),
          decoration: inputFieldDecoration.copyWith(
            hintText: widget.hintText, // Placeholder tùy chỉnh
            errorText: _emailError, // Hiển thị lỗi nếu có
          ),
        ),
      ],
    );
  }
}
