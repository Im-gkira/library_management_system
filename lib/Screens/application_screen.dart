import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/components/app_widget.dart';

//This Page can be accessed by the admin only to approve the applications send by the users.

// These variables are since they are accessed by the bottom_sheet.dart will solve this later using provider package.
// date is the due date given the user.
// uniqueBookCode is the unique code given by the admin to recognise the book.
// userInfoList is the text widget list with the details of the user with the respective application.
// isAvailable is a bool which allows the book to be issued if it it is true.
var date;
var uniqueBookCode;
List<Widget> userInfoList = [];
bool isAvailable;

class ApplicationScreen extends StatefulWidget {
  static String id = 'application_screen';

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {

  // _firestore is the Firebase Firestore instance.
  // appWidgetList is the widget list of all applications.
  final _firestore = FirebaseFirestore.instance;
  List<Widget> appWidgetList = [];

  // reviewApplications fetches all the applications from the applications collection.
  // For every application a appWidget is created and added to appWidgetList.
  // appWidgetList is emptied first whenever the function is called.
  void reviewApplications() async {
    var appData = await _firestore.collection('applications').orderBy('Application Date').get();
    setState(() {
      appWidgetList = [];
      for(var apps in appData.docs){
        var appContent = apps.data();
        appWidgetList.add(AppWidget(appContent: appContent,reviewAgain: reviewApplications,),);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FlatButton(
              child: Text('View Applications'),
              onPressed: reviewApplications,
            ),
            Expanded(
              child: ListView(
                children: appWidgetList,
              ),
            )
          ],
        ),
      ),
    );
  }
}