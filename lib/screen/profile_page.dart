import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_together/repository/auth_repository.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/map/map_sample.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  AuthRepository().signOut();
                },
                child: Text("Sign out")),
            Text('Profile Page'),
            TextButton(
                onPressed: () async {
                  // BitmapDescriptor icon =
                  //     await MarkerIcon.downloadResizePictureCircle(
                  //         'https://cdn-icons-png.flaticon.com/512/4139/4139981.png',
                  //         size: 100);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MapSuport(icon: icon)));
                },
                child: Text('map')),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.manageTrips);
                },
                child: Text('Manage Trip'))
          ],
        )),
      ),
    );
  }
}
