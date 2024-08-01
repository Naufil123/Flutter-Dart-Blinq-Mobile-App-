import 'dart:async';
import '../../appData/dailogbox.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter/material.dart';


class PaymentOtpPage extends StatefulWidget {
  const PaymentOtpPage({Key? key}) : super(key: key);

  @override
  State<PaymentOtpPage> createState() => _PaymentOtpPageState();
}

class _PaymentOtpPageState extends State<PaymentOtpPage> {
  double screenWidth = 0;
  double screenHeight = 0;
  late Timer timer;
  int secondsRemaining = 10;
  bool showResendButton = false;

  // late String mobileNumber;
  // late String emailAddress;


  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();




  @override


  bool isButtonEnabled() {
    // Check if any of the text fields are empty
    return _fieldOne.text.isNotEmpty &&
        _fieldTwo.text.isNotEmpty &&
        _fieldThree.text.isNotEmpty &&
        _fieldFour.text.isNotEmpty &&
        _fieldFive.text.isNotEmpty &&
        _fieldSix.text.isNotEmpty;
  }
  @override
  Widget build(BuildContext context) {
    // Extract arguments
    final Map<String, dynamic>? data =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Access email and mobile number
    // final String mobileNumber = data?['mobileNumber'] ?? '';
    // final String emailAddress = data?['emailAddress'] ?? '';

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: GeneralThemeStyle.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GeneralThemeStyle.primary,
        automaticallyImplyLeading: false,
        bottomOpacity: 300.0,
        elevation: 0.0,
        toolbarHeight: 60,
        actions: [
          SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: const Alignment(-1.0, 1.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          // Navigator.pushReplacementNamed(
                          //     context, '/forgotPassword');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: const Alignment(-1.0, 1),
                      child: Text(
                        "Forgot Password",
                        style: ThemeTextStyle.generalSubHeading
                            .apply(fontSizeDelta: -3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Image.asset(
                    'assets/images/forgotpassword.png',
                    width: screenWidth,
                    height: 250.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                     'Code has been sent to',
                  // 'Code has been sent to ${emailAddress.isNotEmpty ?
                    // "${emailAddress.substring(0, 5)}******${emailAddress.substring(emailAddress.indexOf('@'))}"
                    //     : mobileNumber.replaceRange(3, 9, "******")}',
                    style: ThemeTextStyle.control1
                        .copyWith(fontSize: 16, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth / 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OtpInput(_fieldOne, false, screenWidth, screenHeight),
                      OtpInput(_fieldTwo, false, screenWidth, screenHeight),
                      OtpInput(_fieldThree, false, screenWidth, screenHeight),
                      OtpInput(_fieldFour, false, screenWidth, screenHeight),
                      OtpInput(_fieldFive, false, screenWidth, screenHeight),
                      OtpInput(_fieldSix, false, screenWidth, screenHeight),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !showResendButton,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Resend code in ',
                            style: ThemeTextStyle.control1
                                .apply(fontSizeDelta: -6, color: Colors.black54),
                          ),
                          Text(
                            '$secondsRemaining',
                            style: ThemeTextStyle.control1
                                .apply(fontSizeDelta: -6, color: Colors.orangeAccent),
                          ),
                          Text(
                            ' s',
                            style: ThemeTextStyle.control1
                                .apply(fontSizeDelta: -6, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: showResendButton,
                      child: TextButton(

                        onPressed: () async {
                          // Create an instance of the Verification class

                          // Call the generateAndStoreOTP method

                          // Restart the timer and set showResendButton to false
                          setState(() {
                            // startTimer();
                            showResendButton = false;
                          });
                        },
                        child: Text(
                          'Resend Code',
                          style: TextStyle(
                            color: GeneralThemeStyle.button,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Container(
            width: screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextButton(
                onPressed: isButtonEnabled() ? () async {
                  // paymentSucess.showCustomDialog(
                  //   context,
                  //   '',
                  //   '',// Replace with the actual content
                  //   screenWidth,
                  // );
                } : null,
                style: TextButton.styleFrom(
                  backgroundColor: isButtonEnabled()
                      ? GeneralThemeStyle.button
                      : Colors.grey, // Use grey color if button is disabled
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Continue',
                    style: ThemeTextStyle.detailPara
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          )



        ],
      ),

    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final double screenWidth;
  final double screenHeight;

  const OtpInput(this.controller, this.autoFocus, this.screenWidth,
      this.screenHeight,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight / 18,
      width: screenWidth / 8,
      child: TextField(
        style: const TextStyle(fontSize: 20),
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: GeneralThemeStyle.button,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: GeneralThemeStyle.button, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          counterText: '', // Add this line to remove the counter text
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
