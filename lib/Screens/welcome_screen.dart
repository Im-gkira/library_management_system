import 'package:flutter/material.dart';
import 'package:library_management_system/authorization/registration.dart';
import 'package:library_management_system/authorization/login.dart';

// This Screen is the Welcome Screen That the User sees for the first time when the app starts.
// The Static String is Used so that the routes are not named incorrectly as they are used in many places.
// This Screen contains the Navigator to Login Screen and Registration Screen. So When The User Presses any button He is taken to The Login Screen.
// Whenever the FlatButton is pressed it takes to the respective page.


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FlatButton(
              child: Text('Login'),
              onPressed: (){
                Navigator.pushNamed(context, Login.id);
              },
            ),
            FlatButton(
              child: Text('Register'),
              onPressed: (){
                Navigator.pushNamed(context, Registration.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
