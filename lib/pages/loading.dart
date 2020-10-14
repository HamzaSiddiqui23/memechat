import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meme_chat/pages/home.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meme_chat/data_classes/user.dart' as localUser;
import 'package:meme_chat/data_classes/session.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  SharedPreferences prefs;

  void checkLoggedIn() async {
    var app = await Firebase.initializeApp();
    if (FirebaseAuth.instance != null) {
      User user = FirebaseAuth
          .instanceFor(app: app)
          .currentUser;
      prefs = await SharedPreferences.getInstance();s
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            )
        );
      }
      else {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .get();
        final DocumentSnapshot document = result.docs.first;
        await prefs.setString('id', document.data()['id']);
        await prefs.setString('name', document.data()['name']);
        await prefs.setString('user_name', document.data()['name']);
        await prefs.setString('photoUrl', document.data()['photoUrl']);
        await prefs.setString('status', document.data()['status']);
        await prefs.setString('onlineStatus', 'Online');
        await prefs.setString('phoneNumber', document.data()['phoneNumber']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }

  @override
  void initState() {
    checkLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
