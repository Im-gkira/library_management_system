import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management_system/authorization/registration.dart';
import 'package:library_management_system/authorization/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:auto_size_text/auto_size_text.dart';

// This Screen is the Welcome Screen That the User sees for the first time when the app starts.
// The Static String is Used so that the routes are not named incorrectly as they are used in many places.
// This Screen contains the Navigator to Login Screen and Registration Screen. So When The User Presses any button He is taken to The Login Screen.
// Whenever the FlatButton is pressed it takes to the respective page.

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    });
  }

  bool run = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // image: Image(image: AssetImage('images/books-124590.jpg')),
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomLeft,
                colors: [
              Color(0Xff294D64),
              Color(0Xff294D64),
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 300.0,
              child: AnimatedCrossFade(
                secondCurve: Curves.ease,
                duration: Duration(seconds: 4),
                firstChild: AnimatedDrawing.svg(
                  "images/logo copy 4.svg",
                  width: 180.0,
                  lineAnimation: LineAnimation.oneByOne,
                  scaleToViewport: true,
                  run: this.run,
                  duration: new Duration(seconds: 4),
                  onFinish: () => setState(() {
                    this.run = false;
                  }),
                ),
                secondChild: SvgPicture.asset('images/LMS logo.svg',alignment: Alignment.center,width: 320,color: Colors.black38),
                crossFadeState: _crossFadeState,
              ),
            ),
            //
            //   ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0XaaF4A521),
                        Color(0XaaF4A521),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: AutoSizeText('Login',
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.pushNamed(context, Login.id);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0Xaa305FD6),
                        Color(0Xaa305FD6),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: AutoSizeText('Register',
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.pushNamed(context, Registration.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
