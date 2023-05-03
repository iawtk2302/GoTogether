import 'package:flutter/material.dart';
import 'package:go_together/common/custom_color.dart';
import 'package:go_together/screen/chat/chat_group_page.dart';
import 'package:go_together/screen/chat/chat_message_page.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:go_together/utils/firebase_utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../repository/notification_repository.dart';
import '../../router/routes.dart';



class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
          Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(FirebaseUtil.currentUser!.photoURL!),
                          radius: 22.5,
                        ),
                        Container(
                          width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                              color: CustomColor.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50)),
                          child: TabBar(
                            indicator: BoxDecoration(
                                color: CustomColor.blue,
                                borderRadius: BorderRadius.circular(50)),
                            indicatorPadding: EdgeInsets.all(4),
                            labelColor: CustomColor.bg,
                            unselectedLabelColor: CustomColor.grey,
                            tabs: [
                              Tab(
                                text: "Tin nhắn",
                              ),
                              Tab(
                                text: "Nhóm",
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, Routes.searchChat);
                          },
                          child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: CustomColor.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(Icons.search)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamChat(
                      client: ChatUtil.client,
                      onBackgroundEventReceived: (event) { 
    final currentUserId = ChatUtil.client.state.currentUser!.id; 
    if (![ 
          EventType.messageNew, 
          EventType.notificationMessageNew, 
        ].contains(event.type) || 
        event.user!.id == currentUserId) { 
      return; 
    } 
    if (event.message == null) return; 
    
    final message = event.message;
    final sender = message!.user;
    NotificationRepository().createNotification(sender!.name, message.text!);
  },
                      child: TabBarView(
                      children: [
                        ChatMessagePage(buildContext: context),
                        ChatGroupPage(buildContext: context),
                      ],
                                      ),
                    ))
                ],
              ),
            ),
          ),
        );
  }
}
