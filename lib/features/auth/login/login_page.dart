import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/constants.dart';
import 'package:flutter_application_1/shared/widgets/facebook_sign_in_button.dart';
import 'package:flutter_application_1/shared/widgets/google_sign_in_button.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/password_field.dart';
import 'package:flutter_application_1/shared/widgets/email_field.dart';

import 'package:google_sign_in/google_sign_in.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:js/js_util.dart' as js_util;

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
        '1045583437831-435og125lq6kn1ifiq5l8j4ni3fjndi2.apps.googleusercontent.com',
  );
  bool _isLoading = false;
  String _selectedLanguage = 'EN';
  bool _isFacebookSDKReady = false;

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
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user != null) {
        final GoogleSignInAuthentication googleAuth = await user.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // Tham chiếu đến Firestore
          final userRef = FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseUser.uid);

          // Kiểm tra nếu người dùng đã tồn tại
          DocumentSnapshot doc = await userRef.get();
          if (!doc.exists) {
            // Nếu chưa có, thêm người dùng vào Firestore
            await userRef.set({
              "uid": firebaseUser.uid,
              "userName": firebaseUser.displayName,
              "email": firebaseUser.email,
              "photoUrl": firebaseUser.photoURL,
              "createdAt": FieldValue.serverTimestamp(),
            });
          } else {
            // Nếu đã tồn tại, có thể cập nhật thông tin mới
            await userRef.update({
              "userName": firebaseUser.displayName,
              "photoUrl": firebaseUser.photoURL,
            });
          }

          print("User signed in: ${firebaseUser.displayName}");
          print("Firebase User ID: ${firebaseUser.uid}");

          // Chuyển đến trang chính
          Navigator.pushReplacementNamed(context, Routes.homepage);
        }
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Đợi một chút để SDK Facebook có thể khởi tạo
    Future.delayed(Duration(seconds: 3), () {
      // Sử dụng js_util để lấy giá trị của facebookSDKReady từ JavaScript
      bool? isSDKReady =
          js_util.getProperty(js_util.globalThis, 'facebookSDKReady');

      setState(() {
        _isFacebookSDKReady = isSDKReady ?? false;
      });
      print("SDK ready status: $_isFacebookSDKReady");
    });
  }

  void _handleFacebookSignIn() {
    try {
      var fb = js.context['FB'];
      if (fb == null || fb.callMethod == null) {
        print("Facebook SDK chưa sẵn sàng hoặc không thể gọi phương thức.");
        return;
      }

      // Kiểm tra trạng thái đăng nhập trước
      fb.callMethod('getLoginStatus', [
        js.allowInterop((response) {
          if (response is js.JsObject &&
              response.hasProperty('status') &&
              response['status'] == 'connected' &&
              response.hasProperty('authResponse')) {
            final accessToken = response['authResponse']['accessToken'];
            if (accessToken != null && accessToken.isNotEmpty) {
              print("User already logged in, Access Token: $accessToken");
              _signInWithFirebase(accessToken);
            } else {
              print("User logged in but token is missing, retrying...");
              _getAccessToken();
            }
          } else {
            // Nếu chưa đăng nhập, gọi FB.login()
            print("User not logged in, calling FB.login()");
            fb.callMethod('login', [
              js.allowInterop((loginResponse) {
                if (loginResponse is js.JsObject &&
                    loginResponse.hasProperty('status') &&
                    loginResponse['status'] == 'connected' &&
                    loginResponse.hasProperty('authResponse')) {
                  final loginAccessToken =
                      loginResponse['authResponse']['accessToken'];
                  if (loginAccessToken != null && loginAccessToken.isNotEmpty) {
                    print("Login successful, Access Token: $loginAccessToken");
                    _signInWithFirebase(loginAccessToken);
                  } else {
                    print("Login successful but no token, retrying...");
                    _getAccessToken();
                  }
                } else {
                  print("Facebook login failed: ${loginResponse['status']}");
                }
              }),
              {
                'scope': 'email,public_profile'
              } // Thêm quyền truy cập email, profile
            ]);
          }
        })
      ]);
    } catch (e) {
      print("Facebook Sign-In Error: $e");
    }
  }

  void _getAccessToken() {
    var fb = js.context['FB'];
    fb.callMethod('getLoginStatus', [
      js.allowInterop((response) {
        if (response is js.JsObject &&
            response.hasProperty('status') &&
            response['status'] == 'connected' &&
            response.hasProperty('authResponse')) {
          final accessToken = response['authResponse']['accessToken'];
          if (accessToken != null && accessToken.isNotEmpty) {
            print("Retrieved Access Token: $accessToken");
            _signInWithFirebase(accessToken);
          } else {
            print("Token still unavailable, retrying in 2 seconds...");
            Future.delayed(Duration(seconds: 2), _getAccessToken);
          }
        } else {
          print("User is not logged in after retry.");
        }
      })
    ]);
  }

  void _signInWithFirebase(String accessToken) async {
    try {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken);

      // Đăng nhập vào Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userRef = FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid);
        DocumentSnapshot doc = await userRef.get();

        if (!doc.exists) {
          await userRef.set({
            "uid": firebaseUser.uid,
            "userName": firebaseUser.displayName,
            "email": firebaseUser.email,
            "photoUrl": firebaseUser.photoURL,
            "createdAt": FieldValue.serverTimestamp(),
          });
        } else {
          await userRef.update({
            "userName": firebaseUser.displayName,
            "photoUrl": firebaseUser.photoURL,
          });
        }

        print("User signed in: ${firebaseUser.displayName}");
        Navigator.pushReplacementNamed(context, Routes.homepage);
      }
    } catch (e) {
      print("Error during Firebase sign-in: $e");
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
    children: [


      const Spacer(), // Đẩy các phần tử còn lại về bên phải

      // Nút chọn ngôn ngữ
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    title: Text(tr("select_language")),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          context.setLocale(const Locale('en'));
                          Navigator.pop(context);
                        },
                        child: const Text("English"),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          context.setLocale(const Locale('vi'));
                          Navigator.pop(context);
                        },
                        child: const Text("Tiếng Việt"),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: Text(tr("cancel")),
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Text(
                  context.locale.languageCode.toUpperCase(),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 16),
              ],
            ),
          ),
        ),
      ),

      const SizedBox(width: 16),

      // Nút login
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.signup);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tr('login'),
            style: const TextStyle(color: Colors.white),
          ),
        ),
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

                        const SizedBox(height: 16),
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
                          padding: const EdgeInsets.only(top: 2),
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
                              child: FacebookSignInButton(onPressed: () async {
                                if (!_isFacebookSDKReady) {
                                  print(
                                      "Facebook SDK chưa sẵn sàng, vui lòng thử lại sau.");
                                  return;
                                }
                                _handleFacebookSignIn();
                              }),
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
