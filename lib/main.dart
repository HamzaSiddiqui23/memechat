import 'package:flutter/material.dart';
import 'pages/loading.dart';
import 'pages/login.dart';
import 'pages/new_user.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/login': (context) => Login(),
      '/new_user': (context) => NewUser(),
      '/home': (context) => HomeScreen(),
    },
  ));
}