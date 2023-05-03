import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/search_filter_trip/search_filter_trip_bloc.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/custom_button.dart';
import 'package:go_together/widget/item_trip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
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
  int quantity=1;
  List<DateTime?> _dates=[];
  var formatter = DateFormat('dd-MM-yyyy');
  Future<List<String>> _fetchProvinces() async {
  final response = await http.get(Uri.parse('https://vapi.vnappmob.com/api/province'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    final provinces = data['results'] as List<dynamic>;
    return provinces.map((province) => province['province_name'] as String).toList();
  } else {
    throw Exception('Failed to load provinces');
  }
}
  Future<List<String>> _searchProvinces(String query) async {
  final provinces = await _fetchProvinces();
  return provinces
      .where((province) => province.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) { 
          return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            color: Colors.white
          ),
          height: 300, 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: CustomColor.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(50)
                  ),
                ),
                SizedBox(height: 5,),
                Text("Lọc",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, ),),
                SizedBox(height: 15,),
                InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          var results = await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                                calendarType: CalendarDatePicker2Type.range,
                                firstDate: DateTime.now()),
                            dialogSize: const Size(325, 400),
                            value: _dates,
                            borderRadius: BorderRadius.circular(15),
                          );
          
                          setState(() {
                            _dates = results!;
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: CustomColor.blue1,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Ngày bắt đầu",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColor.grey),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _dates.length == 0
                                              ? "--/--/----"
                                              : formatter.format(_dates[0]!),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: _dates.length == 0
                                                  ? CustomColor.grey
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: CustomColor.blue1,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Ngày kết thúc",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: CustomColor.grey)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _dates.length == 0
                                              ? "--/--/----"
                                              : formatter.format(
                                                  _dates[_dates.length - 1]!),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: _dates.length == 0
                                                  ? CustomColor.grey
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: CustomColor.blue1,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Số thành viên",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: CustomColor.grey),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text("$quantity người",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (quantity > 1) {
                                            quantity -= 1;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.remove,
                                          color: Colors.black)),
                                  Text(quantity.toString()),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          quantity += 1;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),),
                        SizedBox(height: 15,),
                            CustomButton(
                        text: "Áp dụng",
                // child: Text('Áp dụng bộ lọc'),
                // trailing: Icon(Icons.check),
                onPressed: () async{
                      // widget.onFilterChanged(filter);
                      BlocProvider.of<SearchFilterTripBloc>(context).add(Filter(_dates[0]!, _dates[1]!, quantity));
                      Navigator.of(context).pop();
                },
                ),
                        // Row(children: [
                        //   Container(
                        //     width: 80,
                        //     height: 40,
                        //     child: CustomButton(onPressed: (){}, text: "hihi")),
                        //   ElevatedButton(onPressed: (){}, child: Text("haha"))
                        // ],)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       CustomButton(
                //         text: "Cancel",
                // // child: Text('Áp dụng bộ lọc'),
                // // trailing: Icon(Icons.check),
                // onPressed: (){
                //       // widget.onFilterChanged(filter);
                //       // BlocProvider.of<SearchFilterTripBloc>(context).add(Filter(_dates[0]!, _dates[1]!, quantity));
                //       Navigator.of(context).pop();
                // },
                // ),
                //       CustomButton(
                //         text: "Apply",
                // // child: Text('Áp dụng bộ lọc'),
                // // trailing: Icon(Icons.check),
                // onPressed: () async{
                //       // widget.onFilterChanged(filter);
                //       BlocProvider.of<SearchFilterTripBloc>(context).add(Filter(_dates[0]!, _dates[1]!, quantity));
                //       Navigator.of(context).pop();
                // },
                // ),
                //     ],
                //   )
                  ]),
          ));
         },
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Tìm kiếm"),
      body: BlocBuilder<SearchFilterTripBloc, SearchFilterTripState>(
        builder: (context, state) {
          if(state is SearchLoading){
            return CircularProgressIndicator();
          }
          else if (state is SearchFilterTripLoaded){
            return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Autocomplete<String>(

      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _searchProvinces(textEditingValue.text);
      },
      onSelected: (String selection) {
        print('You selected: $selection');
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return Container(
          height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CustomColor.blue1),
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nhập tên tỉnh",
                          fillColor: CustomColor.blue1,
                          filled: true,
                          suffixIcon: IconButton(icon:Icon(Icons.menu),onPressed: () => _showFilterBottomSheet(context),),
                          prefixIcon: Icon(Icons.search)),
            onSubmitted: (String value) {
              BlocProvider.of<SearchFilterTripBloc>(context).add(Query(query: value));
            },
          ),
        );
      },
    ),
              // Container(
              //   height: 55,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       color: CustomColor.blue1),
              //   child: Center(
              //     child: TextField(
              //       onChanged: (value) {
                      
              //       },
              //       decoration: InputDecoration(
              //           border: InputBorder.none,
              //           hintText: "Search",
              //           fillColor: CustomColor.blue1,
              //           filled: true,
              //           suffixIcon: Icon(Icons.menu),
              //           prefixIcon: Icon(Icons.search)),
              //     ),
              //   ),
              // ), 
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
