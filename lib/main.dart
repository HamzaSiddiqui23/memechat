import 'package:flutter/material.dart';
import 'pages/loading.dart';
import 'pages/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/login': (context) => Login(),
    },
  ));
}