import 'package:blinq_sol/splashScreen/splashPage3.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appData/ThemeStyle.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});
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
    return Scaffold(
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
                    height: screenHeight / 2,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: const Text(
                      "Spend money abroad, and track your expense",
                      style: ThemeTextStyle.generalSubHeading4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: screenWidth / 1.09,
                      height: screenHeight / 7,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.0375),
                      child: TextButton(
                        onPressed: () async {
                          await markVisited();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SplashScreen3()),
                          );
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
