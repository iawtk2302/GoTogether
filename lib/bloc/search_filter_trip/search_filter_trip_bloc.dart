import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../model/trip.dart';

part 'search_filter_trip_event.dart';
part 'search_filter_trip_state.dart';

class SearchFilterTripBloc extends Bloc<SearchFilterTripEvent, SearchFilterTripState> {
  SearchFilterTripBloc() : super(SearchFilterTripInitial()) {
    on<LoadSearch>((event, emit) {
      emit(SearchLoading());
      emit(SearchFilterTripLoaded(listTrip: []));
    });
    on<Query>((event, emit) async{
      final trips=FirebaseFirestore.instance.collection("Trip");
      List<Trip> temp=[];
      await trips.where("status",isEqualTo: "pending").get().then((value) {
        temp.addAll(value.docs.map((e) => Trip.fromJson(e.data())).toList());
      },);
      List<Trip> temp2 = temp.where((element) => element.title.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(SearchFilterTripLoaded(listTrip: temp2));
    });
  }
}
