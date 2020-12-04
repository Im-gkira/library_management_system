import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:library_management_system/Screens/issued_books_screen.dart';

// This Screen is the home screen of the admin and provides different options than the home screen of the user.
class AdminScreen extends StatefulWidget {
  static String id = 'admin_screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int x;
  int y;
  int _currentIndex = 0;
  PageController _pageController;

  void countBooks() async {
    QuerySnapshot _myDoc =
        await Firestore.instance.collection('books').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    var s = 0;
    for (var i = 0; i < _myDocCount.length; i++) {
      s = s + _myDocCount[i]['Total Quantity'];
    }
    setState(() {
      x = s;
      print(x);
    }); // Count of Documents in Collection
  }

  void countIssuedBook() async {
    QuerySnapshot _myDoc =
        await Firestore.instance.collection('issued books').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    setState(() {
      y = _myDocCount.length;
      print(y);
    }); // Count of Documents in Collection
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    countBooks();
    countIssuedBook();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (x == null || y == null)
      return Center(child: SizedBox(height:60.0,width:60,child: CircularProgressIndicator()));
    else
      return Scaffold(
          body: SizedBox.expand(
            child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
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
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,width: 2.0),
                                      ),
                                      child: ColoredBox(
                                        color: Colors.red,
                                        child: SizedBox(width: 12, height: 12),
                                      ),
                                    ),

                                    SizedBox(width: 10.0),
                                    AutoSizeText('Total No. of Books',
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,width: 2.0),
                                      ),
                                      child: ColoredBox(
                                        color: Colors.blue,
                                        child: SizedBox(width: 12, height: 12),
                                      ),
                                    ),

                                    SizedBox(width: 10.0),
                                    AutoSizeText('Total No. of Issued Books',
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    PieChart(PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: ((y / x) * 100).roundToDouble(),
                                          title: '${((y / x) * 100).roundToDouble()}%',
                                          color: Colors.blue,
                                          radius: 100.0,
                                        ),
                                        PieChartSectionData(
                                          value:((x - y) * 100 / x).roundToDouble(),
                                          radius:  100.0,
                                          title: '${((x - y) * 100 / x).roundToDouble()}%',
                                        ),
                                      ],
                                      centerSpaceRadius: 8.0,
                                      startDegreeOffset: 0.0,
                                      centerSpaceColor: Colors.black54,
                                      sectionsSpace: 5,
                                      pieTouchData: PieTouchData(enabled: true,),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ApplicationScreen(),
                  ),
                  Container(
                    child: SearchScreen(),
                  ),
                  Container(
                    child: IssuedBooks(),
                  )
                ]),
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 400), curve: Curves.ease);
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: AutoSizeText('Home'),
                activeColor: Colors.red,
              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.people),
                  title: AutoSizeText('Users'),
                  activeColor: Colors.purpleAccent),
              BottomNavyBarItem(
                  icon: Icon(Icons.search),
                  title: AutoSizeText('Search'),
                  activeColor: Colors.pink),
              BottomNavyBarItem(
                  icon: Icon(Icons.library_books_outlined),
                  title: AutoSizeText('Issued Books'),
                  activeColor: Colors.blue),
            ],
          ));
  }
}
