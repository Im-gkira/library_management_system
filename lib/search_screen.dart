import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  static String id = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  String bookName;
  final _firestore = FirebaseFirestore.instance;
  List <Widget> bookWidgetList = [];


  void bookSearch(String bookName) async {
    try{
      final bookData = await _firestore.collection('books').where('Book Name', isEqualTo: bookName).get();
      if(bookData.docs.isEmpty){
        print('Book Not Found');
      }
      for(var book in bookData.docs) {
        print(book.data());
        var bookCode = book.data()['Book Code'];
        setState(() {
          bookWidgetList.add(BookWidget(bookCode: bookCode,bookName: bookName,));
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

class BookWidget extends StatelessWidget {

  BookWidget({this.bookCode,this.bookName});

  final String bookCode;
  final String bookName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          print('$bookName with code $bookCode');
        },
        child: Text('$bookName with code $bookCode'),
    );
  }
}

