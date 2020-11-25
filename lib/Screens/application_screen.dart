import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/bottom_sheet.dart';

var date;
var uniqueBookCode;


class ApplicationScreen extends StatefulWidget {
  static String id = 'application_screen';

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {

  final _firestore = FirebaseFirestore.instance;
  List<Widget> appWidgetList = [];

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


class AppWidget extends StatefulWidget {

  AppWidget({this.appContent,this.reviewAgain});
  final appContent;
  final Function reviewAgain;

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

  final _firestore = FirebaseFirestore.instance;

  void getIssued() async {
    try{
      var borrower = widget.appContent['Borrower'];
      var bookCode = widget.appContent['Book Code'];
      var bookName = widget.appContent['Book Name'];
      var dueDate = DateTime.parse(date);
      print(uniqueBookCode);
      print(date);

      final bookContent = await _firestore.collection('books').doc(bookCode).get();


      int newQuantity = bookContent['Issued Quantity'] + 1;

      _firestore.collection('users').doc(borrower).update({
        'Issued Books.$uniqueBookCode': dueDate,
      });

      _firestore.collection('books').doc(bookCode).update({
        'Issued Quantity': newQuantity,
        'Borrower.$uniqueBookCode': borrower,
      });

      _firestore.collection('issued books').doc(uniqueBookCode).set({
        'Book Code': bookCode,
        'Unique Book Code': uniqueBookCode,
        'Borrower': borrower,
        'Due Date': dueDate,
        'Book Name': bookName,
      });

      deleteApplication();

    }catch(e){
      print(e);
    }
  }

  void deleteApplication() async {
    try{
      var borrower = widget.appContent['Borrower'];
      var bookCode = widget.appContent['Book Code'];
      Map applied = {};
      var applicationId = borrower+bookCode;

      final userData = await _firestore.collection('users').doc(borrower).get();
      applied = userData.data()['Applied'];

      applied.remove(bookCode);
      _firestore.collection('users').doc(borrower).update({
        'Applied': applied,
      });

      _firestore.collection('applications').doc(applicationId).delete();
      Navigator.pop(context);
      setState(() {
        widget.reviewAgain();
      });
    }catch(e){
      print(e);
    }
  }


  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Color(0xff757575),
        child: BottomSheetContents(getIssued: getIssued,deleteApplication: deleteApplication,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        showModalBottomSheet(
          context: context,
          builder: buildBottomSheet,
          isScrollControlled: true,
        );
      },
      child: Text('${widget.appContent['Borrower']} Applied for ${widget.appContent['Book Name']}'),
    );
  }
}


