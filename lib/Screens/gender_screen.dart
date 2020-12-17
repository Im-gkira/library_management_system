import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/authorization/registration.dart';

class GenderScreen extends StatefulWidget {
  static String id = 'Gender_screen';
  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  Color maleColour = Colors.blue;
  Color femaleColour = Color(0XFF77d8d8);
  Color maleBorder = Color(0XFF0779e4);
  Color femaleBorder = Colors.white;
  String gender;

  void setGender() {
    if (gender == 'male') {
      setState(() {
        gender = 'female';
        femaleColour = Colors.blue;
        maleColour = Color(0XFF77d8d8);
        maleBorder = Colors.white;
        femaleBorder = Color(0XFF0779e4);
        print('$gender');
      });
    } else {
      setState(() {
        gender = 'male';
        maleColour = Colors.blue;
        femaleColour = Color(0XFF77d8d8);
        maleBorder = Color(0XFF0779e4);
        femaleBorder = Colors.white;
        print('$gender');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Text(
            'Hey Buddy!',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              decoration: TextDecoration.none,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Choose Your Gender.',
            style: GoogleFonts.montserrat(
              fontSize: 30,
              decoration: TextDecoration.none,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
          Container(
            child: GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.height * 0.22,
                decoration: BoxDecoration(
                  color: maleColour,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('images/Boy.jpg'),
                      fit: BoxFit.fill),
                  border: Border.all(color: maleBorder, width: 4),
                ),
              ),
              onTap: setGender,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.height * 0.22,
                decoration: BoxDecoration(
                  color: femaleColour,
                    shape: BoxShape.circle,
                    // color: femaleColour,
                    image: DecorationImage(
                        image: AssetImage('images/Girl.jpg'),
                        fit: BoxFit.fill),
                    border: Border.all(color: femaleBorder, width: 4),
                ),
              ),
              onTap: setGender,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.16,),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.purple,
                      Colors.purpleAccent,
                    ]),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: FlatButton(
                child: Text(
                  'Continue',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context){
                          return Registration(gender: gender,
                          );
                        }
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
