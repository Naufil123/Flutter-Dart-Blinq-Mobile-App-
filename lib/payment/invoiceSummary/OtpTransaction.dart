// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../Controller/Network_Conectivity.dart';
import '../../appData/ApiData.dart';
import '../../appData/AuthData.dart';
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

class OtpTransaction extends StatefulWidget {
  Map<String, dynamic> paramPaymentData;
  OtpTransaction(
      {
        Key? key,
        required this.paramPaymentData,
      }
      ):super(key: key);

  @override
  _OtpTransactionState createState() => _OtpTransactionState();
}

class _OtpTransactionState extends State<OtpTransaction> {
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
  TextEditingController OtpController = TextEditingController();

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
    ApiData.doAccountPayment["TOKEN"]=widget.paramPaymentData["token"];
    ApiData.doAccountPayment["TRANSACTION_ID"]=widget.paramPaymentData["transaction_id"];
    ApiData.doAccountPayment["BLINQ_TRANS_REF_ID"]=widget.paramPaymentData["blinq_trans_ref_id"];
    ApiData.doAccountPayment["PG_LOGGER_ID"]=widget.paramPaymentData["pg_logger_id"];
    ApiData.doAccountPayment["PG_CAV_ID"]=widget.paramPaymentData["cav_id"];
    ApiData.doAccountPayment["BANK_CODE"]=widget.paramPaymentData["bank_code"];
    ApiData.doAccountPayment["BANK_MNEMONIC"]=widget.paramPaymentData["bank_mnemonic"];
    ApiData.doAccountPayment["PAYMENT_CODE"]=widget.paramPaymentData["payment_code"];
    ApiData.doAccountPayment["ACCOUNT_NUMBER"]=widget.paramPaymentData["account_number"];
    ApiData.doAccountPayment["CNIC"]=widget.paramPaymentData["cnic"];
    ApiData.doAccountPayment["AMOUNT"]=widget.paramPaymentData["amount_to_be_paid"];
    ApiData.doAccountPayment["ORDER_DATE"]=widget.paramPaymentData["order_date"];
    ApiData.doAccountPayment["CUSTOMER_EMAIL"]="demo@this.com";
    ApiData.doAccountPayment["CUSTOMER_MOBILE"]="00000000000";
    // Get.find<NetworkController>().registerPageReloadCallback('/unpaid', _reloadPage);
  }


  @override
  void dispose() {
    Get.find<NetworkController>().unregisterPageReloadCallback('/unpaid');
    super.dispose();
  }


  @override
  void didUpdateWidget(covariant OtpTransaction oldWidget) {
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
                                      child:  Center(
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
                                    // _showDialog3(context);
                                  },
                                  icon: Image.asset(
                                    'assets/images/help.png',
                                    width: screenWidth * 0.1,
                                    height: screenWidth * 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),


                      ProfileSection(),

                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            width: screenWidth,
                            child: Column(
                              children: [
                                Text("You will receive an OTP in a while.",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),

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
                                              'Enter OTP**',
                                              style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 16),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 05, 0, 0),
                                              child: SizedBox(
                                                width: screenWidth,
                                                height: 52.0,
                                                child: TextFormField(
                                                  controller: OtpController,
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        spinner=true;
                                                        ApiData.validatorColor=Colors.red;
                                                        ErrorSendingOtp="";
                                                      });
                                                      ApiData.doAccountPaymentResendOtpData["amount_to_be_paid"]=widget.paramPaymentData["amount_to_be_paid"];
                                                      ApiData.doAccountPaymentResendOtpData["blinq_trans_ref_id"]=widget.paramPaymentData["blinq_trans_ref_id"];
                                                      ApiData.doAccountPaymentResendOtpData["cnic"]=widget.paramPaymentData["cnic"];
                                                      ApiData.doAccountPaymentResendOtpData["bank_mnemonic"]=widget.paramPaymentData["bank_mnemonic"];
                                                      ApiData.doAccountPaymentResendOtpData["token"]=widget.paramPaymentData["token"];
                                                      ApiData.doAccountPaymentResendOtpData["order_date"]=widget.paramPaymentData["order_date"];
                                                      ApiData.doAccountPaymentResendOtpData["pg_logger_id"]=widget.paramPaymentData["pg_logger_id"];
                                                      ApiData.doAccountPaymentResendOtpData["transaction_id"]=widget.paramPaymentData["transaction_id"];
                                                      ApiData.doAccountPaymentResendOtpData["customer_mobile"]="00000000000";
                                                      ApiData.doAccountPaymentResendOtpData["bank_code"]=widget.paramPaymentData["bank_code"];
                                                      ApiData.doAccountPaymentResendOtpData["account_number"]=widget.paramPaymentData["account_number"];
                                                      ApiData.doAccountPaymentResendOtpData["bill_id"]="";
                                                      ApiData.doAccountPaymentResendOtpData["payment_code"]=widget.paramPaymentData["payment_code"];
                                                      ApiData.doAccountPaymentResendOtpData["customer_email"]="demo@this.com";

                                                      var resendReturnData = await ApiData.resendOtpAccountPayment();
                                                      print(resendReturnData);

                                                      setState(() {
                                                        ApiData.doAccountPayment["TRANSACTION_ID"]=resendReturnData["transaction_id"];

                                                        if(resendReturnData["status"]=="success"){
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext context) => AlertDialog(
                                                              title: Text(resendReturnData['status'] as String),
                                                              content: Text(resendReturnData["message"] as String),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                                                                  child: const Text('Okay'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                        else{
                                                          ErrorSendingOtp=resendReturnData["message"];
                                                        }

                                                        spinner=false;
                                                      });

                                                      print(ApiData.validatorColor);
                                                    },
                                                    child: Text("Resend OTP",style: TextStyle(color: Colors.red),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 20,
                                      ),
                                      Text(ErrorSendingOtp,style: TextStyle(color: ApiData.validatorColor),),
                                      Container(
                                        width: screenWidth,
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                        child: TextButton(
                                          onPressed: () async {
                                            {
                                              setState(() {
                                                ApiData.validatorColor = Colors.red;
                                                spinner=true;
                                              });

                                              ApiData.doAccountPayment["OTP"]=OtpController.text;

                                              var transactionApi = await ApiData.doAccountPaymentTransaction();

                                              if(transactionApi['status']=="success"){
                                                setState(() {
                                                  spinner=false;
                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) => AlertDialog(
                                                      title: Text(transactionApi['status'] as String),
                                                      content: Text(transactionApi['message'] as String),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => Navigator.pushReplacementNamed(context, '/pay'),
                                                          child: const Text('Pay Another'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pushReplacementNamed(context, '/dashBoard'),
                                                          child: const Text('Home'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                              }
                                              if(transactionApi['status']=="failure"){
                                                setState(() {
                                                  spinner=false;
                                                  print(transactionApi["error_desc"]);
                                                  ErrorSendingOtp=transactionApi['error_desc'];
                                                });
                                              }
                                              print("*********************");
                                              print(transactionApi);
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
                                              'Submit',
                                              style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
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