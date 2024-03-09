import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../appData/ApiData.dart';
import '../../appData/AuthData.dart';
import '../../appData/ThemeStyle.dart';
import '../../appData/dailogbox.dart';
import '../../appData/masking.dart';
import '../../home/ProfileSection.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import '../../web_view/webView.dart';
import 'TransactionScreen.dart';
import 'TransactionScreenWallet.dart';

class PayBill extends StatefulWidget {
  const PayBill({super.key});

  @override
  _PayBillState createState() => _PayBillState();
}

class _PayBillState extends State<PayBill> {

  bool isInvoiceDownloaded = false;
  bool payNow = false;
  bool notification = true;
  TextEditingController billController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController invoiceamountController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  String imgNotifyUrl = "assets/images/Notification.png";
  String dataImageUrl = "";
  bool isChecked = false;
  bool initialLoad = true;
  bool noRecordFound = true;
  Map<String, dynamic> searchedInvoices = {};
  final SearchController searchController = SearchController();
  bool spinner = false;
  String recordValidator = "";
  String InvoiceStatus = "";
  String InvoicePaidDate = "";
  String InvoicePaidTime = "";
  Future<Map<String, dynamic>> fetchSearchInvoice() async {
    setState(() {
      spinner = true;
    });
    String searchId = searchController.text;
    if(searchId!=""){
      var data = await ApiData.getAllSearchedInvoices(searchId);
      searchedInvoices = data;
      if(searchedInvoices.length>4){
        ApiData.paymentCred = searchedInvoices["payment_api_key"]["credentials"];
        billController.text = searchedInvoices["transaction_charges"]["one_bill_charges"].toString();
        invoiceamountController.text = searchedInvoices["transaction_charges"]["invoice_amount"].toString();
        dateController.text = searchedInvoices["invoice_data"]["duedate1"].toString();
        customerController.text = searchedInvoices["invoice_data"]["customer_name"].toString();
        nicknameController.text = searchedInvoices["invoice_data"]["short_name"].toString();
        businessController.text = searchedInvoices["invoice_data"]["business_name"].toString();
        dataImageUrl = searchedInvoices["invoice_data"]["company_logo_path"].toString();
        recordValidator = searchedInvoices["transaction_charges"]["message"].toString();
        InvoiceStatus = searchedInvoices["invoice_data"]["invoice_status"].toString();
        if(InvoiceStatus=="PAID"){
          InvoicePaidDate = ApiData.dateTimeConverter(searchedInvoices["invoice_data"]["paid_on"].toString(),"date")!;
          InvoicePaidTime = ApiData.dateTimeConverter(searchedInvoices["invoice_data"]["paid_on"].toString(),"time")!;
        }

      }
      if(searchedInvoices["invoice_data"]["status"]==null || searchedInvoices["invoice_data"]["status"]==false){
        setState(() {
          noRecordFound=false;
          initialLoad = false;
        });
      }else {
        setState(() {
          noRecordFound=true;
        });
      }
      setState(() {
        spinner = false;
        initialLoad = false;
      });
      print(noRecordFound);
      print(searchedInvoices["invoice_data"]["status"]);
      return searchedInvoices;
    }else {
      setState(() {
        spinner = false;
        initialLoad = false;
      });
      throw("Error! User Search ID is Null");
    }
  }
  Future <void> Benificary()async{
    await AuthData.Addbeneficary(AuthData.regMobileNumber,customerController.text, searchedInvoices["invoice_data"]["full_consumer_code"].toString(),context);
  }

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  //
  @override
  void initState(){
    super.initState();
    searchedInvoices['routeKey']="";
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
  void didUpdateWidget(covariant PayBill oldWidget) {
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
                                    // Future.delayed(Duration(milliseconds: 1), () {
                                    setState(() {
                                      notification = !notification;
                                      _showDialog2(context);

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

                      // Profile Section
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
                                print("unpaid bill");
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

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                    width: screenWidth,
                                    height: 50,
                                    //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                                    child: TextFormField(
                                      controller: searchController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        labelText: 'Search Invoices',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: GeneralThemeStyle.button, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(0),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(0)
                                          ),
                                          borderSide: BorderSide(
                                              color: GeneralThemeStyle.output, width: 1.0),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          backgroundColor: Color(0xffEE6724),
                                          textStyle: const TextStyle(
                                              fontSize: 17,
                                              color: Color(0xff000000)),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(0),
                                                  bottomRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(0)
                                              )),
                                        ),
                                        onPressed: () {
                                          fetchSearchInvoice();
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          payNow=false;
                                        },
                                        child: const Icon(Icons.search, color: Color(0xffffffff),)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if(noRecordFound!=true)
                        Column(
                          children: [
                            Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0x30000000),width: 1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      dataImageUrl != "null"
                                          ? Container(width:130,child: Image.network(dataImageUrl))
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(right: 8),
                                              child: Icon(Icons.report_gmailerrorred_outlined,size: 30,)
                                          ),
                                          Text("Logo Unavailable"),
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            FileDownloader.downloadFile(
                                              url: searchedInvoices["invoice_data"]["invoice_link"].trim(),
                                              name: "Blinq_Invoice".trim(),
                                              downloadDestination: DownloadDestinations.publicDownloads,
                                              onDownloadCompleted: (String path) async {
                                                try{
                                                  print('FILE DOWNLOADED TO PATH: $path');
                                                  setState(() {
                                                    isInvoiceDownloaded=true;
                                                  });
                                                }catch(e){print(e);}
                                              },
                                              onDownloadError: (String error) {
                                                print('DOWNLOAD ERROR: $error');
                                              },
                                            );
                                          },
                                          child: Text("Download Invoice",style: TextStyle(fontSize: 13),)
                                      ),

                                    ],
                                  ),


                                  if(isInvoiceDownloaded==true)
                                    Countdown(
                                      seconds: 5,
                                      build: (BuildContext context, double time) =>
                                          Container(
                                            width: screenWidth,
                                            child: ListTile(
                                              leading: const Icon(Icons.download,color: Colors.green,size: 30),
                                              title: const Text(
                                                'Blinq_Invoice downloaded to Download folder.',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color:  Color(0x80000000),
                                                  fontSize: 12,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {
                                                  // txt = 'List Tile pressed';
                                                });
                                              },
                                            ),
                                          )
                                      ,
                                      interval: Duration(milliseconds: 100),
                                      onFinished: () {
                                        setState(() {
                                          isInvoiceDownloaded = false;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),


                            Container(
                              width: screenWidth,
                              child: Column(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0x30000000),width: 1),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.perm_identity_outlined,color: InvoiceStatus=="UNPAID" ? Color(0xffEE6724) : Colors.green,size: 30),
                                      title: const Text(
                                        'Consumer Code',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchedInvoices["invoice_data"]["full_consumer_code"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      trailing: Text("Tap to Copy Code",style: TextStyle(color: Color(0x90000000)),),
                                      selected: true,
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(text: searchedInvoices["invoice_data"]["full_consumer_code"].toString()));
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
                                      leading: Icon(Icons.perm_identity_outlined,color: InvoiceStatus=="UNPAID" ? Color(0xffEE6724) : Colors.green,size: 30),
                                      title: const Text(
                                        'Customer Name',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchedInvoices["invoice_data"]["customer_name"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () {
                                        setState(() {
                                          // txt = 'List Tile pressed';
                                        });
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
                                      leading: Icon(Icons.business,color: InvoiceStatus=="UNPAID" ? Color(0xffEE6724) : Colors.green,size: 30),
                                      title: const Text(
                                        'Business Name',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchedInvoices["invoice_data"]["business_name"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () {
                                        setState(() {
                                          // txt = 'List Tile pressed';
                                        });
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
                                      leading: Icon(Icons.mobile_friendly,color: InvoiceStatus=="UNPAID" ? Color(0xffEE6724) : Colors.green,size: 30),
                                      title: const Text(
                                        'Customer Mobile',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchedInvoices["invoice_data"]["customer_mobile1"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () {
                                        setState(() {
                                          // txt = 'List Tile pressed';
                                        });
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
                                      leading: InvoiceStatus=="PAID" ? Icon(Icons.check_circle_outline_rounded,color: Colors.green,size: 30) : Icon(Icons.cancel_outlined,color: Colors.red,size: 30),
                                      title: const Text(
                                        'Invoice Status',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchedInvoices["invoice_data"]["invoice_status"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () {
                                        setState(() {
                                          // txt = 'List Tile pressed';
                                        });
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
                                      leading: InvoiceStatus=="PAID" ? Icon(Icons.code,color: Colors.green,size: 30) : Icon(Icons.code,color: Color(0xffEE6724),size: 30),
                                      title: const Text(
                                        'Payment Code',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color:  Color(0x80000000),
                                          fontSize: 14,
                                          height: 1.7,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: Text(
                                        searchedInvoices["invoice_data"]["payment_code"].toString(),
                                        style: ThemeTextStyle.searchInvoiceListInfo,
                                      ),
                                      selected: true,
                                      onTap: () {
                                        setState(() {
                                          // txt = 'List Tile pressed';
                                        });
                                      },
                                    ),
                                  ),
                                  if (InvoiceStatus == "UNPAID")
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(color: Color(0x30000000), width: 1),
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: const Icon(Icons.calendar_today_rounded, color: Color(0xffEE6724), size: 30),
                                            title: const Text(
                                              'Due Date',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Color(0x80000000),
                                                fontSize: 14,
                                                height: 1.7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            subtitle: Text(
                                              searchedInvoices["invoice_data"]["duedate1"].toString(),
                                              style: ThemeTextStyle.searchInvoiceListInfo,
                                            ),
                                            selected: true,
                                            onTap: () {
                                              setState(() {
                                                // txt = 'List Tile pressed';
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(color: Color(0x30000000), width: 1),
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: const Icon(Icons.receipt, color: Color(0xffEE6724), size: 30),
                                            title: const Text(
                                              'Invoice Amount',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Color(0x80000000),
                                                fontSize: 14,
                                                height: 1.7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            subtitle: Text(
                                              searchedInvoices["transaction_charges"]["invoice_amount"].toString(),
                                              style: ThemeTextStyle.searchInvoiceListInfo,
                                            ),
                                            selected: true,
                                            onTap: () {
                                              setState(() {
                                                // txt = 'List Tile pressed';
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(color: Color(0x30000000), width: 1),
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: const Icon(Icons.newspaper, color: Color(0xffEE6724), size: 30),
                                            title: const Text(
                                              '1 Bill Payable Amount',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Color(0x80000000),
                                                fontSize: 14,
                                                height: 1.7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            subtitle: Text(
                                              searchedInvoices["transaction_charges"]["one_bill_payable_amount"].toString(),
                                              style: ThemeTextStyle.searchInvoiceListInfo,
                                            ),
                                            selected: true,
                                            onTap: () {
                                              setState(() {
                                              });
                                            },
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Padding(
                                        //       padding: const EdgeInsets.only(left:6.50),
                                        //       child: Checkbox(
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius: BorderRadius.circular(5),
                                        //         ),
                                        //         value: isChecked,
                                        //         onChanged: (value) {
                                        //           setState(() {
                                        //             isChecked = value!;
                                        //           });
                                        //         },
                                        //         activeColor: GeneralThemeStyle.button,
                                        //       ),
                                        //     ),
                                        //     RichText(
                                        //       text: TextSpan(
                                        //         text: 'To add this as a ',
                                        //         style: ThemeTextStyle.generalSubHeading3
                                        //             .apply(color: Colors.black),
                                        //         children: <TextSpan>[
                                        //           TextSpan(
                                        //             text: 'Benificary',
                                        //             style: ThemeTextStyle.generalSubHeading3
                                        //                 .apply(color: Colors.orange[900]),
                                        //             // recognizer: TapGestureRecognizer(),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),

                                  if(InvoiceStatus=="PAID")
                                    Column(
                                      children: [
                                        Container(
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(color: Color(0x30000000),width: 1),
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: Icon(Icons.date_range,color: Colors.green,size: 30),
                                            title: const Text(
                                              'Paid Date',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color:  Color(0x80000000),
                                                fontSize: 14,
                                                height: 1.7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            subtitle: Text(
                                              InvoicePaidDate,
                                              style: ThemeTextStyle.searchInvoiceListInfo,
                                            ),
                                            selected: true,
                                            onTap: () {
                                              setState(() {
                                                // txt = 'List Tile pressed';
                                              });
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
                                            leading: Icon(Icons.timelapse_outlined,color: Colors.green,size: 30),
                                            title: const Text(
                                              'Paid Time',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color:  Color(0x80000000),
                                                fontSize: 14,
                                                height: 1.7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            subtitle: Text(
                                              InvoicePaidTime,
                                              style: ThemeTextStyle.searchInvoiceListInfo,
                                            ),
                                            selected: true,
                                            onTap: () {
                                              setState(() {
                                                // txt = 'List Tile pressed';
                                              });
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
                                            leading: Icon(Icons.paid,color: Colors.green,size: 30),
                                            title: const Text(
                                              'Amount Paid',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color:  Color(0x80000000),
                                                fontSize: 14,
                                                height: 1.7,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            subtitle: Text(
                                              searchedInvoices["invoice_data"]["amount_paid"].toString(),
                                              style: ThemeTextStyle.searchInvoiceListInfo,
                                            ),
                                            selected: true,
                                            onTap: () {
                                              setState(() {
                                                // txt = 'List Tile pressed';
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                            Container(height: 30,),


                            if(InvoiceStatus=="UNPAID")
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: screenWidth,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Available Payment Methods",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        if(searchedInvoices["payment_rights"]["is_account_allowed"]==true)
                                          Container(
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Color(0x30000000),width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(Icons.credit_card_outlined,color: Color(0xffEE6724),size: 30),
                                              title: const Text(
                                                'Direct Account Debit',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color:  Colors.black,
                                                  fontSize: 16,
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {
                                                  print(ApiData.paymentCred);
                                                  searchedInvoices['routeKey']="DirectAccountDebit";
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context) =>
                                                          TransactionScreen(
                                                              paramSearchedInvoices: searchedInvoices
                                                          )
                                                      )
                                                  );
                                                });
                                              },
                                            ),
                                          ),

                                        if(searchedInvoices["payment_rights"]["is_wallet_allowed"]==true)
                                          Container(
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Color(0x30000000),width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(Icons.wallet,color: Color(0xffEE6724),size: 30),
                                              title: const Text(
                                                'Wallets',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color:  Colors.black,
                                                  fontSize: 16,
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {
                                                  searchedInvoices['routeKey']="Wallet";
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context) =>
                                                          TransactionScreenWallet(
                                                              paramSearchedInvoices: searchedInvoices
                                                          )
                                                      )
                                                  );
                                                });
                                              },
                                            ),
                                          ),

                                        if(searchedInvoices["payment_rights"]["is_card_allowed"]==true)
                                          Container(
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Color(0x30000000),width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(Icons.comment_bank_outlined,color: Color(0xffEE6724),size: 30),
                                              title: const Text(
                                                'Credit/Debit',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color:  Colors.black,
                                                  fontSize: 16,
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {
                                                  searchedInvoices['routeKey']="credit/debit";
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context) =>
                                                          webView(
                                                              paramSearchedInvoices: searchedInvoices
                                                          )
                                                      )
                                                  );
                                                });
                                              },
                                            ),
                                          ),

                                        if(searchedInvoices["payment_rights"]["is_internet_mobile_or_otc_allowed"]==true)
                                          Container(
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Color(0x30000000),width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(Icons.mobile_friendly,color: Color(0xffEE6724),size: 30),
                                              title: const Text(
                                                'Internet/Mobile',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color:  Colors.black,
                                                  fontSize: 16,
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {
                                                  searchedInvoices['routeKey']="internet/mobile";
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context) =>
                                                          TransactionScreen(
                                                              paramSearchedInvoices: searchedInvoices
                                                          )
                                                      )
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Row(
                                            children: [
                                              if (searchedInvoices["invoice_data"]["full_consumer_code"] != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 2.50),
                                                  child: Checkbox(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    value: isChecked,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isChecked = value!;
                                                        if (isChecked) {
                                                          // Show a confirmation dialog when the checkbox is checked
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text("Confirmation"),
                                                                content: Text("Are you sure you want to add this beneficiary?"),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed: () {
                                                                      // Close the dialog
                                                                      Navigator.of(context).pop();
                                                                      // Call the Benificary() function
                                                                      Benificary();
                                                                    },
                                                                    child: Text("Yes"),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      // Close the dialog without performing the action
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text("No"),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      });
                                                    },
                                                    activeColor: GeneralThemeStyle.button,
                                                  ),
                                                ),
                                              if (searchedInvoices["invoice_data"]["full_consumer_code"] != null)
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'To add this as a ',
                                                    style: ThemeTextStyle.generalSubHeading3.apply(color: Colors.black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: 'Beneficiary',
                                                        style: ThemeTextStyle.generalSubHeading3.apply(color: Colors.orange[900]),
                                                        // recognizer: TapGestureRecognizer(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          onTap: () {
                                            // Handle onTap logic
                                          },
                                        ),





                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            Container(
                              height: 100,
                            ),
                          ],
                        ),

                      if(initialLoad == false)
                        if(noRecordFound==true)
                          Container(
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
class CustomButton extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.imagePath, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1, // Border width
          ),
        ),
      ),
      child: TextButton(
        onPressed: onPressed, // Use the provided callback function
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath,
                    height: 40,
                    width: screenWidth / 11,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left)
                children: [
                  Text(
                    buttonText,
                    style: ThemeTextStyle.good1.copyWith(
                      color: const Color(0xFF2C4364),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                'How to Pay', // Your additional text
                style: ThemeTextStyle.detailPara.copyWith(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

