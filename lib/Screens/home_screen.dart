import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This is the home screen of the normal user and displays all the information of the user.
class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // A Refresh Indicator requires a Key to work which is declared here.
  // currentBackPressTime is used by onWillPop() to check the difference of time in 2 consecutive back presses.
  // _auth is Firebase Authorization Instance.
  // _firestore is Firebase Firestore Instance.
  // emailAddress is taken with the help of loggedInUser which automatically fetches user's email address using Firebase Authorization.
 // fine is the fine calculated for the issued/due books.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  DateTime currentBackPressTime;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String emailAddress;
  var fine;

  // This function calculated the due days of each books by subtracting the due date from the current days.
  // If it is -ve it means that the book is returned in time hence the fine is rounded to zero.
  // If It is +ve it means that the book is returned after the due and hence the no.of extra days are displayed.
  void fineCalculated(var data){
    var due = data['Due Date'].toDate();
    var cur = DateTime.now();
    fine = cur.difference(due).inDays;
    if(fine <= 0){
      fine = 0;
    }
    print(fine);
  }

  // This function fetches the all the data of the users including the details, issued books and applications you send for the various books.
  // userData fetches the specific doc data with the document id == logged in users's email address, from the users collection.
  // bookData fetches the specific doc data where the borrower == logged in users's email Address, from the issued books collection and calls fineCalculate() to calculate fine on each book.
  // applicationData fetches the specific doc data where the borrower == logged in users's email Address, from the applications collection
  Future<void> fetchData() async {
    try{
      final userData = await _firestore.collection('users').doc(emailAddress).get();
      print(userData.data());

      final bookData = await _firestore.collection('issued books').where('Borrower',isEqualTo: emailAddress).get();
      for(var data in bookData.docs){
        print(data.data());
        fineCalculated(data.data());
      }

      final applicationData = await _firestore.collection('applications').where('Borrower',isEqualTo: emailAddress).get();
      for(var appData in applicationData.docs){
        print(appData.data());
      }

    }catch(e){
      print(e);
    }
  }

  // This function returns a bool for onWillPop.
  // It checks if the button is pressed 2 times within the interval of 2 seconds then it will close the app.
  // It returns false always which will prohibit the user from going back to the login or enter_details screen.
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      print('Back Button Pressed');
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(false);
  }

  // This function is executed as soon as the widget is build.
  // The function calls the fetchData()
  @override
  void initState() {
    super.initState();
    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
      }
      fetchData();
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Wrapped the scaffold into the WillPopScope to control the popping of screen.
    //onWillPop takes a bool which allows the screen to popped or not on the basis of it.
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          child:RefreshIndicator(
            // RefreshIndicator is added to bring the scroll down to refresh functionality.
            // key takes the global key declared.
            // onRefresh takes the function to be called when app is refreshed.
            // child of this widget can only on ListView.
            key: _refreshIndicatorKey,
            onRefresh: fetchData,
            child: ListView(
              children: [
                FlatButton(
                  child: Text('Search'),
                  onPressed: (){
                  Navigator.pushNamed(context, SearchScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}