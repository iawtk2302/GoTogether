part of 'map_support_bloc.dart';

abstract class MapSupportEvent extends Equatable {
  const MapSupportEvent();

  @override
  List<Object> get props => [];
}

class MapSupportLoadMembersEvent extends MapSupportEvent {
  final String idTrip;

  const MapSupportLoadMembersEvent({required this.idTrip});

  @override
  List<Object> get props => [idTrip];
}

class MapSupportUpdateMembersEvent extends MapSupportEvent {
  final List<Member> members;

  const MapSupportUpdateMembersEvent({required this.members});

  @override
  List<Object> get props => [members];
}

class MapSupportUpdatePositionToFirebase extends MapSupportEvent {
  final LatLng latLng;
  final String idTrip;

  const MapSupportUpdatePositionToFirebase( {required this.latLng, required this.idTrip});
  @override
  List<Object> get props => [latLng, idTrip];
}
