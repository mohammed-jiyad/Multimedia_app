import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:multimedia_application/main.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedTextKit(
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 1000),
              animatedTexts: [
                TypewriterAnimatedText(
                  'Netflix', // The text to display
                  textStyle: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,fontFamily: GoogleFonts.bebasNeue().fontFamily,
                  ),
                  speed: Duration(milliseconds: 200),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}