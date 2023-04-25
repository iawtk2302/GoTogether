import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/screen/chat/search_chat_page.dart';
import 'package:go_together/screen/create_trip_page.dart';
import 'package:go_together/screen/notification_page.dart';
import 'package:go_together/screen/search_trip/search_page.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:go_together/model/trip.dart';
import 'package:go_together/screen/create_trip_page.dart';
import 'package:go_together/screen/manage_trips/manage_trips_page.dart';
import 'package:go_together/screen/trip_detail/trip_detail_page.dart';

import '../screen/auth/check_info.dart';
import '../screen/auth/forgot_pass_page.dart';
import '../screen/auth/login_page.dart';
import '../screen/auth/register_page.dart';
import '../screen/chat/channel_page.dart';
import '../screen/home_page.dart';
import '../screen/main_page.dart';

class Routes {
  static const login = '/LoginPage';
  static const register = '/RegisterPage';
  static const forgot = '/ForgotPassPage';
  static const home = '/HomePage';
  static const main = '/MainPage';
  static const auth = '/AuthPage';
  static const checkInfo = '/CheckInfoPage';
  static const createTrip = '/CreateTripPage';
  static const channel = '/ChannelPage';
  static const search = '/SearchPage';
  static const notification = '/NotificationPage';
  static const searchChat = '/SearchChatPage';
  static const manageTrips = '/manageTrips';
  static const tripDetail = '/tripDetail';

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
      case Routes.createTrip:
        {
          return MaterialPageRoute(
              builder: (context) => const CreateTripPage(), settings: settings);
        }
      case Routes.search:
        {
          return MaterialPageRoute(
              builder: (context) => const SearchPage(), settings: settings);
        }
      case Routes.channel:
        final arg = settings.arguments as Channel;
        {
          return MaterialPageRoute(
              builder: (context) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  builder: (context, widget) {
                    return StreamChat(
                      client: ChatUtil.client,
                      child: widget,
                    );
                  },
                  home: StreamChannel(
                    channel: arg,
                    child: ChannelPage(
                      buildContext: context,
                    ),
                  ),
                );
              },
              settings: settings);
        }
      case Routes.notification:
        {
          return MaterialPageRoute(
              builder: (context) => const NotificationPage(),
              settings: settings);
        }
      case Routes.searchChat:
        {
          return MaterialPageRoute(
              builder: (context) => SearchChatPage(
                    buildContext: context,
                  ),
              settings: settings);
        }
      case Routes.manageTrips:
        return SlideRightRoute(
            widget: const ManageTripsPage(), settings: settings);
      case tripDetail:
        final trip = settings.arguments as Trip;
        return SlideRightRoute(
            widget: TripDetailPage(trip: trip), settings: settings);
    }
    return null;
  }
}

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
