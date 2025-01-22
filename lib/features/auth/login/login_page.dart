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
  String _selectedLanguage = 'EN';

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the information'),
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
          backgroundColor: const Color(0xFF6610F2), // Màu nền của app bar
          elevation: 0,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo

              Row(
                children: [
                  // Dropdown ngôn ngữ
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    dropdownColor: Colors.white,
                    items: ['EN', 'BN', 'ES', 'NL']
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/lang.png', // Đường dẫn tới icon của bạn
                                  height: 20, // Độ cao của icon
                                  width: 20, // Độ rộng của icon
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  lang,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16),

                  // Nút LOGIN
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.signup);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;

            return Row(
              children: [
                // Background Image
                if (screenWidth >=
                    600) // Chỉ hiển thị background image trên các màn hình lớn
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login-reg-bg.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                // Form Content
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth *
                          0.05, // Điều chỉnh padding theo tỷ lệ màn hình
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const SizedBox(height: 16),
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

                        // Email Input
                        const Text("Email", style: labelStyle),
                        const SizedBox(height: 8),
                        EmailField(
                          emailController: _emailController,
                          hintText: "Enter Your Email",
                        ),
                        const SizedBox(height: 16),

                        // Password Input
                        const Text("Password", style: labelStyle),
                        const SizedBox(height: 8),
                        PasswordField(
                          passwordController: _passwordController,
                          hintText: "Enter Your Password",
                        ),
                        const SizedBox(height: 16),

                        // Login Button
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
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
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Forgot Password Section
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Forgot your password?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 37, 34, 109),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.forgetpassword);
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

                        // Sign Up Section
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 37, 34, 109),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
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

                        // Social Media Sign-In Buttons
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: GoogleSignInButton(
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 16),
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
            );
          },
        ));
  }
}
