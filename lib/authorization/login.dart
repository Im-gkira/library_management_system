import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:library_management_system/Screens/admin_screen.dart';
import 'package:library_management_system/Screens/home_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

// The Login Page is the Main Gateway To The App.
// It takes the already Registered user to the home screen or the admin screen depending upon isAdmin.
class Login extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String emailAddress;
  String password;
  bool isAdmin = true;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isLoading = false;


  // This Function Checks whether the current user is admin or not.
  // It accesses the admin collection in firestore and checks if their is any entry with the current emailAddress.
  // It returns false and then uses setState to change isAdmin to new value, if the user has no entry in admin collection means the user is not an admin.
  Future adminCheck() async {
    try{
      final userData =
      await _firestore.collection('admin').doc(emailAddress).get();
      if (userData.data() == null) {
        setState(() {
          isAdmin = false;
        });
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  void checkVerified() async {
    if(isAdmin){
      Navigator.pushNamed(
          context, AdminScreen.id);
    }
    else{
      final user = _auth.currentUser;
      if(!user.emailVerified){
        Fluttertoast.showToast(msg: 'Email Not Verified');
        setState(() {
          isLoading = false;
        });
      }
      else{
        Navigator.pushNamed(
            context, HomeScreen.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: isLoading ?
      Container(
        color: Colors.black,
        child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 5.0,
              backgroundColor: Colors.pink,
            )
        ),
      ) : Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/Login.jpg'),fit: BoxFit.scaleDown,alignment: Alignment.lerp(Alignment.bottomCenter, Alignment.center, 0.35)),
          color: Colors.white,
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(left: 60,right:60,top: 100),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email,size: 18.0,color: Color(0Xff6B63FF),),
                  labelText: "Enter Email",
                  labelStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
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
                style: GoogleFonts.montserrat(
                  color: Color(0Xff403D55),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                onChanged: (value) {
                  emailAddress = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 60,right:60,top: 25),
              child: TextFormField(
                obscureText: true,
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key,size: 18.0,color: Color(0Xff6B63FF),),
                  labelText: "Enter Password",
                  labelStyle: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                validator: (val) {
                  if(val.length==0) {
                    Fluttertoast.showToast(msg: 'Password cannot be empty',);
                    return "Password cannot be empty";
                  }else{
                    return null;
                  }
                },
                style: GoogleFonts.montserrat(
                  color: Color(0Xff403D55),
              fontWeight: FontWeight.w500,
              fontSize: 16,
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
                        Color(0Xff440047).withOpacity(0.7),
                        Color(0Xff440047).withOpacity(0.8),
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
                      setState(() {
                        isLoading = true;
                      });
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: emailAddress, password: password);
                      if (newUser != null) {
                        // print('Login Successful');
                        await adminCheck();
                        checkVerified();
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString(),);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
