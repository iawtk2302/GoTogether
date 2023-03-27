import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
    Trip({
        required this.destination,
        required this.title,
        required this.dateStart,
        required this.dateEnd,
        required this.quantity,
        required this.description,
        required this.isActive,
        required this.image
    });

    final String destination;
    final String title;
    final Timestamp dateStart;
    final Timestamp dateEnd;
    final int quantity;
    final String description;
    final bool isActive;
    final String image;

    factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        destination: json["destination"],
        title: json["title"],
        dateStart: json["dateStart"],
        dateEnd: json["dateEnd"],
        quantity: json["quantity"],
        description: json["description"],
        isActive: json["isActive"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "destination": destination,
        "title": title,
        "dateStart": dateStart,
        "dateEnd": dateEnd,
        "quantity": quantity,
        "description": description,
        "isActive": isActive,
    };
}
