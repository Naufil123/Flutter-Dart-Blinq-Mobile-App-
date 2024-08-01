// TODO Implement this library.import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:blinq_sol/appData/masking.dart';
import 'package:blinq_sol/appData/AuthData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../appData/AppData.dart';
import 'otp.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}
class _forgotPasswordState extends State<forgotPassword> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // final FocusNode focusNode = FocusNode();
  final maskedEmail = [FilteringTextInputFormatter.deny(RegExp('[^a-zA-Z0-9@.]'))];
  bool isLoading = false;

  Future<void> validateAndShowSnackBar(String email, String mobile, context) async {
    if (email.isEmpty && mobile.isEmpty) {
      Snacksbar.showErrorSnackBar(context, 'Fill at least one field!');
    } else
    if (email.isNotEmpty && (!email.contains('@') || !email.contains('.'))) {
      Snacksbar.showErrorSnackBar(context, 'Please enter a valid email!');
    } else if (mobile.isNotEmpty && mobile.length < 11) {
      Snacksbar.showErrorSnackBar(
          context, 'Mobile number should have at least 11 characters!');
    } else if (mobileController.text[0] != '0') {
      Snacksbar.showErrorSnackBar(context, 'Invalid mobile number. Please enter a valid mobile number starting with 03');
    } else if (mobileController.text[1] != '3') {
      Snacksbar.showErrorSnackBar(context, 'Invalid mobile number. Please enter a valid mobile number starting with 03');
    } else {
      setState(() {
        isLoading = true;
      });
      Timer timer = Timer(Duration(seconds: AuthData.timer), () {
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
          Snacksbar.showErrorSnackBar(
              context, 'No connection. Please try again.');
        }
      });
      try {

        if (AuthData.counter<=2){
        await AuthData.forgotPassVerify(
            mobileController.text, emailController.text, context);}
        else {
           Check();
        }
      } catch (e) {
        Snacksbar.showErrorSnackBar(
            context, 'An error occurred. Please try again.');
      } finally {
        if (timer.isActive) {
          timer.cancel();
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  Future<void> Check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startTimeString = prefs.getString('startTime');


    if (startTimeString != null) {

      DateTime startTime = DateTime.parse(startTimeString);
      DateTime currentTime = DateTime.now();

      Duration difference = currentTime.difference(startTime);

      if (difference.inSeconds < 60) {
        Snacksbar.showSuccessSnackBar(context, "Unable to sent Otp Kindly Contact Support");
        print('You should not pass an hour');
      } else {
        print('You pass an hour');
        setState(() {
          AuthData.counter = 0;
          AuthData.saveOtpCount(AuthData.counter);
        });
      }
    } else {
      print('Start time not found');
    }
  }

  @override
  void initState() {
    super.initState();
     Check();
    // mobileController.clear();
    // focusNode.addListener(() {
    //   if (focusNode.hasFocus && mobileController.text.isEmpty) {
    //     mobileController.text = '03';
    //     mobileController.selection = TextSelection.fromPosition(
    //       const TextPosition(offset: 2),
    //     );
    //   }
    // });

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(

        onWillPop: () async {
          mobileController.clear();
      Navigator.pushReplacementNamed(context, '/login');
      return true;
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, screenHeight * 0.1, screenWidth / 20, 10),
                    child: Text(
                      'Forgot Or Reset Pin',
                      style: ThemeTextStyle.detailPara.apply(fontSizeDelta: 10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, screenWidth * 0.2, 10),
                    child: Text(
                      'Please Reset your pin',
                      style: ThemeTextStyle.generalSubHeading.apply(
                        fontSizeDelta: -19,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Enter your Mobile Number',
                        //   style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                        // ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 05, 0, screenHeight * 0.015),
                          child: SizedBox(
                            width: screenWidth,
                            height: screenHeight * 0.065,
                            child: TextFormField(
                              controller: mobileController,
                              autofillHints: null,

                              // focusNode: focusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskPhone],
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                labelText: 'Mobile Number',
                                // hintText: '03',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Type your Email',
                        //   style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                        // ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: SizedBox(
                            width: screenWidth,
                            height: screenHeight * 0.065,
                            child: TextFormField(
                              controller: emailController,
                              inputFormatters: maskedEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                                labelText: 'Email Address (Optional)',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.04),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          width: screenWidth,
                          height: screenHeight * 0.065,
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            FocusScope.of(context).unfocus();
                            validateAndShowSnackBar(emailController.text, mobileController.text, context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: GeneralThemeStyle.button,
                          ),
                          child: isLoading
                              ? const SpinKitWave(
                            color: Colors.white,
                            size: 25.0,
                          )
                              : Text(
                            'Verify',
                            style: ThemeTextStyle.detailPara.apply(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: Colors.black87,
                child: SpinKitWave(
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.deepOrangeAccent : Colors.orange,
                      ),
                    );
                  },
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
  // @override
  // void dispose() {
  //   mobileController.dispose();
  //   focusNode.dispose();
  //   super.dispose();
  // }
}
