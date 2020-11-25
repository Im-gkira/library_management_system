import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IssuedBooks extends StatefulWidget {
  static String id = 'issued_books';
  @override
  _IssuedBooksState createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {

  final _firestore = FirebaseFirestore.instance;
  List<Widget> issuedBookWidgetList = [];
  var enteredCode;

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

class IssuedBookWidget extends StatefulWidget {

  IssuedBookWidget({this.issuedBookContent,this.viewIssuedBooks});
  final issuedBookContent;
  final Function viewIssuedBooks;

  @override
  _IssuedBookWidgetState createState() => _IssuedBookWidgetState();
}

class _IssuedBookWidgetState extends State<IssuedBookWidget> {

  final _firestore = FirebaseFirestore.instance;
  var fine;
  List<Widget> userInfoList = [];

  Future userInfo() async {
    var borrower = widget.issuedBookContent['Borrower'];
    final userData = await _firestore.collection('users').doc(borrower).get();
    userInfoList.add(Text('${userData['First Name']} ${userData['Last Name']}'));
    userInfoList.add(Text('${userData['Branch']}'));
    userInfoList.add(Text('${userData['Roll Number']}'));
  }


  void fineCalculated(){
    var due = widget.issuedBookContent['Due Date'].toDate();
    var cur = DateTime.now();
    fine = cur.difference(due).inDays;
    if(fine <= 0){
      fine = 0;
    }
  }

  void deleteIssuedBook() async {
    try{
      var uniqueBookCode = widget.issuedBookContent['Unique Book Code'];
      var borrower = widget.issuedBookContent['Borrower'];
      var bookCode = widget.issuedBookContent['Book Code'];
      int newQuantity;
      Map issuedBooks = {};
      Map borrowerList = {};

      final userData = await _firestore.collection('users').doc(borrower).get();
      issuedBooks = userData.data()['Issued Books'];

      issuedBooks.remove(uniqueBookCode);
      _firestore.collection('users').doc(borrower).update({
        'Issued Books': issuedBooks,
      });

      final bookData = await _firestore.collection('books').doc(bookCode).get();
      borrowerList = bookData.data()['Borrower'];
      newQuantity = bookData.data()['Issued Quantity'] - 1;

      borrowerList.remove(uniqueBookCode);
      _firestore.collection('books').doc(bookCode).update({
        'Borrower': borrowerList,
        'Issued Quantity': newQuantity,
      });

      _firestore.collection('issued books').doc(uniqueBookCode).delete();
      Navigator.pop(context);
      setState(() {
        widget.viewIssuedBooks();
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
        child: Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: userInfoList,
              ),
              Text('$fine'),
              FlatButton(
                child: Text('Remove'),
                onPressed: deleteIssuedBook,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: ()async{
        await userInfo();
        fineCalculated();
        showModalBottomSheet(
          context: context,
          builder: buildBottomSheet,
          isScrollControlled: true,
        );
      },
      child: Text('${widget.issuedBookContent['Book Name']} with the unique code ${widget.issuedBookContent['Unique Book Code']} is due for ${widget.issuedBookContent['Due Date'].toDate()}'),
    );
  }
}
