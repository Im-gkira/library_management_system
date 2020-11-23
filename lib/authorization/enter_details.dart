import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management_system/home_screen.dart';

class EnterDetails extends StatefulWidget {
  static String id = 'enter_details';
  @override
  _EnterDetailsState createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String emailAddress;
  String firstName;
  String lastName;
  String rollNumber;
  String branch;
  Map issuedBooks= {};

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
                  _firestore.collection('users').doc(emailAddress).set({
                    'First Name': firstName,
                    'Last Name': lastName,
                    'Branch': branch,
                    'Roll Number': rollNumber,
                    'Email Id': emailAddress,
                    'Issued Books': issuedBooks,
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