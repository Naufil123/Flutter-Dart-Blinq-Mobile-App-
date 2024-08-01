import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Controller/Network_Conectivity.dart';
import '../appData/ThemeStyle.dart';
import '../appData/dailogbox.dart';
import '../appData/masking.dart';
import 'NavigationBar.dart';

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
  List<dynamic> filteredpaidBill = [];


  @override
  void initState() {
    super.initState();
    fetchPaidBill();
    Get.find<NetworkController>().registerPageReloadCallback('/paid', _reloadPage);
  }

  @override
  void dispose() {
    Get.find<NetworkController>().unregisterPageReloadCallback('/paid');
    super.dispose();
  }

  void _reloadPage() {
    fetchPaidBill();
  }
  final TextEditingController Search = TextEditingController();
  Future<List<dynamic>> fetchPaidBill() async {
    Completer<bool> showDialogCompleter = Completer<bool>();

    void refreshPaid(BuildContext context) {
      showDialogCompleter = Completer<bool>();

      Navigator.pushReplacementNamed(context, '/paid');
    }

    Future.delayed(Duration(seconds: AuthData.timer), () {
      if (spinner && !showDialogCompleter.isCompleted) {
        showDialogCompleter.complete(true);
        reload_Dailough(context, "", "",refreshPaid);
      }
    });


    paidBill = await AuthData.fetchGetPaidBill();
    if (!showDialogCompleter.isCompleted) {
      showDialogCompleter.complete(false);
    }

    setState(() {
      spinner = false;
    });

    return paidBill;
  }



  @override
  void didUpdateWidget(covariant Paidbill oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
  }
  void filterpaidBill(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredpaidBill = paidBill.where((bill) {
          final lowerCaseQuery = query.toLowerCase();
          final customerName = bill['customer_name']?.toString().toLowerCase() ?? '';
          final paymentCode = bill['payment_code']?.toString().toLowerCase() ?? '';
          final ConsumerCode = bill['full_consumer_code']?.toString().toLowerCase() ?? '';
          if (lowerCaseQuery.startsWith('100333') && lowerCaseQuery.length > 6) {
            final queryWithoutPrefix = lowerCaseQuery.substring(6);
            return customerName.contains(queryWithoutPrefix) ||
                paymentCode.contains(queryWithoutPrefix) ||
                ConsumerCode.contains(queryWithoutPrefix);
          } else {
            return customerName.contains(lowerCaseQuery) ||
                paymentCode.contains(lowerCaseQuery) ||
                ConsumerCode.contains(lowerCaseQuery);
          }
        }).toList();
      } else {
        filteredpaidBill = [];
      }
    });
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
    String business = paidBill[i]['business_name']?.toString() ?? "";
    String paidon = paidBill[i]['paid_on']?.toString() ?? "";
    String paymentId = paidBill[i]['payment_id']?.toString() ?? "";
    String paymentCode = paidBill[i]['payment_code']?.toString() ?? "";
    String ConsumerCode = paidBill[i]['full_consumer_code']?.toString() ?? "";

    String Download = paidBill[i]['invoice_link']?.toString() ?? "";
    if (customerName.isEmpty) {
      return Container(
        width: screenWidth,
        height: 200,
        decoration: BoxDecoration(
          // color: Colors.red
        ),
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel,color: Color(0xffEE6724),size: 30),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: const Text(
                "NO INVOICE FOUND.",
                style: TextStyle(
                  fontFamily: 'Inter',
                  color:  Color(0xff000000),
                  fontSize: 14,
                  height: 1.7,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    }

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
    Future<void> pay() async {
      if (ConsumerCode != "") {
        Navigator.pushReplacementNamed(
          context,
          '/pay',
          arguments: ConsumerCode,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/pay',
          arguments: paymentCode,
        );
      }
    }
    double fontSize = screenWidth <= 360 ? 8 : 9;
    return GestureDetector(
        onTap: () {
          pay();
        },
   child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Container(
        height: 110.0,
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
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            getInitials(customerName),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName,
                                style: ThemeTextStyle.sF.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              if (paymentId.isNotEmpty)
                                Text(
                                  paymentId ,
                                  style: ThemeTextStyle.sF.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )else if (paymentId.isEmpty || ConsumerCode.isNotEmpty)
                                Text(
                                  ConsumerCode ,
                                  style: ThemeTextStyle.sF.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )else Text(
                                  paymentCode ,
                                  style: ThemeTextStyle.sF.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                business,
                                style: ThemeTextStyle.sF.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),



                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child:  Text(
                                  'Paid On: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(paidon))}',
                                  style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),

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
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 7),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {

                              bool textExceedsWidth = constraints.maxWidth < MediaQuery.of(context).size.width;

                              double fontSize = textExceedsWidth ? 12.0 : 12.0;

                              return Text(
                                "RS $amount",
                                style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w600, color: Colors.green, fontSize: fontSize),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            },
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                            minimumSize: Size.zero,
                            backgroundColor: GeneralThemeStyle.niull,
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
                            _launchDownloadLink();
                          },
                          child: Text(
                            'Download',
                            style: ThemeTextStyle.sF.copyWith(fontSize:fontSize, color: Colors.black45),
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
   ),
    );
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
    print("didUpdateWidget: notification = $notification");

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
        // Navigator.of(context).pop();
        return true;
      },
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
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.arrow_back),
                                          onPressed:() {
                                            Navigator.push(
                                                context,
                                                Navigator.pushReplacementNamed(context, '/dashboard') as Route<Object?>
                                            );
                                          },
                                        ),
                                        Text(
                                          'Paid Bills',
                                          style: ThemeTextStyle.detailPara,
                                        ),
                                      ],
                                    )
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/unpaid');
                                        },
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                screenWidth * 0.075),
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
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/pay');
                                      },
                                      child: Material(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              screenWidth * 0.075),
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
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: Search,

                                onChanged: (value) {
                                  filterpaidBill(value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: Icon(Icons.search),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (filteredpaidBill.isNotEmpty)
                              ...filteredpaidBill.map((bill) {
                                return ListData(
                                  paidBill.indexOf(bill),
                                  screenWidth,
                                  screenHeight,
                                );
                              }).toList()

                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                      if (spinner == false)
                        if (Search.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: SizedBox(
                              height: screenHeight * 0.60,
                              width: screenWidth,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(0.0),
                                scrollDirection: Axis.vertical,
                                itemCount: paidBill.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListData(index, screenWidth, screenHeight)
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
              if (spinner == true)
                Positioned(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    color: Colors.black87,
                    child: SpinKitWave(
                      itemBuilder: (_, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? Colors.deepOrangeAccent
                                : Colors.orange,
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