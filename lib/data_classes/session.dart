import 'package:firebase_auth/firebase_auth.dart';

class Session{
  User firebaseUser;

  static final Session _instance = Session._internal();

  Session._internal();
  factory Session(){
    if(_instance.firebaseUser != null)
      return _instance;
    else {
      _instance.firebaseUser = null;
      return _instance;
    }
  }
}