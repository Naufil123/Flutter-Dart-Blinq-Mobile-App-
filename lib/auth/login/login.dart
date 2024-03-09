// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../../appData/AppData.dart';
import '../../appData/AuthData.dart';
import '../../appData/local_auth.dart';
import '../../appData/masking.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  double accountTextOffset = 0.0;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final String message;
  bool _obscureText = true;
  bool isLoading = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool isAuthenticationSuccessful = false;
  //
  // static Future<bool> authenticateWithBiometric() async {
  //
  //   return await LocalAuth.authenticate();
  // }



  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = true;
    });
    if (passwordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      Snacksbar.showErrorSnackBar(context,'Fill all the required fields');
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    if ( usernameController.text.length < 11) {
      Snacksbar.showErrorSnackBar(context,'Mobile number must have at least 11 digits');
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    if (passwordController.text.length != 4 ) {
      Snacksbar.showErrorSnackBar (context,'Password must be 4 characters long');
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
     await AuthData.Userauthenticate(usernameController.text,passwordController.text,context);

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding  (
                padding: EdgeInsets.fromLTRB(
                  0,
                  screenHeight * 0.1,
                  screenWidth * 0.25,
                  screenHeight * 0.02,
                ),
                child: const Text(
                  'Login to your \naccount.',
                  style: ThemeTextStyle.generalSubHeading,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  0,
                  screenWidth * 0.15,
                  screenHeight * 0.02,
                ),
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
                      'Enter your Username or Email',
                      style: ThemeTextStyle.generalSubHeading.apply(
                        fontSizeDelta: -18),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        5,
                        0,
                        screenHeight * 0.018,
                      ),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskPhone],
                          decoration: InputDecoration(
                            labelText: 'Enter Your Username or Email',
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
                          validator: (value) => validateEmail(value),
                        ),
                      ),
                    ),

              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type your Pin',
                      style: ThemeTextStyle.generalSubHeading.apply(
                        fontSizeDelta: -18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          inputFormatters: [maskPin],
                          controller: passwordController,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Pin',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: GeneralThemeStyle.button,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: GeneralThemeStyle.output,
                                width: 1.0,
                              ),
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

              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/forgotPassword');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: ThemeTextStyle.generalSubHeading3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: screenWidth,
                    height: screenHeight * 0.065,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                      // _userLogin();
                      // _showDialog();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: GeneralThemeStyle.button,
                    ),
                    child: Text(
                      'Sign In',
                      style: ThemeTextStyle.detailPara.apply(color: Colors.white),
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
                          width: screenWidth * 0.4, // Adjust the width as needed
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
                          width: screenWidth * 0.4, // Adjust the width as needed
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
                crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
                children: [
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth / 5,
                    child: IconButton(
                      icon: Image.asset('assets/images/google.png'),
                      onPressed: () {
                        print("Google login");
                      },
                    ),
                  ),

                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth / 5,
                    child: IconButton(
                      icon: Image.asset('assets/images/facebook.png'),
                      onPressed: () {
                        print("Google login");
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth / 5,
                    child: IconButton(
                      icon: Image.asset('assets/images/apple.png'),
                      onPressed: () {
                        print("Google login");
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: ThemeTextStyle.generalSubHeading3.apply(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "Register",
                          style: ThemeTextStyle.generalSubHeading3.apply(
                            color: GeneralThemeStyle.button,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // IconButton for Biometric Login
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight/10 ,
                          width: screenWidth/6 ,
                          child: IconButton(
                            icon: Image.asset('assets/images/biometric.png'),
                            onPressed: () async {
                              final authenticateWithBiometric = await LocalAuth.authenticate(context);

                              // if (authenticateWithBiometric) {
                              //   // Biometric authentication successful, call API authentication
                              //
                              // }
                              setState(() {
                                isAuthenticationSuccessful = authenticateWithBiometric;
                              });
                            },

                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: 8), // Adjust the spacing between the icon and text
                  RichText(
                    text: const TextSpan(
                      text: 'Use biometric for ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'login',
                          style: TextStyle(
                            color: GeneralThemeStyle.button,
                            fontSize: 16,
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
