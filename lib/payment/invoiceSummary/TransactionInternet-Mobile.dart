// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../appData/ApiData.dart';
import '../../appData/ThemeStyle.dart';
import '../../appData/dailogbox.dart';
import '../../appData/masking.dart';
import '../../home/ProfileSection.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterme_credit_card/flutterme_credit_card.dart';
import 'dart:async';
import 'dart:io';

import 'OtpTransaction.dart';

class TransactionInternetScreen extends StatefulWidget {
  Map<String, dynamic> paramSearchedInvoices;
  TransactionInternetScreen(
      {
        Key? key,
        required this.paramSearchedInvoices,
      }
      ):super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionInternetScreen> {
  bool spinner = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController number = TextEditingController();
  late TextEditingController validThru = TextEditingController();
  late TextEditingController cvv = TextEditingController();
  late TextEditingController holder = TextEditingController();

  get billController => null;



  bool enterOTP = false;
  String dropdownValueForBankName = "";
  String selectedBankMnemonicKey = "";
  Map<String, dynamic> respPaymentApi = {};

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController cnicController = TextEditingController();




  @override
  void didUpdateWidget(covariant TransactionInternetScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
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
              padding: const EdgeInsets.all(20.0),
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

                          ],
                        ),
                      ),


                      if(widget.paramSearchedInvoices["routeKey"]=="DirectAccountDebit")
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: screenWidth,
                              child: Column(
                                children: [
                                  // +widget.paramSearchedInvoices["invoice_data"]["full_consumer_code"]
                                  Text("Internet Mobile Banking",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),

                                  Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0x30000000),width: 1),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: const Text(
                                        '\u20A8',
                                        style: TextStyle(
                                          color: Color(0xffEE6724),
                                          fontSize: 20,
                                        ),
                                      ),

                                      title: const Text(
                                        'Total Payable Amount',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        widget.paramSearchedInvoices["transaction_charges"]["one_bill_payable_amount"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () async {

                                      },
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0x30000000),width: 1),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: const Text(
                                        '\u20A8', // Unicode character for the Pakistani Rupee symbol
                                        style: TextStyle(
                                          color: Color(0xffEE6724),
                                          fontSize: 20,
                                        ),
                                      ),
                                      title: const Text(
                                        'Invoice Amount',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        widget.paramSearchedInvoices["transaction_charges"]["invoice_amount"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () async {

                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top:28.0),
                                    child: Container(
                                      width: screenWidth,
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40.0),
                                        child: Image.asset(
                                          'assets/images/howtopay.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                          width: screenWidth,
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Color(0x99000000),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Back',
                                                style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                                              ),
                                            ),
                                      ),
                                         ),

                                ],
                              ),
                            ),
                          ],
                        ),



                    ],
                  )
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

    );

  }
}



InputDecoration inputDecoration({
  required String labelText,
  required String hintText,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: GeneralThemeStyle.button, width: 1.0),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
          color: GeneralThemeStyle.output, width: 1.0
      ),
    ),
    labelStyle: const TextStyle(
      color: Colors.grey,
    ),
  );
}