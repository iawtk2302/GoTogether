import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/item_trip.dart';

import '../bloc/home/home_bloc.dart';
import '../bloc/user/user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 210,
            width: double.infinity,
            color: Colors.green,
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Go together',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                        Text(
                          'Find in minute',
                          style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              // fontSize: 18,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4), width: 0.5),
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 4, top: 4, bottom: 4),
                        child: Row(children: [
                          const Icon(Icons.menu, color: Colors.white),
                          const SizedBox(
                            width: 16,
                          ),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              if (state is UserLoading) {
                                return CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      'https://firebasestorage.googleapis.com/v0/b/sneakerapp-f4de5.appspot.com/o/RWN1mUAm9FXdowlsgKbZqU25zt23.jpg?alt=media&token=0df163e4-3a98-4371-90a7-52ec17c26320'),
                                );
                              } else if (state is UserExist) {
                                return CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      state.user.image.toString()),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                width: size.width - 60,
                height: 95,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 12),
                        child: Text(
                          'Where did you go?',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.arrow_circle_right_rounded,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: TextField(
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              hintText: 'Search location',
                              hintStyle: TextStyle(fontSize: 12),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 1)),
                            ),
                          )),
                        ],
                      ))
                    ]),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 210.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 210,
              width: double.infinity,
              // color: Colors.red,
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const SizedBox();
                  } else if (state is HomeLoaded) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12),
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Recommend for you',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ),
                          ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  ItemTrip(trip: state.trips[index]),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemCount: state.trips.length)
                        ]),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.createTrip);
          }),
    );
  }
}

// Widget itemRender() {
//   return ItemTrip();
// }

