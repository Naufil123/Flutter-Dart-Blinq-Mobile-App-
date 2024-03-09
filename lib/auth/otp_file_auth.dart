import 'dart:async';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../appData/AuthData.dart';


class Authotppage  extends StatefulWidget {
  const Authotppage ({Key? key}) : super(key: key);

  @override
  State<Authotppage > createState() => _AuthotppageState();
}
class _AuthotppageState extends State<Authotppage > {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isLoading = false;
  late Timer timer;
  int secondsRemaining = 60;
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeSettings = ModalRoute.of(context)?.settings;
    if (routeSettings != null) {
      final routeArguments = routeSettings.arguments;
      if (routeArguments is Map<String, dynamic>) {
        data = routeArguments;
        username = data['username'] ?? '';
        email = data['email'] ?? '';
      }
    }
  }
  @override
  void initState() {
    super.initState();
    username = data['username'] ?? '';
    _fieldOne = TextEditingController();
    _fieldTwo = TextEditingController();
    _fieldThree = TextEditingController();
    _fieldFour = TextEditingController();
    _fieldFive = TextEditingController();
    _fieldSix = TextEditingController();
    startTimer();
  }
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          secondsRemaining = 60;
          showResendButton = true;
          print("Resend button should be visible now");
        }
      });
    });
  }
  Future<void> verify() async{
    setState(() {
      isLoading = true;
    });
    var screenOtp = '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}${_fieldFive.text}${_fieldSix.text}';
    try{
    await AuthData.regOtpVerification(screenOtp, username, context);

  } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  bool isButtonEnabled() {
    return _fieldOne.text.isNotEmpty &&
        _fieldTwo.text.isNotEmpty &&
        _fieldThree.text.isNotEmpty &&
        _fieldFour.text.isNotEmpty &&
        _fieldFive.text.isNotEmpty &&
        _fieldSix.text.isNotEmpty;}

  bool showResendButton = false;
  late String username = "";
  late String email = "";
  late Map<String, dynamic> data = {};
  late TextEditingController _fieldOne;
  late TextEditingController _fieldTwo;
  late TextEditingController _fieldThree;
  late TextEditingController _fieldFour;
  late TextEditingController _fieldFive;
  late TextEditingController _fieldSix;



  @override
  Widget build(BuildContext context) {
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
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: const Alignment(-1.0, 1),
                      child: Text(
                        "Register",
                        style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -3),
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Image.asset(
                    'assets/images/forgotpassword.png',
                    width: screenWidth,
                    height: 250.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    'Code has been sent to giving email or mobile number',
                    style: ThemeTextStyle.control1.copyWith(fontSize: 15, color: Colors.black54),
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
                            style: ThemeTextStyle.control1.apply(fontSizeDelta: -6, color: Colors.black54),
                          ),
                          Text(
                            '$secondsRemaining',
                            style: ThemeTextStyle.control1.apply(fontSizeDelta: -6, color: Colors.orangeAccent),
                          ),
                          Text(
                            ' s',
                            style: ThemeTextStyle.control1.apply(fontSizeDelta: -6, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: showResendButton,
                      child: TextButton(
                        onPressed: () async {
                          setState(() async {
                            startTimer();
                             await AuthData.userRegisterSendOTp(username,context);
                            showResendButton = false;
                          });
                        },
                        child: const Text(
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
          SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextButton(
                onPressed: isButtonEnabled() ? () => verify() : null,
                style: TextButton.styleFrom(
                  backgroundColor: isButtonEnabled() ? GeneralThemeStyle.button : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Continue',
                        style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                      ),
                    ),
                    if (isLoading==true)
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Positioned(
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              border: Border.all(color: Colors.black87),
                            ),
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
                      ),
                  ],
                ),
              ),
            ),
          ),
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
  const OtpInput(this.controller, this.autoFocus, this.screenWidth, this.screenHeight, {Key? key}) : super(key: key);
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: GeneralThemeStyle.button, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
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
