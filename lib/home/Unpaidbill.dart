import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Controller/Network_Conectivity.dart';
import '../appData/ThemeStyle.dart';
import '../appData/dailogbox.dart';
import '../appData/masking.dart';
import 'NavigationBar.dart';


class Unpaid  extends StatefulWidget {
  const Unpaid ({super.key});

  @override
  _UnpaidState createState() => _UnpaidState();
}

class _UnpaidState extends State<Unpaid > {
  bool notification = true;
  String imgNotifyUrl = "assets/images/Notification.png";
  List<dynamic> UnpaidBill  = [];
  bool spinner = true;
  List<dynamic> filteredUnpaidBill = [];




  @override
  void initState() {
    super.initState();
    fetchUnpaidBill();
    Get.find<NetworkController>().registerPageReloadCallback('/unpaid', _reloadPage);
  }

  @override
  void dispose() {
    Get.find<NetworkController>().unregisterPageReloadCallback('/unpaid');
    super.dispose();
  }

  void _reloadPage() {

    fetchUnpaidBill();
  }
  final TextEditingController Search = TextEditingController();

  Future<List<dynamic>> fetchUnpaidBill() async {
    Completer<bool> showDialogCompleter = Completer<bool>();
    void refreshunPaid(BuildContext context) {
      showDialogCompleter = Completer<bool>();

      Navigator.pushReplacementNamed(context, '/unpaid');
    }

    Future.delayed(Duration(seconds: AuthData.timer), () {
      if (spinner && !showDialogCompleter.isCompleted) {
        showDialogCompleter.complete(true);
        reload_Dailough(context, "", "",refreshunPaid);
      }
    });
    UnpaidBill = await AuthData.fetchGetUnpaidBill();
    if (!showDialogCompleter.isCompleted) {
      showDialogCompleter.complete(false);
    }

    setState(() {
      spinner = false;
    });

    return UnpaidBill;
  }





  @override
  void didUpdateWidget(covariant Unpaid  oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
  }
  void filterUnpaidBill(String query) {
    setState(() {
      if (query.isNotEmpty){
        filteredUnpaidBill = UnpaidBill.where((bill) {
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
        filteredUnpaidBill = [];
      }
    });
  }


  Widget ListData(i, screenWidth, screenHeight) {
    if (UnpaidBill.isEmpty || i >= UnpaidBill.length) {
      return SizedBox(
        width: screenWidth,
        child: const Text("No Record Found!"),
      );
    }

    String amount = UnpaidBill[i]['amount']?.toString() ?? "";
    String customerName = UnpaidBill[i]['customer_name']?.toString() ?? "";
    String business = UnpaidBill[i]['business_name']?.toString() ?? "";
    String isBenificaryString = UnpaidBill[i]['is_user_beneficiary']?.toString() ?? "";
    String paymentCode = UnpaidBill[i]['payment_code']?.toString() ?? "";
    String ConsumerCode = UnpaidBill[i]['full_consumer_code']?.toString() ?? "";
    String dueDate = UnpaidBill[i]['duedate']?.toString() ?? "";


    if (dueDate.isEmpty) {
      return Container(
        width: screenWidth,
        height: 200,
        decoration: const BoxDecoration(
        ),
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.cancel,color: Color(0xffEE6724),size: 30),
            Container(
              margin: const EdgeInsets.only(left: 10),
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

    bool isBenificary = isBenificaryString.toLowerCase() == 'true';
    double fontSize = screenWidth <= 360 ? 9 : 11;

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

    Future<void> Remove() async {
      await AuthData.RemoveBenificary(AuthData.regMobileNumber, AuthData.Consumer);
    }

    return GestureDetector(
      onTap: () {
        pay();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Container(
          height: 154.0,
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
              ]
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
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              getInitials(customerName),
                              style: ThemeTextStyle.roboto,
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
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              customerName,
                              style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 13),
                            ),
                          ),
                          if (ConsumerCode.isNotEmpty)
                            Text(
                              '100333$ConsumerCode',
                              style: ThemeTextStyle.sF.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                          if (ConsumerCode.isEmpty)
                            Text(
                              '100333$paymentCode',
                              style: ThemeTextStyle.sF.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),


                          Text(
                            business,
                            style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Due Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(dueDate))}',
                            style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isBenificary)
                            Column(
                              children: [
                                Material(
                                  elevation: 0,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Warning",style: TextStyle(fontWeight: FontWeight.w900),),
                                            content: const Text("Are you sure you want to remove this beneficiary?"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  AuthData.Consumer = ConsumerCode;
                                                  Remove();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext context) => const Unpaid(),
                                                    ),
                                                  );
                                                },
                                                child:  const Text("Yes",style:TextStyle(color:Colors.orange)),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("No",style:TextStyle(color:Colors.orange)),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Remove',
                                      style: ThemeTextStyle.generalSubHeading3.copyWith(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
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
                                  style: ThemeTextStyle.sF.copyWith(fontWeight: FontWeight.w600, color: Colors.redAccent, fontSize: fontSize),
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
                              pay();
                            },
                            child: Text(
                              'Pay Now',
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("didUpdateWidget: notification = $notification");

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/dashboard');
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
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed:() {
                                            Navigator.push(
                                              context,
                                                Navigator.pushReplacementNamed(context, '/dashboard') as Route<Object?>
                                            );
                                          },
                                        ),
                                        const Text(
                                          'Unpaid Bills',
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
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: Search,

                                onChanged: (value) {
                                  filterUnpaidBill(value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: const Icon(Icons.search),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (Search.text.isNotEmpty)

                              if (filteredUnpaidBill.isNotEmpty)
                                Column(
                                  children: filteredUnpaidBill.map((bill) {
                                    return ListData(
                                      UnpaidBill.indexOf(bill),
                                      screenWidth,
                                      screenHeight,
                                    );
                                  }).toList()
                                  // else if (paidBil
                                )
                              else
                                SizedBox(
                                  width: screenWidth,
                                  child: const Text("No Record Found!"),
                                ),


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
                                itemCount: UnpaidBill.length,
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
