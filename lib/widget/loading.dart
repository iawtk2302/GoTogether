import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class MyLoading extends StatefulWidget {
  const MyLoading({super.key});

  @override
  State<MyLoading> createState() => MyLoadingState();
}

class MyLoadingState extends State<MyLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 350,
      width: 350,
      child: Lottie.asset('assets/images/loading.json', width: 350, height: 350),
    );
  }
}