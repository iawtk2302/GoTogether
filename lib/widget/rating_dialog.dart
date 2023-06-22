import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
// import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/model/review.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:go_together/widget/custom_button.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, required this.review});
  final Review review;
  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final firestore = FirebaseFirestore.instance.collection("Review");
  final review = FirebaseFirestore.instance.collection("TripMembersJoin");
  TextEditingController controller=TextEditingController();
  int rate=0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text("Đánh giá người dùng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: EmojiFeedback(
              animDuration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn,
              inactiveElementScale: .7,
              showLabel: false,
              onChanged: (value) {
                rate=value;
              },
            ),
          ),
        TextField(
          controller: controller,
        decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none
        ),
        filled: true,
        hintStyle: TextStyle(color: CustomColor.grey),
        hintText: "Nhập đánh giá...",
        fillColor: CustomColor.blue1),
        maxLines: 7,
        ),
        SizedBox(height: 10,),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(onPressed: ()async{
            await firestore.add({
              "content": controller.text.trim(),
              "idReviewer": widget.review.idUser1,
              "idUser": widget.review.idUser2,
              "linkAva": widget.review.image,
              "nameReviewer": widget.review.userName,
              "phoneReviewer": FirebaseUtil.currentUser!.phoneNumber,
              "rate": rate,
              "timeCreated": DateTime.now()
            }).then((value) => {firestore.doc(value.id).update({"idReview":value.id})});
            await review.doc(widget.review.idTripMembersJoin).update({"status":true});
            Navigator.pop(context);
          }, child: Text("Nộp")))
        ]),
      ),
    );
  }
}
