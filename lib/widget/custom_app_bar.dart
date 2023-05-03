import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  CustomAppBar({super.key, required this.title,this.buildContext});
  final String title;
  BuildContext? buildContext;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title,style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: 
        IconButton(icon:Icon(Icons.chevron_left,color: Colors.black,),onPressed: () {
          Navigator.pop(buildContext??context);
        },)
      
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}