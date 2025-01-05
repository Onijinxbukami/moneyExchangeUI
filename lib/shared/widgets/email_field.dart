import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/features/signUp/signup_service.dart';

class EmailField extends StatefulWidget {
  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  final ValidationService _validationService = ValidationService();

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _emailError = _validationService.validateEmail(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress, 
          onChanged: (value) =>
              _validateEmail(), 
          decoration: inputFieldDecoration.copyWith(
            hintText: "Enter Your Email",
            errorText: _emailError, 
            
          ),
        ),
      ],
    );
  }
}
