// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:blinq_sol/appData/masking.dart';
import 'package:blinq_sol/appData/AuthData.dart';
import '../../appData/AppData.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);
  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}
class _forgotPasswordState extends State<forgotPassword> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final maskedEmail = [FilteringTextInputFormatter.deny(RegExp('[^a-zA-Z0-9@.]'))];
  bool isLoading = false;

  Future<void> validateAndShowSnackBar(String email, String mobile, context) async {
    if (email.isEmpty && mobile.isEmpty) {
      Snacksbar.showErrorSnackBar(context, 'Fill at least one field!');
    } else if (email.isNotEmpty && (!email.contains('@') || !email.contains('.'))) {
      Snacksbar.showErrorSnackBar(context, 'Please enter a valid email!');
    } else if (mobile.isNotEmpty && mobile.length < 11) {
      Snacksbar.showErrorSnackBar(context, 'Mobile number should have at least 11 characters!');
    } else {
      try {
        setState(() {
          isLoading = true;
        });
         await AuthData.forgotPassVerify(mobileController.text, emailController.text, context);
        Navigator.pushReplacementNamed(
          context,
          '/otpPage',
          arguments: {
            'mobile': mobileController.text,
            'emailAddress':emailController.text
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                      'Please sign in to your account',
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
                        Text(
                          'Enter your Mobile Number',
                          style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 05, 0, screenHeight * 0.015),
                          child: SizedBox(
                            width: screenWidth,
                            height: screenHeight * 0.065,
                            child: TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskPhone],
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
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
                        Text(
                          'Type your Email',
                          style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                        ),
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
                                labelText: 'Email Address',
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
    );
  }
}