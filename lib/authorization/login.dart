import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:library_management_system/Screens/admin_screen.dart';
import 'package:library_management_system/Screens/home_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final userData =
        await _firestore.collection('users').doc(emailAddress).get();
    print(userData.data());
  }

  // This Function Checks whether the current user is admin or not.
  // It accesses the admin collection in firestore and checks if their is any entry with the current emailAddress.
  // It returns false and then uses setState to change isAdmin to new value, if the user has no entry in admin collection means the user is not an admin.
  Future adminCheck() async {
    final userData =
        await _firestore.collection('admin').doc(emailAddress).get();
    if (userData.data() == null) {
      setState(() {
        isAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/fun.png'),fit: BoxFit.cover),
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomLeft,
                colors: [
              Color(0Xff294D64),
              Color(0Xff294D64),
            ])),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0)),
          margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 210.0),
          elevation: 26.0,
          shadowColor: Colors.black,
          color: Color(0Xaa294D64).withOpacity(0.4),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
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
                      return "Email cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    emailAddress = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: new InputDecoration(
                    labelText: "Enter Password",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(45.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Email cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  style: new TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0Xff393e46),
                          Color(0Xaa393e46),
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
                    child: AutoSizeText('Login',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                          color: Colors.white,
                        )),
                    onPressed: () async {
                      // The Function here logs users in with the help of Firebase Authorization.
                      // )n the basis of isAdmin user is sent to the admin screen or the home screen using ternary statement.
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: emailAddress, password: password);
                        if (newUser != null) {
                          // print('Login Successful');
                          await adminCheck();
                          Navigator.pushNamed(
                              context, isAdmin ? AdminScreen.id : HomeScreen.id);
                        }
                      } catch (e) {
                        print(e);
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
