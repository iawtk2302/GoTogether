import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_together/repository/auth_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Column(
          children: [
            ElevatedButton(onPressed: (){
              AuthRepository().signOut();
            }, child: Text("Sign out")),
            Text('Profile Page'),
          ],
        )),
      ),
    );
  }
}
