import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/model/custom_user.dart';
import 'package:go_together/model/trip.dart';
import 'package:go_together/screen/manage_trips/dialog_check_list.dart';
import 'package:go_together/utils/date_time_utils.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:go_together/utils/toasty.dart';
import 'package:go_together/widget/custom_button.dart';
import 'package:go_together/widget/custom_medium_divider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';

import '../../bloc/map_support/map_support_bloc.dart';
import '../../model/notification.dart';
import '../map/map_sample.dart';

class TripOwnerPreview extends StatefulWidget {
  TripOwnerPreview({super.key, required this.trip});

  final Trip trip;

  // final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.874327, 106.7992051),
    zoom: 14.4746,
  );

  @override
  State<TripOwnerPreview> createState() => _TripOwnerPreviewState();
}

class _TripOwnerPreviewState extends State<TripOwnerPreview> {
  late String status;
  final activities = {
    "Bơi": "🏊‍♀️",
    "Cắm trại": "🏕️",
    'Leo núi': "🧗",
    "Quay phim": "🎥",
    "Chụp ảnh": "📷",
    "Câu cá": "🪝",
    "Nhảy dù": "🪂",
    "Nấu ăn": "🍚",
    "Lặn": "🤿",
    "Tình nguyện": "🫶",
    "Lễ hội âm nhạc": "🎶",
    "Trải nghiệm văn hóa địa phương": "🏘️",
  };

  Map<String, String> mapStatus = {
    "pending": 'Chờ',
    'start': 'Đang đi',
    'lock': 'Khóa',
    'canceled': 'Hủy',
    'completed': 'Hoàn thành',
  };

  @override
  void initState() {
    status = widget.trip.status.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.black,
                  ))),
          const SizedBox(width: 8)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(children: [
              SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                    fit: BoxFit.cover, imageUrl: widget.trip.image),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          _buildTitleAddress(),
          const SizedBox(height: 32),
          const CustomMediumDivider(),
          const SizedBox(height: 8),
          _buildDateQuantity(),
          const SizedBox(height: 26),
          const CustomMediumDivider(),
          const SizedBox(height: 8),
          _buildDescription(),
          const SizedBox(height: 26),
          const CustomMediumDivider(),
          const SizedBox(height: 8),
          _buildActivities(),
          const SizedBox(height: 26),
          const CustomMediumDivider(),
          _buildMap(),
          const SizedBox(height: 26),
          const CustomMediumDivider(),
          QrImageView(
                data: jsonEncode({
                  "idTrip": widget.trip.idTrip,
                  "title": widget.trip.title,
                  "idCreator": widget.trip.idCreator
                }),
                version: QrVersions.auto,
                size: 200.0,
              ),
          const SizedBox(
            height: 100,
          ),
          const SizedBox(height: 26),
          const CustomMediumDivider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Trạng thái: ${mapStatus[status]}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: CustomButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('Trip')
                          .doc(widget.trip.idTrip)
                          .update({'status': 'lock'});
                      setState(() {
                        status = 'lock';
                      });
                    },
                    text: 'Khóa',
                    isDisable: status == 'lock' ||
                        status == 'completed' ||
                        status == 'canceled' ||
                        status == 'start',
                  ),
                ),
                SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: CustomButton(
                    onPressed: () async {
                      final success = await showDialog(
                          context: context,
                          builder: (context) => DialogCheckList(
                                trip: widget.trip,
                              ));

                      if (success) {
                        setState(() {
                          status = 'completed';
                        });
                      }
                    },
                    text: 'Hoàn thành',
                    isDisable: status == 'completed' || status == 'canceled',
                  ),
                ),
              ],
            ),
          ),
          if (status != 'start') _buildButtonStart(),
          if (status == 'start') _buildButtonGo(),
          _buildButtonCancel()
        ]),
      ),
    );
  }

  Widget _buildButtonCancel() {
    return Container(
      color: Colors.transparent,
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4),
        child: CustomButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('Trip')
                .doc(widget.trip.idTrip)
                .update({'status': 'canceled'});
            setState(() {
              status = 'canceled';
            });
          },
          text: 'Hủy',
          color: Colors.red[500],
          isDisable: status == 'canceled' || status == 'completed',
        ),
      ),
    );
  }

  Widget _buildButtonStart() {
    return Container(
      color: Colors.transparent,
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4),
        child: CustomButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('Trip')
                .doc(widget.trip.idTrip)
                .update({'status': 'start'});
            setState(() {
              status = 'start';
            });
            BlocProvider.of<MapSupportBloc>(context)
                .add(MapSupportLoadMembersEvent(idTrip: widget.trip.idTrip));
            BitmapDescriptor icon =
                await MarkerIcon.downloadResizePictureCircle(
                    FirebaseUtil.currentUser!.photoURL!,
                    size: 100);
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapSuport(
                          icon: icon,
                          trip: widget.trip,
                        )));
          },
          text: 'Bắt đầu',
          color: Colors.green[500],
          isDisable: status == 'start' ||
              status == 'completed' ||
              status == 'canceled',
        ),
      ),
    );
  }

  Widget _buildButtonGo() {
    return Container(
      color: Colors.transparent,
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4),
        child: CustomButton(
          onPressed: () async {
            BlocProvider.of<MapSupportBloc>(context)
                .add(MapSupportLoadMembersEvent(idTrip: widget.trip.idTrip));
            BitmapDescriptor icon =
                await MarkerIcon.downloadResizePictureCircle(
                    FirebaseUtil.currentUser!.photoURL!,
                    size: 100);
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapSuport(
                          icon: icon,
                          trip: widget.trip,
                        )));
          },
          text: 'Đi',
          color: Colors.green[500],
          // isDisable: status == 'start' ||
          //     status == 'completed' ||
          //     status == 'canceled',
        ),
      ),
    );
  }

  Column _buildMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: TripOwnerPreview._kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              // _controller.complete(controller);
            },
            onTap: (argument) {},
            // markers: markers,
          ),
        ),
        const SizedBox(height: 6),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: Text(widget.trip.destination),
        // ),
      ],
    );
  }

  Widget _buildActivities() {
    return SizedBox(
      height: widget.trip.activities.length < 3 ? 100 : 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Hoạt động',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Center(
                child: widget.trip.activities.isEmpty
                    ? const Text(
                        'Không có hoạt động nào',
                        style: TextStyle(color: Colors.black),
                      )
                    : Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(
                          widget.trip.activities.length,
                          (index) => _buttonActivity(
                              widget.trip.activities[index],
                              activities[widget.trip.activities[index]],
                              index),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonActivity(text, icon, index) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () {},
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: CustomColor.buttonActivityBgColor.withOpacity(.5),
                  border: Border.all(color: CustomColor.blue)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                children: [
                  Text(icon),
                  Text(' ${text}'),
                ],
              )),
        ),
      ),
      SizedBox(
        width: 6,
      ),
    ]);
  }

  // Widget _buildActivities() {
  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Mô tả',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(widget.trip.description)
        ],
      ),
    );
  }

  Widget _buildDateQuantity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customDateQuantity('Ngày bắt đầu',
                    widget.trip.dateStart.toDate().toDateInfoFormat()),
                const SizedBox(height: 12),
                _customDateQuantity('Số người đã tham gia',
                    widget.trip.membersId.length.toString()),
              ],
            ),
          ),
          Expanded(
            child: _customDateQuantity('Ngày kết thúc',
                widget.trip.dateEnd.toDate().toDateInfoFormat()),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.trip.title,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  widget.trip.destination,
                )
              ],
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('User')
                  .doc(widget.trip.idCreator)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                CustomUser? user;
                if (snapshot.data != null) {
                  user = CustomUser.fromJson(snapshot.data!.data()!);
                }

                return CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(
                      user == null ? '' : user.image ?? ""),
                );
              })
        ],
      ),
    );
  }

  // Widget _buttonActivity(text) {
  Widget _customDateQuantity(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(value)
      ],
    );
  }
}
