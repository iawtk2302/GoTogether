part of 'search_filter_trip_bloc.dart';

abstract class SearchFilterTripEvent extends Equatable {
  const SearchFilterTripEvent();

  @override
  List<Object> get props => [];
}

class LoadSearch extends SearchFilterTripEvent {
  const LoadSearch();
  @override
  List<Object> get props => [];
}

class Query extends SearchFilterTripEvent {
  const Query({required this.query});
  final String query;
  @override
  List<Object> get props => [query];
}
