import 'AuthData.dart';
import 'ThemeStyle.dart';
import '../home/dashBoard.dart';
import 'package:flutter/material.dart';
class Dialogsucess {
  static void showAlertDialog(BuildContext context, String title, String content, double screenWidth) {
    final GlobalKey<_SlideUpDialogState> key = GlobalKey();

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SlideUpDialog(
          key: key,
          title: title,
          content: content,
          screenWidth: screenWidth,
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: GeneralThemeStyle.dull.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ).then((value) {
      if (key.currentState != null) {
        key.currentState!.dismiss();
      }
    });
  }
}

class SlideUpDialog extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const SlideUpDialog({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _SlideUpDialogState createState() => _SlideUpDialogState();
}

class _SlideUpDialogState extends State<SlideUpDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void dismiss() {
    _animationController.reverse().then((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard()));
    });
  }
  void navigateToDashboard() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard()));

  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToDashboard,
      child: Container(
        color: Colors.transparent, // Make the background transparent
        child: DefaultTextStyle(
          style: ThemeTextStyle.generalSubHeading,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: widget.screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 100),
                  Image.asset('assets/images/successful.png'),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: ThemeTextStyle.generalSubHeading,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.content,
                    style: ThemeTextStyle.generalSubHeading5.copyWith(color: Colors.grey, fontSize: 16, height: 1),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}




class CongratsDialog {
  static void showCustomDialog(BuildContext context, String title, String content, double screenWidth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/congrat.png',
                  width: screenWidth,  // Adjust the width as needed
                  height: 250.0,  // Adjust the height as needed
                ),
                Text(
                  title,
                  style: ThemeTextStyle.control.apply(color: Colors.deepOrangeAccent, fontSizeDelta: 10),
                ),
                const SizedBox(height: 16.0),
                Text(
                  content,
                  style: ThemeTextStyle.control.apply(color:Colors.black,fontSizeDelta: -7),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(screenWidth * 0.8, 50.0), backgroundColor: GeneralThemeStyle.button // Set the background color to orange
                    // Other button styling properties can be added here
                  ),
                  child: Text(
                    'Go to Home Page',
                    style: ThemeTextStyle.control.apply(color: Colors.white,fontSizeDelta: -5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class FailureDialog {
  static void showCustomDialog(BuildContext context, String title, String content, double screenWidth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Failure.png',
                  width: screenWidth,  // Adjust the width as needed
                  height: 250.0,  // Adjust the height as needed
                ),
                Text(
                  title,
                  style: ThemeTextStyle.control.apply(color: Colors.red, fontSizeDelta: 10),
                ),
                const SizedBox(height: 16.0),
                Text(
                  content,
                  style: ThemeTextStyle.control.apply(color:Colors.black,fontSizeDelta: -7),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.8, 50.0), backgroundColor: GeneralThemeStyle.secondary // Set the background color to orange
                    // Other button styling properties can be added here
                  ),
                  child: Text(
                    'Go to Home Page',
                    style: ThemeTextStyle.control.apply(color: Colors.white,fontSizeDelta: -5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class paymentSucess {
  static void showCustomDialog(BuildContext context, String title, String content, double screenWidth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/sucess.png',
                  width: screenWidth,  // Adjust the width as needed
                  height: 250.0,  // Adjust the height as needed
                ),
                Text(
                  title,
                  style: ThemeTextStyle.control.apply(color: Colors.deepOrangeAccent, fontSizeDelta: 10),
                ),
                const SizedBox(height: 16.0),
                Text(
                  content,
                  style: ThemeTextStyle.control.apply(color:Colors.black,fontSizeDelta: -7),

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "Bill Paid Successfully",
                    textAlign: TextAlign.center,
                    style: ThemeTextStyle.generalSubHeading5.copyWith(color: Colors.black,fontSize: 25),
                  ),
                ),
                Text(
                 " We're delighted to inform you that your fashion-forward choice has been successfully purchased. Get ready to unleash"
                     " your style and make a statement with this exceptional addition to your wardrobe.",
                  textAlign: TextAlign.center,
                  style: ThemeTextStyle.generalSubHeading5.copyWith(color: Colors.grey,fontSize: 16.5),
                ),
                const SizedBox(height: 16.0),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50.0), backgroundColor: GeneralThemeStyle.button // Set the background color to orange
                      // Other button styling properties can be added here
                    ),
                    child: Text(
                      'Back',
                      style: ThemeTextStyle.control.apply(color: Colors.white,fontSizeDelta: -5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



class Profile {
  static void showAlertDialog(BuildContext context, String title, String content, double screenWidth) {
    final GlobalKey<_Profile2State> key = GlobalKey();

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Profile2(
          key: key,
          title: title,
          content: content,
          screenWidth: screenWidth,
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ).then((value) {
      if (key.currentState != null) {
        key.currentState!.dismiss();
      }
    });
  }
}

class Profile2 extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const Profile2({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _Profile2State createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void dismiss() {
    _animationController.reverse().then((_) {

      Navigator.of(context).pop(); // Close the dialog
    });
  }
  // void navigateToDashboard() {
  //
  //         Navigator.pushReplacementNamed(context, '/dashboard');
  //
  // }

  @override

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
          onTap: () {
        dismiss();
         // navigateToDashboard();
      },
      child: Container(
          color: Colors.transparent,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium!,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: widget.screenWidth,
                height: screenHeight*0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/Ellipse3.png',
                                    width: screenWidth / 6,
                                    height: screenHeight * 0.1,
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.04,
                                    left: 0,
                                    right: 0,
                                    child: const Center(
                                      child: Text(
                                        'NN',
                                        style: ThemeTextStyle.roboto,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.004),
                                    child: Text(
                                      'Naufil Siddiqui',
                                      style: ThemeTextStyle.sF1.copyWith(fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    '03361223839',
                                    style: ThemeTextStyle.sF1.copyWith(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account',
                                  style: ThemeTextStyle.good1.copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '033612239839',
                                    style: ThemeTextStyle.sF1.copyWith(fontSize: 13),
                                  ),
                                ),
                                Text(
                                  'Tap to change phone Number',
                                  style: ThemeTextStyle.sF1.copyWith(fontSize: 14,color: Colors.grey),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 6.0), // Add margin to separate from the text above
                                  height: 2.0,
                                  width: screenWidth,
                                  color: Colors.grey, // You can change the color to your desired highlight color
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    '@Naufil',
                                    style: ThemeTextStyle.good1.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),

                                ),
                                 Text(
                                  'Username',
                                  style: ThemeTextStyle.good1.copyWith(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey,height:0.2),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 40.0), // Add margin to separate from the text above
                                  height: 1.8,
                                  width: screenWidth,
                                  color: Colors.grey, // You can change the color to your desired highlight color
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                                  child: Text(
                                    'Hi I am a junior software Engineer in Blinq Solution',
                                    style: ThemeTextStyle.good1.copyWith(fontSize: 13.5, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  'Bio',
                                  style: ThemeTextStyle.good1.copyWith(fontSize: 19, fontWeight: FontWeight.w600,color: Colors.grey,height: 0.23),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Settings',
                                            style: ThemeTextStyle.good1.copyWith(fontSize: 24, fontWeight: FontWeight.w900),
                                          ),
                                          const SizedBox(height: 10), // Adjust the height as needed
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // Add your onPressed logic here
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets.fromLTRB(0,0,20,0),
                                                              child: Icon(
                                                                Icons.notification_add_outlined, // Replace with your desired icon
                                                                size: 30, // Adjust the size as needed
                                                                color: Colors.orange, // Adjust the color as needed
                                                              ),
                                                            ),
                                                            const SizedBox(width: 0), // Adjust the spacing between the icon and text
                                                            // Padding(
                                                            //   padding: const EdgeInsets.symmetric(horizontal: 8),
                                                            Text(
                                                              'Notification and Sounds',
                                                              style: ThemeTextStyle.good1.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                                                            ),
                                                            // ),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ],

                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // Add your onPressed logic here
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets.fromLTRB(0,0,20,0),
                                                              child: Icon(
                                                                Icons.lock, // Replace with your desired icon
                                                                size: 30, // Adjust the size as needed
                                                                color: Colors.orange, // Adjust the color as needed
                                                              ),
                                                            ),
                                                            const SizedBox(width: 0), // Adjust the spacing between the icon and text
                                                            // Padding(
                                                            //   padding: const EdgeInsets.symmetric(horizontal: 8),
                                                            Text(
                                                              'Privacy and Security',
                                                              style: ThemeTextStyle.good1.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                                                            ),
                                                            // ),
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                ],

                                              ),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                              Padding(
                                              padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                              child: TextButton(
                                                onPressed: () {
                                                  // Add your onPressed logic here
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.fromLTRB(0,0,20,0),
                                                      child: Icon(
                                                        Icons.auto_graph_rounded, // Replace with your desired icon
                                                        size: 30, // Adjust the size as needed
                                                        color: Colors.orange, // Adjust the color as needed
                                                      ),
                                                    ),
                                                    const SizedBox(width: 0), // Adjust the spacing between the icon and text
                                                    // Padding(
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    Text(
                                                      'Data and Storage',
                                                      style: ThemeTextStyle.good1.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    // ),
                                                  ],
                                                ),
                                                )
                                              ),
                                                ],

                                              ), Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                    child: TextButton(
                                                      onPressed: () {
                                                        // Add your onPressed logic here
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.fromLTRB(0,0,20,0),
                                                            child: Icon(
                                                              Icons.chat, // Replace with your desired icon
                                                              size: 30, // Adjust the size as needed
                                                              color: Colors.orange, // Adjust the color as needed
                                                            ),
                                                          ),
                                                          const SizedBox(width: 0), // Adjust the spacing between the icon and text
                                                          // Padding(
                                                          //   padding: const EdgeInsets.symmetric(horizontal: 8),
                                                          Text(
                                                            'Chat Setting',
                                                            style: ThemeTextStyle.good1.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                                                          ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      // Add your onPressed logic here
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0,0,20,0),
                                                          child: Icon(
                                                            Icons.devices, // Replace with your desired icon
                                                            size: 30, // Adjust the size as needed
                                                            color: Colors.orange, // Adjust the color as needed
                                                          ),
                                                        ),
                                                        const SizedBox(width: 0), // Adjust the spacing between the icon and text
                                                        // Padding(
                                                        //   padding: const EdgeInsets.symmetric(horizontal: 8),
                                                           Text(
                                                            'Devices',
                                                            style: ThemeTextStyle.good1.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                                                          ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                        ),
                                            ],
                                          ),


                                      ],
                                    ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //     TextButton(
                                      //       onPressed: () {
                                      //         // Add your onPressed logic here
                                      //       },
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.start,
                                      //         children: [
                                      //           Icon(
                                      //             Icons.devices, // Replace with your desired icon
                                      //             size: 30, // Adjust the size as needed
                                      //             color: Colors.orange, // Adjust the color as needed
                                      //           ),
                                      //           SizedBox(width: 10), // Adjust the spacing between the icon and text
                                      //           Padding(
                                      //             padding: const EdgeInsets.symmetric(horizontal: 8),
                                      //             child: Text(
                                      //               'Devices',
                                      //               style: ThemeTextStyle.good1.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),



                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
      ),
          ),
      ),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


// Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     TextButton(
//       onPressed: () {
//         // Add your onPressed logic here
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.devices, // Replace with your desired icon
//             size: 30, // Adjust the size as needed
//             color: Colors.orange, // Adjust the color as needed
//           ),
//           SizedBox(width: 10), // Adjust the spacing between the icon and text
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               'Devices',
//               style: ThemeTextStyle.good1.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ],
// ),



class Notification3 {
  static void showAlertDialog(BuildContext context, String title, String content, double screenWidth) {
    final GlobalKey<_Notification1State> key = GlobalKey();

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Notification1(
          key: key,
          title: title,
          content: content,
          screenWidth: screenWidth,
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ).then((value) {
      if (key.currentState != null) {
        key.currentState!.dismiss();
      }
    });
  }
}

class Notification1 extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const Notification1({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _Notification1State createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void dismiss() {
    _animationController.reverse().then((_) {

      Navigator.of(context).pop(); // Close the dialog
    });
  }
  // void navigateToDashboard() {
  //
  //         Navigator.pushReplacementNamed(context, '/dashboard');
  //
  // }

  @override

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          dismiss();
          // navigateToDashboard();
        },
        child: Container(
          color: Colors.transparent,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium!,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
    child:SingleChildScrollView(
              child: Column(
              children: [
              const Padding(
                  padding: EdgeInsets.all(20.0),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                const SizedBox(height: 10), // Add some space between the button and the previous content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 88.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Notification',
                      style: ThemeTextStyle.generalSubHeading.copyWith(fontSize: 25)
                    ),
                  ),
                ),
              ],
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                    onPressed: () {
                // Handle 'All' button press
              },
                style: TextButton.styleFrom(
                  textStyle: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 18,color: Colors.black)
                ),
                   child: const Text('All'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle 'Unread' button press
                      },
                      style: TextButton.styleFrom(
                          textStyle: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 18,color: Colors.black)
                      ),
                      child: const Text('Unread'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle 'Read' button press
                      },
                      style: TextButton.styleFrom(
                          textStyle: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 18,color: Colors.black)
                      ),
                      child: const Text('Read'),
                    ),
            ],
          ),
              ],
        ),
      ),
      ),
          ),
      ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class FAQ {
  static void showAlertDialog(BuildContext context, String title, String content, double screenWidth) {
    final GlobalKey<_Notification1State> key = GlobalKey();

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return FAQ1(
          key: key,
          title: title,
          content: content,
          screenWidth: screenWidth,
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ).then((value) {
      if (key.currentState != null) {
        key.currentState!.dismiss();
      }
    });
  }
}
class FAQ1 extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const FAQ1({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _FAQ1State createState() => _FAQ1State();
}
class _FAQ1State extends State<FAQ1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _FetchFAQData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void dismiss() {
    _animationController.reverse().then((_) {

      Navigator.of(context).pop();
    });
  }

  List<Map<String, dynamic>> faqData = [];
  Future<void> _FetchFAQData() async {
    try {
      final List<Map<String, dynamic>> data = (await AuthData.fetchFAQData()) as List<Map<String, dynamic>>;
      setState(() {
        faqData = data;
      });
    } catch (error) {
      print('Error fetching FAQ data: $error');
    }
  }
  int selectedDividerIndex = -1;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: GeneralThemeStyle.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GeneralThemeStyle.primary,
        automaticallyImplyLeading: false,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 90,
        actions: [
          SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 108.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'FAQ',
                          style: ThemeTextStyle.generalHeading.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium!,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var index = 0; index < faqData.length; index++)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDividerIndex = index;
                              });
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: selectedDividerIndex == index
                                      ? GeneralThemeStyle.nuull
                                      : Colors.white,
                                ),
                                height: 350,
                                width: screenWidth / 1.1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (index + 1).toString(),
                                        style: ThemeTextStyle.generalSubHeading.copyWith(
                                          color: Colors.grey,
                                          fontSize: 38,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              faqData[index]['question'].toString(),
                                              style: ThemeTextStyle.generalSubHeading.copyWith(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        faqData[index]['answer'].toString(),
                                        style: ThemeTextStyle.generalSubHeading.copyWith(
                                          color: Colors.grey,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

