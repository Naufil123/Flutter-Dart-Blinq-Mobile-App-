import 'package:blinq_sol/splashScreen/splashPage3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appData/ThemeStyle.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    checkFirstVisit();
  }

  Future<void> checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool visitedSplash = prefs.getBool('visitedSplash') ?? false;

    if (visitedSplash) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> markVisited() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('visitedSplash', true);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print('Screen Height: $screenHeight');
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
                      'assets/images/splashPage2.png',
                      width: screenWidth,
                      height: height,

                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.0),
                        child: Text(
                          "Smarter Payments for Smarter People",
                          style: ThemeTextStyle.generalSubHeading4,
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
                await markVisited();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen3()),
                );
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
