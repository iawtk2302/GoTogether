import 'package:flutter/material.dart';

import '../screen/forgot_pass_page.dart';
import '../screen/check_info.dart';
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
  static const checkInfo = '/CheckInfoPage';
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
    case Routes.forgot:
      {
        return MaterialPageRoute(
            builder: (context) => const ForgotPassPage(), settings: settings);
      }
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
      case Routes.checkInfo:
      {
        return MaterialPageRoute(
            builder: (context) => const CheckInfoPage(), settings: settings);
      }
  }
}}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  SlideRightRoute({
    required this.widget,
    required this.settings,
  }) : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  SlideUpRoute({
    required this.widget,
    required this.settings,
  }) : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
