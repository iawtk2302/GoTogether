part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FavoriteLoadEvent extends FavoriteEvent {
  
}


class FavoriteUpdateEvent extends FavoriteEvent {
  final Trip trip;

  const FavoriteUpdateEvent({required this.trip});
  @override
  List<Object> get props => [trip];
}

class FavoriteUpdateEmptyEvent extends FavoriteEvent {
  
}