import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

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
            color: Colors.black45,
            border: Border.all(width: 3.0,color: Colors.white),
          ),
          child: Center(
            child: Text(item,
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 18.0,
                fontFamily: 'Cubano',
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
        color: Colors.black,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: RaisedButton(
        child: Text(buttonString),
        color: colour,
        textColor: Colors.black,
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
      margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 30.0),
      padding: EdgeInsets.only(left: 25.0,top: 20.0,bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(width: 3.0,color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${userData['First Name']} ${userData['Last Name']} \n${userData['Branch']} \n${userData['Roll Number']}',
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                fontSize: 20.0,
                color: Colors.pinkAccent,
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
            color: Colors.black54,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
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
        border: Border.all(width: 3.0,color: Colors.white),
        color: Colors.black45,
      ),
      child: Center(
        child: Text('Book Name: ${appData.data()['Book Name']} \nBook Code: ${appData.data()['Book Code']}',
          style: TextStyle(
            color: Colors.indigoAccent,
            fontSize: 18.0,
            fontFamily: 'Cubano',
          ),
        ),
      ),
    );
  }
}

class UserImage extends StatelessWidget {

  UserImage({this.name});
  final String name;

  @override
  Widget build(BuildContext context) {

    Path customPath1 = Path();
    customPath1.addOval(Rect.fromCircle(
      center: Offset(52, 52),
      radius: 53.0,
    ));

    Path customPath2 = Path();
    customPath2.addOval(Rect.fromCircle(
      center: Offset(54, 54),
      radius: 61.0,
    ));

    Path customPath3 = Path();
    customPath3.addOval(Rect.fromCircle(
      center: Offset(56, 56),
      radius: 70.0,
    ));


    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(top: 30.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 3.0,color: Colors.white),
      ),
      child: Column(
        children: [
          DottedBorder(
            customPath: (_) => customPath3,
            color: Colors.pink,
            dashPattern: [25, 10],
            strokeWidth: 6,
            strokeCap: StrokeCap.round,
            child: DottedBorder(
              customPath: (_) => customPath2,
              color: Colors.purple,
              dashPattern: [15, 9],
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              child: DottedBorder(
                customPath: (_) => customPath1,
                color: Colors.indigo,
                dashPattern: [10, 9],
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                child: CircleAvatar(
                  child: Image(
                    image: AssetImage('images/writer.png'),
                  ),
                  radius: 48.0,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 40.0,),
          // Text(
          //   name,
          //   style: GoogleFonts.permanentMarker(
          //     textStyle: TextStyle(
          //       color: Colors.white,
          //       fontSize: 18.0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}