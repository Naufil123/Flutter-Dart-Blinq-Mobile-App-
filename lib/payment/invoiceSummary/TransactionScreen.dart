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
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterme_credit_card/flutterme_credit_card.dart';
import 'dart:async';
import 'dart:io';

import 'OtpTransaction.dart';

class TransactionScreen extends StatefulWidget {
  Map<String, dynamic> paramSearchedInvoices;
  TransactionScreen(
      {
        Key? key,
        required this.paramSearchedInvoices,
      }
      ):super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool spinner = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController number = TextEditingController();
  late TextEditingController validThru = TextEditingController();
  late TextEditingController cvv = TextEditingController();
  late TextEditingController holder = TextEditingController();

  get billController => null;


  static List<String> bankMnemonic = <String>[];
  static List<String> bankName = [];
  bool enterOTP = false;
  String dropdownValueForBankName = "";
  String selectedBankMnemonicKey = "";
  Map<String, dynamic> respPaymentApi = {};

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController cnicController = TextEditingController();

  getBankKey(x){
    for(var i=0;i<=bankName.length-1;i++){
      if(x==bankName[i]){
        selectedBankMnemonicKey=bankMnemonic[i];
      }
    }
  }

  String ErrorSendingOtp = "";


  //
  @override
  void initState(){
    super.initState();

    void generateBankList(){
      bankMnemonic = ['Select Bank Name'];
      bankName = ['Select Bank Name'];
      dropdownValueForBankName = bankName[0];
      for(var i = 1;i<widget.paramSearchedInvoices["bank_list"].length;i++){
        var x = widget.paramSearchedInvoices["bank_list"][i]["bank_mnemonic"].toString();
        var y = widget.paramSearchedInvoices["bank_list"][i]["bank_name"].toString();
        bankMnemonic.add(x);
        bankName.add(y);
      }
      print("Below are bank mnemonic");
      print(bankMnemonic);
    }


    if(widget.paramSearchedInvoices["routeKey"]=="DirectAccountDebit") {
      generateBankList();
    }

    // listen to state changes within the form field controllers
    number.addListener(() => setState(() {}));
    validThru.addListener(() => setState(() {}));
    cvv.addListener(() => setState(() {}));
    holder.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant TransactionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print("didUpdateWidget: notification = $notification");
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
                            // Row(
                            //   children: [
                            //     Stack(
                            //       children: [
                            //         Image.asset(
                            //           'assets/images/Ellipse3.png',
                            //           width: screenWidth / 6,
                            //           height: screenHeight * 0.1,
                            //         ),
                            //         Positioned(
                            //           top: screenHeight * 0.04,
                            //           left: 0,
                            //           right: 0,
                            //           child: const Center(
                            //             child: Text(
                            //               'NN',
                            //               style: ThemeTextStyle.roboto,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Padding(
                            //           padding: EdgeInsets.only(bottom: screenHeight * 0.004),
                            //           child: Text(
                            //             'Good Morning',
                            //             style: ThemeTextStyle.good1.copyWith(fontSize: 12),
                            //           ),
                            //         ),
                            //
                            //
                            //         const Text('Assalam Walaikum',
                            //           style: ThemeTextStyle.good2,
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {
                            //         // _showDialog3(context);
                            //       },
                            //       icon: Image.asset(
                            //         'assets/images/help.png',
                            //         width: screenWidth * 0.1,
                            //         height: screenWidth * 0.1,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      // Profile Section
                      // ProfileSection(),

                      //Card Details Screen
                      // Container(
                      //   margin: EdgeInsets.only(top: 35),
                      //   width: screenWidth,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text("Card Details",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
                      //     ],
                      //   ),
                      // ),
                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(vertical: 10.0),
                      //       child: Form(
                      //         child: Container(
                      //           width: screenWidth,
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Container(
                      //                 width: screenWidth,
                      //                 child: FMCreditCard(
                      //                   color: Colors.deepPurple,
                      //                   number: number.text,
                      //                   numberMaskType: FMMaskType.first6last2,
                      //                   cvv: cvv.text,
                      //                   cvvMaskType: FMMaskType.full,
                      //                   validThru: validThru.text,
                      //                   validThruMaskType: FMMaskType.none,
                      //                   holder: holder.text,
                      //                 ),
                      //               ),
                      //               Container(
                      //                 margin: const EdgeInsets.all(10),
                      //                 child: Form(
                      //                   key: formKey,
                      //                   child: Column(
                      //                     children: [
                      //                       FMHolderField(
                      //                         controller: holder,
                      //                         cursorColor: Color(0xff000000),
                      //                         decoration: inputDecoration(
                      //                           labelText: "Card Holder",
                      //                           hintText: "John Doe",
                      //                         ),
                      //                       ),
                      //                       const SizedBox(height: 30),
                      //                       FMNumberField(
                      //                         controller: number,
                      //                         cursorColor: Color(0xff000000),
                      //                         decoration: inputDecoration(
                      //                           labelText: "Card Number",
                      //                           hintText: "0000 0000 0000 0000",
                      //                         ),
                      //                       ),
                      //                       const SizedBox(height: 30),
                      //                       Row(
                      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                         children: [
                      //                           Flexible(
                      //                             child: FMValidThruField(
                      //                               controller: validThru,
                      //                               cursorColor: Color(0xff000000),
                      //                               decoration: const InputDecoration(
                      //                                 focusedBorder: OutlineInputBorder(
                      //                                   borderSide: BorderSide(
                      //                                       color: GeneralThemeStyle.button, width: 1.0),
                      //                                 ),
                      //                               enabledBorder: OutlineInputBorder(
                      //                                 borderRadius: BorderRadius.all(Radius.circular(8)),
                      //                                 borderSide: BorderSide(
                      //                                     color: GeneralThemeStyle.output, width: 1.0
                      //                                 ),
                      //                               ),
                      //                                 border: OutlineInputBorder(),
                      //                                 labelStyle: TextStyle(color: Color(0xFF000000)),
                      //                                 labelText: "Valid Thru",
                      //                                 hintText: "****",
                      //                             ),
                      //                             ),
                      //                           ),
                      //                           const SizedBox(width: 10),
                      //                           Flexible(
                      //                             child: FMCvvField(
                      //                               controller: cvv,
                      //                               cursorColor: Color(0xff000000),
                      //                               decoration: inputDecoration(
                      //                                 labelText: "CVV",
                      //                                 hintText: "***",
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(height: 30),
                      //               Container(
                      //                 width: screenWidth,
                      //                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      //                 child: TextButton(
                      //                   onPressed: () {
                      //                     if (formKey.currentState!.validate()) {
                      //                       Map<String,dynamic> cardInfo = {
                      //                         "holder": holder.text,
                      //                         "number": number.text,
                      //                         "validThru": validThru.text,
                      //                         "cvv": cvv.text,
                      //                       };
                      //                       print(cardInfo);
                      //                     }
                      //                   },
                      //                   style: TextButton.styleFrom(
                      //                     backgroundColor: GeneralThemeStyle.button,
                      //                     shape: RoundedRectangleBorder(
                      //                       borderRadius: BorderRadius.circular(40.0),
                      //                     ),
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: Text(
                      //                       'Pay Bill',
                      //                       style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //               Container(
                      //                 width: screenWidth,
                      //                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      //                 child: TextButton(
                      //                   onPressed: () {
                      //                     Navigator.pop(context);
                      //                   },
                      //                   style: TextButton.styleFrom(
                      //                     backgroundColor: Color(0x99000000),
                      //                     shape: RoundedRectangleBorder(
                      //                       borderRadius: BorderRadius.circular(40.0),
                      //                     ),
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     child: Text(
                      //                       'Back',
                      //                       style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 100,
                      //     ),
                      //   ],
                      // ),

                      if(widget.paramSearchedInvoices["routeKey"]=="DirectAccountDebit")
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: screenWidth,
                              child: Column(
                                children: [
                                  // +widget.paramSearchedInvoices["invoice_data"]["full_consumer_code"]
                                  Text("Direct Account Debit",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),

                                  Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0x30000000),width: 1),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.currency_rupee,color: Color(0xffEE6724),size: 30),
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
                                        widget.paramSearchedInvoices["transaction_charges"]["account_payable_amount"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () async {

                                      },
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0x30000000),width: 1),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.currency_rupee,color: Color(0xffEE6724),size: 30),
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
                                  Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0x30000000),width: 1),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.currency_rupee,color: Color(0xffEE6724),size: 30),
                                      title: const Text(
                                        'Debit Account Charges',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        widget.paramSearchedInvoices["transaction_charges"]["account_charges"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () async {

                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                    width: screenWidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 30,
                                        ),
                                        Form(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Please Select Bank',
                                                style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 16),
                                              ),
                                              Container(
                                                width: screenWidth,
                                                height: 52.0,
                                                margin: EdgeInsets.fromLTRB(0,10,0,15),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: GeneralThemeStyle.output, width: 1.0),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      value: dropdownValueForBankName,
                                                      icon: const Icon(Icons.arrow_downward),
                                                      elevation: 16,
                                                      style: TextStyle(color: Colors.black54),
                                                      onChanged: (String? value) {
                                                        setState(() {
                                                          dropdownValueForBankName = value!;
                                                          getBankKey(dropdownValueForBankName);
                                                          print(selectedBankMnemonicKey);
                                                        });
                                                      },
                                                      items: bankName.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Container(
                                                              width: screenWidth/1.5,
                                                              child: Text(value)
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Form(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Account Number',
                                                style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 16),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 05, 0, 18),
                                                child: SizedBox(
                                                  width: screenWidth,
                                                  height: 52.0,
                                                  child: TextFormField(
                                                    controller: accountNumberController,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
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
                                              ),
                                            ],
                                          ),
                                        ),
                                        Form(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'CNIC',
                                                style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 16),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 05, 0, 18),
                                                child: SizedBox(
                                                  width: screenWidth,
                                                  height: 52.0,
                                                  child: TextFormField(
                                                    controller: cnicController,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
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
                                              ),
                                            ],
                                          ),
                                        ),

                                        if(enterOTP==true)
                                          Form(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Enter OTP**',
                                                  style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 16),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 05, 0, 18),
                                                  child: SizedBox(
                                                    width: screenWidth,
                                                    height: 52.0,
                                                    child: TextFormField(
                                                      controller: cnicController,
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
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
                                                ),
                                              ],
                                            ),
                                          ),

                                        Container(
                                          height: 20,
                                        ),
                                        Text(ErrorSendingOtp,style: TextStyle(color: Colors.red),),
                                        Container(
                                          width: screenWidth,
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                          child: TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                spinner=true;
                                              });
                                              if(selectedBankMnemonicKey=="Select Bank Name" || accountNumberController.text == "" || cnicController.text == ""){
                                                setState(() {
                                                  ErrorSendingOtp="One or more fields above is empty or Not Selected!";
                                                  spinner=false;
                                                });
                                              }else {
                                                setState(() {
                                                  ErrorSendingOtp="";
                                                });
                                                // Customer Email
                                                if(widget.paramSearchedInvoices["invoice_data"]["customer_email1"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_email1"]==null){
                                                  ApiData.directAccountDebitData["CUSTOMER_EMAIL"] = "demo@email.com";
                                                }else {
                                                  ApiData.directAccountDebitData["CUSTOMER_EMAIL"] = widget.paramSearchedInvoices["invoice_data"]["customer_email1"];
                                                }

                                                // Customer Mobile
                                                if(widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"]==null){
                                                  ApiData.directAccountDebitData["CUSTOMER_MOBILE"] = "00000000000";
                                                }else {
                                                  ApiData.directAccountDebitData["CUSTOMER_MOBILE"] = widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"];
                                                }

                                                // Customer Mobile
                                                if(widget.paramSearchedInvoices["invoice_data"]["customer_name"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_name"]==null){
                                                  ApiData.directAccountDebitData["CUSTOMER_NAME"] = "Dummy Name";
                                                }else {
                                                  ApiData.directAccountDebitData["CUSTOMER_NAME"] = widget.paramSearchedInvoices["invoice_data"]["customer_name"];
                                                }

                                                ApiData.paymentCred = widget.paramSearchedInvoices["payment_api_key"]["credentials"];
                                                ApiData.directAccountDebitData["BILL_ID"] = widget.paramSearchedInvoices["invoice_data"]["invoice_number"];
                                                ApiData.directAccountDebitData["PAYMENT_CODE"] = widget.paramSearchedInvoices["invoice_data"]["payment_code"];
                                                ApiData.directAccountDebitData["AMOUNT"] = widget.paramSearchedInvoices["transaction_charges"]["invoice_amount"];
                                                ApiData.directAccountDebitData["BILL_DESC"] = widget.paramSearchedInvoices["invoice_data"]["invoice_number"];
                                                ApiData.directAccountDebitData["EXPIRY_DATE_TIME"] = widget.paramSearchedInvoices["invoice_data"]["duedate1"];
                                                ApiData.directAccountDebitData["ACC_BANK_MNEMONIC"] = selectedBankMnemonicKey;
                                                ApiData.directAccountDebitData["ACC_NUMBER"] = accountNumberController.text;
                                                ApiData.directAccountDebitData["CNIC"] = cnicController.text;
                                                ApiData.directAccountDebitData["RETURN_URL"] = "www.google.com";
                                                var resp_Data = await ApiData.sendDebitValidation();
                                                respPaymentApi = resp_Data;
                                                setState(() {
                                                  if(respPaymentApi['status']=="failure"){
                                                    ErrorSendingOtp=respPaymentApi['message'];
                                                  }
                                                  if(respPaymentApi['status']=="success"){
                                                    print(respPaymentApi);
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (context) =>
                                                            OtpTransaction(
                                                                paramPaymentData: respPaymentApi
                                                            )
                                                        )
                                                    );
                                                    enterOTP=false;
                                                  }
                                                  spinner=false;
                                                });
                                                // print(respPaymentApi);
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: GeneralThemeStyle.button,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Send OTP',
                                                style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Send OTP for Wallet
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


// decoration: const InputDecoration(
//   labelText: 'Search Invoices',
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(
//     color: GeneralThemeStyle.button, width: 1.0),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderRadius: BorderRadius.only(
//     topLeft: Radius.circular(10),
//     topRight: Radius.circular(0),
//     bottomLeft: Radius.circular(10),
//     bottomRight: Radius.circular(0)
//   ),
//   borderSide: BorderSide(
//     color: GeneralThemeStyle.output, width: 1.0),
//   ),
//   labelStyle: TextStyle(
//     color: Colors.grey,
//   ),
// ),


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