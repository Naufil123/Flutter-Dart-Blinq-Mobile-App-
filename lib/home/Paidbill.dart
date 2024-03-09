import 'package:url_launcher/url_launcher.dart';
import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../appData/ThemeStyle.dart';
import '../appData/dailogbox.dart';
import 'NavigationBar.dart';
import 'ProfileSection.dart';

class Paidbill extends StatefulWidget {
  const Paidbill({super.key});

  @override
  _PaidbillState createState() => _PaidbillState();
}

class _PaidbillState extends State<Paidbill> {
  bool notification = true;
  String imgNotifyUrl = "assets/images/Notification.png";
  List<dynamic> paidBill = [];
  bool spinner = true;

  Future<List<dynamic>> fetchPaidBill() async {
    paidBill = await AuthData.fetchGetPaidBill();
    print(paidBill);
    setState(() {
      spinner = false;
    });
    return paidBill;
  }

  @override
  void initState() {
    super.initState();
    fetchPaidBill();
  }

  void _showDialog2(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    Notification3.showAlertDialog(
      context,
      'Successful!',
      'Your ID has been verified \nsuccessfully!',
      screenWidth,
    );
  }

  void _showDialog3(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    FAQ.showAlertDialog(
      context,
      'Successful!',
      'Your ID has been verified \nsuccessfully!',
      screenWidth,
    );
  }

  @override
  void didUpdateWidget(covariant Paidbill oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
  }
  Widget ListData(i, screenWidth, screenHeight) {
    if (paidBill.isEmpty || i >= paidBill.length) {
      return SizedBox(
        width: screenWidth,
        child: const Text("No Record Found!"),
      );
    }

    String amount = paidBill[i]['amount_paid']?.toString() ?? "";
    String customerName = paidBill[i]['customer_name']?.toString() ?? "";
    String PayementCode = paidBill[i]['payment_id']?.toString() ?? "";
    String Download = paidBill[i]['invoice_link']?.toString() ?? "";
    Download = Download.startsWith('http') ? Download : 'http://$Download';
    void _launchDownloadLink() async {
      try {
        if (Download.isNotEmpty) {
          await launch(Download);
        } else {
          print('Download link is null or empty');
        }
      } catch (e) {
        print('Error launching the download link: $e');
      }
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
                    'assets/images/green.png',
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
                        style: ThemeTextStyle.robotogreen,
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
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            PayementCode,
                            style: ThemeTextStyle.sF.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextButton(
                            onPressed: () async {
                              _launchDownloadLink();
                            },
                            style: ButtonStyle(
                              alignment: Alignment.topCenter,
                            ),
                            child: Text(
                              'Download \n\n Invoice',
                              style: ThemeTextStyle.generalSubHeading3.copyWith(fontSize: 9.2,color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w600, color: Colors.green, fontSize: 12),
                  ),
                ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                            child: Text(
                              'Paid',
                              style: ThemeTextStyle.sF.copyWith(fontSize: 11, color: Colors.grey),
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
                    // Header Section

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
                    // Profile Section

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
                                  'Paid Bills',
                                  style: ThemeTextStyle.detailPara,
                                ),
                                // TextButton(
                                //   onPressed: () {
                                //     fetchUnpaidBill();
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
                            itemCount: paidBill.length,
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
                    // unpaidBill.length


                    // Sub-containers
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 0.0),
                    //   child: ContainerList(),
                    // ), // Add this line to include the ContainerList widget
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
                ),),
          ],
        ),

      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }


}
