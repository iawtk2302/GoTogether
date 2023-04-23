import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/model/trip.dart';
import 'package:go_together/utils/date_time_utils.dart';
import 'package:go_together/widget/custom_button.dart';
import 'package:go_together/widget/custom_medium_divider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailPage extends StatelessWidget {
  TripDetailPage({super.key, required this.trip});

  final Trip trip;

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.874327, 106.7992051),
    zoom: 14.4746,
  );

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(children: [
                  SizedBox(
                    width: double.infinity,
                    child: CachedNetworkImage(
                        fit: BoxFit.cover, imageUrl: trip.image),
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
              const SizedBox(height: 32),
              const CustomMediumDivider(),
              Image.asset(
                'assets/images/qr_test.png',
                height: 200,
              ),
              const SizedBox(
                height: 100,
              ),
            ]),
          ),
          _buildButtonRequest()
        ],
      ),
    );
  }

  Positioned _buildButtonRequest() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.transparent,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: CustomButton(onPressed: () {}, text: 'Yêu cầu tham gia'),
          ),
        ));
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
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (argument) {},
            // markers: markers,
          ),
        ),
        Text(trip.description),
      ],
    );
  }

  Widget _buildActivities() {
    return SizedBox(
      height: 120,
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
            Expanded(
              child: Center(
                child: trip.activities.isEmpty
                    ? const Text(
                        'Không có hoạt động nào',
                        style: TextStyle(color: Colors.black),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trip.activities.length ~/ 3,
                        itemBuilder: (context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buttonActivity(trip.activities[index * 3]),
                              _buttonActivity(trip.activities[index * 3 + 1]),
                              _buttonActivity(trip.activities[index * 3 + 2])
                            ]),
                      ),
              ),
            )
            // const SizedBox(
            //   height: 8,
            // ),

            // const SizedBox(
            //   height: 12,
            // ),
            // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //   _buttonActivity(),
            //   _buttonActivity(),
            //   _buttonActivity()
            // ]),
          ],
        ),
      ),
    );
  }

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
          Text(trip.description)
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
                _customDateQuantity(
                    'Ngày bắt đầu', trip.dateStart.toDate().toDateInfoFormat()),
                const SizedBox(height: 12),
                _customDateQuantity('Số người', trip.quantity.toString()),
              ],
            ),
          ),
          Expanded(
            child: _customDateQuantity(
                'Ngày kết thúc', trip.dateEnd.toDate().toDateInfoFormat()),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.destination,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Cat Tai, Phu Cat, Binh Dinh',
              )
            ],
          ),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                'https://firebasestorage.googleapis.com/v0/b/gotogether-1b01c.appspot.com/o/2Q8nqe3yHjj1YKsperyB.jpg?alt=media&token=c071b178-6426-44e0-9d8d-4a21332eeb53'),
          )
        ],
      ),
    );
  }

  Widget _buttonActivity(text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {},
        child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomColor.buttonActivityBgColor.withOpacity(.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Text(text)),
      ),
    );
  }

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
