import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/chat/channel_page.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:collection/collection.dart';
import '../../utils/firebase_utils.dart';




class ChatGroupPage extends StatefulWidget {
  const ChatGroupPage({super.key, required this.buildContext});
  
  final BuildContext buildContext;
  @override
  State<ChatGroupPage> createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChannelListPage(buildContext: widget.buildContext,);
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
    Filter.equal('type', 'group'),
    Filter.greaterOrEqual('member_count', 2),
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
              separatorBuilder: (context, values, index) {
                return Container();
              },  
              itemBuilder: _channelTileBuilder,    
              controller: _listController,
              // onChannelTap: (channel) {
              //   Navigator.pushNamed(widget.buildContext, Routes.channel,arguments: channel);
              // },
            ),
          ),
        ],
      ),
    );
  }
  Widget _channelTileBuilder(BuildContext context, List<Channel> channels,
      int index, StreamChannelListTile defaultChannelTile) {
    final channel = channels[index];

    final channelState = channel.state!;
    final currentUser = channel.client.state.currentUser!;

    final channelPreviewTheme = StreamChannelPreviewTheme.of(context);

    final leading = 
        StreamChannelAvatar(
          channel: channel,
          borderRadius: BorderRadius.circular(25),
          constraints: const BoxConstraints.tightFor(
    width: 50,
    height: 50,
  ),
        );

    final title = 
        StreamChannelName(
          channel: channel,
          textStyle: channelPreviewTheme.titleStyle!.copyWith(fontSize: 16),
        );

    final subtitle = 
        ChannelListTileSubtitle(
          channel: channel,
          textStyle: channelPreviewTheme.subtitleStyle!.copyWith(fontSize: 14),
        );

    final trailing = 
        ChannelLastMessageDate(
          channel: channel,
          textStyle: channelPreviewTheme.lastMessageAtStyle!.copyWith(fontSize: 14),
        );

    return BetterStreamBuilder<bool>(
      stream: channel.isMutedStream,
      initialData: channel.isMuted,
      builder: (context, isMuted) => AnimatedOpacity(
        opacity: isMuted ? 0.5 : 1,
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          onTap: (){
            Navigator.pushNamed(widget.buildContext, Routes.channel,arguments: channel);
          },
         
          leading: leading,
         
          selectedTileColor: 
              StreamChatTheme.of(context).colorTheme.borders,
          title: Row(
            children: [
              Expanded(child: title),
              BetterStreamBuilder<List<Member>>(
                stream: channelState.membersStream,
                initialData: channelState.members,
                comparator: const ListEquality().equals,
                builder: (context, members) {
                  if (members.isEmpty ||
                      !members.any((it) => it.user!.id == currentUser.id)) {
                    return const Offstage();
                  }
                  return 
                      StreamUnreadIndicator(cid: channel.cid);
                },
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: subtitle,
                ),
              ),
              BetterStreamBuilder<List<Message>>(
                stream: channelState.messagesStream,
                initialData: channelState.messages,
                comparator: const ListEquality().equals,
                builder: (context, messages) {
                  final lastMessage = messages.lastWhereOrNull(
                    (m) => !m.shadowed && !m.isDeleted,
                  );

                  if (lastMessage == null ||
                      (lastMessage.user?.id != currentUser.id)) {
                    return const Offstage();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child:
                            StreamSendingIndicator(
                              message: lastMessage,
                              size: channelPreviewTheme.indicatorIconSize,
                              isMessageRead: channelState
                                  .currentUserRead!.lastRead
                                  .isAfter(lastMessage.createdAt),
                            ),
                  );
                },
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}


