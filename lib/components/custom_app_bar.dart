import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customAppBar(){
  return AppBar(
    title: Text('MemeChat',style: TextStyle(color: Colors.white),),
    backgroundColor: Colors.red,
    centerTitle: true,
    leading: Icon(Icons.videogame_asset,color: Colors.white,),
  );
}