class Review {
    final String idTrip;
    final String idCreator;
    final String idUser1;
    final String idUser2;
    final String nameTrip;
    final String userName;
    final String phone;
    final bool status;
    final String image;
    final String idTripMembersJoin;

    Review({
        required this.idTrip,
        required this.idCreator,
        required this.idUser1,
        required this.idUser2,
        required this.nameTrip,
        required this.userName,
        required this.phone,
        required this.status,
        required this.image,
        required this.idTripMembersJoin,
    });

    Review copyWith({
        String? idTrip,
        String? idCreator,
        String? idUser1,
        String? idUser2,
        String? nameTrip,
        String? userName,
        String? phone,
        bool? status,
        String? image,
        String? idTripMembersJoin,
    }) => 
        Review(
            idTrip: idTrip ?? this.idTrip,
            idCreator: idCreator ?? this.idCreator,
            idUser1: idUser1 ?? this.idUser1,
            idUser2: idUser2 ?? this.idUser2,
            nameTrip: nameTrip ?? this.nameTrip,
            userName: userName ?? this.userName,
            phone: phone ?? this.phone,
            status: status ?? this.status,
            image: image ?? this.image,
            idTripMembersJoin: idTripMembersJoin ?? this.idTripMembersJoin,
        );

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        idTrip: json["idTrip"],
        idCreator: json["idCreator"],
        idUser1: json["idUser1"],
        idUser2: json["idUser2"],
        nameTrip: json["nameTrip"],
        userName: json["userName"],
        phone: json["phone"],
        status: json["status"],
        image: json["image"],
        idTripMembersJoin: json["idTripMembersJoin"],
    );

    Map<String, dynamic> toJson() => {
        "idTrip": idTrip,
        "idCreator": idCreator,
        "idUser1": idUser1,
        "idUser2": idUser2,
        "nameTrip": nameTrip,
        "userName": userName,
        "phone": phone,
        "status": status,
        "image": image,
        "idTripMembersJoin": idTripMembersJoin,
    };
}