import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/router/routes.dart';
import 'package:go_together/screen/chat/channel_page.dart';
import 'package:go_together/utils/chatUtils.dart';
import 'package:go_together/widget/custom_app_bar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../common/custom_color.dart';
import '../../utils/firebase_utils.dart';




class SearchChatPage extends StatefulWidget {
  const SearchChatPage({super.key, required this.buildContext});
  
  final BuildContext buildContext;
  @override
  State<SearchChatPage> createState() => _SearchChatPageState();
}

class _SearchChatPageState extends State<SearchChatPage> {
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
final _queryController = TextEditingController();
 var filter= Filter.and([
    Filter.autoComplete("member.user.name", "/"),
    Filter.in_("members", [FirebaseUtil.currentUser!.uid])
  ]);
   late StreamChannelListController _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: filter,
    sort: const [SortOption('last_message_at')],
    limit: 20,
  );
  void query(String query){
    if(query==""){
      query='/';
    }
    var filter= Filter.and([
    Filter.autoComplete("member.user.name", query),
    Filter.in_("members", [FirebaseUtil.currentUser!.uid])
  ]);
   late StreamChannelListController _temp = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: filter,
    sort: const [SortOption('last_message_at')],
    limit: 20,
  );
  setState(() {
    _listController=_temp;
  });
  }
  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }
  final search=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search",buildContext: widget.buildContext,),
      body: Column(   
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: CustomColor.blue1
              ),
              child: Center(
                child: TextField( 
                  controller: _queryController,  
                  onChanged: query,
                  decoration: InputDecoration(
                    border: InputBorder.none,                
                    hintText: "Search",
                    fillColor: CustomColor.blue1,
                    filled: true,
                    suffixIcon: Icon(Icons.menu),
                    prefixIcon: Icon(Icons.search)
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamChannelListView(    
              controller: _listController,
              emptyBuilder: (context) {
                return Container();
              },
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


