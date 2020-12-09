import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

// This is the widget of each search result of application_screen it brings out a bottom sheet for more options.
class AppWidget extends StatefulWidget {

  //appContent are the contents of the particular application doc in applications collection.
  // reviewAgain is called again whenever action is taken on application.
  AppWidget({this.appContent,this.reviewAgain});
  final appContent;
  final Function reviewAgain;

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

  // _firestore is Firebase Firestore instance.
  final _firestore = FirebaseFirestore.instance;

  // This Function fetches the data of the particular document with the borrower's email address
  // Then adds the data to userInfoList which was public in the application_screen.dart.
  // The userInfoList is emptied each time this function runs.
  Future userInfo() async {
    try{
      var borrower = widget.appContent['Borrower'];
      final userData = await _firestore.collection('users').doc(borrower).get();
      setState(() {
        userInfoList = [];
        userInfoList.add(Text('${userData['First Name']} ${userData['Last Name']}'));
        userInfoList.add(Text('${userData['Branch']}'));
        userInfoList.add(Text('${userData['Roll Number']}'));
      });
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function issues the book for the user.
  // First of all the uniqueBookCode is checked. If there exists any doc with the same name that means the code has been assigned to some other book and can't be assigned now.
  // Entry is created in the particular user doc's Applied map of the users collection with the uniqueBookCode and due date.
  // Entry is created in the particular book doc's Borrower map of the books collection with the borrower's email Address and uniqueBookCode.
  // A new doc is created with the uniqueBookCode in issued books collections.
  // Then the applications is deleted after calling deleteApplication().
  void getIssued() async {
    try{
      var borrower = widget.appContent['Borrower'];
      var bookCode = widget.appContent['Book Code'];
      var bookName = widget.appContent['Book Name'];
      var dueDate = date;
      // print(uniqueBookCode);
      // print(date);

      final issuedBookContent = await _firestore.collection('issued books').doc(uniqueBookCode).get();

      if(issuedBookContent.data() != null){
        Fluttertoast.showToast(msg: 'Enter Unique Code',);
        // print('Enter Unique Code');
      }
      else{
        // print('Success');
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
      }

    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This Function deletes application once the action of accept or reject has been taken over it.
  // It deletes the particular application doc with id = borrower's emailAddress + BookCode
  // It deletes the entry from the applied of the particular user.
  // Then It Pops out the bottom sheet calls reviewApplications again using set state to rebuild the application screen and remove the application from screen.
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
        Fluttertoast.showToast(msg: 'Application Updated',);
        widget.reviewAgain();
      });
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This Function checks if the books are available or not.
  // Changes the isAvailable to false if the book's total quantity is equal to the issued quantity.
  void canIssue() async {
    try{
      var bookCode = widget.appContent['Book Code'];
      final bookContent = await _firestore.collection('books').doc(bookCode).get();

      isAvailable = !(bookContent['Total Quantity'] == bookContent['Issued Quantity']);
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }



  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Color(0xff757575),
        child: BottomSheetContents(getIssued: getIssued,deleteApplication: deleteApplication),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: ()async {
        // Whenever the widget is long pressed it calls the canIssue() to check its availability.
        // Then it awaits to get the userInfo of the borrower then it brings up the modal sheet.
        canIssue();
        await userInfo();
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

// This class controls what will be displayed on the bottom sheet.
class BottomSheetContents extends StatefulWidget {

  // It takes the function getIssued and deleteApplication as arguments.
  BottomSheetContents({this.getIssued,this.deleteApplication,});
  final VoidCallback getIssued;
  final VoidCallback deleteApplication;

  @override
  _BottomSheetContentsState createState() => _BottomSheetContentsState();
}

class _BottomSheetContentsState extends State<BottomSheetContents> {

  // bottomSheetItems contains item that will be displayed on the bottom sheet.
  List<Widget> bottomSheetItems = [];

  Future pickDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    date = picked;
  }

  // This Functions puts the initial widgets to be displayed.
  // It shows Accept or the Not Available depending on the isAvailable button.
  // The Reject button deletes the application using deleteApplication().
  void bottomSheetPhaseOne() {
    // print(isAvailable);
    // print(userInfoList);
    bottomSheetItems = userInfoList;
    setState(() {
      bottomSheetItems.add(isAvailable ? FlatButton(onPressed: bottomSheetPhaseTwo, child: Text('Accept'),) : FlatButton(onPressed: (){}, child: Text('Not Available'),));
      bottomSheetItems.add(FlatButton(onPressed: widget.deleteApplication, child: Text('Reject'),),);
    });
  }

  // This function works when the accept button is pressed in PhaseOne.
  // This function takes the uniqueBookCode and due date from the admin when the Accept button is pressed calls getIssued to issue the book.
  void bottomSheetPhaseTwo() {
    setState(() {
      // print('Phase 2 going on!');
      bottomSheetItems = [];
      bottomSheetItems.add(Text('Enter Unique Code'),);
      bottomSheetItems.add(TextField(
        onChanged: (value){
          uniqueBookCode = value;
        },
      ),);
      // bottomSheetItems.add(Text('Enter Due Date in yyyy-mm-dd'),);
      // bottomSheetItems.add(TextField(
      //   onChanged: (value){
      //     date = value;
      //   },
      // ),);
      bottomSheetItems.add(RaisedButton(
        child: Icon(Icons.calendar_today,),
        onPressed:pickDate,
      ),);
      bottomSheetItems.add(FlatButton(onPressed: widget.getIssued, child: Text('Accept'),),);
    });

  }

  @override
  void initState() {
    super.initState();
    bottomSheetPhaseOne();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: bottomSheetItems,
      ),
    );
  }
}

