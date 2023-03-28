import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../bloc/chat/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).add(ConnectChat());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if(state is ChatLoading){
          return Container();
        }
        else if (state is ChatLoaded){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) => StreamChat(
        client: state.client,
        child: child,
      ),
      home: const ChannelListPage(),
          );
        }
        else{
          return Container();
        }
      },
    );
  }
}
class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: const <Widget>[
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
