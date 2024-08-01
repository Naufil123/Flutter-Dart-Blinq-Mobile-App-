import 'dart:async';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../appData/AuthData.dart';
import '../appData/masking.dart';

class Authotppage extends StatefulWidget {
  const Authotppage({Key? key}) : super(key: key);

  @override
  State<Authotppage> createState() => _AuthotppageState();
}

class _AuthotppageState extends State<Authotppage> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isLoading = false;
  late Timer timer;
  int secondsRemaining = 60;
  bool showResendButton = false;
  late String username = "";
  late String email = "";
  String codeValue = "";
  late Map<String, dynamic> data = {};
  late TextEditingController _fieldOne;
  late TextEditingController _fieldTwo;
  late TextEditingController _fieldThree;
  late TextEditingController _fieldFour;
  late TextEditingController _fieldFive;
  late TextEditingController _fieldSix;

  late FocusNode _focusOne;
  late FocusNode _focusTwo;
  late FocusNode _focusThree;
  late FocusNode _focusFour;
  late FocusNode _focusFive;
  late FocusNode _focusSix;

  @override
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

    _focusOne = FocusNode();
    _focusTwo = FocusNode();
    _focusThree = FocusNode();
    _focusFour = FocusNode();
    _focusFive = FocusNode();
    _focusSix = FocusNode();

    startTimer();
    AuthData.signature_id;
    // getAppSignature();
    listenForSms();
    SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _fieldOne.dispose();
    _fieldTwo.dispose();
    _fieldThree.dispose();
    _fieldFour.dispose();
    _fieldFive.dispose();
    _fieldSix.dispose();

    _focusOne.dispose();
    _focusTwo.dispose();
    _focusThree.dispose();
    _focusFour.dispose();
    _focusFive.dispose();
    _focusSix.dispose();
    super.dispose();
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
        }
      });
    });
  }

  // void getAppSignature() async {
  //   String? signature = await SmsAutoFill().getAppSignature;
  //   print("App Signature: $signature");
  // }

  void listenForSms() {
    SmsAutoFill().listenForCode();
    SmsAutoFill().code.listen((code) {
      if (code != null && code.length == 6) {
        setState(() {
          _fieldOne.text = code[0];
          _fieldTwo.text = code[1];
          _fieldThree.text = code[2];
          _fieldFour.text = code[3];
          _fieldFive.text = code[4];
          _fieldSix.text = code[5];
        });
      }
    });
  }

  Future<void> verify() async {
    setState(() {
      isLoading = true;
    });
    var codeValue =
        '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}${_fieldFive.text}${_fieldSix.text}';
    try {
      await AuthData.regOtpVerification(codeValue, username, context);
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
        _fieldSix.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/register');
        return true;
      },
      child: Scaffold(
          backgroundColor: GeneralThemeStyle.primary,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: Row(
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
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 120.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          'Code has been sent to given mobile number',
                          style: ThemeTextStyle.control1.copyWith(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenWidth / 12),
                        child: AutofillGroup(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OtpInput(_fieldOne, true, screenWidth, screenHeight, _focusOne, _focusTwo),
                              OtpInput(_fieldTwo, false, screenWidth, screenHeight, _focusTwo, _focusThree),
                              OtpInput(_fieldThree, false, screenWidth, screenHeight, _focusThree, _focusFour),
                              OtpInput(_fieldFour, false, screenWidth, screenHeight, _focusFour, _focusFive),
                              OtpInput(_fieldFive, false, screenWidth, screenHeight, _focusFive, _focusSix),
                              OtpInput(_fieldSix, false, screenWidth, screenHeight, _focusSix, null),
                            ],
                          ),
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
                                setState(() {
                                  startTimer();
                                  AuthData.userRegisterSendOTp(AuthData.regMobileNumber, context);
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

              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Continue',
                          style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black87.withOpacity(0.7),
                    child: Center(
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
          )
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final double screenWidth;
  final double screenHeight;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const OtpInput(
      this.controller,
      this.autoFocus,
      this.screenWidth,
      this.screenHeight,
      this.focusNode,
      this.nextFocusNode, {
        Key? key,
      }) : super(key: key);

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
        inputFormatters: [maskPhone],
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        cursorColor: GeneralThemeStyle.button,
        autofillHints: [AutofillHints.oneTimeCode],
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
          counterText: '',
        ),
          onChanged: ((value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).previousFocus();
            }
          }
          )
      ),
    );  }
}