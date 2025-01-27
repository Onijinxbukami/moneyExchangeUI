import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/facebook_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/google_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/email_field.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
   bool _isLoading = false;
  String _selectedLanguage = 'EN';

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty) {
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
              ],
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          return Column(
            children: [
              // Thêm khoảng cách giữa AppBar và phần body
              const SizedBox(height: 10), // Khoảng cách 20 pixels

              Expanded(
                child: Row(
                  children: [
                    // Background Image
                    if (screenWidth >=
                        600) // Hiển thị ảnh nền trên màn hình lớn
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/login-reg-bg.png'),
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
                              0.05, // Padding dựa trên tỷ lệ màn hình
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Center(
                              child: Text(
                                "FORGET PASSWORD",
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

                           
                            const SizedBox(height: 8),
                            EmailField(
                              emailController: _emailController,
                              hintText: "Enter Your Email",
                            ),
                            const SizedBox(height: 16),

                            // Submit Button
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
                                  "SUBMIT",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Social Media Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: GoogleSignInButton( onPressed: _isLoading
                                    ? null
                                    : _handleGoogleSignIn, ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FacebookSignInButton(onPressed: () {}),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
