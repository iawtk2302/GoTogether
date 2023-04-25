import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/chat/channel_page.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../utils/firebase_utils.dart';




class ChatMessagePage extends StatefulWidget {
  const ChatMessagePage({super.key, required this.buildContext});
  
  final BuildContext buildContext;
  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) => StreamChat(
        client: ChatUtil.client,
        child: child,
      ),
      home:  ChannelListPage(buildContext: widget.buildContext,),
          );
  }
}
class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key, required this.buildContext,
  }) : super(key: key);
  final BuildContext buildContext;
  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage>{
 final filter= Filter.and([
    Filter.in_(
      'members',
      [FirebaseUtil.currentUser!.uid],
    ),
    Filter.lessOrEqual(
      'member_count',
      2,
    ),
     Filter.equal('type', 'messaging'),
  ]);
   late final StreamChannelListController _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: filter,
    sort: const [SortOption('last_message_at')],
    limit: 20,
  );
  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }
  final search=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamChannelListView(     
              controller: _listController,
              onChannelTap: (channel) {
                Navigator.pushNamed(widget.buildContext, Routes.channel,arguments: channel);
              },
            ),
          ),
        ],
      ),
    );
  }
}


