import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/manage_trip/manage_trip_bloc.dart';
import 'package:go_together/screen/manage_trips/completed_trip_tab.dart';
import 'package:go_together/screen/manage_trips/own_trip_tab.dart';
import 'package:go_together/screen/manage_trips/trip_active_tab.dart';


class UserReviewPage extends StatefulWidget {
  const UserReviewPage({super.key});

  @override
  State<UserReviewPage> createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  @override
  void initState() {
    BlocProvider.of<ManageTripBloc>(context)
        .add(ManageTripLoadEvent(idUser: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Đánh giá người dùng',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Urbanist'),
          ),
          bottom: const TabBar(
            // indicatorColor: Theme.of(context).textTheme.bodyText2!.color,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'Hoạt động'),
              Tab(
                text: 'Của bạn',
              ),
              Tab(
                text: 'Hoàn thành',
              )
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.5,
        ),
        body: const TabBarView(
          children: [
            Text('data'),
            Text('data'),
            Text('data'),
          ],
        ),
      ),
    );
  }
}
