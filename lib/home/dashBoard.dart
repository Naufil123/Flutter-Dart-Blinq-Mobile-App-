import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controller/Network_Conectivity.dart';
import '../appData/ApiData.dart';
import '../appData/AuthData.dart';
import 'package:flutter/material.dart';
import '../appData/ThemeStyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../appData/dailogbox.dart';
import '../appData/masking.dart';
import '../appData/notification.dart';
import 'NavigationBar.dart';
import 'ProfileSection.dart';
import 'Userprofile.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {
  bool notification = true;
  String imgNotifyUrl = "assets/images/Notification.png";
  List announcement = [];
  Map<String, dynamic> profileData = {};
  bool spinner = true;
  Future<Map<String, dynamic>> fetchProfileInfo() async {
    var data = await ApiData.fetchGetUserProfile();
    profileData = data;
    AuthData.regFullName = profileData["full_name"];
    AuthData.regMobileNumber = profileData["mobile"];
    return profileData;
  }
  @override
  void initState() {
    super.initState();
    initialLoadingData();
    loadInitData();
    Get.find<NetworkController>().registerPageReloadCallback('/dashboard', _reloadPage);
  }

  @override
  void dispose() {
    Get.find<NetworkController>().unregisterPageReloadCallback('/dashboard');
    super.dispose();
  }





  Widget FeatureBox(int i, double width, BuildContext context) {
    String description = announcement[i]['description'].toString();
    String title = announcement[i]['title'].toString();

    return GestureDetector(
      onTap: () {
        showFullTextDialog(context, title, description);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Container(
          width: width / 2 - 30,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/focus.gif',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),


                const SizedBox(height: 1.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 8, 0, 5),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontFamily: 'Poppins-SemiBold',
                        color: Colors.black,
                        fontSize: 13,
                        height: 1,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display ',
                      color: Colors.grey,
                      fontSize: 9.5,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }



  void _reloadPage() {
    initialLoadingData();
    loadInitData();
  }
  Future initialLoadingData() async {
    var x = await ApiData.fetchGetTop4Announcement();
    announcement = x;
    return announcement;
  }
  Future loadInitData() async {
    Completer<bool> showDialogCompleter = Completer<bool>();

    void refreshDashboard(BuildContext context) {
      showDialogCompleter = Completer<bool>();

      Navigator.pushReplacementNamed(context, '/dashboard');
    }

    Future.delayed(Duration(seconds: AuthData.timer), () {
      if (spinner && !showDialogCompleter.isCompleted) {
        showDialogCompleter.complete(true);
        reload_Dailough(context, "", "", refreshDashboard );

      }
    });

    await initialLoadingData();

    if (!showDialogCompleter.isCompleted) {
      showDialogCompleter.complete(false);
    }

    setState(() {
      spinner = false;
    });
  }
  Future<bool> _onWillPop() async {
    bool exitConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No',style: TextStyle(color: Colors.deepOrange),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes',style: TextStyle(color: Colors.deepOrange),),
            ),
          ],
        );
      },
    ) ?? false;
    if (exitConfirmed) {
      SystemNavigator.pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, screenHeight * 0.01, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Profile.showAlertDialog(context, '', '', screenWidth);
                                  },
                                  child: Stack(
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
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: screenHeight * 0.004),
                                      child: Text(
                                        DateTime.now().hour > 5 && DateTime.now().hour < 12
                                            ? 'Good Morning'
                                            : DateTime.now().hour > 12 && DateTime.now().hour < 17
                                            ? 'Good Afternoon'
                                            : DateTime.now().hour > 17 && DateTime.now().hour <= 23
                                            ? 'Good Evening'
                                             : 'Good Evening',
                                        style: ThemeTextStyle.good1.copyWith(fontSize: 12),
                                      ),
                                    ),


                                    const Text('Assalam Walaikum',
                                      style: ThemeTextStyle.good2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    BellNotifAndHelp(key: UniqueKey())

                      ]
                        ),
                      ),
                      if(spinner==false)
                        ProfileSection(),
                      // Feature Section
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/unpaid');
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.075),
                                ),
                                color: Colors.transparent,
                                child: SizedBox(
                                  height: 90,
                                  width: screenWidth / 5,
                                  child: Image.asset(
                                    'assets/images/unpaidbill.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/paid');
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.075),
                                ),
                                color: Colors.transparent,
                                child: SizedBox(
                                  height: 90,
                                  width: screenWidth / 5,
                                  child: Image.asset(
                                    'assets/images/paidbill.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/pay');
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.075),
                                ),
                                color: Colors.transparent,
                                child: SizedBox(
                                  height: 90,
                                  width: screenWidth / 5,
                                  child: Image.asset(
                                    'assets/images/Benificary.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6,horizontal: 0),
                        child: Column(
                          children: [
                            Text(
                              'Features',
                              style: ThemeTextStyle.good1,
                            ),
                          ],
                        ),
                      ),


                      SizedBox(
                        width: screenWidth,
                        height: 500,
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 20,
                          padding: EdgeInsets.zero,
                          childAspectRatio: 1,
                          children: List.generate(announcement.length, (index) {
                            var i = index.toInt();
                            return Stack(
                              children: [
                                FeatureBox(i, screenWidth, context),
                              ],
                            );

                          }),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              if(spinner==true)
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
            ],

          ),

        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );

  }
}
