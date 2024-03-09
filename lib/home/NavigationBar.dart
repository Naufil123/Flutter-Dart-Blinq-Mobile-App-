import 'package:flutter/material.dart';

import '../appData/dailogbox.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.025,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              icon: Image.asset(
                "assets/images/Home.png",
                width: screenWidth / 15,
                height: screenHeight / 32,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/location');
              },
              icon: Image.asset(
                "assets/images/Location.png",
                width: screenWidth / 15,
                height: screenHeight / 32,
              ),
            ),
            IconButton(
              onPressed: () {
                Profile.showAlertDialog(context, '', '', screenWidth);              },
              icon: Image.asset(
                "assets/images/Profile.png",
                width: screenWidth / 15,
                height: screenHeight / 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
