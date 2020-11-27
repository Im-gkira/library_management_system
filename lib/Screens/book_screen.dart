import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This screens shows the contents of the book that was tapped in the search screen.
// If the user is an admin he can only view the status of the book but not apply for the book.
class BookScreen extends StatefulWidget {
  BookScreen({this.bookContent});
  final bookContent;

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {

  // _firestore is Firebase FireStore instance.
  // _auth is the Firebase Authorization instance.
  // emailAddress is taken with the help of loggedInUser which automatically fetches user's email address using Firebase Authorization.
  // isAvailable is bool which is true if at least one book is available to be issued.
  // isAdmin is bool which is true if the user is an Admin and false if it is a normal user. Its true since it can't be null when the widgets are build.
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String emailAddress;
  bool isAvailable;
  bool isAdmin = true;

  // This Function Checks whether the current user is admin or not.
  // It accesses the admin collection in firestore and checks if their is any entry with the current emailAddress.
  // It returns false and then uses setState to change isAdmin to new value, if the user has no entry in admin collection means the user is not an admin.
  void adminCheck() async {
    final userData = await _firestore.collection('admin').doc(emailAddress).get();
    if (userData.data() == null){
      setState(() {
        isAdmin = false;
      });
    }
    print(isAdmin);
    print(userData.data());
  }

  // This function checks whether the book being applied is already issued by the user or not.
  // This function checks if any documents in issued books collections is having the current user's email address in the Borrower map.
  // we use the firstWhere to check for the condition and if it is issued the user's application is not send.
  void checkIssued () {
    var isIssued = widget.bookContent['Borrower'].keys.firstWhere(
            (k) => widget.bookContent['Borrower'][k] == emailAddress, orElse: () => null);
    if(isIssued != null){
      print('Already Issued');
      // print(widget.bookContent['Borrower']);
    }
    else{
      checkApplied();
    }
  }

  // This function checks if the user has already applied to the book or not.
  // This function checks whether the particular user's doc in users collection contains the map applied with the particular book code being applied for.
  // This Function will limit the no.of applications for the book to one per person.
  void checkApplied() async {
    final userData = await _firestore.collection('users').doc(emailAddress).get();
    if(userData.data()['Applied']['${widget.bookContent['Book Code']}'] != null){
      print('Already Applied');
    }
    else{
      print('Issuing Request Send');
      sendApplication();
    }
  }

  // sendApplication sends the application of the user.
  // If isIssued and checkApplied are cleared then the user can send the application.
  // It creates a new doc in the applications collection and a new entry in the applied of the user doc in users collection.
  // The Application id is simply the emailAddress of the user + BookCode
  void sendApplication() {
    String applicationId;
    applicationId = emailAddress+widget.bookContent['Book Code'];
    print(applicationId);
    _firestore.collection('applications').doc(applicationId).set({
      'Book Code': widget.bookContent['Book Code'],
      'Borrower': emailAddress,
      'Application Date': DateTime.now(),
      'Book Name': widget.bookContent['Book Name'],
    });
    _firestore.collection('users').doc(emailAddress).update({
      'Applied.${widget.bookContent['Book Code']}': DateTime.now(),
    });
  }

  // This function is executed as soon as the widget is build.
  // isAvailable is true if the no.of books issued are less than total no.of books.
  // The function fetches the email address of the user via Firebase Authorization automatically.
  @override
  void initState() {
    super.initState();
    isAvailable = widget.bookContent['Total Quantity'] > widget.bookContent['Issued Quantity'];
    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
      }
      adminCheck();
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${widget.bookContent['Book Name']}'),
            Text('${widget.bookContent['Book Code']}'),
            Text('${widget.bookContent['Issued Quantity']}'),
            Text('${widget.bookContent['Total Quantity']}'),
            FlatButton(
              // If the isAdmin is true the user can cannot issue the book.
              // If the isAvailable is true the user cannot issue the book.
              onPressed: isAdmin ? (){print('Admin');} : isAvailable ? checkIssued : (){print('UnAvailable');},
              child: isAvailable ? Text('Issue') : Text('Not Available'),
            ),
          ],
        ),
      ),
    );
  }
}
