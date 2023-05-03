import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyNotification extends Equatable{
    MyNotification({
        required this.idNoti,
        required this.idReceiver,
        required this.idSender,
        required this.idTrip,
        required this.fullName,
        required this.imgAva,
        required this.title,
        required this.type,
        required this.status,
        required this.createAt,
    });

    final String idNoti;
    final String idReceiver;
    final String idSender;
    final String idTrip;
    final String fullName;
    final String imgAva;
    final String title;
    final String type;
    final String status;
    final Timestamp createAt;

    MyNotification copyWith({
        String? idNoti,
        String? idReceiver,
        String? idSender,
        String? idTrip,
        String? fullName,
        String? imgAva,
        String? title,
        String? type,
        String? status,
        Timestamp? createAt
    }) => 
        MyNotification(
            idNoti: idNoti ?? this.idNoti,
            idReceiver: idReceiver ?? this.idReceiver,
            idSender: idSender ?? this.idSender,
            idTrip: idTrip ?? this.idTrip,
            fullName: fullName ?? this.fullName,
            imgAva: imgAva ?? this.imgAva,
            title: title ?? this.title,
            type: type ?? this.type,
            status: status ?? this.status,
            createAt: createAt ?? this.createAt
        );

    factory MyNotification.fromJson(Map<String, dynamic> json) => MyNotification(
        idNoti: json["idNoti"],
        idReceiver: json["idReceiver"],
        idSender: json["idSender"],
        idTrip: json["idTrip"],
        fullName: json["fullName"],
        imgAva: json["imgAva"],
        title: json["title"],
        type: json["type"],
        status: json["status"],
        createAt: json['createAt']
    );

    Map<String, dynamic> toJson() => {
        "idNoti": idNoti,
        "idReceiver": idReceiver,
        "idSender": idSender,
        "idTrip": idTrip,
        "fullName": fullName,
        "imgAva": imgAva,
        "title": title,
        "type": type,
        "status": status,
        "createAt":createAt
    };
    
      @override
      // TODO: implement props
      List<Object?> get props => [idNoti,idReceiver,idSender,idTrip,fullName,imgAva,title,type,status,createAt];
}
