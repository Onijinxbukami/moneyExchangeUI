import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/shared/widgets/facebook_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/google_sign_in_button.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/password_field.dart';
import 'package:flutter_application_1/shared/widgets/email_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiển thị thông tin nhập vào trong console log
    print('Username: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: lightColor,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề "MoneyExchange" ở bên trái
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20), // Cách lề trái và lề trên
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/homepage'); // Hành động khi nhấn
                  },
                  child: const Text(
                    "MoneyExchange",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Nút Login ở bên phải
          Padding(
            padding: const EdgeInsets.only(
                top: 10, right: 20), // Cách lề phải và lề trên
            child: ElevatedButton(
              onPressed: () {
                // Handle login action
                Navigator.pushNamed(context, Routes.signup);
              },
              // ignore: sort_child_properties_last
              child: const Text("Sign Up", style: buttonTextStyle),
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
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Colors.black,
            thickness: 1,
            indent: 0, // Khoảng cách từ trái
            endIndent: 0, // Khoảng cách từ phải
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
                      "LOGIN",
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

                  // Register to continue
                  const SizedBox(height: verticalSpacing),

                  // Email Input
                  const Text("Email", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  EmailField(
                    emailController: _emailController,
                    hintText: "Enter Your Email",
                  ),

                  const SizedBox(height: verticalSpacing),

                  // Password Input
                  const Text("Password", style: labelStyle),
                  const SizedBox(height: inputSpacing),
                  PasswordField(
                    passwordController: _passwordController,
                    hintText: "Enter Your Password",
                  ),
                  const SizedBox(height: verticalSpacing),

                  // Sign Up Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      // Navigator.pushNamed(context, Routes.userprofile);
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4743C9), // Button color
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
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center align the row
                      children: [
                        const Text(
                          "Forgot your password?",
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
                            Navigator.pushNamed(context, Routes.forgetpassword);
                          },
                          child: const Text(
                            "Click here",
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
                  // "Don't have an account?" text with the login button next to it
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
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
                            Navigator.pushNamed(context, Routes.signup);
                          },
                          child: const Text(
                            "Sign up",
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
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
