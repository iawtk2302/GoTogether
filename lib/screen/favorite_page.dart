import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_together/screen/map/search_sample.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../router/routes.dart';
import 'map/map_sample.dart';

// import '../screen/map/map_example.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Text('Favorite'),
          TextButton(
              onPressed: () async {
                BitmapDescriptor icon =
                    await MarkerIcon.downloadResizePictureCircle(
                        'https://cdn-icons-png.flaticon.com/512/4139/4139981.png',
                        size: 100);
                Navigator.pushNamed(context, Routes.manageTrips);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (ctx) => MapSuport(icon: icon,)));
              },
              child: Text('click'))
        ]),
      ),
    );
  }
}
