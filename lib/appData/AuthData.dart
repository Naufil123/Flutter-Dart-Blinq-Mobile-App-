import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'ApiData.dart';
import 'ThemeStyle.dart';
import 'dailogbox.dart';
import 'local_auth.dart';
class AuthData {
  static String apiKey = 'S905TAcU9bD29e48rnCJAsQpwQAqBnZd52OhDZt3BBIvQQQq2j5Uv0wXhstzWfno4jugilAOMXZy2dOzcMlCxw7oU2qAgSZP+G6N3AxD3Lw=';
  static String token ="";
  static const String userRegister = '${siteUrl}api/v2/mobile/user/create';
  static const String userCodeVerificationVerifyCode = '${siteUrl}api/v2/mobile/user/code/verification/verifycode';
  static const String userReSetPINSendOTP = '${siteUrl}api/v2/mobile/user/send/otp/for/reset/pin';
  static const String userReSetPIN = '${siteUrl}api/v2/mobile/user/reset/pin';
  static const String userCodeVerify = '${siteUrl}api/v2/mobile/user/code/verification/verifycode';
  static const String userRegisterResendOtp = '${siteUrl}api/v2/mobile/user/resend/otp/for/register/user';
  static const String userBeneficiaryCreate = '${siteUrl}api/v2/mobile/user/beneficiary/create';
  static const String userAuthenticate = '${siteUrl}api/v2/mobile/user/authenticate';
  static const String FAQs = '${siteUrl}api/v2/mobile/faq/get/all';
  static const String getUnpaidInvoices = '${siteUrl}api/v2/mobile/invoices/get/unpaid';
  static const String getPaidInvoices = '${siteUrl}api/v2/mobile/invoices/get/paid';
  static const String removeBenificary = '${siteUrl}api/v2/mobile/user/beneficiary/remove';
  static String regMobileNumber = "";
  static String isBenificary = "";
  static String Consumer="";
  static Future<void> regUser(username, email, confirmPin, fullName, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',};
    Map<String, dynamic> data = {
      "username": username,
      "email": email,
      "confirm_pin": confirmPin,
      "full_name": fullName,};
    try {
      final response = await http.post(
        Uri.parse(AuthData.userRegister),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String message = responseBody['message'];
        if (message == 'Username/Mobile already exists. Kindly try different') {
          Snacksbar.showErrorSnackBar(
              context, 'Username/Mobile already exists. Kindly try different');
        } else {
          Snacksbar.showSuccessSnackBar(
              context, 'Blinq Mobile App user Successfully Registered');
          Navigator.pushReplacementNamed(
              context, '/reg_otp', arguments: {
            'username': username,
            'email': email,
          });
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static String generateSaltKey() {
    Random random = Random();
    int salt = random.nextInt(900000) + 100000;
    String Saltkey = salt.toString().padLeft(6, '0');
    return Saltkey;
  }
  static String generateHashPin(String saltKey, String password) {
    String saltedPassword = '$saltKey$password';
    var bytes = utf8.encode(saltedPassword);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  static Future <void> regOtpVerification(code, username, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',};
    Map<String, dynamic> data = {
      "username": username,
      "code": code
    };
    try {
      final response = await http.post(
        Uri.parse(AuthData.userCodeVerificationVerifyCode),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String message = responseBody['message'];
        if (message == 'Sorry, the code you entered does not match.') {
          Snacksbar.showErrorSnackBar(
              context, 'Sorry, the code you entered does not match.');
        } else if (message ==
            'Your code has expired as more than 2 minutes have passed. Please request a new code.') {
          Snacksbar.showErrorSnackBar(context,
              'Your code has expired as more than 2 minutes have passed. Please request a new code.');
        } else {
          Snacksbar.showSuccessSnackBar(
              context, 'Code successfully matched and verified');
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<void> forgotPassVerify(username, email, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
      "email": email,};
    try {
      final response = await http.post(
        Uri.parse(AuthData.userReSetPINSendOTP),
        headers: headers,
        body: jsonEncode(data),);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<void> UserCodeVerify(search, code, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "search_by": search,
      "code": code,
    };
    try {
      final response = await http.post(
        Uri.parse(AuthData.userCodeVerify),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
          Navigator.pushReplacementNamed(context, '/otpVerification', arguments: {'mobile': search,},
          );
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<void> userResetPin(username, confirmPin, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
      "confirm_pin": confirmPin
    };
    try {
      final response = await http.post(
        Uri.parse(AuthData.userReSetPIN),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Pin has changed successfully'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Continue'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<void> userRegisterSendOTp(username, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
    };
    try {
      final response = await http.post(
        Uri.parse(AuthData.userRegisterResendOtp),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<void> Addbeneficary(username, beneficiaryName, fullConsumerCode, context) async {
    Map<String, String> headers = {
      'token': token,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
      "beneficiary_name": beneficiaryName,
      "full_consumer_code": fullConsumerCode
    };
    try {
      final response = await http.post(
        Uri.parse(AuthData.userBeneficiaryCreate),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
        }
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }
  static Future<void> Userauthenticate(username, pin, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
      "password_pin": pin,
    };
    AuthData.regMobileNumber = username;
    try {
      final response = await http.post(
        Uri.parse(AuthData.userAuthenticate),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
          if (responseBody.containsKey('token')) {
            String token = responseBody['token'];
            AuthData.token=token;
            print('Received token: $token');

          }
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        }
      } else {
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<void> userBiometricAuthenticate({required String username, required String pin, required BuildContext context, bool useBiometric = false,}) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };


    Map<String, dynamic> data = {
      "username": username,
      "password_pin": pin,
    };
    AuthData.regMobileNumber = username;
    try {
      final response = await http.post(
        Uri.parse(AuthData.userAuthenticate),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];

        if (status == 'failure') {
          Snacksbar.showErrorSnackBar(context, message);
        } else {
          Snacksbar.showSuccessSnackBar(context, message);
          if (responseBody.containsKey('token')) {
            String token = responseBody['token'];
            AuthData.token = token;
            print('Received token: $token');
          }
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        }
      } else {
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
  static Future<List<Map<String, dynamic>>> fetchFAQData() async {
    try {
      final response = await http.post(
        Uri.parse(AuthData.FAQs),
        headers: {
          'token':AuthData.token,
        },
      );
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('faq_list')) {
          final List<Map<String, dynamic>> faqData = List<
              Map<String, dynamic>>.from(
            (responseData['faq_list'] as List<dynamic>).map((item) {
              return {
                'id': item['id'].toString() ?? '',
                'question': item['question'].toString() ?? '',
                'answer': item['answer'].toString() ?? '',};
            }),
          );
          return faqData;
        } else {
          throw Exception(
              'Unexpected response format. Missing "faq_list" key.');
        }
      } else {
        throw Exception(
            'Error fetching FAQ data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching FAQ data: $error');
    }
  }
  static Future<List<dynamic>> fetchGetUnpaidBill() async {
    var headers = {
      'token': AuthData.token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AuthData.getUnpaidInvoices));

    request.body = json.encode({
      "username": AuthData.regMobileNumber
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
      'token': AuthData.token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AuthData.getPaidInvoices));
    request.body = json.encode({
      "username": AuthData.regMobileNumber
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
  static Future<List<dynamic>> RemoveBenificary(username,full_consumer_code) async {
    var headers = {
      'token': AuthData.token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AuthData.removeBenificary));

    request.body = json.encode({
      "username":username,
      "full_consumer_code":full_consumer_code
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var r = await response.stream.bytesToString();
      var data = jsonDecode(r);
      // AuthData.fetchGetUnpaidBill();
      return data;
    }
    else {
      print(response.reasonPhrase);
      throw("Error Fetching Unpaid Bill Api!");
    }
  }

}