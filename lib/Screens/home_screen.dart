import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  DateTime currentBackPressTime;
  String emailAddress;
  List issuedBooks = [];

  void fetchData() async {
    try{
      final userData = await _firestore.collection('users').doc(emailAddress).get();
      print(userData.data());

      final bookData = await _firestore.collection('issued books').where('Borrower',isEqualTo: emailAddress).get();
      for(var data in bookData.docs){
        print(data.data());
      }

      final applicationData = await _firestore.collection('applications').where('Borrower',isEqualTo: emailAddress).get();
      for(var appData in applicationData.docs){
        print(appData.data());
      }

    }catch(e){
      print(e);
    }
  }


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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          child:Column(
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
    );
  }
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
}