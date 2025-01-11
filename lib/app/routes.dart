

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/login/login_page.dart';
import 'package:flutter_application_1/features/signUp/signup_page.dart';
import 'package:flutter_application_1/features/user_profile/user_profile_page.dart';
import 'package:flutter_application_1/features/money_exchange/money_exchange_page.dart';
import 'package:flutter_application_1/features/home_page/home_page.dart';
import 'package:flutter_application_1/features/foget_password/forget_password_page.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String userprofile = '/userprofile';
  static const String moneyexchang = '/moneyexchange';
  static const String homepage = '/homepage';
  static const String forgetpassword = '/forgetpassword';



  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginPage(),
      signup: (context) => const SignupPage(),
      userprofile: (context) => const UserProfilePage(),
      moneyexchang: (context) => const MoneyExchangePage(),
      homepage: (context) => const HomePage(),
      forgetpassword: (context) => ForgetPasswordPage(),
    };
  }
}
