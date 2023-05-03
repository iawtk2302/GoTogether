part of 'map_support_bloc.dart';

abstract class MapSupportState extends Equatable {
  const MapSupportState();

  @override
  List<Object> get props => [];
}

class MapSupportInitial extends MapSupportState {}

class MapSupportLoaded extends MapSupportState {
  final List<Member> members;
  final Map<String, BitmapDescriptor>? icons;

  const MapSupportLoaded({required this.members, this.icons});

  MapSupportLoaded copyWith({
    final List<Member>? members,
    final Map<String, BitmapDescriptor>? icons,
  }) {
    return MapSupportLoaded(
        members: members ?? this.members, icons: icons ?? this.icons);
  }

  @override
  List<Object> get props => [members];
}
