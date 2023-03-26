import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/bloc/user/user_bloc.dart';
import 'package:go_together/repository/auth_repository.dart';
import 'package:go_together/screen/fill_profile_page.dart';
import 'package:go_together/screen/home_page.dart';


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
            return CircularProgressIndicator();
          }
          else if(state is UserExist){
            return HomePage();
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