import '../appData/ThemeStyle.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: GeneralThemeStyle.button,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Countdown(
              seconds: 2,
              build: (BuildContext context, double time) => Text(""),
              interval: Duration(milliseconds: 100),
              onFinished: () {
                Navigator.pushReplacementNamed(context, '/splashPage2');
              },
            ),
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 0.0,
                    child: Image.asset('assets/images/screen1Ellipse.png'),
                  ),
                  Positioned(
                    top: screenHeight * 0.340,
                    right: screenWidth * 0.22,
                    child: Image.asset(
                      'assets/images/Blinq.png',
                      width: screenWidth / 3,
                      height: screenHeight * 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
