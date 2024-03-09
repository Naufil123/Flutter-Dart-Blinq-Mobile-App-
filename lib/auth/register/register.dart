// TODO Implement this library.import 'package:blinq_sol/appData/AppData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../appData/AppData.dart';
import '../../appData/AuthData.dart';
import '../../appData/masking.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);
  @override
  _registerState createState() => _registerState();
}
class _registerState extends State<register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  double accountTextOffset = 0.0;
  bool isChecked = false;
  bool _obscureText = true;
  bool isLoading= false;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }
 Future<void> regUserApi() async {
   setState(() {
     isLoading = true;
   });
     if (!_formKey.currentState!.validate() ||
         !_formKey1.currentState!.validate() ||
         !_formKey2.currentState!.validate() ||
         !_formKey3.currentState!.validate() ||
         !_formKey4.currentState!.validate()) {
       setState(() {
         isLoading = false;
       });
       return;
     }
     setState(() {
       isLoading = true;
     });
     if (passwordController.text.isEmpty ||
         repasswordController.text.isEmpty ||
         mobileController.text.isEmpty ||
         fullNameController.text.isEmpty) {
       Snacksbar.showErrorSnackBar(context,'Fill all the required fields');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     if (mobileController.text.length < 11) {
       Snacksbar.showErrorSnackBar(context,'Mobile number must have at least 11 digits');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     if (!emailController.text.contains('@') ||
         !emailController.text.contains('.')) {
       Snacksbar.showErrorSnackBar(context,'Invalid email format');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     if (passwordController.text.length != 4 ||
         repasswordController.text.length != 4) {
       Snacksbar.showErrorSnackBar (context,'Password must be 4 characters long');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     if (passwordController.text != repasswordController.text) {
       Snacksbar.showErrorSnackBar(context,'Pin are not same');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
   if (isChecked==false) {
     Snacksbar.showErrorSnackBar(context,'You must agree the term of privacy policy to register');
     setState(() {
       isLoading = false;
     });
     return;
   }
   setState(() {
     isLoading = true;
   });
    await AuthData.regUser(mobileController.text,emailController.text,repasswordController.text,fullNameController.text,context);
     setState(() {
       isLoading = false;
     });
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
                padding: EdgeInsets.fromLTRB(0, screenHeight * 0.1, 10, 10),
                child: const Text(
                  'Create your new account.',
                  style: ThemeTextStyle.generalSubHeading,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, screenHeight * 0.02),
                child: Text(
                  'Create an account to start looking for the food you like',
                  style: ThemeTextStyle.generalSubHeading.apply(
                    fontSizeDelta: -19,
                    color: Colors.black26,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name', style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                    ),
                    Padding(padding:
                      EdgeInsets.fromLTRB(0, 5, 0, screenHeight * 0.015),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: fullNameController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [maskAlphabet],
                          decoration: InputDecoration(
                            labelText: 'Your Full Name',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
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
              Form(key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile No',
                      style: ThemeTextStyle.generalSubHeading
                          .apply(fontSizeDelta: -18),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(0, 5, 0, screenHeight * 0.015),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskPhone],
                          decoration: InputDecoration(
                            labelText: 'Enter Your Mobile Number',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
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
              Form(
                key: _formKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: ThemeTextStyle.generalSubHeading
                          .apply(fontSizeDelta: -18),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(0, 05, 0, screenHeight * 0.015),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: emailController,
                          // inputFormatters: [maskedEmail],
                          keyboardType: TextInputType.emailAddress,
                          // inputFormatters: [maskedEmail()],
                          decoration: InputDecoration(
                            labelText: 'Enter Your Email',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // validator: (value) => validateEmail(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type your Pin',
                      style: ThemeTextStyle.generalSubHeading
                          .apply(fontSizeDelta: -18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 05),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          inputFormatters: [maskPin],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Pin',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
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
                key: _formKey4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Re-Enter pin',
                        style: ThemeTextStyle.generalSubHeading
                            .apply(fontSizeDelta: -18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 05),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: repasswordController,
                          inputFormatters: [maskPin],
                          obscureText: _obscureText,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Re-Enter Pin',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
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
                padding: EdgeInsets.fromLTRB(
                    0, screenHeight * 0.01, 0, screenHeight * 0.01),
                child: Row(
                  children: [
                    Checkbox(
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
                        text: 'I Agree with ',
                        style: ThemeTextStyle.generalSubHeading3
                            .apply(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Terms of Service',
                            style: ThemeTextStyle.generalSubHeading3
                                .apply(color: Colors.orange[900]),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: ThemeTextStyle.generalSubHeading3
                                .apply(color: Colors.orange[900]),
                            // recognizer: TapGestureRecognizer(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
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
                        regUserApi();
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
                        'Register',
                        style: ThemeTextStyle.detailPara.apply(color: Colors.white),
                      ),
                    ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/images/signin.png',
                          width:
                          screenWidth * 0.4, // Adjust the width as needed
                          fit: BoxFit.contain,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    Text(
                      '    or sign up with    ',
                      style: ThemeTextStyle.generalSubHeading4.copyWith(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/signin.png',
                          width:
                          screenWidth * 0.4, // Adjust the width as needed
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start, // Align to the top
                children: [
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth / 5,
                    child: IconButton(
                      icon: Image.asset('assets/images/google.png'),
                      onPressed: () {
                       /* print("Google login");*/
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth / 5,
                    child: IconButton(
                      icon: Image.asset('assets/images/facebook.png'),
                      onPressed: () {
                      /*  print("Google login");*/
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth / 5,
                    child: IconButton(
                      icon: Image.asset('assets/images/apple.png'),
                      onPressed: () {
                       /* print("Google login");*/
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),


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
]
    )
    );
  }
}

