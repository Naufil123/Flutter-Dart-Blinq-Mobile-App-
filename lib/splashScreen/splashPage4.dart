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
    double height = screenHeight <= 756 ? screenHeight / 2.5 :  screenHeight / 2;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
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
                      height: height,
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      child:  Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.0),
                        child: Text(
                          "Pay from the comfort of your home",
                          style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 36),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: screenWidth / 1.09,
              height: screenHeight / 14,
            ),
            child: TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/login');

              },

              style: TextButton.styleFrom(
                backgroundColor: GeneralThemeStyle.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              child: Text(
                'Next',
                style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
