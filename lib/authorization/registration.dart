import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management_system/authorization/enter_details.dart';

// The Registration Page creates a new account using the Firebase Authorization.

class Registration extends StatefulWidget {
  static String id = 'registration';
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  // emailAddress Stores The email address entered by the user.
  // password saves the password entered by the user.
  // _auth is Firebase Authorization Instance.
  String emailAddress;
  String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('Enter Username'),
            TextField(
              onChanged: (value){
                emailAddress = value;
              },
            ),
            Text('Enter Password'),
            TextField(
              onChanged: (value){
                password = value;
              },
            ),
            FlatButton(
              child: Text('Register'),
              onPressed: () async {
                try{
                  // This creates the new account using Firebase Authorization
                  // Then redirects them to the enter_details.dart to fill in useful info.
                  // No one can become admin using register it can solely be done by the developer of the App.
                  final newUser = await _auth.createUserWithEmailAndPassword(email: emailAddress, password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, EnterDetails.id);
                  }
                }
                catch(e){
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}