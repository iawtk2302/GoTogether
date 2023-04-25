import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/widget/custom_app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: CustomColor.blue1
            ),
            child: Center(
              child: TextField(   
                decoration: InputDecoration(
                  border: InputBorder.none,                
                  hintText: "Search",
                  fillColor: CustomColor.blue1,
                  filled: true,
                  suffixIcon: Icon(Icons.menu),
                  prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
  
}