import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/home/home_bloc.dart';
import 'package:go_together/bloc/user/user_bloc.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/main_page.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (_) => HomeBloc()..add(HomeLoadEvent())),
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
