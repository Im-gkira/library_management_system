import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                child: Center(
                  child: Text(
                    'To view Please Press the Button',
                    style: GoogleFonts.montserrat(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0)),
              margin: EdgeInsets.symmetric(
                  horizontal: 40.0, vertical: 20.0),
              elevation: appWidgetList.length == 0 ? 0 : 26.0,
              shadowColor: Colors.black,
              color: Color(0Xff294D64),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 10.0),
                  child: DefaultTextStyle(
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.6,
                        )),
                    child: Builder(
                      builder: (context) {
                        return SizedBox(
                          height: 400.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                children: List.generate(
                                    appWidgetList.length,
                                        (index) {
                                      return Column(children: [
                                        appWidgetList[index],
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text("****"),
                                        SizedBox(
                                          height: 15.0,
                                        )
                                      ]);
                                    })),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(35.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0XaaDD4040),
                          Color(0XaaDD4040),
                        ]),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                            2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: FlatButton(
                    child: Text('View Applications'),
                    onPressed: reviewApplications,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}