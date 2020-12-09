import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class Carousel extends StatelessWidget {
  Carousel({this.bookNameList});
  final List<String> bookNameList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
        ),
        items: bookNameList.map((item) => Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xAAd264b6),
          ),
          child: Center(
            child: Text(item,
              style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  SmallButton({this.buttonString,this.onPressed,this.colour});
  final String buttonString;
  final Function onPressed;
  final Color colour;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: colour,
          width: 4.0,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: RaisedButton(
        child: Text(buttonString),
        color: colour,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class UserDataWidget extends StatelessWidget {
  UserDataWidget({this.userData});
  final userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      padding: EdgeInsets.only(left: 25.0,top: 10.0,bottom: 10.0),
      decoration: BoxDecoration(
        color: Color(0xAAff499e),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${userData['First Name']} ${userData['Last Name']} \n${userData['Branch']} \n${userData['Roll Number']}',
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DivisionTitle extends StatelessWidget {

  DivisionTitle({this.title,this.colour});
  final String title;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 59.0,
            width: 5.0,
            margin: EdgeInsets.only(left: 20.0,top: 20.0,bottom: 20.0),
            color: colour
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0,bottom: 20.0),
          padding: EdgeInsets.only(right: 20.0,left: 20.0,bottom: 20.0),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            title,
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                  fontSize: 40.0,
                  color: colour
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ApplicationWidget extends StatelessWidget {

  ApplicationWidget({this.appData});
  final appData;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,

      margin: EdgeInsets.symmetric(horizontal: 35.0,vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Color(0xAAaf2bbf),
      ),
      child: Center(
        child: Text('Book Name: ${appData.data()['Book Name']} \nBook Code: ${appData.data()['Book Code']}',
          style: GoogleFonts.permanentMarker(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}