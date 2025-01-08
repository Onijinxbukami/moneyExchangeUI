import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/facebook_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/google_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/password_field.dart';
import 'package:flutter_application_1/shared/widgets/email_field.dart';

import 'package:flutter_application_1/features/signUp/signup_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _userNameError;
  String? _emailError;
  String? _phoneNumberError;

  final ValidationService _validationService = ValidationService();
  void _validateUserName() {
    final userName = _userNameController.text;
    setState(() {
      _userNameError = _validationService.validateUsername(userName);
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _emailError = _validationService.validateEmail(email);
    });
  }

  void _validatePhoneNumber() {
    final phoneNumber = _phoneNumberController.text;
    setState(() {
      _phoneNumberError = _validationService.validatePhoneNumber(phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: lightColor,
        elevation: 0,
        toolbarHeight: 80,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề "MoneyExchange" ở bên trái
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 20), // Cách lề trái và lề trên
              child: Text(
                "MoneyExchange",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Nút Login ở bên phải
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: ElevatedButton(
              onPressed: () {
                // Handle login action
                Navigator.pushNamed(context, Routes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4743C9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text("Login", style: buttonTextStyle),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Colors.black,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login-reg-bg.png'),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4743C9),
                        letterSpacing: 1.5,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const SizedBox(height: verticalSpacing),

                  // Username Input
                  const Text("Username", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  TextField(
                    controller: _userNameController,
                    obscureText: true,
                    decoration: inputFieldDecoration.copyWith(
                      hintText: "Enter Your Username",
                      errorText: _userNameError,
                    ),
                    onChanged: (value) => _validateUserName(),
                  ),

                  const SizedBox(height: verticalSpacing),

                  const Text("Email", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  EmailField(),

                  const SizedBox(height: verticalSpacing),
                  const Text("Phone Number", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: inputFieldDecoration.copyWith(
                        hintText: "Enter Your PhoneNumber",
                        errorText: _phoneNumberError),
                    onChanged: (value) => _validatePhoneNumber(),
                  ),

                  const SizedBox(height: verticalSpacing),

                  // Password Input
                  const Text("Password", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  PasswordField(),
                  // "Don't have an account?" text with the login button next to it
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center align the row
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 37, 34, 109),
                            letterSpacing: 1.5,
                            height: 1.2,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle login action
                            Navigator.pushNamed(context, Routes.login);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4743C9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: verticalSpacing),

                  // Sign Up Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _validateEmail();
                        if (_emailError == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email is valid")),
                          );
                        }
                        Navigator.pushNamed(context, Routes.userprofile);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4743C9),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Canh giữa hai nút
                    children: [
                      Expanded(
                        child: GoogleSignInButton(
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16), // Khoảng cách giữa hai nút
                      Expanded(
                        child: FacebookSignInButton(
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
