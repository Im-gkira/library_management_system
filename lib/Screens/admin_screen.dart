import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          children:[
            Container(
            child: Column(
              children: [
                FlatButton(
                  child: Text('Applications'),
                  onPressed: (){
                    // Takes the user to the Application screen
                    Navigator.pushNamed(context,ApplicationScreen.id);
                  },
                ),
                FlatButton(
                  child: Text('Search'),
                  onPressed: (){
                    // Takes the user to the Application screen
                    Navigator.pushNamed(context,SearchScreen.id);
                  },
                ),
                FlatButton(
                  child: Text('Issued Books'),
                  onPressed: (){
                    // Takes the user to the Application screen
                    Navigator.pushNamed(context,IssuedBooks.id);
                  },
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
          ]
        ),
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
                activeColor: Colors.purpleAccent
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.search),
                title: AutoSizeText('Search'),
                activeColor: Colors.pink
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.library_books_outlined),
                title: AutoSizeText('Issued Books'),
                activeColor: Colors.blue
            ),
          ],
        )
    );
  }
}

class _MyHomePageState extends State<AdminScreen> {

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
    return Scaffold(
      appBar: AppBar(title: Text("Bottom Nav Bar")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(color: Colors.blueGrey,),
            Container(color: Colors.red,),
            Container(color: Colors.green,),
            Container(color: Colors.blue,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
              title: Text('Item Two'),
              icon: Icon(Icons.apps)
          ),
          BottomNavyBarItem(
              title: Text('Item Three'),
              icon: Icon(Icons.chat_bubble)
          ),
          BottomNavyBarItem(
              title: Text('Item Four'),
              icon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
}
