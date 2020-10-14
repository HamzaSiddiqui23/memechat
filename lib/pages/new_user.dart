import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:meme_chat/data_classes/session.dart';
import 'package:meme_chat/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final _formKey = GlobalKey<FormState>();
  String success = ' ';
  File _image;
  SharedPreferences prefs;
  String photoUrl;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  List<String> existingUserNames = new List();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }
  void getUserNames() async{
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for(var doc in documents){
      existingUserNames.add(doc.data()['user_name']);
    }
    print(existingUserNames);
  }

  @override

  void initState(){
    getUserNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Welcome to Meme Chat!',style: TextStyle(color: Colors.white, fontSize: 30,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Enter your sign up details!',style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:  const EdgeInsets.fromLTRB(50,50,50,0),
                      child:  Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              getImage();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 75,
                              child: _image== null? Icon(Icons.add_a_photo,size: 75, color: Colors.red,) : ClipOval(child: Image.file(_image,fit: BoxFit.cover,)),
                            ),
                          ),
                          _image!= null? Positioned(
                            bottom: 0,
                            left: 75,
                            child: RawMaterialButton(
                              onPressed: (){
                                setState(() {
                                  _image = null;
                                });
                              },
                              elevation: 2,
                              fillColor: Colors.red,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.close,color: Colors.white),
                            ),
                          )
                          :
                              SizedBox(),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(color: Colors.red),
                        cursorColor: Colors.red,
                        validator: (value) {
                          if(value.isEmpty){
                            return '*Required Field';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          hintText: 'Name',
                          filled: true,
                          errorStyle: TextStyle(color: Colors.white,fontSize: 15),
                          fillColor: Colors.grey[200],
                          hintStyle: TextStyle(color: Colors.red,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50,0,50,50),
                      child: TextFormField(
                        controller: userNameController,
                        style: TextStyle(color: Colors.red),
                        cursorColor: Colors.red,
                        validator: (value) {
                          if(containsCaseInsensitive(value,existingUserNames)){
                            return '*Username is Taken. Please Try a different Username';
                          }
                          return null;
                        },
                        inputFormatters: [FilteringTextInputFormatter.deny(
                            new RegExp(r"\s\b|\b\s")
                        )],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          hintText: 'User Name',
                          filled: true,
                          errorStyle: TextStyle(color: Colors.white,fontSize: 15),
                          fillColor: Colors.grey[200],
                          hintStyle: TextStyle(color: Colors.red,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50,0,50,50),
                      child: TextFormField(
                        controller: statusController,
                        style: TextStyle(color: Colors.red),
                        cursorColor: Colors.red,
                        validator: (value) {
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          hintText: "Status - What's on your mind?",
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintStyle: TextStyle(color: Colors.red,),
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white,width: 3), borderRadius: BorderRadius.circular(18)),
                      onPressed: () async {
                        if(_formKey.currentState.validate() && _image!=null){
                          prefs = await SharedPreferences.getInstance();
                          String filename = Session().firebaseUser.user.uid.toString();
                          StorageReference reference = FirebaseStorage.instance.ref().child(filename);
                          StorageUploadTask uploadTask = reference.putFile(_image);
                          StorageTaskSnapshot storageTaskSnapshot;
                          uploadTask.onComplete.then((value){
                            if(value.error == null)
                              {
                                storageTaskSnapshot = value;
                                storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
                                  photoUrl = downloadUrl;
                                  FirebaseFirestore.instance.collection('users').doc(Session().firebaseUser.user.uid).set({
                                    'name' : nameController.text,
                                    'photoUrl' : photoUrl,
                                    'user_name' : userNameController.text,
                                    'id' : Session().firebaseUser.user.uid,
                                    'status' : statusController==null? ' ' : statusController.text,
                                    'onlineStatus' : 'Online',
                                    'phoneNumber' : Session().firebaseUser.user.phoneNumber
                                  }).then((value) async
                                  {
                                    setState(() {
                                      success='New User Created';
                                    });
                                    await prefs.setString('id', Session().firebaseUser.user.uid);
                                    await prefs.setString('name', nameController.text);
                                    await prefs.setString('user_name', userNameController.text);
                                    await prefs.setString('photoUrl', photoUrl);
                                    await prefs.setString('status', statusController==null? ' ' : statusController.text);
                                    await prefs.setString('onlineStatus', 'Online');
                                    await prefs.setString('phoneNumber', Session().firebaseUser.user.phoneNumber);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
                                  }
                                  ).catchError((err){
                                    setState(() {
                                      success = "New User Creation Failed + $err";
                                    });
                                  });
                                });
                              }
                          });
                          setState(() {
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Submit',style: TextStyle(color: Colors.white,fontSize: 24),),
                      ),
                    ),
                    Text(success),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool containsCaseInsensitive(String s, List<String> l){
  for (String str in l){
    print("Comparing ${str.toLowerCase()} with ${s.toLowerCase()}");
    if (str.toLowerCase() == s.toLowerCase()){
      return true;
    }
  }
  return false;
}