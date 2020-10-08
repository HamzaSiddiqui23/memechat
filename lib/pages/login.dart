import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme_chat/components/custom_app_bar.dart';
import 'package:international_phone_input/international_phone_input.dart';
import '../data_classes/session.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _codeController = TextEditingController();

  Future registerUser(String mobile, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(phoneNumber: phoneNumber, verificationCompleted: (AuthCredential authCredentials){
      setState(() {
        _auth.signInWithCredential(authCredentials).then((var results) {
          result = 'Success! Logged In';
          print(results);
        });
      });
    },
        verificationFailed: (FirebaseAuthException authException){
      setState(() {
        result =  "Error ${authException.message}";
        print(authException.message);
      });
        }
        , codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text("Enter SMS Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),

                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Done"),
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    onPressed: () {
                      FirebaseAuth auth = FirebaseAuth.instance;

                      var smsCode = _codeController.text.trim();


                      var _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                      auth.signInWithCredential(_credential).then((var results){
                        Navigator.pop(context);
                        setState(() {
                          print(results);
                          result = "Success Log in";
                        });
                      }).catchError((e){
                        print(e);
                      });
                    },
                  )
                ],
              )
          );
        }
        , timeout: Duration(seconds: 60), codeAutoRetrievalTimeout: (String verificationId){
          print(verificationId);
          print("Timeout");
        });
  }

  String result = '';
  String phoneNumber;
  String phoneIsoCode;
  bool visible = false;
  String confirmedNumber = '';

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = internationalizedPhoneNumber;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter Phone Number', style: TextStyle(color: Colors.black,fontSize: 20),),
            SizedBox(height: 50,),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: InternationalPhoneInput(
                  onPhoneNumberChange: onPhoneNumberChange,
                  initialPhoneNumber: phoneNumber,
                  initialSelection: phoneIsoCode,
                  showCountryCodes: true,
                enabledCountries: ["+1","+92"],
              ),
            ),
            SizedBox(height: 50,),
            RaisedButton(
              onPressed: (){
                print(phoneNumber);
                registerUser(phoneNumber, context);},
              color: Colors.red,
              child: Text('Submit',style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 30,),
            SizedBox(height: 50),
            Text(result)
          ],
        ),
      ),
    );
  }
}
