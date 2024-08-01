import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import '../appData/ThemeStyle.dart';
import 'Userprofile.dart';

class ProfileSection extends StatefulWidget {
  ProfileSection({super.key});

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProfileSection oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Profile.showAlertDialog(context, '', '', screenWidth);
          },
          child: Container(
            height: screenHeight * 0.1,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/Rectangle.png'),
              ),
              color: Color(0xffEE6724),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Username',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      AuthData.regMobileNumber.length <= 14
                          ? AuthData.regMobileNumber
                          : AuthData.regMobileNumber.substring(0, 14) + '...',
                      style: ThemeTextStyle.Good.apply(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: screenHeight * 0.07,
                  color: Colors.white,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Full Name",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      AuthData.regFullName.length <= 20
                          ? AuthData.regFullName
                          : AuthData.regFullName.substring(0, 14) + '...', // Truncate text if it exceeds 20 characters
                      style: ThemeTextStyle.Good.apply(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.15,
          right: screenWidth * 0.02,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth / 2 - screenWidth * 0.03,
                height: screenHeight * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.0375),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: screenWidth * 0.0025,
                      blurRadius: screenWidth * 0.005,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
