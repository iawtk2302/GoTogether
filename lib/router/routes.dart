import 'package:flutter/material.dart';

import '../screen/home_page.dart';
import '../screen/login_page.dart';
import '../screen/main_page.dart';
import '../screen/register_page.dart';

class Routes {
  static const login = '/LoginPage';
  static const register = '/RegisterPage';
  static const forgot = '/ForgotPassPage';
  static const home = '/HomePage';
  static const main = '/MainPage';
  static const auth = '/AuthPage';
  Route? getRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.login:
      {
        return MaterialPageRoute(
            builder: (context) => const LoginPage(), settings: settings);
      }
    case Routes.register:
      {
        return MaterialPageRoute(
            builder: (context) => const RegisterPage(), settings: settings);
      }
    // case Routes.forgot:
    //   {
    //     return MaterialPageRoute(
    //         builder: (context) => const ForgotPassPage(), settings: settings);
    //   }
    case Routes.home:
      {
        return MaterialPageRoute(
            builder: (context) => const HomePage(), settings: settings);
      }
    case Routes.main:
      {
        return MaterialPageRoute(
            builder: (context) => const MainPage(), settings: settings);
      }
  }
  return null;
}
}
 
