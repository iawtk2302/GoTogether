part of 'manage_trip_bloc.dart';

abstract class ManageTripState extends Equatable {
  const ManageTripState();
  
  @override
  List<Object> get props => [];
}

class ManageTripLoading extends ManageTripState {}

class ManageTripLoaded extends ManageTripState {
  final List<Trip> trips;

  const ManageTripLoaded({required this.trips});

   @override
  List<Object> get props => [trips];
}
