import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme_chat/components/custom_app_bar.dart';
import 'package:meme_chat/data_classes/session.dart';
import 'package:meme_chat/data_classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;
  User u;
  void getUserDetails() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      u = User(userName: prefs.getString("user_name"), id: prefs.getString("id"), name: prefs.getString("name"), photoUrl: prefs.get("photoUrl"), phoneNumber: prefs.get("phoneNumber"), status: prefs.get("status"), onlineStatus: prefs.get("onlineStatus"));
      Session().setLocalUser(u);
    });
  }

  @override

  void initState(){
    getUserDetails();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child:
        u==null ?
        Text('Loading')
            :
        Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index],u),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}


Widget buildItem(BuildContext context, DocumentSnapshot document, User u) {
  if (document.data()['id'] == u.id) {
    return Container();
  } else {
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: document.data()['photoUrl'] != null
                  ? CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  width: 50.0,
                  height: 50.0,
                  padding: EdgeInsets.all(15.0),
                ),
                imageUrl: document.data()['photoUrl'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              )
                  : Icon(
                Icons.account_circle,
                size: 50.0,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${document.data()['name']}',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        '${document.data()['status'] ?? ' '}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
        },
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
        Border(bottom: BorderSide(color: Colors.grey,width: 1)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}