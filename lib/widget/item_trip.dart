import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/trip.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:go_together/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ItemTrip extends StatelessWidget {
  const ItemTrip({
    super.key,
    required this.trip,
  });
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pushNamed(context, Routes.tripDetail, arguments: trip);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 230,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: trip.image,
                        ),
                      )),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconFavorite(trip: trip),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.destination,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [Icon(Icons.star), Text('4.1')],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                'Cách 1 km',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                trip.dateStart.toDate().toHighlightFormat(),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconFavorite extends StatefulWidget {
  const IconFavorite({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  State<IconFavorite> createState() => _IconFavoriteState();
}

class _IconFavoriteState extends State<IconFavorite> {
  bool isFavorite = false;
  String id = '';
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Favorite')
                  .where("idUser", isEqualTo: FirebaseUtil.currentUser!.uid)
                  .where("idTrip", isEqualTo: widget.trip.idTrip)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  );
                }
                isFavorite = snapshot.data!.docs.isNotEmpty;
                if (isFavorite) {
                  id = snapshot.data!.docs.first.id;
                }
                return Icon(
                  !isFavorite ? Icons.favorite_border : Icons.favorite,
                  color: Colors.white,
                );
              }),
        ),
        onTap: () async {
          // final data = await FirebaseFirestore.instance
          //     .collection('Favorite')
          //     .where("idUser", isEqualTo: FirebaseUtil.currentUser!.uid)
          //     .where("idTrip", isEqualTo: widget.trip.idTrip)
          //     .get();
          if (!isFavorite) {
            final uuid = Uuid();
            final id = uuid.v1();
            await FirebaseFirestore.instance
                .collection('Favorite')
                .doc(id)
                .set({
              "idFavorite": id,
              "idUser": FirebaseUtil.currentUser!.uid,
              "idTrip": widget.trip.idTrip
            });
          } else {
            await FirebaseFirestore.instance
                .collection('Favorite')
                .doc(id)
                .delete();
          }
          setState(() {
            isFavorite = !isFavorite;
          });
        },
      ),
    );
  }
}
