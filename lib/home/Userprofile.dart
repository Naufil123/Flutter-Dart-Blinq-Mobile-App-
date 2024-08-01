import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../appData/AuthData.dart';
import '../appData/ThemeStyle.dart';
import '../appData/dailogbox.dart';
import '../appData/masking.dart';

class Profile {
  static void showAlertDialog(BuildContext context, String title, String content, double screenWidth) {
    final GlobalKey<_Profile2State> key = GlobalKey();
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Profile2(
          key: key,
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
    ).then((value) {});
  }
}

class Profile2 extends StatefulWidget {
  final String title;
  final String content;
  final double screenWidth;

  const Profile2({Key? key, required this.title, required this.content, required this.screenWidth}) : super(key: key);

  @override
  _Profile2State createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final TextEditingController otpController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    await AuthData.fetchUserProfile();
    setState(() {
      isLoading = false;
    });
  }

  void dismiss() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.orange),)
        : SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          dismiss();
        },
        child: DefaultTextStyle(
          style: Theme
              .of(context)
              .textTheme
              .titleMedium!,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: widget.screenWidth,
              height: screenHeight * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/Ellipse3.png',
                                  width: screenWidth / 6,
                                  height: screenHeight * 0.1,
                                ),
                                Positioned(
                                  top: screenHeight * 0.04,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      getInitials(AuthData.regFullName),
                                      style: ThemeTextStyle.roboto,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AuthData.regFullName.length <= 17
                                      ? AuthData.regFullName
                                      : AuthData.regFullName.substring(0, 17),
                                  style: ThemeTextStyle.sF1.copyWith(
                                    fontSize: 15,
                                    color: CupertinoColors.inactiveGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(
                                  Icons.email_rounded,
                                  size: 22,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            Text(
                              'Username',
                              style: ThemeTextStyle.good1.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Text(
                            AuthData.regMobileNumber,
                            style: ThemeTextStyle.sF1.copyWith(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(
                                  Icons.accessibility_sharp,
                                  size: 22,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            Text(
                              'Full Name',
                              style: ThemeTextStyle.good1.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Text(
                            AuthData.regFullName,
                            style: ThemeTextStyle.sF1.copyWith(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        buildProfileDetailRow(
                          context,
                          icon: Icons.phone_android,
                          label: 'Mobile Number',
                          value: AuthData.mobile1,
                          value1: AuthData.mobile2,
                          value2: AuthData.mobile3,

                          onPressed: () {
                            print("Edit mobile number");
                          },
                          showAddIcon: true,
                        ),
                        buildProfileDetailRow(
                          context,
                          icon: Icons.email_rounded,
                          label: 'Email',
                          value: AuthData.email1,
                          value1: AuthData.email2,
                          value2: AuthData.email3,

                          onPressed: () {},
                          showEmailAddIcon: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget buildProfileDetailRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String value1,
    required String value2,
    bool showAddIcon = false,
    bool showEmailAddIcon = false,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: ThemeTextStyle.good1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              if (showAddIcon && (value == "" || value1 == "" || value2 == ""))
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.deepOrange),
                  onPressed: () {
                    showProfileUpdateMobileDialog(context, "", "");
                  },
                ),
              if (showEmailAddIcon &&
                  (value == "" || value1 == "" || value2 == ""))
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.deepOrange),
                  onPressed: () {
                    showProfileUpdateEmailDialog(context, '', '');
                  },
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (value.isNotEmpty) ...[
                buildValueRow(context, value, 'value'),
              ],
              if (value1.isNotEmpty) ...[
                buildValueRow(context, value1, 'value1'),
              ],
              if (value2.isNotEmpty) ...[
                buildValueRow(context, value2, 'value2'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget buildValueRow(BuildContext context, String value, String valueType) {
    return Row(
      children: [
        Text(
          value.length <= 22 ? value : value.substring(0, 19) + '..',
          overflow: TextOverflow.ellipsis,
          style: ThemeTextStyle.sF1.copyWith(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        if (value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value.contains('@'))
                    GestureDetector(
                      onTap: () {
                        showeditEmailprofile(context, '', '', valueType);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.edit_note, color: Colors.deepOrange),
                      ),
                    ),
                  if (value.contains('@'))
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text(
                                  "Are you sure you want to remove this Email?",
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.deepOrange,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (valueType == 'value') {
                                        setState(() {
                                          AuthData.UpdateProfile(
                                            AuthData.regMobileNumber,
                                            AuthData.regFullName,
                                            AuthData.mobile1,
                                            AuthData.mobile2,
                                            AuthData.mobile3,
                                            null,
                                            AuthData.email2,
                                            AuthData.email3,
                                            context,
                                          );

                                          Snacksbar.showCustomSucessSnackbar(context,"Remove Sucessfully");
                                        });

                                      } else if (valueType == 'value1') {
                                        setState(() {
                                          AuthData.UpdateProfile(
                                            AuthData.regMobileNumber,
                                            AuthData.regFullName,
                                            AuthData.mobile1,
                                            AuthData.mobile2,
                                            AuthData.mobile3,
                                            AuthData.email1,
                                            null,
                                            AuthData.email3,
                                            context,
                                          );

                                          Snacksbar.showCustomSucessSnackbar(context,"Remove Sucessfully");
                                        });

                                      } else if (valueType == 'value2') {
                                        setState(() {
                                          AuthData.UpdateProfile(
                                            AuthData.regMobileNumber,
                                            AuthData.regFullName,
                                            AuthData.mobile1,
                                            AuthData.mobile2,
                                            AuthData.mobile3,
                                            AuthData.email1,
                                            AuthData.email2,
                                            null,
                                            context,
                                          );
                                          Snacksbar.showCustomSucessSnackbar(context,"Remove Sucessfully");
                                        });

                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.deepOrange,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(
                            Icons.delete_outline, color: Colors.deepOrange),
                      ),
                    ),
                  if (!value.contains('@'))
                    GestureDetector(
                      onTap: () {
                        showeditmobileprofile(context, '', '', valueType);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.edit_note, color: Colors.deepOrange),
                      ),
                    ),
                  if (!value.contains('@'))
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text(
                                  "Are you sure you want to remove this number?",
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.deepOrange,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (valueType == 'value') {
                                        setState(() {
                                          AuthData.UpdateProfile(
                                            AuthData.regMobileNumber,
                                            AuthData.regFullName,
                                            null,
                                            AuthData.mobile2,
                                            AuthData.mobile3,
                                            AuthData.email1,
                                            AuthData.email2,
                                            AuthData.email3,
                                            context,
                                          );
                                          Snacksbar.showCustomSucessSnackbar(context,"Remove Sucessfully");
                                        });

                                      } else if (valueType == 'value1') {
                                        setState(() {
                                          AuthData.UpdateProfile(
                                            AuthData.regMobileNumber,
                                            AuthData.regFullName,
                                            AuthData.mobile1,
                                            null,
                                            AuthData.mobile3,
                                            AuthData.email1,
                                            AuthData.email2,
                                            AuthData.email3,
                                            context,
                                          );
                                          Snacksbar.showCustomSucessSnackbar(context,"Remove Sucessfully");
                                        });

                                      } else if (valueType == 'value2') {
                                        setState(() {
                                          AuthData.UpdateProfile(
                                            AuthData.regMobileNumber,
                                            AuthData.regFullName,
                                            AuthData.mobile1,
                                            AuthData.mobile2,
                                            null,
                                            AuthData.email1,
                                            AuthData.email2,
                                            AuthData.email3,
                                            context,
                                          );

                                          Snacksbar.showCustomSucessSnackbar(context,"Remove Sucessfully");
                                        });

                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.deepOrange,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: Icon(Icons.delete_outline, color: Colors.deepOrange),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

