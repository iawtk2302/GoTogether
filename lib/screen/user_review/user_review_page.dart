import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/notification.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/item_notification.dart';
import 'package:go_together/widget/item_review_user.dart';

import '../../model/review.dart';

class UserReviewTabPage extends StatefulWidget {
  const UserReviewTabPage({super.key});

  @override
  State<UserReviewTabPage> createState() => _UserReviewTabPageState();
}

class _UserReviewTabPageState extends State<UserReviewTabPage> {
  final Stream<QuerySnapshot> _reviewsStream = FirebaseFirestore.instance.collection('TripMembersJoin').where("idUser1",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where("status",isEqualTo: false).snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: "Thông báo"),
      body: SafeArea(
        child:StreamBuilder<QuerySnapshot>(
      stream: _reviewsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasData)
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Review data = Review.fromJson(document.data()! as Map<String, dynamic>);
            return ItemReviewUser(review: data,);
          }).toList(),
        );
        else return Container();
      },
      )
      ),
    );
  }
}