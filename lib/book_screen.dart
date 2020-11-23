import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status{
  available,
  unavailable,
}

Status currentStatus;


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


  void sendApplication(){
    _firestore.collection('applications').doc(emailAddress).set({
      'Book Code': widget.bookContent['Book Code'],
      'Borrower': emailAddress,
      'Application Date': DateTime.now(),
    });
  }


  void checkIssued (){
    var usdKey = widget.bookContent['Borrower'].keys.firstWhere(
            (k) => widget.bookContent['Borrower'][k] == emailAddress, orElse: () => null);
    print(usdKey);
    if(usdKey != null){
      print('Already Issued');
      print(widget.bookContent['Borrower']);
    }
    else{
      print('Issuing Request Send');
      sendApplication();
    }
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

    currentStatus = widget.bookContent['Total Quantity'] == widget.bookContent['Issued Quantity'] ? Status.unavailable : Status.available;

    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
      }
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
              onPressed: currentStatus == Status.available ? checkIssued : (){},
              child: currentStatus == Status.available ? Text('Issue') : Text('Not Available'),
            ),
          ],
        ),
      ),
    );
  }
}
