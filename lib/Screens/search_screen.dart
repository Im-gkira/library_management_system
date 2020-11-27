import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/components/book_widget.dart';

// This Page simply searches for the book of the given name.
class SearchScreen extends StatefulWidget {
  static String id = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  // bookName is entered by the user.
  // _firestore is the Firestore Instance.
  // bookWidgetList are the search results for the entered name.
  String bookName;
  final _firestore = FirebaseFirestore.instance;
  List <Widget> bookWidgetList = [];


  // This functions searches for the books with the name entered by the user.
  // Then for each book found, it adds a BookWidget to bookWidgetsList.
  // bookWidgetsList is emptied before every search.
  void bookSearch(String bookName) async {
    try{
      final bookData = await _firestore.collection('books').where('Book Name', isEqualTo: bookName).get();
      if(bookData.docs.isEmpty){
        print('Book Not Found');
      }
      for(var book in bookData.docs) {
        // print(book.data());
        var bookContent = book.data();
        setState(() {
          bookWidgetList.add(BookWidget(bookContent: bookContent));
        });
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
          children: [
            Text('Search For The Books'),
            TextField(
              onChanged: (value){
                bookName = value;
              }
            ),
            FlatButton(onPressed: (){
              bookSearch(bookName.toLowerCase());
              bookWidgetList = [];
            },
              child: Text('Search'),
            ),
            Expanded(
              child: ListView(
                children: bookWidgetList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}