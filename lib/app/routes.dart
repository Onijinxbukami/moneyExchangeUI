import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/login/login_page.dart';
import 'package:flutter_application_1/features/auth/signUp/signup_page.dart';

import 'package:flutter_application_1/features/home_page/screens/send_money/homepage_send_bankAccount_details.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/homepage_send_exchange_details.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/homepage_send_user_details.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/hompage_send_address_details.dart';
import 'package:flutter_application_1/features/money_exchange/screens/exchange_details.dart';
import 'package:flutter_application_1/features/user_profile/user_profile_page.dart';
import 'package:flutter_application_1/features/money_exchange/money_exchange_page.dart';

import 'package:flutter_application_1/features/money_exchange/screens/exchange_address.dart';
import 'package:flutter_application_1/features/home_page/home_page.dart';
import 'package:flutter_application_1/features/auth/foget_password/forget_password_page.dart';


class Routes {
  //auth
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetpassword = '/forgetpassword';
  //homepage
  static const String homepage = '/homepage';
  static const String exchangeDetails = '/homepagesenddetails';
  static const String bankAccountDetails = '/hompagebankaccountdetails';
  static const String addressDetails = '/hompageaddressdetails';
  static const String userDetails = '/homepageuserdetail';
  //userprofile
  static const String userprofile = '/userprofile';
  static const String address = '/address';
  static const String details = '/details';
  static const String moneyexchange = '/moneyexchange';





  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //home 
      homepage: (context) => const HomePage(),
      exchangeDetails: (context) => HomepageMoneyExchangeDetailsPage(),
      bankAccountDetails: (context) => HomepageBankAccountDetailsPage(),
      addressDetails: (context) => HomepageAddressPage(),
      userDetails: (context) => HomepageUserDetailsPage(),
      //auth
      login: (context) => LoginPage(),
      signup: (context) => const SignupPage(),
      forgetpassword: (context) => ForgetPasswordPage(),
      //money exchange
      moneyexchange: (context) => const MoneyExchangePage(),
      address: (context) => const ExchangeAddressPage(),
      details: (context) => const ExchangeDetailsPage(),
      //userprofile
      userprofile: (context) => const UserProfilePage(),
      
    };
  }
}
