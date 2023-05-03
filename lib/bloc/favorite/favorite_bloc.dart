import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../model/trip.dart';
import '../../utils/firebase_utils.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteLoading()) {
    on<FavoriteLoadEvent>(_load);
    on<FavoriteUpdateEvent>(_update);
    on<FavoriteUpdateEmptyEvent>(_updateEmpty);
  }

  _load(FavoriteLoadEvent event, Emitter<FavoriteState> emit) async {
    if (state is FavoriteLoading) {
      emit(FavoriteLoaded(trips: []));
    }
    print(FirebaseUtil.currentUser!.uid);
    final data = await FirebaseFirestore.instance
        .collection('Favorite')
        .where("idUser", isEqualTo: FirebaseUtil.currentUser!.uid)
        .snapshots();
    final List<String> idFavorites = [];

    data.listen((event) async {
      Logger().v('change');
      if (event.docs.isEmpty) {
      Logger().v('empty');

        add(FavoriteUpdateEmptyEvent());
      } else if (state is FavoriteLoaded) {
        final curr = state as FavoriteLoaded;

        curr.trips.clear();
        Logger().v('change1');

        for (var element in event.docs) {
          // idFavorites.add();
          final snapshot = await FirebaseFirestore.instance
              .collection('Trip')
              .where("idTrip", isEqualTo: element.data()['idTrip'])
              .get();

          add(FavoriteUpdateEvent(
              trip: Trip.fromJson(snapshot.docs.first.data())));
        }
      }
    });
  }

  _update(FavoriteUpdateEvent event, Emitter<FavoriteState> emit) {
    if (state is FavoriteLoading) {
      emit(FavoriteLoaded(trips: [event.trip]));
    } else if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;

      Set temp = currentState.trips.toSet();

      temp.add(event.trip);

      emit(FavoriteLoaded(trips: temp.toList() as List<Trip>));
    }
  }

  _updateEmpty(FavoriteUpdateEmptyEvent event, Emitter<FavoriteState> emit) {
    emit(FavoriteLoaded(trips: []));
  }
}
