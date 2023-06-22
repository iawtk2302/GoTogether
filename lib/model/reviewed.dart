import 'package:cloud_firestore/cloud_firestore.dart';

class Reviewed {
  String? content;
  String? idReview;
  String? idReviewer;
  String? idUser;
  String? linkAva;
  String? nameReviewer;
  String? phoneReviewer;
  int? rate;
  Timestamp? timeCreated;

  Reviewed(
      {this.content,
      this.idReview,
      this.idReviewer,
      this.idUser,
      this.linkAva,
      this.nameReviewer,
      this.phoneReviewer,
      this.rate,
      this.timeCreated});

  Reviewed.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    idReview = json['idReview'];
    idReviewer = json['idReviewer'];
    idUser = json['idUser'];
    linkAva = json['linkAva'];
    nameReviewer = json['nameReviewer'];
    phoneReviewer = json['phoneReviewer'];
    rate = json['rate'];
    timeCreated = json['timeCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['idReview'] = this.idReview;
    data['idReviewer'] = this.idReviewer;
    data['idUser'] = this.idUser;
    data['linkAva'] = this.linkAva;
    data['nameReviewer'] = this.nameReviewer;
    data['phoneReviewer'] = this.phoneReviewer;
    data['rate'] = this.rate;
    data['timeCreated'] = this.timeCreated;
    return data;
  }
}