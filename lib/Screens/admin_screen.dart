import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/application_screen.dart';


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
                Navigator.pushNamed(context,ApplicationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
