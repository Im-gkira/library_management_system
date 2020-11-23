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


  void sendApplication(){
    String applicationId;
    applicationId = DateTime.now().millisecondsSinceEpoch.toString()+widget.bookContent['Book Code'];
    print(applicationId);
    _firestore.collection('applications').doc(applicationId).set({
      'Book Code': widget.bookContent['Book Code'],
      'Borrower': emailAddress,
      'Application Date': DateTime.now(),
    });
  }


  void checkIssued () {
    var isIssued = widget.bookContent['Borrower'].keys.firstWhere(
            (k) => widget.bookContent['Borrower'][k] == emailAddress, orElse: () => null);
    print(isIssued);
    if(isIssued != null){
      print('Already Issued');
      print(widget.bookContent['Borrower']);
    }
    else{
      checkApplied();
    }
  }

  void checkApplied() async {
    final userData = await _firestore.collection('users').doc(emailAddress).get();
    print(userData.data());

    // if(userData.data()['Applied']['${widget.bookContent['Book Code']}'] != null){
    //   print('Already Applied');
    // }
    // else{
    //   print(userData.data());
    //   print('Issuing Request Send');
    //   sendApplication();
    // }
  }


  // void getIssued() async {
  //   try{
  //     var uniqueBookCode = '10012';
  //     int newQuantity = widget.bookContent['Issued Quantity'] + 1;
  //     var dueDate = DateTime.parse("2021-01-01 11:59:59Z");
  //     print(dueDate);
  //
  //     _firestore.collection('users').doc(emailAddress).update({
  //       'Issued Books.$uniqueBookCode': dueDate,
  //     });
  //
  //
  //     _firestore.collection('books').doc(widget.bookContent['Book Code']).update({
  //       'Issued Quantity': newQuantity,
  //       'Borrower.$uniqueBookCode': emailAddress,
  //     });
  //
  //     _firestore.collection('issued books').doc(uniqueBookCode).set({
  //       'Book Code': widget.bookContent['Book Code'],
  //       'Unique Book Code': uniqueBookCode,
  //       'Borrower': emailAddress,
  //       'Due Date': dueDate,
  //     });
  //
  //   }catch(e){
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();

    isAvailable = widget.bookContent['Total Quantity'] == widget.bookContent['Issued Quantity'];

    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
        print(emailAddress);
      }
      checkApplied();
      print('hi');

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
              onPressed: isAvailable ? checkIssued : (){},
              child: isAvailable ? Text('Issue') : Text('Not Available'),
            ),
          ],
        ),
      ),
    );
  }
}
