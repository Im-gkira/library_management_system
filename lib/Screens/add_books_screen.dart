import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

class AddBooks extends StatefulWidget {
  static String id = 'add_books';
  @override
  _AddBooksState createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {

  final _firestore = FirebaseFirestore.instance;
  String bookCode;
  String bookName;
  String author;
  String editionYear;
  Map borrower = {};
  int issuedQuantity = 0;
  int totalQuantity;

  void bookDataCheck() async {
    bool check = true;
    String toastMessage;

    if(bookName == null || bookCode == null || totalQuantity == null || editionYear == null || author == null){
      toastMessage = 'Data Entry Not Correct';
      check = false;
    }
    else{

      final checkData = await _firestore.collection('books').doc(bookCode).get();
      if(checkData.data() != null){
        toastMessage = 'Code Not Unique';
        check = false;
      }
      else{
        final bookData = await _firestore.collection('books').where('Book Name', isEqualTo: bookName).get();
        for(var data in bookData.docs){
          if(data.data()['Author'] == author && data.data()['Edition Year'] == editionYear){
            toastMessage = '${data.data()['Book Code']} contains identical data';
            check = false;
            break;
          }
        }
      }
    }

    if(!check){
      Fluttertoast.showToast(msg: toastMessage,);
    }
    else{
      addBook();
    }
  }

  // This Sends the data to the Firestore collection of users.
  // The document id is the emailAddress of the user filling the details.
  // After all the details are filled it takes the user to the home screen.
  void addBook() async {
    try{
      _firestore.collection('books').doc(bookCode).set({
        'Book Code': bookCode,
        'Book Name': bookName,
        'Edition Year': editionYear,
        'Author': author,
        'Total Quantity': totalQuantity,
        'Issued Quantity': issuedQuantity,
        'Borrower': borrower,
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Record Updated',);
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Text('Enter Book Code'),
            TextField(
              onChanged: (value){
                bookCode = value == '' ? null : value;
              },
            ),
            Text('Enter Book Name'),
            TextField(
              onChanged: (value){
                bookName = value == '' ? null : value.toLowerCase();
              },
            ),
            Text('Enter Edition Year'),
            TextField(
              onChanged: (value){
                editionYear = value == '' ? null : value;
              },
            ),
            Text('Enter Author Name'),
            TextField(
              onChanged: (value){
                author = value == '' ? null : value.toLowerCase();
              },
            ),
            Text('Enter Total Quantity'),
            TextField(
              onChanged: (value){
                totalQuantity = int.parse(value);
              },
            ),
            FlatButton(
              child: Text('Add Book'),
              onPressed: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('WARNING!'),
                    content: Text('We currently do not have the ability to update book contents. So please be extra sure.'),
                    actions: [
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                          bookDataCheck();
                        },
                        child: Text('Proceed'),
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('ReCheck'),
                      ),
                    ],
                    elevation: 20.0,
                  ),
                  barrierDismissible: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}