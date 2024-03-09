import '../appData/ThemeStyle.dart';
import 'package:flutter/material.dart';

class SplashScreen4 extends StatefulWidget {
  const SplashScreen4({super.key});

  @override
  _SplashScreen4State createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white, // Set the background color of the screen
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.04),
                child: Image.asset(
                  'assets/images/blinq-logoo.png',
                  width: screenWidth,
                  height: screenHeight * 0.35,
                ),
              ),
              centerTitle: true,
              floating: false,
              pinned: true,
            ),
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/splashPage4.png',
                    width: screenWidth,
                    height: screenHeight /2,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: const Text(
                      "Receive Money From Anywhere In The World",
                      style: ThemeTextStyle.generalSubHeading4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: screenWidth / 1.09,
                      height: screenHeight /7,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.0375),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: GeneralThemeStyle.button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.1),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                        ),
                      ),
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
