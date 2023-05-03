import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseUtil{
  static final currentUser=FirebaseAuth.instance.currentUser;
  static final trips=FirebaseFirestore.instance.collection("Trip");
  static final notifications=FirebaseFirestore.instance.collection("Notification");
}