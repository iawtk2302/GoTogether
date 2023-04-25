import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/repository/chat_repository.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Flexible(
          flex: 1,
          child: CircleAvatar(backgroundImage: NetworkImage(notification.imgAva),radius: 40
          ,)),
        Flexible(
          flex: 2,
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
                Text(notification.fullName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                SizedBox(height: 2,),
                Text(notification.title, style: TextStyle(fontSize: 14),),
              ],),
              IconButton(onPressed: ()async{
                await ChatRepository().CreateMessageChannel(context, notification);
              }, icon: Icon(Icons.chat))
            ],),
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){
                    ChatRepository().AddMember(myNotification: notification);
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
            ],)
          ],))
      ]),),
    );
  }
}