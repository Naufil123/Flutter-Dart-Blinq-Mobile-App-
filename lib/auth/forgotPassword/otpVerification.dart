import 'package:flutter/material.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Make sure to add this package in your pubspec.yaml
import '../../appData/AuthData.dart';
import '../../appData/masking.dart';

class otpVerification extends StatefulWidget {
  const otpVerification({Key? key}) : super(key: key);

  @override
  State<otpVerification> createState() => _otpVerificationState();
}

class _otpVerificationState extends State<otpVerification> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;
  late Map<String, dynamic> data = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
  }

  Future<void> _showCongratulationDialog() async {
    if (passwordController.text.isEmpty || repasswordController.text.isEmpty) {
      Snacksbar.showErrorSnackBar(context, 'Please fill all required fields');
      return;
    }
    if (passwordController.text.length != 4 || repasswordController.text.length != 4) {
      Snacksbar.showErrorSnackBar(context, 'Pin must be 4 digits');
      return;
    }
    if (passwordController.text != repasswordController.text) {
      Snacksbar.showErrorSnackBar(context, 'Pin must be the same');
      return;
    }
    setState(() {
      isLoading = true;
    });
    await AuthData.userResetPin(data['mobile'], repasswordController.text, context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/forgot');
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Create New PIN",
                          style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -3),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/otp.png',
                        width: screenWidth,
                        height: 225.0,
                      ),
                      const SizedBox(height: 10.0),

                      const SizedBox(height: 0.0),
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth - 180),
                        child: Text(
                          'Create your New Pin',
                          style: ThemeTextStyle.generalSubHeading3.apply(color: Colors.grey),
                        ),
                      ),
                      Form(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.0),
                              child: SizedBox(
                                width: screenWidth / 1.07,
                                height: screenHeight * 0.065,
                                child: TextFormField(
                                  inputFormatters: [maskPin],
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    labelText: 'Pin',
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
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: GeneralThemeStyle.dull,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      ),
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
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, screenHeight * 0.02, 0, screenHeight * 0.0),
                              child: SizedBox(
                                width: screenWidth / 1.07,
                                height: screenHeight * 0.065,
                                child: TextFormField(
                                  controller: repasswordController,
                                  inputFormatters: [maskPin],
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    labelText: 'Re-Enter Pin',
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
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: GeneralThemeStyle.dull,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: screenWidth,
                height: screenHeight / 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: TextButton(
                    onPressed: isLoading ? null : _showCongratulationDialog,
                    style: TextButton.styleFrom(
                      backgroundColor: GeneralThemeStyle.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              Positioned(
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.black87.withOpacity(0.5),
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
        ),

      ),
    );
  }
}
