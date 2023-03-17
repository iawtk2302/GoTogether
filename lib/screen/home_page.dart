import 'package:flutter/material.dart';
import 'package:go_together/repository/auth_repository.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(onPressed: ()async{AuthRepository().signOut();}, child: Text("out"))
    ],);
  }
}