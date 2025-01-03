import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/login/login_page.dart'; // Đảm bảo import đúng trang Login
import 'package:flutter_application_1/features/signUp/signup_page.dart'; // Đảm bảo import đúng trang Signup

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginPage(),
      signup: (context) => SignupPage(),
    };
  }
}
