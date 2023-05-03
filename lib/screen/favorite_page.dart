import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_together/repository/notification_repository.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:go_together/widget/rating_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../router/routes.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    // final channelType = 'messaging';
    // final channelID =
    //     'bvSBs2IeOWcWZjH6gdLnKkLrJ932${auth.FirebaseAuth.instance.currentUser!.uid}'; // ID kênh được định danh bởi 2 user ID

    // final user1 = User(id: 'bvSBs2IeOWcWZjH6gdLnKkLrJ932', extraData: {
    //   'name': 'User One',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/gotogether-1b01c.appspot.com/o/bvSBs2IeOWcWZjH6gdLnKkLrJ932.jpg?alt=media&token=1845cc5e-0efa-41b6-aa1f-79ab9a774a8f'
    // });
    // final user2 = User(id: 'PX5H6QK7sIPvQNrqIZkRqdPhZxc2', extraData: {
    //   'name': 'User Two',
    //   'image':
    //       'https://firebasestorage.googleapis.com/v0/b/gotogether-1b01c.appspot.com/o/PX5H6QK7sIPvQNrqIZkRqdPhZxc2.jpg?alt=media&token=29b91591-8e50-496f-88e9-647185c56d3e'
    // });
    // final channel = ChatUtil.client.channel(channelType, id: channelID);
    // Future<void> CreateChannel(BuildContext context)async {
    //   final client=ChatUtil.client;
    //   final channel=client.channel('messaging',extraData: {
    //     "members":[client.state.currentUser!.id,"khoihaycuoi"]
    //   });
    //   await channel.watch();
    //   Navigator.pushNamed(context, Routes.channel,
    //                   arguments: channel);
    // }
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return Dialog(
                    //       child: RatingDialog(),
                    //     );
                    //   },
                    // );
                    NotificationRepository().isAllow();
                  },
                  child: Text("haha")),
              ElevatedButton(
                child: Text('Favorite'),
                onPressed: () async {
                  // NotificationRepository().createNotification();
                  // CreateChannel(context);
                  //       final channel = ChatUtil.client.channel('messaging',extraData: {
                  //   "name": "xin chao 2",
                  //   "image": "https://khoinguonsangtao.vn/wp-content/uploads/2022/08/hinh-anh-naruto-1.jpg",
                  //   "members": [auth.FirebaseAuth.instance.currentUser!.uid,"bvSBs2IeOWcWZjH6gdLnKkLrJ932",],
                  // }, );
                  // print(auth.FirebaseAuth.instance.currentUser!.uid);
                  // await channel.watch();
                  // await channel.addMembers([user2.id, "bakhanh"]);
                  
                  // await channel.sendMessage(Message(text: 'Hello User Two!'));

                  // Navigator.pushNamed(context, Routes.channel,
                  //     arguments: channel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
