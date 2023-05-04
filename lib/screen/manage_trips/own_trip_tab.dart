import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/utils/date_time_utils.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/manage_trip/manage_trip_bloc.dart';
import '../../bloc/map_support/map_support_bloc.dart';
import '../../model/trip.dart';
import '../map/map_sample.dart';

class TripOwnTab extends StatelessWidget {
  const TripOwnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ManageTripBloc, ManageTripState>(
            builder: (context, state) {
              if (state is ManageTripLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ManageTripLoaded) {
                List<Trip> displayList = state.trips
                    .where((element) =>
                        element.idCreator == FirebaseUtil.currentUser!.uid)
                    .toList();
                return ListView.separated(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) =>
                      _itemTripManage(context, displayList[index]),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 2,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        )
      ],
    );
  }

  Widget _itemTripManage(BuildContext context, Trip trip) {
    return InkWell(
      onTap: () async {
        // if (trip.status == 'start') {
        //   BlocProvider.of<MapSupportBloc>(context)
        //       .add(MapSupportLoadMembersEvent(idTrip: trip.idTrip));
        //   BitmapDescriptor icon = await MarkerIcon.downloadResizePictureCircle(
        //       FirebaseUtil.currentUser!.photoURL!,
        //       size: 100);
        //   // ignore: use_build_context_synchronously
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => MapSuport(
        //                 icon: icon,
        //                 trip: trip,
        //               )));
        // } else {
          Navigator.pushNamed(context, Routes.tripOwnerPreview,
              arguments: trip);
        // }
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
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(imageUrl: trip.image, width: 100,),
              ),
              SizedBox(width: 6,),
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
                          Expanded(
                            child: Text(
                              trip.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            trip.dateStart.toDate().toDateMiniTripFormat(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          Text(trip.destination),
                        ],
                      ),
                      Text(
                        trip.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
}