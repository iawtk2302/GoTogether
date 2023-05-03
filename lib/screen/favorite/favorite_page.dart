import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:go_together/utils/date_time_utils.dart';
import 'package:go_together/widget/rating_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../bloc/favorite/favorite_bloc.dart';
import '../../model/trip.dart';
import '../../router/routes.dart';
import '../../utils/firebase_utils.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Yêu thích',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriteLoaded) {
              print(state.trips.length);
              return ListView.builder(
                  itemCount: state.trips.length,
                  itemBuilder: (context, index) =>
                      _itemTripManage(context, state.trips[index]));
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}

Widget _itemTripManage(BuildContext context, Trip trip) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, Routes.tripDetail, arguments: trip);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: trip.image,
                  errorWidget: (context, url, error) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trip.title,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () async {
                            final favorite = await FirebaseFirestore.instance
                                .collection('Favorite')
                                .where("idUser",
                                    isEqualTo: FirebaseUtil.currentUser!.uid)
                                .where("idTrip", isEqualTo: trip.idTrip)
                                .get();
                            await FirebaseFirestore.instance
                                .collection('Favorite')
                                .doc(favorite.docs.first.id)
                                .delete();
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text(trip.destination),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trip.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            trip.dateStart.toDate().toDateMiniTripFormat(),
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
