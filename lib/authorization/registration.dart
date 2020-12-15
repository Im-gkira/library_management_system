import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/authorization/login.dart';

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
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              border: Border.all(width: 5.0,color: Colors.white),
            ),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter First Name",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    onChanged: (value){
                      firstName = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Last Name",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    onChanged: (value){
                      lastName = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Roll Number",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    onChanged: (value){
                      rollNumber = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Branch Name",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    onChanged: (value){
                      branch = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    onChanged: (value){
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      fillColor: Colors.white,
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    onChanged: (value){
                      password = value == '' ? null : value;
                    },
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Gender',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 17.0
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                color: maleColour,
                                child: Icon(Icons.person),
                              ),
                              onTap: setGender,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                color: femaleColour,
                                child: Icon(Icons.person),
                              ),
                              onTap: setGender,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text('Register',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      )),
                  onPressed: makeRecord,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:library_management_system/authorization/enter_details.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// // The Registration Page creates a new account using the Firebase Authorization.
//
// class Registration extends StatefulWidget {
//   static String id = 'registration';
//   @override
//   _RegistrationState createState() => _RegistrationState();
// }
//
// class _RegistrationState extends State<Registration> {
//
//   // emailAddress Stores The email address entered by the user.
//   // password saves the password entered by the user.
//   // _auth is Firebase Authorization Instance.
//   String emailAddress;
//   String password;
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.centerRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   Color(0Xff294D64),
//                   Color(0Xff294D64),
//                 ])),
//         child: Card(
//           margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 210),
//           elevation: 26.0,
//           shadowColor: Colors.black,
//           color: Color(0Xff294D64),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     labelText: "Enter Email",
//                     labelStyle: TextStyle(
//                       color: Colors.white,
//                     ),
//                     border:  OutlineInputBorder(
//                       borderRadius:  BorderRadius.circular(35.0),
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                   ),
//                   validator: (val) {
//                     if(val.length==0) {
//                       Fluttertoast.showToast(msg: 'Email cannot be empty',);
//                       return "Email cannot be empty";
//                     }else{
//                       return null;
//                     }
//                   },
//                   keyboardType: TextInputType.emailAddress,
//                   style: TextStyle(
//                     fontFamily: "Poppins",
//                     color: Colors.white,
//                   ),
//                   onChanged: (value){
//                     emailAddress = value;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
//                 child: TextFormField(
//                   obscureText: true,
//                   decoration: new InputDecoration(
//                     labelText: "Enter Password",
//                     labelStyle: TextStyle(
//                       color: Colors.white,
//                     ),
//                     fillColor: Colors.white,
//                     border: new OutlineInputBorder(
//                       borderRadius: new BorderRadius.circular(35.0),
//                       borderSide: new BorderSide(
//                       ),
//                     ),
//                   ),
//                   validator: (val) {
//                     if(val.length==0) {
//                       Fluttertoast.showToast(msg: 'password cannot be empty',);
//                       return "Password cannot be empty";
//                     }else{
//                       return null;
//                     }
//                   },
//                   style: new TextStyle(
//                     fontFamily: "Poppins",
//                     color: Colors.white,
//                   ),
//                   onChanged: (value){
//                     password = value;
//                   },
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 50.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.centerRight,
//                         end: Alignment.bottomLeft,
//                         colors: [
//                           Color(0Xaa305FD6),
//                           Color(0Xaa305FD6),
//                         ]),
//                     borderRadius: BorderRadius.circular(30.0),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black,
//                         blurRadius: 2.0,
//                         spreadRadius: 0.0,
//                         offset:
//                         Offset(2.0, 2.0), // shadow direction: bottom right
//                       )
//                     ],
//                   ),
//                 child: FlatButton(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                   child: AutoSizeText('Register',
//                       maxLines: 1,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 1.6,
//                         color: Colors.white,
//                       )),
//                   onPressed: () async {
//                     try{
//                       // This creates the new account using Firebase Authorization
//                       // Then redirects them to the enter_details.dart to fill in useful info.
//                       // No one can become admin using register it can solely be done by the developer of the App.
//                       final newUser = await _auth.createUserWithEmailAndPassword(email: emailAddress, password: password);
//                       if(newUser != null){
//                         Navigator.pushNamed(context, EnterDetails.id);
//                       }
//                     }
//                     catch(e){
//                       Fluttertoast.showToast(msg: e.toString(),);
//                     }
//                   },
//                 ),
//               ),
//               ),],
//           ),
//         ),
//       ),
//     );
//   }
// }