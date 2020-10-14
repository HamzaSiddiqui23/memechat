import 'package:firebase_auth/firebase_auth.dart';
import 'package:meme_chat/data_classes/user.dart' as LocalUser;

class Session{
  UserCredential firebaseUser;
  LocalUser.User localUser;

  static final Session _instance = Session._internal();

  Session._internal();
  factory Session(){
    if(_instance.firebaseUser != null)
      return _instance;
    else {
      _instance.firebaseUser = null;
      _instance.localUser = null;
      return _instance;
    }
  }

  void setLocalUser(LocalUser.User u){
    localUser = u;
  }
}