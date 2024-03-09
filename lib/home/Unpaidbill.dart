import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../appData/ThemeStyle.dart';
import '../appData/dailogbox.dart';
import 'NavigationBar.dart';
import 'ProfileSection.dart';

class Unpaid extends StatefulWidget {
  const Unpaid({super.key});
  @override
  _UnpaidState createState() => _UnpaidState();
}
class _UnpaidState extends State<Unpaid> {
  bool notification = true;
  String imgNotifyUrl = "assets/images/Notification.png";
  List<dynamic> unpaidBill = [];
  bool spinner = true;

  Future<List<dynamic>> fetchUnpaidBill() async {
    unpaidBill = await AuthData.fetchGetUnpaidBill();
    print(unpaidBill);
    setState(() {
      spinner=false;
    });
    return unpaidBill;
  }

  @override
  void initState(){
    super.initState();
    fetchUnpaidBill();
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
  void didUpdateWidget(covariant Unpaid oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
  }
  Widget ListData(i, screenWidth, screenHeight) {
    if (unpaidBill.isEmpty || i >= unpaidBill.length) {
      return SizedBox(
        width: screenWidth,
        child: const Text("No Record Found!"),
      );
    }
    String amount = unpaidBill[i]['amount']?.toString() ?? "";
    String customerName = unpaidBill[i]['customer_name']?.toString() ?? "";
    String PayementCode = unpaidBill[i]['payment_id']?.toString() ?? "";
    String isBenificaryString = unpaidBill[i]['is_user_beneficiary']?.toString() ?? "";
    String ConsumerCode = unpaidBill[i]['full_consumer_code']?.toString() ?? "";
    bool isBenificary = isBenificaryString.toLowerCase() == 'true';

    Future<void> Remove() async {
      await AuthData.RemoveBenificary(AuthData.regMobileNumber,AuthData.Consumer);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Container(
        height: 100.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              offset: Offset(2.0, 0.0),
              blurRadius: 10.5,
              spreadRadius: 4.5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/red.png',
                        width: screenWidth / 8,
                        height: 80.0,
                      ),
                      const Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            "SN",
                            style: ThemeTextStyle.robotored,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          child: Text(
                            customerName,
                            style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 13),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  PayementCode,
                                  style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 11),
                                ),
                              ),
                              if (isBenificary)
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Warning"),
                                          content: Text("Are you sure you want to remove this beneficiary?"),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                AuthData.Consumer = ConsumerCode;
                                                Remove();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) => Unpaid(),
                                                  ),
                                                );
                                              },
                                              child: Text("Yes"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("No"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                  child: Text(
                                    'Remove',//+ ConsumerCode,
                                    style: ThemeTextStyle.generalSubHeading3.copyWith(fontSize: 10),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            "\RS$amount",
                            style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w600, color: Colors.red, fontSize: 12),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                            minimumSize: Size.zero,
                            backgroundColor: GeneralThemeStyle.niull, // Set the background color here
                            textStyle: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/pay');
                          },
                          child: Text(
                            'Pay Now',
                            style: ThemeTextStyle.sF.copyWith(fontSize: 11, color: Colors.black45), // Set the text color
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("didUpdateWidget: notification = $notification");


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
                                onPressed: () {
                                  setState(() {
                                    notification = !notification;
                                    _showDialog2(context);
                                  });
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
                    ProfileSection(),
                    // Feature Section
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Unpaid Bills',
                                  style: ThemeTextStyle.detailPara,
                                ),
                                // TextButton(
                                //   onPressed: () {
                                //     // fetchUnpaidBill();
                                //   },
                                //   child: Text(
                                //     'View all',
                                //     style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 12),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: InkWell(
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
                        ],
                      ),
                    ),
                    Container(
                      height: 5,
                    ),

                    if(spinner==false)
                      Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: SizedBox(
                        height:screenHeight*0.60,
                        width: screenWidth,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          scrollDirection: Axis.vertical,
                          itemCount: unpaidBill.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListData(index,screenWidth,screenHeight)
                              ],
                            );
                          },
                        ),
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

// class ContainerList extends StatelessWidget {
//   const ContainerList({super.key, Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//      bool isLargeHeight(BuildContext context) => //ye wala isDesktop tm apne bari screens k liye use kroge, like iphone 14 pro ki screen for example 300+ hai to usko 300< lagayenge
//         MediaQuery.of(context).size.height >= 867;
//      bool isLowHeight(BuildContext context) =>
//          MediaQuery.of(context).size.height < 867;
//
//     List<String> headings = [
//       'Naufil Nadeem',
//       'Farhan Siddiqui',
//       'Adil Hussain',
//       'Asif Hassan',
//       'Bilal Ahmed',
//     ];
//     List<String> text = [
//       'Consumer ID: 0011',
//       'Consumer ID: 0012',
//       'Consumer ID: 0013',
//       'Consumer ID: 0014',
//       'Consumer ID: 0015',
//     ];
//     List<String> imagetext = ['NN', 'FS', 'AH', 'AS', 'MM'];
//     List<String> Number = ['Rs 2000', 'Rs 2000', 'Rs 2000', 'Rs 2000', 'Rs 2000'];
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0),
//       child: SizedBox(
//         height: isLargeHeight(context) ? screenHeight * 0.44 : (isLowHeight(context) ? screenHeight * 0.38 : null),
//         width: screenWidth,
//         child: Column(
//             children: [
//         Expanded(
//         child: ListView.builder(
//         padding: const EdgeInsets.all(0.0),
//         scrollDirection: Axis.vertical,
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               Container(
//                 height: 80.0,
//                 margin: const EdgeInsets.symmetric(vertical: 10.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10.0),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0x10000000),
//                       offset: Offset(1.0, 0.0),
//                       blurRadius: 3.5,
//                       spreadRadius: 1.5,
//                     ),
//                   ],
//                 ),
//                   child: Row(
//                     children: [
//                       Stack(
//                         children: [
//                           Image.asset(
//                             'assets/images/red.png',
//                             width: screenWidth / 8,
//                             height: 80.0,
//                           ),
//                           Positioned(
//                             top: 30,
//                             left: 15,
//                             child: Text(
//                               imagetext[index],
//                               style: ThemeTextStyle.robotored,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 20.0),
//                                 child: Text(
//                                   headings[index],
//                                   style: ThemeTextStyle.sF.copyWith(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 10.0),
//                                 child: Text(
//                                   text[index],
//                                   style: ThemeTextStyle.sF.copyWith(
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.grey,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(3.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text(
//                                   Number[index],
//                                   style: ThemeTextStyle.sF.copyWith(
//                                     fontWeight: FontWeight.w900,
//                                     color: Colors.red,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pushReplacementNamed(context, '/pay');
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: GeneralThemeStyle.niull,
//                                     minimumSize: Size(50.0, 20.0), // Adjust width and height as needed
//                                   ),
//                                   child: Text(
//                                     'Pay Now',
//                                     style: ThemeTextStyle.sF.copyWith(
//                                       fontSize: 8,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//
//                     ],
//
//                   ),
//
//                 ),
//
//               ],
//             );
//           },
//         ),
//       ),
//     ],
//       ),
//       )
//     );
//   }
// }


























// class ContainerList extends StatelessWidget {
//   const ContainerList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//
//     List<String> headings = [
//       'Naufil Nadeem',
//       'Farhan Siddiqui',
//       'Adil Hussain',
//       'Asif Hassan',
//       'Bilal Ahmed',
//     ];
//     List<String> text = [
//       'Consumer ID: 0011',
//       'Consumer ID: 0012',
//       'Consumer ID: 0013',
//       'Consumer ID: 0014',
//       'Consumer ID: 0015',
//     ];
//     List<String> imagetext = [
//       'NN',
//       'FS',
//       'AH',
//       'AS',
//       'MM',
//     ];
//     List<String> Number = [
//       'Rs 2000',
//       'Rs 2000',
//       'Rs 2000',
//       'Rs 2000',
//       'Rs 2000',
//     ];
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0),
//       child: Container(
//
//         height:screenHeight*0.40,
//         width: screenWidth,
//         child: ListView.builder(
//           padding: EdgeInsets.all(0.0),
//           scrollDirection: Axis.vertical,
//           itemCount: 5,
//           itemBuilder: (context, index) {
//             return Container(
//               height: 80.0, // Adjust the height as needed
//               margin: const EdgeInsets.symmetric(vertical: 10.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0x10000000),
//                     offset: Offset(2.0, 0.0),
//                     blurRadius: 10.5,
//                     spreadRadius:4.5,
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   Image.asset(
//                     'assets/images/red.png',
//                     width: screenWidth / 8,
//                     height: 80.0,
//                   ),
//                   Positioned(
//                     top: 30,
//                     left: 0,
//                     right: 320,
//                     child: Center(
//                       child: Text(
//                         imagetext[index], // You can customize this text if needed
//                         style: ThemeTextStyle.robotored,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: screenWidth / 1.5,
//                     child: Stack(
//                       children: [
//                         Positioned(
//                           top: 10,
//                           bottom: 0,
//                           left: 65,
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 0),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 12.0),
//                               child: Text(
//                                 headings[index],
//                                 style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 20,
//                           left: 65,
//                           child: Container(
//                             child: Text(
//                               text[index],
//                               style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 10),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//
//                   Positioned(
//                     top: 0,
//                     left: 250,
//                     right: 00,
//                     bottom: 40,
//                     child: Center(
//                       child: Text(
//                         Number[index],
//                         style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w900, color: Colors.red, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     right: 10,
//                     width: screenWidth / 5,
//                     height: 20.0,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/pay');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: GeneralThemeStyle.niull,
//                       ),
//                       child: Text(
//                         'Pay Now',
//                         style: ThemeTextStyle.sF.copyWith(fontSize: 8, color: Colors.black),
//                       ),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
