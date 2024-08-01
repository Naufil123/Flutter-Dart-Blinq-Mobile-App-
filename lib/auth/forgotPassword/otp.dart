import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../appData/AuthData.dart';
import '../../appData/ThemeStyle.dart';
import '../../appData/masking.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with CodeAutoFill {
  double screenWidth = 0;
  double screenHeight = 0;
  bool isLoading = false;
  Timer? timer;
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

  void startHourTimer() async {
    DateTime startTime = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('startTime', startTime.toIso8601String());

    timer = Timer(const Duration(hours: 1), () {
      setState(() {
        AuthData.counter = 0;
        AuthData.saveOtpCount(AuthData.counter);
        showResendButton = true;
      });
      checkTimeDifference();
    });
  }

    Future<void> checkTimeDifference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startTimeString = prefs.getString('startTime');
    startTimeString== AuthData.time as String;

    if (startTimeString != null) {
      DateTime startTime = DateTime.parse(startTimeString);
      DateTime currentTime = DateTime.now();

      Duration difference = currentTime.difference(startTime);

      if (difference.inHours < 1) {
        print('You should not pass an hour');
      } else {
        print('You pass an hour');
        setState(() {
          AuthData.counter = 0;
          AuthData.saveOtpCount(AuthData.counter);
          showResendButton = true;
        });
      }
    } else {
      print('Start time not found');
    }
  }

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
    startTimer();
    AuthData.signature_id;
    listenForSms();
    SmsAutoFill().listenForCode;
    loadOtpCount();
    checkTimeDifference();
  }

  @override
  void codeUpdated() {
    if (codeValue.length == 6) {
      _fieldOne.text = codeValue[0];
      _fieldTwo.text = codeValue[1];
      _fieldThree.text = codeValue[2];
      _fieldFour.text = codeValue[3];
      _fieldFive.text = codeValue[4];
      _fieldSix.text = codeValue[5];
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  Future<void> loadOtpCount() async {
    int? count = await AuthData.getOtpCount();
    setState(() {
      AuthData.counter = count ?? 0;
    });
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

  Future<void> VerifyOTp() async {
    setState(() {
      isLoading = true;
    });
    var screenOtp =
        '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}${_fieldFive.text}${_fieldSix.text}';
    try {
      await AuthData.UserCodeVerify(data['mobile'], screenOtp, context);
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
        Navigator.pushReplacementNamed(context, '/login');
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
                                Navigator.pushReplacementNamed(
                                    context, '/login');
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
                        "Code has been sent to given mobile number",
                        style: ThemeTextStyle.control1.copyWith(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth / 12),
                      child: AutofillGroup(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OtpInput(
                                _fieldOne, true, screenWidth, screenHeight),
                            OtpInput(
                                _fieldTwo, false, screenWidth, screenHeight),
                            OtpInput(
                                _fieldThree, false, screenWidth, screenHeight),
                            OtpInput(
                                _fieldFour, false, screenWidth, screenHeight),
                            OtpInput(
                                _fieldFive, false, screenWidth, screenHeight),
                            OtpInput(
                                _fieldSix, false, screenWidth, screenHeight),
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
                              if (AuthData.counter <= 2) ...[
                                Text(
                                  'Resend code in ',
                                  style: ThemeTextStyle.control1.apply(
                                      fontSizeDelta: -6,
                                      color: Colors.black54),
                                ),
                                Text(
                                  '$secondsRemaining',
                                  style: ThemeTextStyle.control1.apply(
                                      fontSizeDelta: -6,
                                      color: Colors.orangeAccent),
                                ),
                                Text(
                                  ' s',
                                  style: ThemeTextStyle.control1.apply(
                                      fontSizeDelta: -6,
                                      color: Colors.black54),
                                ),
                              ] else ...[
                                Text(
                                  'Unable to sent Otp Kindly Contact Support',
                                  style: ThemeTextStyle.control1.apply(
                                      fontSizeDelta: -6,
                                      color: Colors.black54),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showResendButton,
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                AuthData.counter++;
                                AuthData.saveOtpCount(AuthData.counter);
                                showResendButton = false;
                              });

                              if (AuthData.counter <= 2) {
                                startTimer();
                                AuthData.userRegisterSendOTp(
                                    AuthData.regMobileNumber, context);
                              } else {
                                startHourTimer();
                                // await checkTimeDifference();
                              }
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: TextButton(
                    onPressed: isButtonEnabled() ? () => VerifyOTp() : null,
                    style: TextButton.styleFrom(
                      backgroundColor: isButtonEnabled()
                          ? GeneralThemeStyle.button
                          : Colors.grey,
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
                            color: index.isEven
                                ? Colors.deepOrangeAccent
                                : Colors.orange,
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
        inputFormatters: [maskPhone],
        controller: controller,
        maxLength: 1,
        cursorColor: GeneralThemeStyle.button,
        autofillHints: [AutofillHints.oneTimeCode],
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: GeneralThemeStyle.button, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
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
        }),
      ),
    );
  }
}
