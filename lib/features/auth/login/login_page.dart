import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/shared/widgets/facebook_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/google_sign_in_button.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/password_field.dart';
import 'package:flutter_application_1/shared/widgets/email_field.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '1049850024670-t352kp6332dnvv5k9p1edvuek64lljpf.apps.googleusercontent.com',
  );
  bool _isLoading = false;
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
    try {
      // Bắt đầu quá trình đăng nhập Google
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user != null) {
        // Lấy token để đăng nhập với Firebase
        final GoogleSignInAuthentication googleAuth = await user.authentication;

        // Tạo một thông tin đăng nhập Firebase từ Google
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Đăng nhập vào Firebase với thông tin đăng nhập từ Google
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Xử lý sau khi đăng nhập thành công
        print("User signed in: ${user.displayName}");
        print("Firebase User ID: ${userCredential.user?.uid}");

        // Bạn có thể tiếp tục điều hướng đến màn hình chính hoặc làm gì đó sau khi đăng nhập thành công
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      // Đăng nhập với Facebook
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Lấy accessToken từ extension
        final accessToken = loginResult.accessToken;
        if (accessToken != null) {
          // Sử dụng getter từ extension để lấy token
          final String token = accessToken.token;

          // Tạo thông tin đăng nhập từ token
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(token);

          // Đăng nhập vào Firebase với thông tin đăng nhập
          final UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          // Lấy thông tin người dùng sau khi đăng nhập
          final User? user = userCredential.user;
          if (user != null) {
            print("User signed in: ${user.displayName}");
            print("Email: ${user.email}");
          }
        } else {
          print("Access token is null.");
        }
      } else if (loginResult.status == LoginStatus.cancelled) {
        print("Facebook sign-in cancelled.");
      } else {
        print("Facebook sign-in failed: ${loginResult.message}");
      }
    } catch (e) {
      print("Facebook Sign-In Error: $e");
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
                                onPressed:
                                    _handleGoogleSignIn, // Chỉ tham chiếu hàm
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FacebookSignInButton(
                                onPressed: _handleFacebookSignIn,
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

extension AccessTokenExtension on AccessToken {
  String get token => this.token ?? '';
}
