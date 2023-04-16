import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  Trip({
    required this.destination,
    required this.title,
    required this.dateStart,
    required this.dateEnd,
    required this.quantity,
    required this.description,
    required this.isActive,
    required this.image,
    required this.members,
    required this.activities,
  });

  final String destination;
  final String title;
  final Timestamp dateStart;
  final Timestamp dateEnd;
  final int quantity;
  final String description;
  final bool isActive;
  final String image;
  final List<Member> members;
  final List<String> activities;

  Trip copyWith({
    String? destination,
    String? title,
    Timestamp? dateStart,
    Timestamp? dateEnd,
    int? quantity,
    String? description,
    bool? isActive,
    String? image,
    List<Member>? members,
    List<String>? activities,
  }) =>
      Trip(
        destination: destination ?? this.destination,
        title: title ?? this.title,
        dateStart: dateStart ?? this.dateStart,
        dateEnd: dateEnd ?? this.dateEnd,
        quantity: quantity ?? this.quantity,
        description: description ?? this.description,
        isActive: isActive ?? this.isActive,
        image: image ?? this.image,
        members: members ?? this.members,
        activities: activities ?? this.activities,
      );

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        destination: json["destination"],
        title: json["title"],
        dateStart: json["dateStart"],
        dateEnd: json["dateEnd"],
        quantity: json["quantity"],
        description: json["description"],
        isActive: json["isActive"],
        image: json["image"],
        members: json["members"] == null
            ? []
            : List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        activities: json["activities"] == null
            ? []
            : List<String>.from(json["activities"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "title": title,
        "dateStart": dateStart,
        "dateEnd": dateEnd,
        "quantity": quantity,
        "description": description,
        "isActive": isActive,
        "image": image,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "activities": List<dynamic>.from(activities.map((x) => x)),
      };

  @override
  List<Object?> get props => [
        destination,
        title,
        dateStart,
        dateEnd,
        quantity,
        description,
        isActive,
        image,
        members,
        activities,
      ];
}

class Member extends Equatable {
  Member({
    required this.idUser,
    required this.image,
    required this.lat,
    required this.lng,
  });

  final String idUser;
  final String image;
  final String lat;
  final String lng;

  Member copyWith({
    String? idUser,
    String? image,
    String? lat,
    String? lng,
  }) =>
      Member(
        idUser: idUser ?? this.idUser,
        image: image ?? this.image,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        idUser: json["idUser"],
        image: json["image"],
        lat: json["lat"],
        lng: json["lng"],
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
