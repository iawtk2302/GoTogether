import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  Trip(
      {required this.idTrip,
      required this.idCreator,
      required this.destination,
      required this.title,
      required this.dateStart,
      required this.dateEnd,
      required this.quantity,
      required this.description,
      required this.status,
      required this.image,
      required this.members,
      required this.activities,
      required this.membersId,
      required this.dateCompleted});
  final String idTrip;
  final String idCreator;
  final String destination;
  final String title;
  final Timestamp dateStart;
  final Timestamp dateEnd;
  final Timestamp dateCompleted;
  final int quantity;
  final String description;
  final String status;
  final String image;
  final List<Member> members;
  final List<String> activities;
  final List<String> membersId;

  Trip copyWith({
    String? idTrip,
    String? idCreator,
    String? destination,
    String? title,
    Timestamp? dateStart,
    Timestamp? dateEnd,
    int? quantity,
    String? description,
    String? status,
    String? image,
    List<Member>? members,
    List<String>? activities,
    List<String>? membersId,
    Timestamp? dateCompleted,
  }) =>
      Trip(
        idTrip: idTrip ?? this.idTrip,
        idCreator: idCreator ?? this.idCreator,
        destination: destination ?? this.destination,
        title: title ?? this.title,
        dateStart: dateStart ?? this.dateStart,
        dateEnd: dateEnd ?? this.dateEnd,
        quantity: quantity ?? this.quantity,
        description: description ?? this.description,
        status: status ?? this.status,
        image: image ?? this.image,
        members: members ?? this.members,
        activities: activities ?? this.activities,
        membersId: membersId ?? this.membersId,
        dateCompleted: dateCompleted ?? this.dateCompleted,
      );

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        idTrip: json["idTrip"] ?? "",
        idCreator: json["idCreator"] ?? "",
        destination: json["destination"],
        title: json["title"],
        dateStart: json["dateStart"],
        dateEnd: json["dateEnd"],
        quantity: json["quantity"],
        description: json["description"],
        status: json["status"],
        image: json["image"],
        dateCompleted: json['dateCompleted'] ?? Timestamp.now(),
        members: json["members"] == null
            ? []
            : List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        activities: json["activities"] == null
            ? []
            : List<String>.from(json["activities"].map((x) => x)),
        membersId: json['membersId'] == null
            ? []
            : List<String>.from(json["membersId"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "title": title,
        "dateStart": dateStart,
        "dateEnd": dateEnd,
        "quantity": quantity,
        "description": description,
        "status": status,
        "image": image,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "activities": List<dynamic>.from(activities.map((x) => x)),
        "membersId": List<dynamic>.from(membersId.map((x) => x)),
        "idCreator": idCreator,
        "idTrip": idTrip,
        'dateCompleted': dateCompleted,
      };

  @override
  List<Object?> get props => [
        destination,
        title,
        dateStart,
        dateEnd,
        quantity,
        description,
        status,
        image,
        members,
        activities,
        membersId,
        idCreator,
        idTrip,
        membersId,
        dateCompleted
      ];
}

class Member extends Equatable {
  Member({
    required this.idUser,
    required this.image,
    required this.lat,
    required this.lng,
    required this.nameUser,
  });

  final String idUser;
  final String image;
  final String lat;
  final String lng;
  final String nameUser;

  Member copyWith({
    String? idUser,
    String? image,
    String? lat,
    String? lng,
    String? nameUser
  }) =>
      Member(
        idUser: idUser ?? this.idUser,
        image: image ?? this.image,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        nameUser: nameUser ?? this.nameUser
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        idUser: json["idUser"] ?? "",
        image: json["image"] ?? "",
        lat: json["lat"] != "" ? json["lat"] : "10.945",
        lng: json["lng"] != "" ? json["lng"] : "106.6345",
        nameUser: json['nameUser'] == null ? "Nguyen Ba Khanh": json['nameUser']
      );

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "image": image,
        "lat": lat,
        "lng": lng,
      };

  @override
  List<Object?> get props => [
        idUser,
        image,
        lat,
        lng,
      ];
}
