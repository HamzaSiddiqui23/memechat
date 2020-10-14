import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_chat/data_classes/session.dart';

Widget CustomAppBar(){
  return AppBar(
    title: Text('MemeChat',style: TextStyle(color: Colors.white),),
    backgroundColor: Colors.red,
    centerTitle: true,
    leading: Icon(Icons.videogame_asset,color: Colors.white,),
    actions: [
      IconButton(icon: Icon(Icons.search), onPressed: (){}),
      IconButton(icon: Icon(Icons.settings), onPressed: (){})
    ],

  );
}