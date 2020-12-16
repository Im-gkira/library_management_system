import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management_system/authorization/registration.dart';
import 'package:library_management_system/authorization/login.dart';
import 'package:drawing_animation/drawing_animation.dart';

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
  bool run = true;

  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              border: Border.all(color: Colors.white,width: 5.0,),
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              children: [
                //SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: AnimatedCrossFade(
                    secondCurve: Curves.ease,
                    alignment: Alignment.center,
                    duration: Duration(seconds: 6),
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
                    secondChild: SvgPicture.asset('images/LMS logo.svg',width: 240,color: Color(0XFF6B63FF)),
                    crossFadeState: _crossFadeState,
                  ),
                ),
                //
                //   ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.pink.shade800,width: 4.0),
                  ),
                  child: FlatButton(
                    child: Text('Login',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Cubano',
                          color: Colors.pink.shade800,
                        ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Login.id);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.purple.shade800,width: 4.0),
                  ),
                  child: FlatButton(
                    child: Text('Register',
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Cubano',
                          fontSize: 18.0,
                          color: Colors.purple.shade800,)
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Registration.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
