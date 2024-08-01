// TODO Implement this library.import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blinq_sol/appData/ThemeStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool isAuthenticationSuccessful = false;
  @override
  @override
  void initState() {
    super.initState();
    loadInitData();
    AuthData.getAppSignature();
    AuthData.loadCredentials();
    AuthData.checkLoginStatus(context);
  }
  Future loadInitData() async {
    Completer<bool> showDialogCompleter = Completer<bool>();
    Future.delayed(Duration(seconds: AuthData.timer), () {
      if (isLoading && !showDialogCompleter.isCompleted) {
        showDialogCompleter.complete(true);
        setState(() {
          isLoading = false;
        });
        Snacksbar.showErrorSnackBar(
            context, 'Connection time out please try again');
      }
    });
  }

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
    if ( usernameController.text[0]!='0'  )
    {
      Snacksbar.showErrorSnackBar(context,'Invalid mobile number. Please enter a valid mobile number starting with 03');
      setState(() {
        isLoading = false;
      });
      return;
    }  if ( usernameController.text[1]!='3'  )
    {
      Snacksbar.showErrorSnackBar(context,'Invalid mobile number. Please enter a valid mobile number starting with 03');
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    if (passwordController.text.length != 4 ) {
      Snacksbar.showErrorSnackBar (context,'Pin must be 4 characters long');
      setState(() {
        isLoading = false;
      });
      return;
    }


    setState(() {
      isLoading = true;
    });
    Timer timer = Timer(Duration(seconds: AuthData.timer), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
        Snacksbar.showErrorSnackBar(context, 'No connection. Please try again.');
      }
    });

    try {
      await AuthData.Userauthenticate(usernameController.text, passwordController.text, context);
      await saveCredentials(usernameController.text, passwordController.text);
      await AuthData.saveLoginStatus(true);
    } catch (e) {
      Snacksbar.showErrorSnackBar(context, 'An error occurred. Please try again.');
    } finally {
      if (timer.isActive) {
        timer.cancel();
      }
      setState(() {
        isLoading = false;
      });
    }
    }
  Future<void> saveCredentials(String username, String pin) async {
    AuthData.biousername = username;
    AuthData.biopin = pin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', AuthData.biousername);
    await prefs.setString('pin', AuthData.biopin);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:  Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [
            SingleChildScrollView(

              child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Image.asset(
                  'assets/images/blinq-logoo.png',
                  width: screenWidth,
                  height: 60.0,
                ),
              ),
              const Text(
                'Login to your \naccount.',
                style: ThemeTextStyle.generalSubHeading,
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(
              //     0,
              //     0,
              //     screenWidth * 0.15,
              //     screenHeight * 0.02,
              //   ),
              //   child: Text(
              //     'Please sign in to your account',
              //     style: ThemeTextStyle.generalSubHeading.apply(
              //       fontSizeDelta: -19,
              //       color: Colors.black26,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                            labelText: 'Enter Your Mobile Number ',
                             // hintText: '03xxxxxxxxx',
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
                          // validator: (value) => validateEmail('03'),
                        ),
                      ),
                    ),

              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

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
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
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
                    usernameController.clear();
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
                      FocusScope.of(context).unfocus();
                      login();
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
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
                          children: [
                            SizedBox(
                              height: screenHeight/10 ,
                              width: screenWidth/6 ,
                              child: IconButton(
                                icon: Image.asset('assets/images/google.png'),
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  AuthData.signInWithGoogle(context);
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ),
                        ],
                        ),
                        // const SizedBox(height: 15),

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

                                        if (AuthData.biousername==""&& AuthData.biopin==""){
                                          Snacksbar.showErrorSnackBar(context, "Please log in with your username and PIN first to enable fingerprint login");
                                        }else{
                                        // if (AuthData.status==0){
                                        //   Snacksbar.showErrorSnackBar(context,
                                        //       "Your Device isn't compatible for fingerprint");
                                        // }else {
                                          final authenticateWithBiometric = await LocalAuth
                                              .authenticate(context);


                                          setState(() {
                                            isAuthenticationSuccessful =
                                                authenticateWithBiometric;
                                          });
                                         }
                                        },

                                    ),
                                  ),
                                ],
                              ),
                            ),


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
                                      color:Colors.black,
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
                  ],
                ),
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
        ),
    );
  }

}

