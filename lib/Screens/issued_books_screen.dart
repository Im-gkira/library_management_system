import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/components/issued_book_widget.dart';

// This Class removes the books that are returned.
class IssuedBooks extends StatefulWidget {
  static String id = 'issued_books';
  @override
  _IssuedBooksState createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {

  // _firestore is the Firebase Firestore instance.
  // issuedBookWidgetList stores the widget for each issued book dsiplayed.
  // enteredCode is the unique code of the book to be returned.
  final _firestore = FirebaseFirestore.instance;
  List<Widget> issuedBookWidgetList = [];
  var enteredCode;

  // Gets the information of all the books that are issued.
  // Creates a widget for each issued book and adds to the list.
  // The list is emptied in the beginning.
  // The data is sorted in accordance to the due date to show the whose date is near on the top.
  void viewIssuedBooks() async {
    var bookData = await _firestore.collection('issued books').orderBy('Due Date').get();
    setState(() {
      issuedBookWidgetList = [];
      for(var apps in bookData.docs){
        var issuedBookContent = apps.data();
        issuedBookWidgetList.add(IssuedBookWidget(issuedBookContent: issuedBookContent,viewIssuedBooks: viewIssuedBooks,),);
      }
    });
  }

  // This function display the issued book whose unique code is entered if such book exists.
  // The function adds the book widget to the list after it is emptied.
  void viewEnteredBook() async {
    var bookData = await _firestore.collection('issued books').doc(enteredCode).get();
    setState(() {
      issuedBookWidgetList = [];
      issuedBookWidgetList.add(IssuedBookWidget(issuedBookContent: bookData,viewIssuedBooks: viewEnteredBook,),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextField(
              onChanged: (value){
                enteredCode = value;
              },
            ),
            Row(
              children: [
                FlatButton(
                  child: Text('View Issued Books'),
                  onPressed: viewIssuedBooks,
                ),
                FlatButton(
                  child: Text('Search The Particular Books'),
                  onPressed: viewEnteredBook,
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: issuedBookWidgetList,
              ),
            )
          ],
        ),
      ),
    );
  }
}