import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/home_screen.dart';

class Login extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String emailAddress;
  String password;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void dataCheck() async {
    final userData = await _firestore.collection('users').doc(emailAddress).get();
    print(userData.data());
  }

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
              child: Text('Login'),
              onPressed: () async {
                try{
                  final newUser = await _auth.signInWithEmailAndPassword(email: emailAddress, password: password);
                  if(newUser != null){
                    print('Login Successful');
                    Navigator.pushNamed(context, HomeScreen.id);
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