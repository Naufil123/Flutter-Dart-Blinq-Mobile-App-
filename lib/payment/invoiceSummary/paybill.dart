import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/Network_Conectivity.dart';
import '../../appData/ApiData.dart';
import '../../appData/AuthData.dart';
import '../../appData/ThemeStyle.dart';
import '../../appData/dailogbox.dart';
import '../../appData/firebase_api.dart';
import '../../appData/masking.dart';
import '../../home/NavigationBar.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'dart:async';
import '../../web_view/webView.dart';
import 'TransactionInternet-Mobile.dart';
import 'TransactionScreen.dart';
import 'TransactionScreenWallet.dart';
import 'Transactionscreenpayincash.dart';

class PayBill extends StatefulWidget {
  const PayBill({Key? key}) : super(key: key);

  @override
  _PayBillState createState() => _PayBillState();
}

class _PayBillState extends State<PayBill> {
  late String paymentCode;
  late String ConsumerCode;
  bool isInitialized = false;
  final GlobalKey paymentMethodsKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();


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
  late DateTime dueDate;
  late DateTime validDate;
  late DateTime currentDate;



  Future<Map<String, dynamic>> fetchSearchInvoice() async {
    if (searchController.text.length <= 4) {
      Snacksbar.showErrorSnackBar(context, "Invalid Id");
      setState(() {
        spinner = false;
      });
      return {};
    }
    setState(() {
      spinner = true;
    });

    String searchId = searchController.text;
    Completer<bool> showDialogCompleter = Completer<bool>();
    void refreshpay(BuildContext context) {
      showDialogCompleter = Completer<bool>();
      Navigator.pushReplacementNamed(context, '/pay', arguments: searchId);
    }

    Future.delayed(Duration(seconds: AuthData.timer), () {
      if (spinner && !showDialogCompleter.isCompleted) {
        showDialogCompleter.complete(true);
        reload_Dailough(context, "", "", refreshpay);
      }
    });

    if (searchId.isNotEmpty) {
      var data = await ApiData.getAllSearchedInvoices(searchId);
      searchedInvoices = data;


      if (searchedInvoices.containsKey("invoice_data")) {
        String dueDateStr = searchedInvoices["invoice_data"]["duedate"]
            .toString();
        String? isValid = searchedInvoices["invoice_data"]["validity_date"]
            ?.toString();

        if (dueDateStr.isNotEmpty) {
          dueDate = DateTime.tryParse(dueDateStr) ?? DateTime.now();
        } else {
          dueDate = DateTime.now();
        }
        validDate = isValid != null
            ? DateTime.tryParse(isValid) ?? DateTime.now()
            : dueDate;
        currentDate = DateTime.now();

        if (searchedInvoices.length >= 4 &&
            searchedInvoices["invoice_data"]["status"] != "failure") {
          if (searchedInvoices["payment_api_key"]["credentials"] != null) {
            ApiData.paymentCred =
            searchedInvoices["payment_api_key"]["credentials"];
            billController.text =
                searchedInvoices["transaction_charges"]["one_bill_charges"]
                    .toString();
            invoiceamountController.text =
                searchedInvoices["transaction_charges"]["invoice_amount"]
                    .toString();
            dateController.text =
                searchedInvoices["invoice_data"]["duedate"].toString();
            customerController.text =
                searchedInvoices["invoice_data"]["customer_name"].toString();
            nicknameController.text =
                searchedInvoices["invoice_data"]["short_name"].toString();
            businessController.text =
                searchedInvoices["invoice_data"]["business_name"].toString();
            dataImageUrl = searchedInvoices["invoice_data"]["company_logo_path"]
                .toString();
            recordValidator =
                searchedInvoices["transaction_charges"]["message"].toString();
            InvoiceStatus =
                searchedInvoices["invoice_data"]["invoice_status"].toString();
            setState(() {
              spinner = false;
              initialLoad = false;
              noRecordFound = false;
            });
          } else {
            billController.text =
                searchedInvoices["transaction_charges"]["one_bill_charges"]
                    .toString();
            invoiceamountController.text =
                searchedInvoices["transaction_charges"]["invoice_amount"]
                    .toString();
            dateController.text =
                searchedInvoices["invoice_data"]["duedate"].toString();
            customerController.text =
                searchedInvoices["invoice_data"]["customer_name"].toString();
            nicknameController.text =
                searchedInvoices["invoice_data"]["short_name"].toString();
            businessController.text =
                searchedInvoices["invoice_data"]["business_name"].toString();
            dataImageUrl = searchedInvoices["invoice_data"]["company_logo_path"]
                .toString();
            recordValidator =
                searchedInvoices["transaction_charges"]["message"].toString();
            InvoiceStatus =
                searchedInvoices["invoice_data"]["invoice_status"].toString();
          }
          if (InvoiceStatus == "PAID") {
            InvoicePaidDate = ApiData.dateTimeConverter(
                searchedInvoices["invoice_data"]["paid_on"].toString(),
                "date")!;
            InvoicePaidTime = ApiData.dateTimeConverter(
                searchedInvoices["invoice_data"]["paid_on"].toString(),
                "time")!;
          }

          setState(() {
            spinner = false;
            initialLoad = false;
            noRecordFound = false;
          });
        } else {
          setState(() {
            spinner = false;
            initialLoad = false;
            noRecordFound = true;
          });
        }
      } else {
        setState(() {
          spinner = false;
          initialLoad = false;
          noRecordFound = true;
        });
      }
      return searchedInvoices;
    }

    else {
      setState(() {
        spinner = false;
        initialLoad = false;
        noRecordFound = true;
      });
      throw ("Error! User Search ID is Null");
    }
  }

  Future<Map<String, dynamic>> UnpaidSerchInvoice() async {
    Completer<bool> showDialogCompleter = Completer<bool>();
    void refreshpay(BuildContext context) {
      showDialogCompleter = Completer<bool>();

      Navigator.pushReplacementNamed(context, '/pay', arguments: paymentCode);
    }

    Future.delayed(Duration(seconds: AuthData.timer), () {
      if (spinner && !showDialogCompleter.isCompleted) {
        showDialogCompleter.complete(true);
        reload_Dailough(context, "", "", refreshpay);
      }
    });
    setState(() {
      spinner = true;
    });
    String searchId = paymentCode;

    if (searchId.isNotEmpty) {
      var data = await ApiData.getAllSearchedInvoices(searchId);
      searchedInvoices = data;

      if (searchedInvoices.containsKey("invoice_data")) {
        String dueDateStr = searchedInvoices["invoice_data"]["duedate"]
            .toString();
        String? isValid = searchedInvoices["invoice_data"]["validity_date"]
            ?.toString();

        if (dueDateStr.isNotEmpty) {
          // Parse dueDate with time
          dueDate = DateTime.tryParse(dueDateStr) ?? DateTime.now();
        } else {
          dueDate = DateTime.now();
        }

        validDate = isValid != null
            ? DateTime.tryParse(isValid) ?? DateTime.now()
            : dueDate;
        currentDate = DateTime.now().toLocal();
        currentDate =
            DateTime.utc(currentDate.year, currentDate.month, currentDate.day);

        if (searchedInvoices.length >= 4) {
          if (searchedInvoices["payment_api_key"]["credentials"] != null) {
            ApiData.paymentCred =
            searchedInvoices["payment_api_key"]["credentials"];
            billController.text =
                searchedInvoices["transaction_charges"]["one_bill_charges"]
                    .toString();
            invoiceamountController.text =
                searchedInvoices["transaction_charges"]["invoice_amount"]
                    .toString();
            dateController.text =
                searchedInvoices["invoice_data"]["duedate"].toString();
            customerController.text =
                searchedInvoices["invoice_data"]["customer_name"].toString();
            nicknameController.text =
                searchedInvoices["invoice_data"]["short_name"].toString();
            businessController.text =
                searchedInvoices["invoice_data"]["business_name"].toString();
            dataImageUrl = searchedInvoices["invoice_data"]["company_logo_path"]
                .toString();
            recordValidator =
                searchedInvoices["transaction_charges"]["message"].toString();
            InvoiceStatus =
                searchedInvoices["invoice_data"]["invoice_status"].toString();
          } else {
            billController.text =
                searchedInvoices["transaction_charges"]["one_bill_charges"]
                    .toString();
            invoiceamountController.text =
                searchedInvoices["transaction_charges"]["invoice_amount"]
                    .toString();
            dateController.text =
                searchedInvoices["invoice_data"]["duedate"].toString();
            customerController.text =
                searchedInvoices["invoice_data"]["customer_name"].toString();
            nicknameController.text =
                searchedInvoices["invoice_data"]["short_name"].toString();
            businessController.text =
                searchedInvoices["invoice_data"]["business_name"].toString();
            dataImageUrl = searchedInvoices["invoice_data"]["company_logo_path"]
                .toString();
            recordValidator =
                searchedInvoices["transaction_charges"]["message"].toString();
            InvoiceStatus =
                searchedInvoices["invoice_data"]["invoice_status"].toString();
          }
          if (InvoiceStatus == "PAID") {
            InvoicePaidDate = ApiData.dateTimeConverter(
                searchedInvoices["invoice_data"]["paid_on"].toString(),
                "date")!;
            InvoicePaidTime = ApiData.dateTimeConverter(
                searchedInvoices["invoice_data"]["paid_on"].toString(),
                "time")!;
          }

          setState(() {
            spinner = false;
            initialLoad = false;
            noRecordFound = false;
          });
        } else {
          setState(() {
            spinner = false;
            initialLoad = false;
            noRecordFound = true;
          });
        }
      } else {
        setState(() {
          spinner = false;
          initialLoad = false;
          noRecordFound = true;
        });
      }
      return searchedInvoices;
    } else {
      setState(() {
        spinner = false;
      });
      throw ("Error! User Search ID is Null");
    }
  }

  Future <void> Benificary() async {
    await AuthData.Addbeneficary(
        AuthData.regMobileNumber, customerController.text,
        searchedInvoices["invoice_data"]["full_consumer_code"].toString(),
        context);
  }

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  Widget notificationImage(double screenWidth,
      List<Map<String, dynamic>> notification) {
    bool hasUnreadNotification = notification.any((notif) =>
    notif.containsKey('is_read') && !notif['is_read']);
    if (hasUnreadNotification) {
      return Image.asset(
        "assets/images/Notification.png",
        width: screenWidth / 8,
        height: 40.0,
      );
    } else {
      return Image.asset(
        "assets/images/NoNotification.png",
        width: screenWidth / 10,
        height: 40.0,
      );
    }
  }


  //
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final arguments = ModalRoute
          .of(context)
          ?.settings
          .arguments;
      paymentCode = arguments is String ? arguments : "";
      ConsumerCode = arguments is String ? arguments : "";

      if (ConsumerCode.isNotEmpty) {
        UnpaidSerchInvoice();
      } else if (ConsumerCode.isEmpty || paymentCode.isNotEmpty) {
        UnpaidSerchInvoice();
      } else {}


      isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    UnpaidSerchInvoice();
    // fetchSearchInvoice();
    Get.find<NetworkController>().registerPageReloadCallback(
        '/pay', _reloadPage);
  }

  @override
  void dispose() {
    Get.find<NetworkController>().unregisterPageReloadCallback('/pay');
    super.dispose();
  }

  void _reloadPage() {
    UnpaidSerchInvoice();
  }


  @override
  void didUpdateWidget(covariant PayBill oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
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
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
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
                          padding: EdgeInsets.fromLTRB(
                              0, screenHeight * 0.01, 0, 0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            ],
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  '/dashboard') as Route<
                                                  Object?>
                                          );
                                        },
                                      ),
                                      const Text(
                                        'Pay Bills',
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
                                          context, '/paid');
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
                                          'assets/images/paidbill.png',
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
                                      child: TextFormField(
                                        controller: searchController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: ' 1Bill Invoice / Payment ID',
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: GeneralThemeStyle.button,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(0),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(0)
                                            ),
                                            borderSide: BorderSide(
                                                color: GeneralThemeStyle.output,
                                                width: 1.0),
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
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 5),
                                            backgroundColor: Color(0xffEE6724),
                                            textStyle: const TextStyle(
                                                fontSize: 17,
                                                color: Color(0xff000000)),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        10),
                                                    topLeft: Radius.circular(0),
                                                    bottomRight: Radius
                                                        .circular(10),
                                                    bottomLeft: Radius.circular(
                                                        0)
                                                )),
                                          ),
                                          onPressed: () {
                                            fetchSearchInvoice();
                                            FocusScope.of(context).requestFocus(
                                                FocusNode());
                                            payNow = false;
                                          },
                                          child: const Icon(Icons.search,
                                            color: Color(0xffffffff),)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if(noRecordFound != true)
                          Column(
                            children: [
                              Container(
                                width: screenWidth,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0x30000000), width: 1),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              String invoiceUrl = searchedInvoices["invoice_data"]["invoice_link"]
                                                  .trim();
                                              String invoiceName = "Blinq_Invoice"
                                                  .trim();

                                              await FileDownloader.downloadFile(
                                                url: invoiceUrl,
                                                name: invoiceName,
                                                downloadDestination: DownloadDestinations
                                                    .publicDownloads,
                                                onDownloadCompleted: (
                                                    String path) async {
                                                  print(
                                                      'FILE DOWNLOADED TO PATH: $path');
                                                  setState(() {
                                                    isInvoiceDownloaded = true;
                                                  });

                                                  await launch(invoiceUrl);
                                                },
                                                onDownloadError: (
                                                    String error) {
                                                  print(
                                                      'DOWNLOAD ERROR: $error');
                                                },
                                              );
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.download,
                                                color: Color(0xffEE6724),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Download Invoice",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color:  Color(0xffEE6724),
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
if ((dueDate.year > currentDate.year ||
    (dueDate.year == currentDate.year &&
        dueDate.month > currentDate.month) ||
    (dueDate.year == currentDate.year &&
        dueDate.month == currentDate.month &&
        dueDate.day >= currentDate.day)) &&
    InvoiceStatus == "UNPAID")
                                        SizedBox(
                                          width: 110,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              scrollToPaymentMethod();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xffEE6724),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40),
                                              ),
                                            ),
                                            child: const Text(
                                              "Pay Now",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        )

                                      ],
                                    ),

                                    if(isInvoiceDownloaded == true)
                                      Countdown(
                                        seconds: 5,
                                        build: (BuildContext context,
                                            double time) =>
                                            SizedBox(
                                              width: screenWidth,
                                              child: ListTile(
                                                leading: const Icon(
                                                    Icons.download,
                                                    color: Colors.green,
                                                    size: 30),
                                                title: const Text(
                                                  'Blinq_Invoice downloaded to Download folder.',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color(0x80000000),
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
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0x30000000), width: 1),
                                  ),
                                ),
                                // check_circle_outline_rounded
                                child: ListTile(
                                  leading: InvoiceStatus == "PAID" ? Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Colors.green, size: 30) : Icon(
                                      Icons.cancel_outlined, color: Colors.red,
                                      size: 30),
                                  title: const Text(
                                    'Invoice Status',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0x80000000),
                                      fontSize: 14,
                                      height: 1.7,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  subtitle: Text(
                                    searchedInvoices["invoice_data"]["invoice_status"]
                                        .toString(),
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
                                child: Column(
                                  children: [

                                    Container(
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0x30000000),
                                              width: 1),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.perm_identity_outlined,
                                          // Icons.perm_identity_outlined,
                                          color: InvoiceStatus == "UNPAID"
                                              ? Color(0xffEE6724)
                                              : Colors.green,
                                          size: 30,
                                        ),
                                        title: const Text(
                                          '1 Bill Invoice ID',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0x80000000),
                                            fontSize: 14,
                                            height: 1.7,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        subtitle: Text(
                                          (searchedInvoices["invoice_data"]["full_consumer_code"] !=
                                              null
                                              ? '100333' + " " + insertSpaces(
                                              searchedInvoices["invoice_data"]["full_consumer_code"]
                                                  .toString())
                                              : searchedInvoices["invoice_data"]["payment_code"] !=
                                              null
                                              ? '100333' + " " + insertSpaces(
                                              searchedInvoices["invoice_data"]["payment_code"]
                                                  .toString())
                                              : 'No code found'),
                                          style: ThemeTextStyle
                                              .searchInvoiceListInfo,
                                        ),
                                        trailing: const Text(
                                          "Tap to Copy",
                                          style: TextStyle(
                                              color: Color(0x90000000)),
                                        ),
                                        selected: true,
                                        onTap: () async {
                                          String codeToCopy =
                                          searchedInvoices["invoice_data"]["full_consumer_code"] !=
                                              null
                                              ? '100333${searchedInvoices["invoice_data"]["full_consumer_code"]}'
                                              : searchedInvoices["invoice_data"]["payment_code"] !=
                                              null
                                              ? '100333${searchedInvoices["invoice_data"]["payment_code"]}'
                                              : 'No code found';
                                          await Clipboard.setData(
                                              ClipboardData(text: codeToCopy));
                                          Snacksbar.Showmsg(context, "Copied");
                                        },

                                      ),

                                    ),
                                    Container(
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0x30000000),
                                              width: 1),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                            Icons.perm_identity_outlined,
                                            color: InvoiceStatus == "UNPAID"
                                                ? const Color(0xffEE6724)
                                                : Colors.green, size: 30),
                                        title: const Text(
                                          'Customer Name',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0x80000000),
                                            fontSize: 14,
                                            height: 1.7,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        subtitle: searchedInvoices["invoice_data"]["customer_name"] !=
                                            null
                                            ? Text(
                                          searchedInvoices["invoice_data"]["customer_name"]
                                              .toString(),
                                          style: ThemeTextStyle
                                              .searchInvoiceListInfo,
                                        )
                                            : const SizedBox(),

                                        selected: true,

                                      ),
                                    ),
                                    Container(
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0x30000000),
                                              width: 1),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Icon(Icons.business,
                                            color: InvoiceStatus == "UNPAID"
                                                ? const Color(0xffEE6724)
                                                : Colors.green, size: 30),
                                        title: const Text(
                                          'Business Name',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0x80000000),
                                            fontSize: 14,
                                            height: 1.7,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        subtitle: Text(
                                          searchedInvoices["invoice_data"]["business_name"]
                                              .toString(),
                                          style: ThemeTextStyle
                                              .searchInvoiceListInfo,
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
                                          bottom: BorderSide(
                                              color: Color(0x30000000),
                                              width: 1),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Icon(Icons.mobile_friendly,
                                            color: InvoiceStatus == "UNPAID"
                                                ? const Color(0xffEE6724)
                                                : Colors.green, size: 30),
                                        title: const Text(
                                          'Customer Mobile',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0x80000000),
                                            fontSize: 14,
                                            height: 1.7,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        subtitle: searchedInvoices["invoice_data"]["customer_mobile1"] !=
                                            null
                                            ? Text(
                                          searchedInvoices["invoice_data"]["customer_mobile1"]
                                              .toString(),
                                          style: ThemeTextStyle
                                              .searchInvoiceListInfo,
                                        )
                                            : const SizedBox(),
                                        selected: true,

                                      ),
                                    ),

                                    Container(
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0x30000000),
                                              width: 1),
                                        ),
                                      ),

                                    ),
                                    if (InvoiceStatus == "UNPAID")
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            width: screenWidth,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0x30000000),
                                                    width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(
                                                  Icons.calendar_today_rounded,
                                                  color: Color(0xffEE6724),
                                                  size: 30),
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
                                                searchedInvoices["invoice_data"]["duedate"]
                                                    .toString(),
                                                style: ThemeTextStyle
                                                    .searchInvoiceListInfo,
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
                                                bottom: BorderSide(
                                                    color: Color(0x30000000),
                                                    width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(Icons.receipt,
                                                  color: Color(0xffEE6724),
                                                  size: 30),
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
                                                searchedInvoices["transaction_charges"]["invoice_amount"]
                                                    .toString(),
                                                style: ThemeTextStyle
                                                    .searchInvoiceListInfo,
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0x30000000),
                                                    width: 1),
                                              ),
                                            ),

                                          ),

                                        ],
                                      ),

                                    if(InvoiceStatus == "PAID")
                                      Column(
                                        children: [
                                          Container(
                                            width: screenWidth,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0x30000000),
                                                    width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Icon(
                                                  Icons.date_range,
                                                  color: Colors.green,
                                                  size: 30),
                                              title: const Text(
                                                'Paid Date',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(0x80000000),
                                                  fontSize: 14,
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              subtitle: Text(
                                                InvoicePaidDate,
                                                style: ThemeTextStyle
                                                    .searchInvoiceListInfo,
                                              ),
                                              selected: true,
                                              onTap: () {
                                                setState(() {
                                                  // txt = 'List Tile pressed';
                                                });
                                              },
                                            ),
                                          ),
                                          // Container(
                                          //   width: screenWidth,
                                          //   decoration: const BoxDecoration(
                                          //     border: Border(
                                          //       bottom: BorderSide(
                                          //           color: Color(0x30000000),
                                          //           width: 1),
                                          //     ),
                                          //   ),
                                          //   child: ListTile(
                                          //     leading: const Icon(
                                          //         Icons.timelapse_outlined,
                                          //         color: Colors.green,
                                          //         size: 30),
                                          //     title: const Text(
                                          //       'Paid Time',
                                          //       style: TextStyle(
                                          //         fontFamily: 'Inter',
                                          //         color: Color(0x80000000),
                                          //         fontSize: 14,
                                          //         height: 1.7,
                                          //         fontWeight: FontWeight.w400,
                                          //       ),
                                          //     ),
                                          //     subtitle: Text(
                                          //       InvoicePaidTime,
                                          //       style: ThemeTextStyle
                                          //           .searchInvoiceListInfo,
                                          //     ),
                                          //     selected: true,
                                          //     onTap: () {
                                          //       setState(() {
                                          //         // txt = 'List Tile pressed';
                                          //       });
                                          //     },
                                          //   ),
                                          // ),
                                          Container(
                                            width: screenWidth,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0x30000000),
                                                    width: 1),
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: const Text(
                                                '\u20A8',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              title: const Text(
                                                'Amount Paid',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(0x80000000),
                                                  fontSize: 14,
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              subtitle: Text(
                                                searchedInvoices["invoice_data"]["amount_paid"]
                                                    .toString(),
                                                style: ThemeTextStyle
                                                    .searchInvoiceListInfo,
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


                              if ((dueDate.year > currentDate.year ||
                                  (dueDate.year == currentDate.year &&
                                      dueDate.month > currentDate.month) ||
                                  (dueDate.year == currentDate.year &&
                                      dueDate.month == currentDate.month &&
                                      dueDate.day >= currentDate.day)) &&
                                  InvoiceStatus == "UNPAID")


                                Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: screenWidth,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Text("Available Payment Methods",
                                            style: TextStyle(fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                    ),


                                    Container(
                                      width: screenWidth,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [


                                          if(searchedInvoices["payment_rights"]["is_card_allowed"] ==
                                              true)
                                            Container(
                                              width: screenWidth,
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                color: Colors.white,
                                                // Change color to red
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                child: ListTile(
                                                  leading: const Icon(Icons
                                                      .comment_bank_outlined,
                                                      color: Colors.deepOrange,
                                                      size: 30),
                                                  title: const Text(
                                                    'Credit/Debit',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.deepOrange,
                                                      fontSize: 16,
                                                      height: 1.7,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                  selected: true,
                                                  onTap: () {
                                                    setState(() {
                                                      searchedInvoices['routeKey'] =
                                                      "credit/debit";
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  webView(
                                                                      paramSearchedInvoices: searchedInvoices
                                                                  )
                                                          )
                                                      );
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          if(searchedInvoices["payment_rights"]["is_internet_mobile_or_otc_allowed"] ==
                                              true)
                                            Container(
                                              width: screenWidth,
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                color: Colors.white,
                                                // Change color to red
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                child: ListTile(
                                                  leading: const Icon(
                                                      Icons.handshake,
                                                      color: Colors.deepOrange,
                                                      size: 30),
                                                  title: const Text(
                                                    'Pay in Cash ',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.deepOrange,
                                                      fontSize: 16,
                                                      height: 1.7,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                  selected: true,
                                                  onTap: () {
                                                    setState(() {
                                                      searchedInvoices['routeKey'] =
                                                      "DirectAccountDebit";
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  Payincash(
                                                                      paramSearchedInvoices: searchedInvoices
                                                                  )
                                                          )
                                                      );
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),


                                          if(searchedInvoices["payment_rights"]["is_internet_mobile_or_otc_allowed"] ==
                                              true)
                                            Container(
                                              width: screenWidth,
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                color: Colors.white,
                                                // Change color to red
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                child: ListTile(
                                                  leading: const Icon(
                                                      Icons.mobile_friendly,
                                                      color: Colors.deepOrange,
                                                      size: 30),
                                                  title: const Text(
                                                    'Internet Mobile Banking',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.deepOrange,
                                                      fontSize: 16,
                                                      height: 1.7,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                  selected: true,
                                                  onTap: () {
                                                    setState(() {
                                                      searchedInvoices['routeKey'] =
                                                      "DirectAccountDebit";
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  TransactionInternetScreen(
                                                                      paramSearchedInvoices: searchedInvoices
                                                                  )
                                                          )
                                                      );
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          if(searchedInvoices["payment_rights"]["is_wallet_allowed"] ==
                                              true)
                                            Container(
                                              width: screenWidth,
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                color: Colors.white,
                                                // Change color to red
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                child: ListTile(
                                                  leading: const Icon(
                                                      Icons.wallet,
                                                      color: Colors.deepOrange,
                                                      size: 30),
                                                  title: const Text(
                                                    'Wallets ',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.deepOrange,
                                                      fontSize: 16,
                                                      height: 1.7,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                  selected: true,
                                                  onTap: () {
                                                    setState(() {
                                                      searchedInvoices['routeKey'] =
                                                      "Wallet";
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  TransactionScreenWallet(
                                                                      paramSearchedInvoices: searchedInvoices
                                                                  )
                                                          )
                                                      );
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          if(searchedInvoices["payment_rights"]["is_account_allowed"] ==
                                              true )
                                            Container(
                                              width: screenWidth,
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                color: Colors.white,
                                                // Change color to red
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                                child: ListTile(
                                                  leading: const Icon(Icons
                                                      .credit_card_outlined,
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      size: 30),
                                                  title: const Text(
                                                    'Direct Account Debit ',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                      fontSize: 16,
                                                      height: 1.7,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                  selected: true,
                                                  onTap: () {
                                                    setState(() {
                                                      searchedInvoices['routeKey'] =
                                                      "DirectAccountDebit";
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  TransactionScreen(
                                                                      paramSearchedInvoices: searchedInvoices
                                                                  )
                                                          )
                                                      );
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),


                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              children: [
                                                if (searchedInvoices["invoice_data"]["full_consumer_code"] !=
                                                    null)
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .only(left: 2.50),
                                                      child: Checkbox(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(5),
                                                        ),
                                                        value: isChecked,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isChecked = value!;
                                                            if (isChecked) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (
                                                                    BuildContext context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        "Confirmation"),
                                                                    content: const Text(
                                                                        "Are you sure you want to add this beneficiary?"),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                          Navigator
                                                                              .of(
                                                                              context)
                                                                              .pop();
                                                                          Benificary();
                                                                        },
                                                                        child: const Text(
                                                                          "Yes",
                                                                          style: TextStyle(
                                                                            color: Colors
                                                                                .deepOrange, // Text color
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            isChecked =
                                                                            false;
                                                                          });
                                                                          Navigator
                                                                              .of(
                                                                              context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                          "No",
                                                                          style: TextStyle(
                                                                            color: Colors
                                                                                .deepOrange, // Text color
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          });
                                                        },
                                                        activeColor: GeneralThemeStyle
                                                            .button,
                                                      )
                                                  ),

                                                if (searchedInvoices["invoice_data"]["full_consumer_code"] !=
                                                    null)
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'To add this as a ',
                                                      style: ThemeTextStyle
                                                          .generalSubHeading3
                                                          .apply(
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Beneficiary',
                                                          style: ThemeTextStyle
                                                              .generalSubHeading3
                                                              .apply(
                                                              color: Colors
                                                                  .orange[900]),
                                                          // recognizer: TapGestureRecognizer(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            onTap: () {

                                            },
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              // Container(
                              //   height: 0,
                              // ),
                            ],
                          ),
                        if(initialLoad == false)
                          if(noRecordFound == true)
                            Container(
                              width: screenWidth,
                              height: 200,
                              decoration: const BoxDecoration(
                                // color: Colors.red
                              ),
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                      Icons.cancel, color: Color(0xffEE6724),
                                      size: 30),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Text(
                                      "NO INVOICE FOUND.",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xff000000),
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

              if(spinner == true)
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

  void scrollToPaymentMethod() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}