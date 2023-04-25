part of 'search_filter_trip_bloc.dart';

abstract class SearchFilterTripState extends Equatable {
  const SearchFilterTripState();
  
  @override
  List<Object> get props => [];
}

class SearchFilterTripInitial extends SearchFilterTripState {}

class SearchLoading extends SearchFilterTripState {
  const SearchLoading();
 
  @override
  List<Object> get props => [];
}

class SearchFilterTripLoaded extends SearchFilterTripState {
  const SearchFilterTripLoaded({required this.listTrip});
  final List<Trip> listTrip;
  @override
  List<Object> get props => [listTrip];
}