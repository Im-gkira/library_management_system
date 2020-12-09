import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0Xff294D64),
                  Color(0Xff294D64),
                ])),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 180.0),
          elevation: 26.0,
          shadowColor: Colors.black,
          color: Color(0Xff294D64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter First Name",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border:  OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(35.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      Fluttertoast.showToast(msg: 'First Name cannot be empty',);
                      return "First Name cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value){
                    firstName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Last Name",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border:  OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(35.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      Fluttertoast.showToast(msg: 'Last Name cannot be empty',);
                      return "Last Name cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value){
                    lastName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Roll Number",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border:  OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(35.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      Fluttertoast.showToast(msg: 'Roll Number cannot be empty',);
                      return "Roll Number cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value){
                    rollNumber = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Branch Name",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border:  OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(35.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      Fluttertoast.showToast(msg: 'Branch Name cannot be empty',);
                      return "Branch Name cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value){
                    branch = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0Xaa404E57),
                          Color(0Xaa404E57),
                        ]),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: AutoSizeText('Submit',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                          color: Colors.lightBlueAccent,
                        )),
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
                        Fluttertoast.showToast(msg: e.toString(),);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}