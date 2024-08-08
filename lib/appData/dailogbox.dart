
import 'AuthData.dart';
import 'ThemeStyle.dart';
import 'package:flutter/material.dart';

import 'masking.dart';


class FAQ {
  static void showAlertDialog(BuildContext context, String title, String content, double screenWidth) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return FAQ1(
          title: title,
          content: content,
          screenWidth: screenWidth,
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
    ).then((value) {

    });
  }
}
class FAQ1 extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const FAQ1({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _FAQ1State createState() => _FAQ1State();
}
class _FAQ1State extends State<FAQ1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  List<Map<String, dynamic>> faqData = [];
  int selectedDividerIndex = -1;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _fetchFAQData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchFAQData() async {
    try {
      final List<Map<String, dynamic>> data =
      await AuthData.fetchFAQData() as List<Map<String, dynamic>>;
      setState(() {
        faqData = data;
      });
    } catch (error) {
      print('Error fetching FAQ data: $error');
      // Handle error gracefully, show a message to the user, etc.
    }
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  void dismiss() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
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
        toolbarHeight: 90,
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
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 108.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'FAQ',
                          style: ThemeTextStyle.generalHeading.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium!,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var index = 0; index < faqData.length; index++)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDividerIndex = index;
                              });
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: selectedDividerIndex == index
                                      ? GeneralThemeStyle.nuull
                                      : Colors.white,
                                ),
                                width: screenWidth / 1.1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (index + 1).toString(),
                                        style: ThemeTextStyle.generalSubHeading.copyWith(
                                          color: Colors.grey,
                                          fontSize: 38,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              faqData[index]['question'].toString(),
                                              style: ThemeTextStyle.generalSubHeading.copyWith(
                                                color: Colors.black,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        faqData[index]['answer'].toString(),
                                        style: ThemeTextStyle.generalSubHeading.copyWith(
                                          color: Colors.grey,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(), // Divider after each FAQ item
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showFullTextDialog(
    BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title ,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w900),),
      content: SingleChildScrollView(
        child: Text(description ,style: const TextStyle(color: Colors.black),),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.w900),),
        ),
      ],
    ),
  );
}


typedef RefreshCallback = void Function(BuildContext context);
void reload_Dailough(BuildContext context, String title, String description, RefreshCallback refreshCallback) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text(
            "Connection Timeout",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            "Failed to load data. Please try again later.",
            style: TextStyle(
              color: Colors.deepOrange,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                refreshCallback(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white,fontSize: 12),
              ),
            ),
          ],
        ),
      );
    },
  );
}
void showProfileUpdateMobileDialog(BuildContext context, String title, String description) {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      String newMobileNumber = AuthData.regMobileNumber;
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text(
          'Add Mobile Number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: screenWidth,
          height: 100.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [maskPhone],
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                  labelText: 'Add Your Mobile',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newMobileNumber = value;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () {
              if (otpController.text.isEmpty) {
                Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
              } else if (otpController.text.length > 11) {
                Snacksbar.showCustomSnackbar(context, "Invalid number");
              } else if (otpController.text[0] != '0' || otpController.text[1] != '3') {
                Snacksbar.showCustomSnackbar(context, "Invalid number");
              }
              else if(AuthData.mobile1.isNotEmpty && AuthData.mobile1==otpController.text){
                Snacksbar.showCustomSnackbar(context, "Number Alredy dded");
              } else if(AuthData.mobile2.isNotEmpty && AuthData.mobile2==otpController.text){
                Snacksbar.showCustomSnackbar(context, "Number Alredy dded");
              } else if(AuthData.mobile3.isNotEmpty && AuthData.mobile3==otpController.text){
                Snacksbar.showCustomSnackbar(context, "Number Alredy dded");
              }else {
                Navigator.of(context).pop();
                AuthData.profile_sendotp(otpController.text, context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    String otp = '';
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: const Text(
                        'Enter OTP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: SizedBox(
                        width: screenWidth,
                        height: 130.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Please enter the OTP sent to your mobile.",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              inputFormatters: [maskotpPin],
                              controller: codeController,
                              onChanged: (value) {
                                otp = value;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter OTP',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (codeController.text.isEmpty) {
                              Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
                            }
                            else {
                              AuthData.profilecodeverify(
                                  otpController.text, codeController.text,
                                  context);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      );
    },
  );
}


void showProfileUpdateEmailDialog(
    BuildContext context, String title, String description) {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      String newMobileNumber = AuthData.regMobileNumber;
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Add Email Address', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: screenWidth,
          height: 100.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  labelText: 'Enter Your Email',
                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newMobileNumber = value;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              if (otpController.text.isEmpty) {
                Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
              } else if (!otpController.text.contains('@') || !otpController.text.contains('.')) {
                Snacksbar.showCustomSnackbar(context, "Invalid Email");
              }  else if(AuthData.email1.isNotEmpty && AuthData.email1==otpController.text){
                Snacksbar.showCustomSnackbar(context, "Email Alredy added");
              } else if(AuthData.email2.isNotEmpty && AuthData.email2==otpController.text){
                Snacksbar.showCustomSnackbar(context, "Email Alredy added");
              } else if(AuthData.email3.isNotEmpty && AuthData.email3==otpController.text){
                Snacksbar.showCustomSnackbar(context, "Email Alredy added");
              }else {
                Navigator.of(context).pop();
                AuthData.profile_sendotp(otpController.text, context);

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    String otp = '';
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: const Text('Enter OTP', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: SizedBox(
                        width: screenWidth,
                        height: 100.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Please enter the OTP sent to your email.",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              inputFormatters: [maskotpPin],
                              controller: codeController,
                              onChanged: (value) {
                                otp = value;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter OTP',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
                        ),
                        TextButton(
                          onPressed: () {

                            if (codeController.text.isEmpty) {
                              Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
                            }
                            else {
                              AuthData.profilecodeverify(
                                  otpController.text, codeController.text,
                                  context);
                              Navigator.of(context).pop(); // Close OTP dialog
                            }
                          },
                          child: const Text('Save', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.orange)),
          ),
        ],
      );
    },
  );
}


Future<void> showeditMobileprofile(BuildContext context, String title, String description, value) async {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  double screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Edit your Mobile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: screenWidth,
          height: 100.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [maskPhone],
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                  labelText: 'Edit Your Mobile',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              AuthData.val = otpController.text;
              AuthData.type = codeController.text;
              if (otpController.text.isEmpty) {
                Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
              } else if (otpController.text.length > 11) {
                Snacksbar.showCustomSnackbar(context, "Invalid number");
              } else if (otpController.text[0] != '0' || otpController.text[1] != '3') {
                Snacksbar.showCustomSnackbar(context, "Invalid number");
              }
              else if(AuthData.mobile1.isNotEmpty && AuthData.mobile1==otpController.text) {
                Snacksbar.showCustomSnackbar(context, "Number is Already Added");
              }  else if(AuthData.mobile2.isNotEmpty && AuthData.mobile2==otpController.text) {
                Snacksbar.showCustomSnackbar(context, "Number is Already Added");
              }  else if(AuthData.mobile3.isNotEmpty && AuthData.mobile3==otpController.text) {
                Snacksbar.showCustomSnackbar(context, "Number is Already Added");
              } else {
                Navigator.of(context).pop();
                AuthData.profile_sendotp(otpController.text, context);

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    String otp = '';
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: const Text('Enter OTP', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: SizedBox(
                        width: screenWidth,
                        height: 130.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Please enter the OTP sent to your mobile.",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              inputFormatters: [maskotpPin],
                              controller: codeController,
                              onChanged: (value) {
                                otp = value;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter OTP',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (codeController.text.isEmpty) {
                              Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
                            }
                            else {
                              AuthData.type=value;
                              AuthData.editprofilecodeverify(
                                  otpController.text, codeController.text,
                                  value, context);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.orange)),
          ),
        ],
      );
    },
  );
}

void showeditEmailprofile(BuildContext context, String title, String description, value) {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  double screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text('Edit your Email', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: screenWidth,
          height: 100.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  labelText: 'Edit Your Email',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              if (otpController.text.isEmpty) {
                Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
              } else if (!otpController.text.contains('@') || !otpController.text.contains('.')) {
                Snacksbar.showCustomSnackbar(context, "Invalid Email");
              }
              else if(AuthData.email1.isNotEmpty && AuthData.email1==otpController.text) {
                Snacksbar.showCustomSnackbar(context, "Email is Already Added");
              }  else if(AuthData.email2.isNotEmpty && AuthData.email2==otpController.text) {
                Snacksbar.showCustomSnackbar(context, "Email is Already Added");
              }  else if(AuthData.email3.isNotEmpty && AuthData.email3==otpController.text) {
                Snacksbar.showCustomSnackbar(context, "Email is Already Added");
              } else {
                Navigator.of(context).pop();
                AuthData.profile_sendotp(otpController.text, context);

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    String otp = '';
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: const Text('Enter OTP', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: SizedBox(
                        width: screenWidth,
                        height: 100.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              "Please enter the OTP sent to your email.",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: codeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskotpPin],
                              decoration: InputDecoration(
                                hintText: 'Enter OTP',
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                ),
                                labelStyle: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (codeController.text.isEmpty) {
                              Snacksbar.showCustomSnackbar(context, "Please fill all required fields");
                            }
                            else {
                              AuthData.type=value;
                              AuthData.editprofilecodeverify(
                                  otpController.text, codeController.text,
                                  value, context);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.orange)),
          ),
        ],
      );
    },
  );
}
