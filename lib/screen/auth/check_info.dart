import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/user/user_bloc.dart';
import 'package:go_together/common/custom_color.dart';

import 'package:go_together/screen/auth/fill_profile_page.dart';
import 'package:go_together/screen/home_page.dart';
import 'package:go_together/screen/profile_page.dart';
import 'package:go_together/widget/loading.dart';
import '../../utils/chatUtils.dart';
import '../chat/chat_page.dart';
import '../favorite/favorite_page.dart';
import '../profile/profile_page.dart';




class CheckInfoPage extends StatefulWidget {
  const CheckInfoPage({super.key});

  @override
  State<CheckInfoPage> createState() => _CheckInfoPageState();
}

class _CheckInfoPageState extends State<CheckInfoPage> {
  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(LoadUser());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc,UserState>(
        builder: (BuildContext context, state) { 
          if (state is UserLoading){
            return Center(child: MyLoading());
          }
          else if(state is UserExist){
            return MainPageContent();
          }
          else if(state is UserNotExist){
            return FillProfilePage();
          }
          else{
            return Container();
          }
         },
    
      ),
    );
  }
}
class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 0;
  late TabController _tabController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void initState() { 
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    ChatUtil.initChat();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          ChatUtil.onBackground = false;
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        setState(() {
          ChatUtil.onBackground = true;
        });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: CustomColor.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [HomePage(), ChatPage(), FavoritePage(), ProfilePage1()],
          )),
    );
  }
}