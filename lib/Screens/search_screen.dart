import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0Xff294D64),
                  Color(0Xff294D64),
                ])),
        child: Container(
          margin: EdgeInsets.only(top: 160),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0)),
                margin: EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 30.0),
                elevation: 26.0,
                shadowColor: Colors.black,
                color: Color(0Xff294D64),
                child: TextFormField(
                  autofocus: true,
                  onChanged: (value){
                    bookName = value;
                  },
                  validator: (val) {
                    if (val.length == 0) {
                      return "Search Books";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search,color: Colors.white,),
                        onPressed: (){
                          bookSearch(bookName.toLowerCase());
                          bookWidgetList = [];
                        },),
                    labelText: "Search Books",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0Xaa2E59CC),
                          Color(0Xaa2E59CC),
                        ]),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    onPressed: (){
                    bookSearch(bookName.toLowerCase());
                    bookWidgetList = [];
                  },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: AutoSizeText('Search',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0)),
                margin: EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                elevation: bookWidgetList.length == 0 ? 0 : 26.0,
                shadowColor: Colors.black,
                color: Color(0Xff294D64),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: DefaultTextStyle(
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.6,
                          )),
                      child: Builder(
                        builder: (context) {
                          return Column(
                            children: bookWidgetList,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}