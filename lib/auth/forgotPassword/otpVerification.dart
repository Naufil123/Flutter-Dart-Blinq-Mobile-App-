// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter/material.dart';
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
  double accountTextOffset = 0.0;
  bool isChecked = false;
  bool _obscureText = true;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
  }
  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }
  late Map<String, dynamic> data = {};
  Future<void> _showCongratulationDialog() async {
    if (passwordController.text.isEmpty ||
        repasswordController.text.isEmpty){
      Snacksbar.showErrorSnackBar(context, 'Please fill all required Filed');
    }
    if (passwordController.text.length!=4 ||
        repasswordController.text.length!=4){
      Snacksbar.showErrorSnackBar(context, 'Pin must be 4 digit');
    }
    if (passwordController.text!=repasswordController.text){
      Snacksbar.showErrorSnackBar(context, 'Pin must be same');
    }
    if (passwordController.text.isNotEmpty &&
        repasswordController.text.isNotEmpty &&
        passwordController.text == repasswordController.text &&
        passwordController.text.length == 4 &&
        repasswordController.text.length == 4) {
    await AuthData.userResetPin(data['mobile'], repasswordController.text,context);
    } else {
      if (passwordController.text.isEmpty ||
          repasswordController.text.isEmpty ||
          passwordController.text.length != 4 ||
          repasswordController.text.length != 4) {
        print('One or both fields are null, empty, or not equal to 4 characters');
      }
    }
  }
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
        toolbarHeight: screenHeight * 0.1,
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
                        Navigator.pushReplacementNamed(context, '/forgotPassword');
                      },
                    ),
                    Text(
                      "Create New Password",
                      style: ThemeTextStyle.detailPara.apply(fontSizeDelta: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.025),
                  child: Image.asset(
                    'assets/images/otp.png',
                    width: screenWidth,
                    height: screenHeight * 0.4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 250),
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
                                Icons.lock_outline,
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
                                Icons.lock_outline,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(0, screenHeight * 0.01, 0, screenHeight * 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        activeColor: GeneralThemeStyle.button,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Remember me',
                          style: ThemeTextStyle.generalSubHeading3.apply(color: Colors.black),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          bottomNavigationBar: Row(
        children: [
        SizedBox(

        width: screenWidth ,
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: TextButton(
            onPressed: isLoading
                ? null
                : () {
              setState(() {
                isLoading = false;
              });

              setState(() {
                isLoading = true;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: GeneralThemeStyle.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
              child: TextButton(
                onPressed: () {
                  _showCongratulationDialog();
                  },
                style: TextButton.styleFrom(
                  backgroundColor: GeneralThemeStyle.button,
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
          )
        ),
        )
          ),
      ],
          ),
    );
  }
}
