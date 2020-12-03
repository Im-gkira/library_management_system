import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
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
    try {
      var bookData =
          await _firestore.collection('issued books').doc(enteredCode).get();
      if (bookData.data() == null) {
        print('Book Not Found');
      } else {
        setState(() {
          issuedBookWidgetList = [];
          issuedBookWidgetList.add(Column(
            children: [
              IssuedBookWidget(
                  issuedBookContent: bookData,
                  viewIssuedBooks: viewEnteredBook),
            ],
          ));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
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
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TabBar(
            onTap: (value){
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
            },
            labelPadding: EdgeInsets.only(top: 10.0),
            labelStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            )),
            labelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.search),
                text: 'Search',
                iconMargin: EdgeInsets.all(0.0),
              ),
              Tab(
                  icon: Icon(Icons.list),
                  text: 'All',
                  iconMargin: EdgeInsets.all(0.0)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      margin: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 30.0),
                      elevation: 26.0,
                      shadowColor: Colors.black,
                      color: Color(0Xff294D64),
                      child: TextFormField(
                        autofocus: true,
                        keyboardAppearance: Brightness.dark,
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
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: viewEnteredBook),
                          labelText: "Enter Unique Code of the Book",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      margin: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      elevation: issuedBookWidgetList.length == 0 ? 0 : 26.0,
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
                                  children: issuedBookWidgetList,
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        child: Center(
                      child: Text(
                        'To view Please Press the Button',
                        style: GoogleFonts.montserrat(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      margin: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      elevation: issuedBookWidgetList.length == 0 ? 0 : 26.0,
                      shadowColor: Colors.black,
                      color: Color(0Xff294D64),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 10.0),
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
                                return SizedBox(
                                  height: 400.0,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: List.generate(
                                            issuedBookWidgetList.length,
                                            (index) {
                                      return Column(children: [
                                        issuedBookWidgetList[index],
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Text("****"),
                                        SizedBox(
                                          height: 15.0,
                                        )
                                      ]);
                                    })),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 50.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0XaaDD4040),
                                  Color(0XaaDD4040),
                                ]),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: FlatButton(
                            child: AutoSizeText('Check All Issued Books',
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.6,
                                  color: Colors.white,
                                )),
                            onPressed: viewIssuedBooks,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
