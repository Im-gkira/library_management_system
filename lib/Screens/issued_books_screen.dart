import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/components/issued_book_widget.dart';
import 'package:flutter/services.dart';

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
    var bookData =
        await _firestore.collection('issued books').orderBy('Due Date').get();
    setState(() {
      issuedBookWidgetList = [];
      for (var apps in bookData.docs) {
        var issuedBookContent = apps.data();
        issuedBookWidgetList.add(
          IssuedBookWidget(
            issuedBookContent: issuedBookContent,
            viewIssuedBooks: viewIssuedBooks,
          ),
        );
      }
    });
  }

  // This function display the issued book whose unique code is entered if such book exists.
  // The function adds the book widget to the list after it is emptied.
  void viewEnteredBook() async {
    try{
      var bookData = await _firestore.collection('issued books').doc(enteredCode).get();
      if(bookData.data() == null){
        print('Book Not Found');
      }
      else{
        setState(() {
          issuedBookWidgetList = [];
          issuedBookWidgetList.add(IssuedBookWidget(issuedBookContent: bookData,viewIssuedBooks: viewEnteredBook,),);
        });
      }
    }catch(e){
      print(e);
    }
  }

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: TabBar(
            labelPadding: EdgeInsets.only(top: 10.0),
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'search'),
              Tab(text: 'All'),
            ],
          ),
          body: TabBarView(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color(0Xff294D64),
                      Color(0Xff294D64),
                    ])),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                      margin:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                      elevation: 26.0,
                      shadowColor: Colors.black,
                      color: Color(0Xff294D64),
                      child: TextFormField(
                        onChanged: (value) {
                          enteredCode = value;
                        },
                        validator: (val) {
                          if (val.length == 0) {
                            return "Please type the code of the book";
                          } else {
                            return null;
                          }
                        },

                        keyboardType: TextInputType.number,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: viewEnteredBook),
                          labelText: "Enter Unique Code of the Book",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:  BorderRadius.circular(35.0),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                      margin:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      elevation: issuedBookWidgetList.length==0?0:26.0,
                      shadowColor: Colors.black,
                      color: Color(0Xff294D64),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                          child: DefaultTextStyle(
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.6,
                              )
                            ),
                            child: Builder(
                            builder: (context){
                              return Column(
                                children: issuedBookWidgetList,
                              );},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text('View Issued Books'),
                      onPressed: viewIssuedBooks,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
