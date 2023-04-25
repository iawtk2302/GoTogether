import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/search_filter_trip/search_filter_trip_bloc.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/item_trip.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    BlocProvider.of<SearchFilterTripBloc>(context).add(LoadSearch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      body: BlocBuilder<SearchFilterTripBloc, SearchFilterTripState>(
        builder: (context, state) {
          if(state is SearchLoading){
            return CircularProgressIndicator();
          }
          else if (state is SearchFilterTripLoaded){
            return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CustomColor.blue1),
                child: Center(
                  child: TextField(
                    onChanged: (value) {
                      BlocProvider.of<SearchFilterTripBloc>(context).add(Query(query: value));
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        fillColor: CustomColor.blue1,
                        filled: true,
                        suffixIcon: Icon(Icons.menu),
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
              ), 
              Expanded(
                child: ListView.builder(
                  itemCount: state.listTrip.length,
                  itemBuilder: (context, index) {
                  return ItemTrip(trip: state.listTrip[index]);
                },),
              )
            ]),
          );
          }
          else{
            return Container();
          }
        },
      ),
    );
  }
}
