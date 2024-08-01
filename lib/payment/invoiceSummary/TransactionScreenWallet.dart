// import 'dart:html';



import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controller/Network_Conectivity.dart';
import '../../appData/ApiData.dart';
import '../../appData/AuthData.dart';
import '../../appData/ThemeStyle.dart';

import '../../appData/masking.dart';
import '../../home/ProfileSection.dart';


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

    if(widget.paramSearchedInvoices["invoice_data"]["customer_email1"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_email1"]==null){
      ApiData.doWalletJazzCashData["CUSTOMER_EMAIL"] = "demo@email.com";
    }else {
      ApiData.doWalletJazzCashData["CUSTOMER_EMAIL"] = widget.paramSearchedInvoices["invoice_data"]["customer_email1"];
    }
    if(widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"]=="" || widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"]==null){
      ApiData.doWalletJazzCashData["CUSTOMER_MOBILE"] = "00000000000";
    }else {
      ApiData.doWalletJazzCashData["CUSTOMER_MOBILE"] = widget.paramSearchedInvoices["invoice_data"]["customer_mobile1"];
    }


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
  Future<void> fetchChargesForWallet() async {
    setState(() {
      if (dropdownValueForWalletName.trim().toLowerCase() == 'select wallet name') {
       widget.paramSearchedInvoices["transaction_charges"]["wallet_charges"] = 0.00;
      } else if (dropdownValueForWalletName.trim().toLowerCase() == 'easypaisa') {
        widget.paramSearchedInvoices["transaction_charges"]["wallet_charges"] = widget.paramSearchedInvoices["transaction_charges"]["ep_wallet_charges"].toString();
      } else if (dropdownValueForWalletName.trim().toLowerCase() == 'jazzcash') {
        widget.paramSearchedInvoices["transaction_charges"]["wallet_charges"] = widget.paramSearchedInvoices["transaction_charges"]["jc_wallet_charges"].toString();
      }
    });
  }



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
    number.addListener(() => setState(() {}));
    validThru.addListener(() => setState(() {}));
    cvv.addListener(() => setState(() {}));
    holder.addListener(() => setState(() {}));
    Get.find<NetworkController>().registerPageReloadCallback('/Wallet', _reloadPage);
  }


  @override
  void dispose() {
    Get.find<NetworkController>().unregisterPageReloadCallback('/Wallet');
    super.dispose();
  }

  void _reloadPage() {

    collectInitialData();
  }

  @override
  void didUpdateWidget(covariant TransactionScreenWallet oldWidget) {
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
  ]
                        ),
                      ),


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
                                    leading: const Text(
                                      '\u20A8', // Unicode character for the Pakistani Rupee symbol
                                      style: TextStyle(
                                        color: Color(0xffEE6724),
                                        fontSize: 20,
                                      ),
                                    ),
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
                                      dropdownValueForWalletName.trim().toLowerCase() == 'easypaisa'
                                          ? widget.paramSearchedInvoices["transaction_charges"]["ep_wallet_payable_amount"].toString()
                                          : dropdownValueForWalletName.trim().toLowerCase() == 'jazzcash'
                                          ? widget.paramSearchedInvoices["transaction_charges"]["jc_wallet_payable_amount"].toString()
                                          : widget.paramSearchedInvoices["transaction_charges"]["invoice_amount"].toString(),


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
                                                    onChanged: (String? value) async {
                                                      setState(() {
                                                        dropdownValueForWalletName = value!;
                                                        getWalletKey(dropdownValueForWalletName);
                                                        fetchChargesForWallet();
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

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 05, 0, 18),
                                              child: SizedBox(
                                                width: screenWidth,
                                                height: 52.0,
                                                child: TextFormField(
                                                  controller: walletNumberController,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters:[maskPhone],
                                                  decoration: InputDecoration(
                                                    labelText: 'Wallet Number',
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

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 05, 0, 18),
                                              child: SizedBox(
                                                width: screenWidth,
                                                height: 52.0,
                                                child: TextFormField(
                                                  controller: cnicController,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters:[CNIC],
                                                  decoration: InputDecoration(
                                                    labelText: 'CNIC',
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
                                                // ErrorSendingWallet="One or more fields above is empty or Not Selected!";
                                                Snacksbar.showErrorSnackBar(
                                                    context, "One or more fields above is empty or Not Selected!");
                                                spinner=false;
                                              });
                                            }else if (selectedWalletMnemonicKey=="Easypaisa" && widget.paramSearchedInvoices["transaction_charges"]["ep_wallet_payable_amount"]- widget.paramSearchedInvoices["transaction_charges"]["ep_wallet_charges"] <="0"){

                                              setState(() {
                                                // ErrorSendingWallet="One or more fields above is empty or Not Selected!";
                                                Snacksbar.showErrorSnackBar(
                                                    context, "Could not proceed to pay ");
                                                spinner=false;
                                              });
                                            }
                                            else if (selectedWalletMnemonicKey=="Easypaisa" &&  widget.paramSearchedInvoices["transaction_charges"]["jc_wallet_payable_amount"]- widget.paramSearchedInvoices["transaction_charges"]["jc_wallet_charges"] <='0'){
                                              setState(() {
                                                // ErrorSendingWallet="One or more fields above is empty or Not Selected!";
                                                Snacksbar.showErrorSnackBar(
                                                    context, "Could not proceed to pay ");
                                                spinner=false;
                                              });
                                            }
                                            else {
                                              setState(() {
                                                // Snacksbar.showErrorSnackBar(
                                                //     context, "");
                                                 ErrorSendingWallet="";
                                              });

                                              ApiData.doWalletJazzCashData["WALLET_NUMBER"] = walletNumberController.text;
                                              ApiData.doWalletJazzCashData["CNIC"] = cnicController.text;
                                              ApiData.doWalletJazzCashData["WALLET_BANK_MNEMONIC"] = selectedWalletMnemonicKey;

                                              var resp_Data = await ApiData.doWalletJazzCash();
                                              respWalletApi = resp_Data;

                                              if(respWalletApi['status']=="failure"){
                                                setState(() {
                                                  Snacksbar.showErrorSnackBar(
                                                      context, respWalletApi['message']);
                                                  // ErrorSendingWallet=respWalletApi['message'];
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
                                                    title: Text(respWalletApi['status'] as String,style: TextStyle(fontWeight: FontWeight.w900),),
                                                    content: Text(respWalletApi['message'] as String),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator.pushReplacementNamed(context, '/pay'),
                                                        child:  const Text('Pay Another',style:TextStyle(color:Colors.orange)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.pushReplacementNamed(context, '/dashBoard'),
                                                        child:  Text('Home',style:TextStyle( color:Colors.orange)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              else {
                                                Snacksbar.showErrorSnackBar(
                                                    context, respWalletApi['message']);
                                                // ErrorSendingWallet=respWalletApi['message'];
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
                                              'Proceed to Pay',
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