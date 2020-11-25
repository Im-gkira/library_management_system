import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookScreen extends StatefulWidget {
  BookScreen({this.bookContent});
  final bookContent;

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String emailAddress;
  bool isAvailable;
  bool isAdmin = true;

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
              onPressed: isAdmin ? (){print('Admin');} : isAvailable ? checkIssued : (){print('UnAvailable');},
              child: isAvailable ? Text('Issue') : Text('Not Available'),
            ),
          ],
        ),
      ),
    );
  }
}
