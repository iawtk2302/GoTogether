import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/favorite/favorite_bloc.dart';
import 'package:go_together/bloc/home/home_bloc.dart';
import 'package:go_together/bloc/manage_trip/manage_trip_bloc.dart';
import 'package:go_together/bloc/user/user_bloc.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/repository/notification_repository.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/main_page.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'bloc/map_support/map_support_bloc.dart';
import 'bloc/search_filter_trip/search_filter_trip_bloc.dart';
// @pragma('vm:entry-point')
// Future<void> onBackgroundMessage(RemoteMessage message) async {
//   final chatClient = StreamChatClient("d5k87ckf34wh");

//   await chatClient.connectUser(
//     User(id: FirebaseUtil.currentUser!.uid,role: "user", image: FirebaseUtil.currentUser!.photoURL, name: FirebaseUtil.currentUser!.displayName),
//     await chatClient.devToken(FirebaseUtil.currentUser!.uid).rawValue,
//     connectWebSocket: false,
//   );

//   handleNotification(message, chatClient);
// }
// Future<FlutterLocalNotificationsPlugin> setupLocalNotifications() async {
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   final initializationSettingsIOS = IOSInitializationSettings();
//   final initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String? payload) async {
//     // Handle notification tap
//   });
//   return flutterLocalNotificationsPlugin;
// }
// void handleNotification(
//   RemoteMessage message,
//   StreamChatClient chatClient,
// ) async {

//   final data = message.data;

//   if (data['type'] == 'message.new') {
//     final flutterLocalNotificationsPlugin = await setupLocalNotifications();
//     final messageId = data['id'];
//     final response = await chatClient.getMessage(messageId);

//     flutterLocalNotificationsPlugin.show(
//       1,
//       'New message from ${response.message.user!.name} in ${response.channel!.name}',
//       response.message.text,
//       NotificationDetails(
//           android: AndroidNotificationDetails(
//         'new_message',
//         'New message notifications channel',
//         ""
//       )),
//     );
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  await NotificationRepository().initializeNotification();
  await Firebase.initializeApp();
  runApp(const MyApp());
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Got a message whilst in the foreground!');
//   print('Message data: ${message.data}');

//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//   }
// });
}
// Future<void> showNotification({
//   required String title,
//   required String body,
//   int? channelId,
// }) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'stream_chat_channel',
//     'Stream Chat Channel',
//     'Notifications for new messages',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: true,
//   );
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await FlutterLocalNotificationsPlugin().show(
//     channelId ?? 0,
//     title,
//     body,
//     platformChannelSpecifics,
//   );
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => SearchFilterTripBloc()),
        BlocProvider(create: (_) => HomeBloc()..add(HomeLoadEvent())),
        BlocProvider(create: (context) => MapSupportBloc()),
        BlocProvider(create: (context) => ManageTripBloc()),
        BlocProvider(create: (context) => FavoriteBloc()..add(FavoriteLoadEvent()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Go Together',
        onGenerateRoute: (settings) => Routes().getRoute(settings),
        theme: ThemeData(
          primarySwatch: createMaterialColor(CustomColor.blue),
          // textTheme: ThemeData.light().textTheme.copyWith(
          //       bodyText1: TextStyle(color: Colors.white),
          //       bodyText2: TextStyle(color: Colors.white),
          //       headline1: TextStyle(color: Colors.white),
          //       headline2: TextStyle(color: Colors.white),
          //       headline3: TextStyle(color: Colors.white),
          //       headline4: TextStyle(color: Colors.white),
          //       headline5: TextStyle(color: Colors.white),
          //       headline6: TextStyle(color: Colors.white),
          //       subtitle1: TextStyle(color: Colors.white),
          //       subtitle2: TextStyle(color: Colors.white),
          //       caption: TextStyle(color: Colors.white),
          //       overline: TextStyle(color: Colors.white),
          //       button: TextStyle(color: Colors.black),
          //     ),
        ),
        home: MainPage(),
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
