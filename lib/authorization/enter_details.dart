import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management_system/Screens/home_screen.dart';

// This Takes the Info of the newly registered users so that it can be utilized when the user apply for a book to be issued.

class EnterDetails extends StatefulWidget {
  static String id = 'enter_details';
  @override
  _EnterDetailsState createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {

  // _auth is Firebase Authorization Instance.
  // _firestore is Firebase Firestore Instance.
  // emailAddress is taken with the help of loggedInUser which automatically fetches user's email address using Firebase Authorization.
  //firstName, lastName, rollNumber, branch stores the respective information.
  // issuedBooks and applied are required to passed null inorder to have at their entry else the app will crash in later phases if they are not found.
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String emailAddress;
  String firstName;
  String lastName;
  String rollNumber;
  String branch;
  Map issuedBooks= {};
  Map applied = {};

  // This function is executed as soon as the widget is build.
  // The function fetches the email address of the user via Firebase Authorization automatically.
  @override
  void initState(){
    super.initState();
    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
      }
    }
    catch(e){
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('Enter First Name'),
            TextField(
              onChanged: (value){
                firstName = value;
              },
            ),
            Text('Enter Last Name'),
            TextField(
              onChanged: (value){
                lastName = value;
              },
            ),
            Text('Enter Roll Number'),
            TextField(
              onChanged: (value){
                rollNumber = value;
              },
            ),
            Text('Enter Branch'),
            TextField(
              onChanged: (value){
                branch = value;
              },
            ),
            FlatButton(
              child: Text('Give Details'),
              onPressed: () async {
                try{
                  // This Sends the data to the Firestore collection of users.
                  // The document id is the emailAddress of the user filling the details.
                  // After all the details are filled it takes the user to the home screen.
                  _firestore.collection('users').doc(emailAddress).set({
                    'First Name': firstName,
                    'Last Name': lastName,
                    'Branch': branch,
                    'Roll Number': rollNumber,
                    'Email Id': emailAddress,
                    'Issued Books': issuedBooks,
                    'Applied': applied,
                  });
                  Navigator.pushNamed(context, HomeScreen.id);
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