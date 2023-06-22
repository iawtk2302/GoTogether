import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/reviewed.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:go_together/utils/utils.dart';

class ItemInfoReview extends StatefulWidget {
  const ItemInfoReview({super.key, required this.reviewed});
  final Reviewed reviewed;
  @override
  State<ItemInfoReview> createState() => _ItemInfoReviewState();
}

class _ItemInfoReviewState extends State<ItemInfoReview> {
  Map<int, String> stars= {1:"⭐",2:"⭐⭐",3:"⭐⭐⭐",4:"⭐⭐⭐⭐",5:"⭐⭐⭐⭐⭐"};
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.15,
      color: Colors.white,
      child: 
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          CircleAvatar(backgroundImage: NetworkImage(FirebaseUtil.currentUser!.photoURL!),),
          SizedBox(width: 4,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(FirebaseUtil.currentUser!.displayName!),
              SizedBox(height: 6,),
              Text(stars[widget.reviewed.rate!]!),
              SizedBox(height: 6,),
              Text(widget.reviewed.timeCreated!.toDate().toReviewedFormat()),
              SizedBox(height: 6,),
              Text(widget.reviewed.content!),
            ],),
          )
        ]),
        
      ],
    ),);
  }
}