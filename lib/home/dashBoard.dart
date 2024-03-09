
import '../appData/ApiData.dart';
import '../appData/dailogbox.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../appData/ThemeStyle.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'NavigationBar.dart';
import 'ProfileSection.dart';

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
    ApiData.regFullName = profileData["full_name"];
    ApiData.regMobileNumber = profileData["mobile"];
    return profileData;
  }

  Future initialLoadingData() async {
    var x = await ApiData.fetchGetTop4Announcement();
    announcement = x;
    return announcement;
  }
  // Future<StreamedResponse> appToken() async {
  //   var appToken = await ApiData.fetchAuthTokenRequest();
  //   return appToken;
  // }

  Future loadInitData() async {
    await initialLoadingData();
    // await fetchProfileInfo();
    setState(() {
      spinner=false;
    });
  }

  Widget FeatureBox(i, width){

    String id = announcement[i]['id'].toString();
    String isExpired = announcement[i]['is_expired'].toString();
    String description = announcement[i]['description'].toString();
    String expiryDate = announcement[i]['expiry_date'].toString();
    String title = announcement[i]['title'].toString();
    String icon = announcement[i]['icon'].toString();

    if(announcement.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
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
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/bulb.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(5,8,0,5),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                      color: Colors.black,
                      fontSize: 13,
                      height: 1,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
                child: Text(
                  description,
                  style: TextStyle(
                      fontFamily: 'SF Pro Display ',
                      color: Colors.grey,
                      fontSize: 9.5,
                      height: 1.2,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
        ),
        // Add your content for the third sub-container here
      ),
    );
  }

  //
  @override
  void initState(){
    // if(ApiData.appToken==''){
    //   appToken();
    // }
    loadInitData();
    super.initState();
  }

  void _showDialog2(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Notification3.showAlertDialog(
      context,
      'Successful!',
      'Your ID has been verified \nsuccessfully!',
      screenWidth,
    );
  }
  void _showDialog3(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    FAQ.showAlertDialog(
      context,
      'Successful!',
      'Your ID has been verified \nsuccessfully!',
      screenWidth,
    );
  }
  @override
  void didUpdateWidget(covariant Dashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
  }



  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                                    child: const Center(
                                      child: Text(
                                        'NN',
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
                                  Padding(
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.004),
                                    child: Text(
                                      'Good Morning',
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showDialog3(context);
                                },
                                icon: Image.asset(
                                  'assets/images/help.png',
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.1,
                                ),
                              ),

                              IconButton(
                                onPressed: () async {
                                  // Future.delayed(Duration(milliseconds: 1), () {
                                  setState(() async {
                                    notification = !notification;
                                    // _showDialog2(context);
                                  });
                                  // });
                                },

                                icon: Builder(
                                  builder: (context) {
                                    if (notification) {
                                      return Image.asset(
                                        "assets/images/Notification.png",
                                        width: screenWidth/8,
                                        height: 40.0,
                                      );
                                    } else {
                                      return Image.asset(
                                        "assets/images/NoNotification.png",
                                        width: screenWidth/10,
                                        height: 40.0,
                                      );
                                    }
                                  },
                                ),
                              ),





                            ],
                          ),
                        ],
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
                                borderRadius: BorderRadius.circular(screenWidth * 0.075), // Adjust the border radius for a square shape
                              ),
                              color: Colors.transparent, // Set the color to transparent to avoid the default splash color
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
                                borderRadius: BorderRadius.circular(screenWidth * 0.075), // Adjust the border radius for a square shape
                              ),
                              color: Colors.transparent, // Set the color to transparent to avoid the default splash color
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
                                borderRadius: BorderRadius.circular(screenWidth * 0.075), // Adjust the border radius for a square shape
                              ),
                              color: Colors.transparent, // Set the color to transparent to avoid the default splash color
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



                    // Other Sections
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
                                FeatureBox(i,screenWidth),
                              ],
                            );
                            const Center(
                            // Text(
                            // 'Item $index',
                            // style: Theme.of(context).textTheme.headlineSmall,
                            // ),
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
       bottomNavigationBar: CustomBottomNavigationBar(),
    );

  }
}
