import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/authorization/login.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
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
  // _firestore is Firebase Firestore Instance.
  //firstName, lastName, rollNumber, branch stores the respective information.
  // issuedBooks and applied are required to passed null inorder to have at their entry else the app will crash in later phases if they are not found.
  String emailAddress;
  String password;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String firstName;
  String lastName;
  String rollNumber;
  String branch;
  Map issuedBooks= {};
  Map applied = {};
  Color maleColour = Colors.blue;
  Color femaleColour = Colors.white;
  String gender = 'male';

  void makeRecord() async {
    if(firstName == null || lastName == null || rollNumber == null || branch == null || emailAddress == null || password == null){
      Fluttertoast.showToast(msg: 'Field can\'t be empty');
    }
    else{
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
          'Gender': gender,
        });
        createAccount();
      }
      catch(e){
        Fluttertoast.showToast(msg: e.toString(),);
      }
    }
  }

  void createAccount() async {
    try{
      // This creates the new account using Firebase Authorization
      // Then redirects them to the enter_details.dart to fill in useful info.
      // No one can become admin using register it can solely be done by the developer of the App.
      final newUser = await _auth.createUserWithEmailAndPassword(email: emailAddress, password: password);
      if(newUser != null){
        final user = _auth.currentUser;
        await user.sendEmailVerification();
        Fluttertoast.showToast(msg: 'Verification email Send');
        Navigator.pushNamed(context, Login.id);
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  void setGender() {
    if(gender == 'male'){
      setState(() {
        gender = 'female';
        femaleColour = Colors.pink;
        maleColour = Colors.white;
        print('$gender');
      });
    }
    else{
      setState(() {
        gender = 'male';
        maleColour = Colors.blue;
        femaleColour = Colors.white;
        print('$gender');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.9,
            // height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/SignIn.png'),fit: BoxFit.scaleDown,alignment: Alignment.lerp(Alignment.bottomCenter, Alignment.center, 0.1)),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(
                      //   child: Text(
                      //     'Select Gender',
                      //     style: TextStyle(
                      //         fontFamily: "Poppins",
                      //         color: Colors.black,
                      //         fontSize: 17.0
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                color: maleColour,
                                child: Icon(LineAwesomeIcons.male,size: 60),
                              ),
                              onTap: setGender,
                            ),
                          ),
                          Container(
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                color: femaleColour,
                                child: Icon(LineAwesomeIcons.female,size: 60,),
                              ),
                              onTap: setGender,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.edit,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter First Name",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.edit,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Last Name",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.idCard,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Roll Number",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.graduationCap,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Branch Name",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.user,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.key,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 45.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0Xff440047).withOpacity(0.4),
                            Color(0Xff440047).withOpacity(0.2),
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
                      child: Text('Register',
                          style: GoogleFonts.montserrat(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                            color: Colors.white,
                          )
                      ),
                      onPressed: makeRecord,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}