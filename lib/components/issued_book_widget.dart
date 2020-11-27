import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This class build the widget for the issued books displayed and also brings up the bottom sheet.
class IssuedBookWidget extends StatefulWidget {

  IssuedBookWidget({this.issuedBookContent,this.viewIssuedBooks});
  // issuedBookContents contains the data of that particular issued book that is displayed.
  // viewIssuedBooks is called whenever changes are mad to the issued books.
  final issuedBookContent;
  final Function viewIssuedBooks;

  @override
  _IssuedBookWidgetState createState() => _IssuedBookWidgetState();
}

class _IssuedBookWidgetState extends State<IssuedBookWidget> {

  // _firestore is Firebase Firestore instance.
  // fine is calculated by the subtracting the due date from current date.
  // userInfoList contains the details of the borrower.
  final _firestore = FirebaseFirestore.instance;
  var fine;
  List<Widget> userInfoList = [];

  // This Function fetches the data of the particular document with the borrower's email address
  // Then adds the data to userInfoList which was public in the application_screen.dart.
  // The userInfoList is emptied each time this function runs.
  Future userInfo() async {
    userInfoList = [];
    var borrower = widget.issuedBookContent['Borrower'];
    final userData = await _firestore.collection('users').doc(borrower).get();
    userInfoList.add(Text('${userData['First Name']} ${userData['Last Name']}'));
    userInfoList.add(Text('${userData['Branch']}'));
    userInfoList.add(Text('${userData['Roll Number']}'));
  }

  // This function calculated the due days of each books by subtracting the due date from the current days.
  // If it is -ve it means that the book is returned in time hence the fine is rounded to zero.
  // If It is +ve it means that the book is returned after the due and hence the no.of extra days are displayed.
  void fineCalculated(){
    var due = widget.issuedBookContent['Due Date'].toDate();
    var cur = DateTime.now();
    fine = cur.difference(due).inDays;
    if(fine <= 0){
      fine = 0;
    }
  }

  // This function deletes the issued book from the issued books collection and the issued map of users.
  // It updates the issued quantity by subtracting one.
  // It uses the uniqueBookCode to delete the users issued map entry.
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


  // This builds the bottom sheet/
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
        // userInfo and fineCalculated run before the bottom sheet starts building.
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
