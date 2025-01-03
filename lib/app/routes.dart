import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/login/login_page.dart';
import 'package:flutter_application_1/features/signUp/signup_page.dart';
import 'package:flutter_application_1/features/user_profile/user_profile_page.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String userprofile = '/userprofile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginPage(),
      signup: (context) => SignupPage(),
      userprofile: (context) => UserProfilePage()
    };
  }
}
