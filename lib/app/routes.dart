import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/login/login_page.dart';
import 'package:flutter_application_1/features/auth/signUp/signup_page.dart';
import 'package:flutter_application_1/features/deposite/deposite_details.dart';
import 'package:flutter_application_1/features/history/transaction_history.dart';
import 'package:flutter_application_1/features/money_exchange/screens/exchange_details.dart';
import 'package:flutter_application_1/features/user_profile/user_profile_page.dart';
import 'package:flutter_application_1/features/money_exchange/money_exchange_page.dart';
import 'package:flutter_application_1/features/deposite/deposite_money.dart';
import 'package:flutter_application_1/features/money_exchange/screens/exchange_address.dart';
import 'package:flutter_application_1/features/home_page/home_page.dart';
import 'package:flutter_application_1/features/auth/foget_password/forget_password_page.dart';


class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String userprofile = '/userprofile';
  static const String moneyexchange = '/moneyexchange';
  static const String deposite = '/deposite';
  static const String depositeDetails = '/deposite_details';
  static const String history = '/history';
  static const String homepage = '/homepage';
  static const String forgetpassword = '/forgetpassword';
  static const String address = '/address';
  static const String details = '/details';




  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //home 
      homepage: (context) => const HomePage(),
      //auth
      login: (context) => LoginPage(),
      signup: (context) => const SignupPage(),
      forgetpassword: (context) => ForgetPasswordPage(),
      //mooney exchange
      moneyexchange: (context) => const MoneyExchangePage(),
      address: (context) => const ExchangeAddressPage(),
      details: (context) => const ExchangeDetailsPage(),
      //transaction history 
      history: (context) =>  const TransactionHistoryForm(),
      //userprofile
      userprofile: (context) => const UserProfilePage(),
      //depostie
      deposite: (context) => const DepositMoney(),
      depositeDetails: (context) => const DepositMoneyDetails(),
    };
  }
}
