part of 'manage_trip_bloc.dart';

abstract class ManageTripEvent extends Equatable {
  const ManageTripEvent();

  @override
  List<Object> get props => [];
}

class ManageTripLoadEvent extends ManageTripEvent {
  final String idUser;

  const ManageTripLoadEvent({required this.idUser});
}

class ManageTripUpdateEvent extends ManageTripEvent {
  final List<Trip> trips;

  const ManageTripUpdateEvent({required this.trips});
  @override
  List<Object> get props => [trips];
}
