import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/facebook_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/google_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/password_field.dart';
import 'package:flutter_application_1/shared/widgets/email_field.dart';

import 'package:flutter_application_1/features/auth/signUp/signup_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final TextEditingController _passwordController = TextEditingController();
  final ValidationService _validationService = ValidationService();
  bool _isLoading = false;
  String? _userNameError;
  String? _phoneNumberError;
  String _selectedLanguage = 'EN';

  Future<void> _handleRegister() async {
    // Kiểm tra các trường nhập liệu
    if (_userNameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _phoneNumberController.text.isEmpty ||
            _passwordController.text.isEmpty

        // _initialsController.text.isEmpty ||
        // _roleController.text.isEmpty
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all the information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    print('Username: ${_userNameController.text}');
    print('Email: ${_emailController.text}');
    print('Phone Number: ${_phoneNumberController.text}');
    print('Password: ${_passwordController.text}');

    try {
      setState(() {
        _isLoading = true;
      });

      // Đăng ký tài khoản trên Firebase Authentication
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Lưu thông tin bổ sung vào Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'username': _userNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('User registered and data saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.green,
        ),
      );

      // Chuyển hướng tới trang chính hoặc đăng nhập tự động
      Navigator.pushReplacementNamed(context, Routes.homepage);
    } catch (e) {
      print('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

    try {
      setState(() {
        _isLoading = true;
      });

      // Đăng nhập bằng email và password qua Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Đăng nhập thành công, chuyển hướng đến trang chính
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, Routes.homepage);
    } catch (e) {
      // Xử lý lỗi đăng nhập
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Bước 1: Đăng nhập tài khoản Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Bước 2: Xác thực tài khoản Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Bước 3: Nhận thông tin đăng nhập từ Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Bước 4: Đăng nhập Firebase
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, ${userCredential.user?.displayName}!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Xử lý lỗi đăng nhập
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In Failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateUserName() {
    final userName = _userNameController.text;
    setState(() {
      _userNameError = _validationService.validateUsername(userName);
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
          backgroundColor: const Color(0xFF6610F2), // Màu nền của app bar
          elevation: 0,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      Navigator.pushNamed(context, Routes.login);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LOGIN',
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
                // Background Image (Responsive for large screens)
                if (screenWidth >=
                    600) // Chỉ hiển thị background image trên các màn hình lớn
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login-reg-bg.png'),
                          fit: BoxFit
                              .cover, // Chỉnh sửa lại để ảnh bao phủ toàn bộ
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                // Main content (Sign up form)
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
                          obscureText: false,
                          decoration: inputFieldDecoration.copyWith(
                            hintText: "Enter Your Username",
                            errorText: _userNameError,
                          ),
                          onChanged: (value) => _validateUserName(),
                        ),
                        const SizedBox(height: verticalSpacing),

                        // Email Input
                        const Text("Email", style: labelStyle),
                        const SizedBox(height: inputSpacing),
                        EmailField(
                          emailController: _emailController,
                          hintText: "Enter Your Email",
                        ),
                        const SizedBox(height: verticalSpacing),

                        // Phone Number Input
                        const Text("Phone Number", style: labelStyle),
                        const SizedBox(height: inputSpacing),
                        TextField(
                          controller: _phoneNumberController,
                          decoration: inputFieldDecoration.copyWith(
                            hintText: "Enter Your PhoneNumber",
                            errorText: _phoneNumberError,
                          ),
                          onChanged: (value) => _validatePhoneNumber(),
                        ),
                        const SizedBox(height: verticalSpacing),

                        // Password Input
                        const Text("Password", style: labelStyle),
                        const SizedBox(height: inputSpacing),
                        PasswordField(
                          passwordController: _passwordController,
                          hintText: "Enter Your Password",
                        ),

                        // "Don't have an account?" text with login button
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            onPressed: _isLoading ? null : _handleRegister,
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Social Sign-In Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GoogleSignInButton(
                                onPressed: _handleGoogleSignIn,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FacebookSignInButton(
                                onPressed: _handleGoogleSignIn,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
