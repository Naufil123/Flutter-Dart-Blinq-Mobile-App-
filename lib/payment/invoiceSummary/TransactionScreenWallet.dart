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

class TransactionScreenWallet extends StatefulWidget {
  Map<String, dynamic> paramSearchedInvoices;
  TransactionScreenWallet(
      {
        Key? key,
        required this.paramSearchedInvoices,
      }
      ):super(key: key);

  @override
  _TransactionScreenWalletState createState() => _TransactionScreenWalletState();
}

class _TransactionScreenWalletState extends State<TransactionScreenWallet> {
  bool spinner = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController number = TextEditingController();
  late TextEditingController validThru = TextEditingController();
  late TextEditingController cvv = TextEditingController();
  late TextEditingController holder = TextEditingController();

  get billController => null;


  static List<String> bankMnemonic = <String>[];
  static List<String> walletName = [];
  String dropdownValueForWalletName = "";
  String selectedWalletMnemonicKey = "";
  Map<String, dynamic> respWalletApi = {};

  TextEditingController walletNumberController = TextEditingController();
  TextEditingController cnicController = TextEditingController();

  getWalletKey(x){
    for(var i=0;i<=walletName.length-1;i++){
      if(x==walletName[i]){
        selectedWalletMnemonicKey=bankMnemonic[i];
      }
    }
  }

  String ErrorSendingWallet = "";


  void collectInitialData(){
    // Customer Email
    if(widget.paramSearchedInvoices["invoice_data"]["customer_email1"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_email1"]==null){
      ApiData.doWalletJazzCashData["CUSTOMER_EMAIL"] = "demo@email.com";
    }else {
      ApiData.doWalletJazzCashData["CUSTOMER_EMAIL"] = widget.paramSearchedInvoices["invoice_data"]["customer_email1"];
    }

    // Customer Mobile
    if(widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"]==null){
      ApiData.doWalletJazzCashData["CUSTOMER_MOBILE"] = "00000000000";
    }else {
      ApiData.doWalletJazzCashData["CUSTOMER_MOBILE"] = widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"];
    }

    // Customer Name
    if(widget.paramSearchedInvoices["invoice_data"]["customer_name"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_name"]==null){
      ApiData.doWalletJazzCashData["CUSTOMER_NAME"] = "Dummy Name";
    }else {
      ApiData.doWalletJazzCashData["CUSTOMER_NAME"] = widget.paramSearchedInvoices["invoice_data"]["customer_name"];
    }

    ApiData.doWalletJazzCashData["BILL_ID"] = widget.paramSearchedInvoices["invoice_data"]["invoice_number"];
    ApiData.doWalletJazzCashData["PAYMENT_CODE"] = widget.paramSearchedInvoices["invoice_data"]["payment_code"];
    ApiData.doWalletJazzCashData["AMOUNT"] = widget.paramSearchedInvoices["transaction_charges"]["invoice_amount"];
    ApiData.doWalletJazzCashData["BILL_DESC"] = widget.paramSearchedInvoices["invoice_data"]["invoice_number"];
    ApiData.doWalletJazzCashData["EXPIRY_DATE_TIME"] = widget.paramSearchedInvoices["invoice_data"]["duedate1"];
    ApiData.doWalletJazzCashData["WALLET_EMAIL"] = "Mohammad.saleem4738@gmail.com";
    ApiData.doWalletJazzCashData["RETURN_URL"] = "https://staging-ipg.blinq.pk/Home/Payinvoice";

  }

  //
  @override
  void initState(){
    super.initState();

    void generateWalletList(){
      bankMnemonic = ['Select Wallet Name'];
      walletName = ['Select Wallet Name'];
      dropdownValueForWalletName = walletName[0];
      for(var i = 0;i<widget.paramSearchedInvoices["wallet_bank"].length;i++){
        var x = widget.paramSearchedInvoices["wallet_bank"][i]["bank_mnemonic"].toString();
        var y = widget.paramSearchedInvoices["wallet_bank"][i]["wallet"].toString();
        bankMnemonic.add(x);
        walletName.add(y);
      }
      print("Below are bank mnemonic");
      print(bankMnemonic);
    }
    generateWalletList();
    collectInitialData();

    // listen to state changes within the form field controllers
    number.addListener(() => setState(() {}));
    validThru.addListener(() => setState(() {}));
    cvv.addListener(() => setState(() {}));
    holder.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant TransactionScreenWallet oldWidget) {
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

                      // Profile Section
                      ProfileSection(),

                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            width: screenWidth,
                            child: Column(
                              children: [
                                Text("Wallet Payment ",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),
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
                                      'Wallet Charges',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color:  Color(0x80000000),
                                        fontSize: 14,
                                        height: 1.7,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Text(
                                      widget.paramSearchedInvoices["transaction_charges"]["wallet_charges"].toString(),
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
                                      'Total Wallet Payable Amount',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color:  Color(0x80000000),
                                        fontSize: 14,
                                        height: 1.7,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Text(
                                      widget.paramSearchedInvoices["transaction_charges"]["wallet_payable_amount"].toString(),
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
                                              'Please Select Wallet',
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
                                                    value: dropdownValueForWalletName,
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.black54),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        dropdownValueForWalletName = value!;
                                                        getWalletKey(dropdownValueForWalletName);
                                                      });
                                                    },
                                                    items: walletName.map<DropdownMenuItem<String>>((String value) {
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
                                              'Wallet Number',
                                              style: ThemeTextStyle.generalSubHeading4.copyWith(fontSize: 16),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 05, 0, 18),
                                              child: SizedBox(
                                                width: screenWidth,
                                                height: 52.0,
                                                child: TextFormField(
                                                  controller: walletNumberController,
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
                                      Container(
                                        height: 20,
                                      ),
                                      Text(ErrorSendingWallet,style: TextStyle(color: ApiData.validatorColor),),
                                      Container(
                                        width: screenWidth,
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                        child: TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              ApiData.validatorColor = Colors.red;
                                              spinner=true;
                                            });
                                            if(selectedWalletMnemonicKey=="Select Wallet Name" || walletNumberController.text == "" || cnicController.text == ""){
                                              setState(() {
                                                ErrorSendingWallet="One or more fields above is empty or Not Selected!";
                                                spinner=false;
                                              });
                                            }else {
                                              setState(() {
                                                ErrorSendingWallet="";
                                              });

                                              ApiData.doWalletJazzCashData["WALLET_NUMBER"] = walletNumberController.text;
                                              ApiData.doWalletJazzCashData["CNIC"] = cnicController.text;
                                              ApiData.doWalletJazzCashData["WALLET_BANK_MNEMONIC"] = selectedWalletMnemonicKey;

                                              var resp_Data = await ApiData.doWalletJazzCash();
                                              respWalletApi = resp_Data;

                                              if(respWalletApi['status']=="failure"){
                                                setState(() {
                                                  ErrorSendingWallet=respWalletApi['error_desc'];
                                                });
                                              }

                                              else if(respWalletApi['status']=="success"){
                                                setState(() {
                                                  ApiData.WalletOrder_BLINQ_TRANS_REF_ID = respWalletApi['blinq_trans_ref_id'];
                                                });

                                                var getOrdData = await ApiData.getOrderStatus();
                                                print(getOrdData);

                                                setState(() {
                                                  ApiData.WalletOrder_BLINQ_TRANS_REF_ID = respWalletApi['blinq_trans_ref_id'];
                                                });

                                                showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: Text(respWalletApi['status'] as String),
                                                    content: Text(respWalletApi['message'] as String),
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
                                              }
                                              else {
                                                ErrorSendingWallet=respWalletApi['message'];
                                              }
                                              setState(() {
                                                spinner=false;
                                              });
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