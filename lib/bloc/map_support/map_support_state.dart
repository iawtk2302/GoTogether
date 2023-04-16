part of 'map_support_bloc.dart';

abstract class MapSupportState extends Equatable {
  const MapSupportState();
  
  @override
  List<Object> get props => [];
}

class MapSupportInitial extends MapSupportState {}

class MapSupportLoaded extends MapSupportState {
  final List<Member> members;

  const MapSupportLoaded({required this.members});

  

  @override
  List<Object> get props => [members];
}