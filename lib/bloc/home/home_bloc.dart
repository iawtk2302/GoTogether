import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:http/http.dart' as http;
import '../../model/trip.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<dynamic>? listIdTrip;
  int? completedTrip = 0;
  // List<Trip>? temp = [];
  List<Trip>? trips = [];
  HomeBloc() : super(HomeLoading()) {
    on<HomeLoadEvent>((event, emit) async {
      emit(HomeLoading());
      final dio = Dio();
    final tempTrips =  await FirebaseFirestore.instance
          .collection('Trip')
          // .where('idCreator', isEqualTo: FirebaseUtil.currentUser!.uid)
          .where('status', isEqualTo: "completed")
          .get();
         
      final temp = tempTrips.docs.map((e) => Trip.fromJson(e.data())).toList();
      final temp1= temp.where((element) => element.membersId.contains(FirebaseUtil.currentUser!.uid)).toList();
      completedTrip=temp1.length;
      if (completedTrip! > 0) {
        // final body={
        //   "idTrip": temp[0].idTrip,
        //   "title": temp[0].title,
        //   "description": temp[0].description,
        //   "activities": temp[0].activities.join("|")
        // };
        print(temp1[0].activities.join("|"));
        final body = {
          "idTrip": temp1[0].idTrip,
          "title": temp1[0].title,
          "description":temp1[0].description,
          "activities": temp1[0].activities.join("|")
        };
        final response = await dio.post(
            "https://gotogether-recommendation.onrender.com/recommend_trips",
            data: body);

        listIdTrip = response.data['recommended_trips'];
        print(listIdTrip);
        // listIdTrip.forEach((element) {
        //    FirebaseFirestore.instance
        //     .collection('Trip').doc(element.toString()).get().then((value) => trips.add(Trip.fromJson(value.data()!)));
        // });
        // for(int i=0; i<listIdTrip.length;i++){
        //   FirebaseFirestore.instance
        //     .collection('Trip').doc(listIdTrip[i].toString()).get().then((value) => trips.add(Trip.fromJson(value.data()!)));
        // }
        // Future.delayed(Duration(seconds: 5));
        await processArray(listIdTrip!);
        emit(HomeLoaded(trips: trips!));
      } else {
        final trip = await FirebaseFirestore.instance
            .collection('Trip')
            .where("status", isEqualTo: "pending")
            .limit(10)
            .get();
        trips!.addAll(trip.docs.map((e) => Trip.fromJson(e.data())));
        emit(HomeLoaded(trips: trips!));
      }
    });
  }
  Future<void> processArray(List<dynamic> array) async {
    for (dynamic item in array) {
      await performAsyncOperation(item);
      // Hành động khác sau khi hàm performAsyncOperation() hoàn thành
      print('Completed processing item: $item');
    }
  }

  Future<void> performAsyncOperation(dynamic item) async {
    // Đây là một hàm bất đồng bộ mô phỏng một công việc mất thời gian thực hiện
    await FirebaseFirestore.instance
        .collection('Trip')
        .doc(item.toString())
        .get()
        .then((value) => trips!.add(Trip.fromJson(value.data()!)));
    print('Finished processing item: $item');
  }
}
