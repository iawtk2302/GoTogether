import 'package:flutter/material.dart';
import 'package:go_together/widget/rating_dialog.dart';

import '../model/review.dart';

class ItemReviewUser extends StatefulWidget {
  const ItemReviewUser({super.key, required this.review});
  final Review review;
  @override
  State<ItemReviewUser> createState() => _ItemReviewUserState();
}

class _ItemReviewUserState extends State<ItemReviewUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
            height: MediaQuery.of(context).size.height*0.24,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Row(
                      children: [
                        Icon(Icons.flight),
                        Text(widget.review.nameTrip),
                      ],
                    ),
                    Text("Đã hoàn thành")
                  ],),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.review.image),
                      radius: 28,
                    ),
                    SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(widget.review.userName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                      Text(widget.review.phone)
                    ],)
                  ],
                ),
                Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: (){
                    showDialog(context: context, builder: (context) => Dialog(child: RatingDialog(review: widget.review,)),);
                  }, child: Text("Đánh giá")))
              ]),
            ),
          );
  }
}