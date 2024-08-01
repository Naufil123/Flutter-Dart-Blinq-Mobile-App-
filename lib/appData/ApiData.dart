import 'dart:convert';
import 'dart:ui';
import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


// Live URL
//     const siteUrl = "https://mobileapi.blinq.pk/";

// Staging URL
   const siteUrl = "https://staging-mobileapi.blinq.pk/";

class ApiData {

  static String appToken = AuthData.token;
   static String paymentCred = '';
  static String WalletOrder_BLINQ_TRANS_REF_ID = '';
  static Color validatorColor = Colors.black;
  static const String getTop4Announcement = '${siteUrl}api/v2/mobile/announcement/get/by/top/4';
  static const String getPaidInvoicesV2 = '${siteUrl}api/v2/mobile/invoices/get/unpaid';
  static const String getUserProfile = '${siteUrl}api/v2/mobile/user/get/by/username';
  static const String getUnpaidInvoicesV2 = '${siteUrl}api/v2/mobile/invoices/get/unpaid';
  static const String getPaidInvoices = '${siteUrl}api/v2/mobile/invoices/get/paid';
  static const String searchInvoice = '${siteUrl}api/v2/mobile/invoices/search';


  //Old API Data
  // static const String authTokenRequest = '${siteUrl}api/mobile/auth';
  // static const String getUnpaidInvoices = '${siteUrl}api/mobile/invoices/get/unpaid';
  // static const String checkFullConsumerCode = '${siteUrl}api/mobile/consumer/check/fullconsumercode';
  // static const String createUser = '${siteUrl}api/mobile/user/create';
  // static const String userCodeVerificationInsert = '${siteUrl}api/mobile/user/code/verification/insert';
  // static const String userCodeVerificationVerifyCode = '${siteUrl}api/mobile/user/code/verification/verifycode';
  // static const String userCodeVerificationGetCode = '${siteUrl}api/mobile/user/code/verification/get/code';
  // static const String userResetPin = '${siteUrl}api/mobile/user/reset/pin';
  // static const String systemLogging = '${siteUrl}api/mobile/sys/log';
  // static const String apiRequestLogging = '${siteUrl}api/mobile/api-request/log';
  // static const String apiResponseLogging = '${siteUrl}api/mobile/api-response/log';
  // static const String getUserBeneficiaryCsv = '${siteUrl}api/user/beneficiary/get/all/csv';
  // static const String getUserBeneficiaryById = '${siteUrl}api/user/beneficiary/get/by/id';
  // static const String createUserBeneficiary = '${siteUrl}api/user/beneficiary/create';
  // static const String userAuditLogging = '${siteUrl}api/mobile/user/audit/log';
  // static const String loginStatus = '${siteUrl}api/user/login/status';
  // static const String getAppConfigValueByName = '${siteUrl}api/mobile/appconfig/get/by/config/name';
  // static const String sendEmail = '${siteUrl}api/mobile/send/email';
  // static const String sendSMS = '${siteUrl}api/mobile/send/sms';
  // static const String doWallet = '${siteUrl}blinq/api/wallet/payment/rest/service/v1/dw';
  // static const String getInvoiceStatus = '${siteUrl}blinq/api/payment/rest/service/v2/gs';
  // static const String accountValidation = '${siteUrl}blinq/api/account/payment/rest/service/v1/cav';
  // static const String doCard = '${siteUrl}blinq/api/card/payment/rest/service/v1/vm';

  static Map<String, dynamic> directAccountDebitData = {
    "BILL_ID": "",
    "PAYMENT_CODE": "",
    "AMOUNT": "",
    "BILL_DESC": "",
    "EXPIRY_DATE_TIME": "",
    "CUSTOMER_NAME": "",
    "CUSTOMER_EMAIL": "",
    "CUSTOMER_MOBILE": "",
    "ACC_BANK_MNEMONIC": "",
    "ACC_NUMBER": "",
    "CNIC": "",
    "RETURN_URL": "https://ipg.blinq.pk/Home/Payinvoice"
  };

  // Account PAYMENT Data
  static Map<String, dynamic> doAccountPayment = {
    "RETREIVAL_REFERENCE_NO":"",
    "SECURE_HASH":null,
    "TOKEN": "",
    "TRANSACTION_ID": "",
    "BLINQ_TRANS_REF_ID": "",
    "PG_LOGGER_ID": "",
    "PG_CAV_ID": "",
    "OTP": "",
    "BANK_CODE": "",
    "BANK_MNEMONIC": "",
    "PAYMENT_CODE": "",
    "ACCOUNT_NUMBER": "",
    "CNIC": "",
    "AMOUNT": "",
    "ORDER_DATE": "",
    "CUSTOMER_EMAIL": "",
    "CUSTOMER_MOBILE": ""
  };
  static Map<String, dynamic> doAccountPaymentResendOtpData = {
    "amount_to_be_paid": "58.5",
    "blinq_trans_ref_id": "19778158-1928-4ca8-9a31-708b34324bd5",
    "cnic": "4210131715059",
    "bank_mnemonic": "DMO",
    "token": "6f0d78a629b15ba1dba2db1b79589e8d521884643aac3d1017410048f7f12edb",
    "order_date": "2024-02-13",
    "pg_logger_id": "23498",
    "transaction_id": "94f861e7-b010-f1fd-73a7-89b353728399",
    "cav_id": "391",
    "customer_mobile": "03222486053",
    "bank_code": "11",
    "account_number": "123456789",
    "bill_id": "Test Inv05032023-28",
    "payment_code": "00442404300016",
    "customer_email": "farhan.siddiqui@blinq.pk"
  };

  // Wallet PAYMENT Data
  static Map<String, dynamic> doWalletJazzCashData = {
    "BILL_ID": "",
    "PAYMENT_CODE": "",
    "AMOUNT": "",
    "BILL_DESC": "",
    "EXPIRY_DATE_TIME": "",
    "CUSTOMER_NAME": "",
    "CUSTOMER_EMAIL": "",
    "CUSTOMER_MOBILE": "",
    "WALLET_BANK_MNEMONIC": "",
    "WALLET_NUMBER": "",
    "CNIC": "",
    "WALLET_EMAIL": "",
    "RETURN_URL": "https://ipg.blinq.pk/Home/Payinvoice"
  };


  static fetchRequest(req) async {
    final response = await http
        .get(Uri.parse(req));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch Api');
    }
  }

  static postFetchReq(req,param) async {
    final response = await http
        .post(Uri.parse(req),headers: param);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch Param Api');
    }
  }



  static Future<Map<String, dynamic>> getAllSearchedInvoices(searchId) async {
    var headers = {
      'token': appToken,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiData.searchInvoice));
    request.body = json.encode({
      "search_by": searchId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error fetching Add Beneficiary API!");
    }
  }

  static Future<List<dynamic>> fetchGetTop4Announcement() async {
    var headers = {
      'token': AuthData.token,
      'Content-Type': 'application/json'
    };
    final response = await http.post(
        Uri.parse(ApiData.getTop4Announcement),
        headers: headers
    );
    if (response.statusCode == 200) {
      var data =  jsonDecode(response.body);
      // print(data);
      return data['announcement_list'];
    }
    else {
      print(response.reasonPhrase);
      throw Exception("Error! Unable to fetch top 4 announcement!");
    }
  }

  static Future<List<dynamic>> fetchGetUnpaidBill() async {
    var headers = {
      'token': appToken,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiData.getUnpaidInvoicesV2));
    request.body = json.encode({
      "csv_consumercode": "",
      "customer_mobile": "03333473872"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Fetching Unpaid Bill Api!");
    }
  }

  static Future<List<dynamic>> fetchGetPaidBill() async {
    var headers = {
      'token': appToken,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiData.getPaidInvoicesV2));
    request.body = json.encode({
      "csv_consumercode": "02501685008676748,02501685079161034,02501685688115936",
      "customer_mobile": ""
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Fetching Unpaid Bill Api!");
    }
  }

  static Future<Map<String, dynamic>> fetchGetUserProfile() async {
    var headers = {
      'token': appToken,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiData.getUserProfile));
    request.body = json.encode({
      "username": "03222486053"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Fetching GetUserProfile!");
    }
  }

  static Future<Map<String, dynamic>> sendDebitValidation() async {
    var headers = {
      'credentials': paymentCred,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://payments.blinq.pk/blinq/api/account/payment/rest/service/v1/cav'));
    request.body = json.encode(directAccountDebitData);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Sending OTP Req!");
    }
  }

  static Future <Map<String, dynamic>> doAccountPaymentTransaction() async {
    var headers = {
      'credentials': paymentCred,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://payments.blinq.pk/blinq/api/account/payment/rest/service/v1/initiate/transaction'));
    request.body = json.encode(doAccountPayment);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Sending OTP Req!");
    }
  }

  static Future <Map<String, dynamic>> resendOtpAccountPayment() async {
    var headers = {
      'credentials': paymentCred,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://payments.blinq.pk/blinq/api/account/payment/rest/service/v1/cavresend'));
    request.body = json.encode(doAccountPaymentResendOtpData);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Sending OTP Req!");
    }
  }

  static Future <Map<String, dynamic>> doWalletJazzCash() async {
    var headers = {
      'credentials': paymentCred,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://payments.blinq.pk/blinq/api/wallet/payment/rest/service/v1/dw'));
    request.body = json.encode(doWalletJazzCashData);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Sending Wallet Data!");
    }
  }

  static Future <Map<String, dynamic>> getOrderStatus() async {
    var headers = {
      'credentials': paymentCred,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://payments.blinq.pk/blinq/api/payment/rest/service/v2/gs'));
    request.body = json.encode({
      "BLINQ_TRANS_REF_ID": WalletOrder_BLINQ_TRANS_REF_ID,
      "PAY_VIA": "BLINQ_WALLET"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Sending Wallet Data!");
    }
  }

  static String? dateTimeConverter(dateTimeVar, req){


    var x = dateTimeVar.toString();
    var y = x.split("T");
    var date = y[0];
    var z = y[1].split("Z");
    var time = z[0];

    if(req=="time"){
      return time;
    }
    if(req=="date") {
      return date;
    }

    return null;

  }

}

