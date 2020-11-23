import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/book_screen.dart';

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

class BookWidget extends StatelessWidget {

  BookWidget({this.bookContent});

  final bookContent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          //Navigator.pushNamed(context,BookScreen.id,arguments: bookContent);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context){
                    return BookScreen(bookContent: bookContent);}
              ),
          );
        },
        child: Text('${bookContent['Book Name']} with code ${bookContent['Book Code']}'),
    );
  }
}

