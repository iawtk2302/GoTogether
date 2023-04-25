import 'package:flutter/material.dart';

class CategoriesPlaces extends StatelessWidget {
  CategoriesPlaces({super.key, required this.onPress});

  final Function onPress;

  final categories = [
    {
      "icon": Icons.restaurant,
      'place': 'Restaurants',
      "value": 'restaurant'
    },
    {
      "icon": Icons.hotel,
      'place': 'Hotels',
      "value": 'lodging'
    },
    {
      "icon": Icons.coffee,
      'place': 'Coffee',
      "value": 'cafe'
    },
    {
      "icon": Icons.local_gas_station_rounded,
      'place': 'Fuel',
      'value': 'gas_station'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (ctx, index) => SizedBox(
          child: Center(
            child: _itemPlace(index),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 8),
      ),
    );
  }

  Widget _itemPlace(int index) {
    return InkWell(
      onTap: () {
        onPress(categories[index]["value"]);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(8),
        child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon((categories[index]["icon"] as IconData)),
              const SizedBox(width: 6),
              Text(
                categories[index]["place"] as String,
                textAlign: TextAlign.center,
              )
            ]),
      ),
    );
  }
}
