import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/notification.dart';
import 'package:go_together/model/reviewed.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/item_info_review.dart';
import 'package:go_together/widget/item_notification.dart';
import 'package:go_together/widget/item_review_user.dart';

import '../../model/review.dart';

class UserReviewedTabPage extends StatefulWidget {
  const UserReviewedTabPage({super.key});
  @override
  State<UserReviewedTabPage> createState() => _UserReviewedTabPageState();
}

class _UserReviewedTabPageState extends State<UserReviewedTabPage> {
  final Stream<QuerySnapshot> _reviewedStream = FirebaseFirestore.instance.collection('Review').where("idReviewer",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: "Thông báo"),
      body: SafeArea(
        child:StreamBuilder<QuerySnapshot>(
      stream: _reviewedStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasData)
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Reviewed data = Reviewed.fromJson(document.data()! as Map<String, dynamic>);
              return ItemInfoReview(reviewed: data,);
            }).toList(),
          ),
        );
        else return Container();
      },
      )
      ),
    );
  }
}