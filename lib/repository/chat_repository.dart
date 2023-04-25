import 'package:flutter/material.dart';

import '../model/notification.dart';
import '../router/routes.dart';
import '../utils/chatUtils.dart';

class ChatRepository{
    Future<void> CreateMessageChannel(BuildContext context, MyNotification myNotification)async {
      final client=ChatUtil.client;
      final channel=client.channel('messaging',extraData: {
        "members":[client.state.currentUser!.id,myNotification.idSender]
      },);
      await channel.watch();
      Navigator.pushNamed(context, Routes.channel,arguments: channel);
    }
    Future<void> CreateGroupChannel({required BuildContext context, required  String image, required String title, required String idTrip})async {
      final client=ChatUtil.client;
      final channel=client.channel('group',extraData: {
        "name": title, 
        "image": image,
        "members":[client.state.currentUser!.id],
      },id:idTrip);
      await channel.watch();
    }
    Future<void> AddMember({required MyNotification myNotification})async{
      final client = ChatUtil.client;
      final channel = client.channel("group", id: myNotification.idTrip);
      await channel.addMembers([myNotification.idSender]);
    }
}