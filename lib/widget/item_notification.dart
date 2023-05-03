import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/model/trip.dart';
import 'package:go_together/repository/chat_repository.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:intl/intl.dart';

import '../model/notification.dart';

class ItemNotification extends StatelessWidget {
  const ItemNotification({super.key, required this.notification});
  final MyNotification notification;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: Container(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Flexible(
          flex: 1,
          child: CircleAvatar(backgroundImage: NetworkImage(notification.imgAva),radius: 35
          ,)),
        Flexible(
          flex: 3,
          child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  width: 190,
                  child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: notification.fullName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                TextSpan(
                  text: ' sent a request to join the trip ',
                  style: TextStyle(fontSize: 14),
                ),
                TextSpan(
                  text: notification.title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),),
                SizedBox(height: 2,),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(notification.createAt.toDate()), style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.5)),),
              ],),
              IconButton(onPressed: ()async{
                await ChatRepository().CreateMessageChannel(context, notification);
              }, icon: Icon(Icons.chat))
            ],),
            SizedBox(height: 6,),
            notification.status=="pending"?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: ()async{
                    // ChatRepository().AddMember(myNotification: notification);
                    await FirebaseUtil.notifications.doc(notification.idNoti).update({
                      "status":"accepted"
                    });
                    final jsonTrip = await FirebaseUtil.trips.doc(notification.idTrip).get();
                    final trip=Trip.fromJson(jsonTrip.data()!);
                    await FirebaseUtil.trips.doc(notification.idTrip).update({
                        "members":[...trip.members.map((e) => e.toJson()).toList(),{
                          "idUser":notification.idSender,
                          "image":notification.imgAva,
                          "lat":"",
                          "lng":""
                        }],
                        "membersId":[...trip.membersId,notification.idSender]
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: CustomColor.blue,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Accept", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),
                  ),
                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async{
                    await FirebaseUtil.notifications.doc(notification.idNoti).update({
                      "status":"rejected"
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: CustomColor.grey,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Reject",style: TextStyle(fontWeight: FontWeight.w500),)),
                  ),
                ),
              )
            ],):notification.status=="accepted"?Align(
              alignment: Alignment.centerLeft,
              child: Text("Accepted the request",style: TextStyle(color: Colors.green),)):Align(
                alignment: Alignment.centerLeft,
                child: Text("Rejected the request",style: TextStyle(color: Colors.red)))
          ],))
      ]),),
    );
  }
}