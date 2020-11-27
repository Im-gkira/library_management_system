import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/Screens/admin_screen.dart';
import 'package:library_management_system/Screens/home_screen.dart';

// The Login Page is the Main Gateway To The App.
// It takes the already Registered user to the home screen or the admin screen depending upon isAdmin.
class Login extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // emailAddress Stores The email address entered by the user.
  // password saves the password entered by the user.
  // isAdmin is bool which is true if the user is an Admin and false if it is a normal user. Its true since it can't be null when the widgets are build.
  // _auth is Firebase Authorization Instance.
  // _firestore is Firebase Firestore Instance.
  String emailAddress;
  String password;
  bool isAdmin = true;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // This Function is not fully implemented.
  // It's task was to check whether or not user completed their registration correctly.
  void dataCheck() async {
    final userData = await _firestore.collection('users').doc(emailAddress).get();
    print(userData.data());
  }

  // This Function Checks whether the current user is admin or not.
  // It accesses the admin collection in firestore and checks if their is any entry with the current emailAddress.
  // It returns false and then uses setState to change isAdmin to new value, if the user has no entry in admin collection means the user is not an admin.
  Future adminCheck() async {
    final userData = await _firestore.collection('admin').doc(emailAddress).get();
    if (userData.data() == null){
      setState(() {
        isAdmin = false;
      });
    }
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
                // The Function here logs users in with the help of Firebase Authorization.
                // )n the basis of isAdmin user is sent to the admin screen or the home screen using ternary statement.
                try{
                  final newUser = await _auth.signInWithEmailAndPassword(email: emailAddress, password: password);
                  if(newUser != null){
                    // print('Login Successful');
                    await adminCheck();
                    Navigator.pushNamed(
                        context,
                        isAdmin ? AdminScreen.id : HomeScreen.id);
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