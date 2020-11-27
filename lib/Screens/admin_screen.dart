import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:library_management_system/Screens/issued_books_screen.dart';

// This Screen is the home screen of the admin and provides different options than the home screen of the user.
class AdminScreen extends StatefulWidget {
  static String id = 'admin_screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FlatButton(
              child: Text('Applications'),
              onPressed: (){
                // Takes the user to the Application screen
                Navigator.pushNamed(context,ApplicationScreen.id);
              },
            ),
            FlatButton(
              child: Text('Search'),
              onPressed: (){
                // Takes the user to the Application screen
                Navigator.pushNamed(context,SearchScreen.id);
              },
            ),
            FlatButton(
              child: Text('Issued Books'),
              onPressed: (){
                // Takes the user to the Application screen
                Navigator.pushNamed(context,IssuedBooks.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
