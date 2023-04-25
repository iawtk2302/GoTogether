import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_together/model/notification.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:go_together/widget/item_notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Stream<QuerySnapshot> _notisStream = FirebaseFirestore.instance.collection('Notification').where("idReceiver",isEqualTo: FirebaseAuth.instance.currentUser!.uid).where("status",isEqualTo: "pending").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notification"),
      body: SafeArea(
        child:StreamBuilder<QuerySnapshot>(
      stream: _notisStream,
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
          MyNotification data = MyNotification.fromJson(document.data()! as Map<String, dynamic>);
            return ItemNotification(notification: data);
          }).toList(),
        );
        else return Container();
      },
      )
      ),
    );
  }
}