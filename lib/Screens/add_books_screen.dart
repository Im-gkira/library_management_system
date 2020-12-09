import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

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

    if (bookName == null ||
        bookCode == null ||
        totalQuantity == null ||
        editionYear == null ||
        author == null) {
      toastMessage = 'Data Entry Not Correct';
      check = false;
    } else {
      final checkData =
          await _firestore.collection('books').doc(bookCode).get();
      if (checkData.data() != null) {
        toastMessage = 'Code Not Unique';
        check = false;
      } else {
        final bookData = await _firestore
            .collection('books')
            .where('Book Name', isEqualTo: bookName)
            .get();
        for (var data in bookData.docs) {
          if (data.data()['Author'] == author &&
              data.data()['Edition Year'] == editionYear) {
            toastMessage =
                '${data.data()['Book Code']} contains identical data';
            check = false;
            break;
          }
        }
      }
    }

    if (!check) {
      Fluttertoast.showToast(
        msg: toastMessage,
      );
    } else {
      addBook();
    }
  }

  // This Sends the data to the Firestore collection of users.
  // The document id is the emailAddress of the user filling the details.
  // After all the details are filled it takes the user to the home screen.
  void addBook() async {
    try {
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
      Fluttertoast.showToast(
        msg: 'Record Updated',
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/demo.png"),fit: BoxFit.cover),
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomLeft,
                colors: [
              Color(0Xff294D64),
              Color(0Xff294D64),
            ])),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0)),
          margin: EdgeInsets.only(top: 210.0,left:40.0,right:40.0,bottom:170.0),
          elevation: 26.0,
          shadowColor: Colors.black54,
          color: Color(0X00aaaaaa).withOpacity(0.8),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,right: 70.0),
                child: TextFormField(
                  autofocus: true,

                  decoration: InputDecoration(
                    labelText: "Enter Book Code",
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight:FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    bookCode = value == '' ? null : value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,right: 70.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Book Name",
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight:FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black54,
                  ),
                  onChanged: (value) {
                    bookName = value == '' ? null : value.toLowerCase();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,right: 70.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Edition Year",
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight:FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black54,
                  ),
                  onChanged: (value) {
                    editionYear = value == '' ? null : value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,right: 70.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Author Name",
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight:FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black54,
                  ),
                  onChanged: (value) {
                    author = value == '' ? null : value.toLowerCase();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,right: 70.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Total Quantity",
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight:FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    totalQuantity = int.parse(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0Xff393e46),
                          Color(0Xaa393e46),
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
                    child: Text('Add Book',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )
                    ),),
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('WARNING!'),
                          content: Text(
                              'We currently do not have the ability to update book contents. So please be extra sure.'),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                bookDataCheck();
                              },
                              child: Text('Proceed'),
                            ),
                            FlatButton(
                              onPressed: () {
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
