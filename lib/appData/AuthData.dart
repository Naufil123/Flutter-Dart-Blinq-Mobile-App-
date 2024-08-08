import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'ApiData.dart';
import 'ThemeStyle.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
class AuthData {
  // Live Api key
  //        static String apiKey ="S905TAcU9bD29e48rnCJAsQpwQAqBnZd52OhDZt3jhewqkjhkbJHJBH99Wfno4jugilAOMXZy2dOzcMlCxw7oU2qAgSZP+G6N3AxD3Lw=";


  // Staging Api key
  static String apiKey = 'S905TAcU9bD29e48rnCJAsQpwQAqBnZd52OhDZt3BBIvQQQq2j5Uv0wXhstzWfno4jugilAOMXZy2dOzcMlCxw7oU2qAgSZP+G6N3AxD3Lw=';
  static String token = "";
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
  static const String fcmDeviceRegister = '${siteUrl}api/v2/mobile/user-device/firebase-id/insert';
  static const String Notification = '${siteUrl}api/v2/mobile/user/get/push-notification';
  static const String Markasread = '${siteUrl}api/v2/mobile/user/push-notification/mark-as-read';
  static const String Updateprofileapi = '${siteUrl}api/v2/mobile/user/profile/update';
  static const String GetprofileData = '${siteUrl}/api/v2/mobile/user/profile/get/by/username';
  static const String profilesendotp = '${siteUrl}/api/v2/mobile/user/send/otp/for/profile/user';
  static String regMobileNumber = "";
  static String val = "";
  static String type = "";

  // static String email = "";
  static String isBenificary = "";
  static String Consumer = "";
  static String regFullName = "";
  static String regemail = "";
  static String Googleemail = "";
  static String Googlepin = "";
  static String Googlecnfrmpin = "";
  static String mobile1 = "";
  static String mobile2 = "";
  static String mobile3 = "";
  static String email1 = "";
  static String email2 = "";
  static String email3 = "";
  static late String biousername = "";
  static late String biopin = "";
  static int unreadCount = 0;
  static int dotcount = 0;
  static int timer = 22;
  static int status = 0;
  static String countforgototp = "";
  static var counter = 0;
  static var time = 0;
  static var signature_id = "";
  static final storage = const FlutterSecureStorage();


  static Future<void> regUser(username, email, confirmPin, fullName,
      loginsource, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',};
    // AuthData.getAppSignature();
    Map<String, dynamic> data = {
      "username": username,
      "email": email,
      "confirm_pin": confirmPin,
      "full_name": fullName,
      "login_source": loginsource,
      "api_signature_id": AuthData.signature_id};
    try {
      final response = await http.post(
        Uri.parse(AuthData.userRegister),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        AuthData.regMobileNumber = username;
        AuthData.regemail = email;
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String message = responseBody['message'];
        final String Status = responseBody['status'];
        if (Status == 'failure' &&
            message == 'Username/Mobile already exists. Kindly try different') {
          Snacksbar.showErrorSnackBar(
              context, 'Username/Mobile already exists. Kindly try different');

          if (Status == 'failure' && message == 'User not verified') {
            Snacksbar.showErrorSnackBar(
                context,
                'User not verified Use forgot password to verify your account');
          }
        } else if (Status == 'failure') {
          Snacksbar.showErrorSnackBar(
              context, message);
        }
        else {
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


  static Future <void> regOtpVerification(code, username, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',};
    Map<String, dynamic> data = {
      "search_by": username,
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
        final String status = responseBody['status'];
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
      "email": email,
      "api_signature_id": AuthData.signature_id};
    try {
      AuthData.regMobileNumber = username;
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
          Navigator.pushReplacementNamed(
              context,
              '/otpPage',
              arguments: {
                'mobile': username,
                'emailAddress': email});

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
          // Snacksbar.showSuccessSnackBar(context, message);
          AuthData.counter = 0;
          AuthData.saveOtpCount(AuthData.counter);
          Navigator.pushReplacementNamed(
            context, '/otpVerification', arguments: {'mobile': search,},
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
          Navigator.pushReplacementNamed(context, '/login');
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
      "api_signature_id": AuthData.signature_id
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
          // Snacksbar.showErrorSnackBar(context,message );
        } else {
          // Snacksbar.showSuccessSnackBar(context, message);
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

  static Future<void> profile_sendotp(username, context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "emailOrMobile": username,
      "api_signature_id": AuthData.signature_id
    };
    try {
      final response = await http.post(
        Uri.parse(AuthData.profilesendotp),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          Snacksbar.ProfileSucess(context,message );
        } else {
          Snacksbar.showCustomSucessSnackbar(context, message);
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }


  static Future<void> Addbeneficary(username, beneficiaryName, fullConsumerCode,
      context) async {
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
            print('user token$token');
            String name = responseBody['full_name'];
            String email = responseBody['email'];
            AuthData.token = token;
            AuthData.regFullName = name;
            AuthData.regemail = email;
            print('Received token: $token');
            await _saveToken(
                token,
                regMobileNumber,
                regFullName,
                username,
                pin,
                regemail,
                0);
          }
          await addFirebaseDevice();
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }


  static Future<void> _saveToken(String token, regMobileNumber, regFullName,
      username, password_pin, regemail, countototp) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'regMobileNumber', value: regMobileNumber);
    await storage.write(key: 'regFullName', value: regFullName);
    await storage.write(key: 'regFullName', value: regFullName);
    await storage.write(key: 'regemail', value: regemail);
    await storage.write(key: 'username', value: regFullName);
    await storage.write(key: 'password_pin', value: regFullName);
    // await storage.write(key: 'countototp', value: countototp.toString());
    AuthData.token = token;
    AuthData.regMobileNumber = regMobileNumber;
    AuthData.regFullName = regFullName;
    AuthData.regemail = regemail;

    // AuthData.countforgototp=countototp;
  }

  static Future<void> clearTokenData() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'regMobileNumber');
    await storage.delete(key: 'regFullName');
    await storage.delete(key: 'regemail');
    await storage.delete(key: 'username');
    await storage.delete(key: 'password_pin');
    AuthData.token = "";
    AuthData.regMobileNumber = "";
    AuthData.regFullName = "";
    AuthData.regemail = "";
  }

  static Future<void> saveOtpCount(int counter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('countotp', counter);
  }

  // static Future<void> saveOtpCount(int counter) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('countotp', counter);
  //   Timer(Duration(minutes: 1), () async {
  //     await resetOtpCount();
  //   });
  // }
  //
  // static Future<void> resetOtpCount() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('countotp', 0);
  // }
  static Future<void> fetchAndSetToken() async {
    AuthData.token = await storage.read(key: 'token') ?? "";
    AuthData.regMobileNumber = await storage.read(key: 'regMobileNumber') ?? "";
    AuthData.regFullName = await storage.read(key: 'regFullName') ?? "";
    AuthData.regemail = await storage.read(key: 'regemail') ?? "";
  }

  static Future<int?> getOtpCount() async {
    final prefs = await SharedPreferences.getInstance();
    counter = (prefs.getInt('countotp') ?? 0);
    // if ( AuthData.counter != null) {
    //   return int.tryParse( AuthData.countforgototp);
    // }
    return counter;
  }


  static Future<void> checkLoginStatus(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      await AuthData.fetchAndSetToken();
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
    else {
      await AuthData.getOtpCount();
    }
  }


  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    // status++;
  }


  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Snacksbar.showSuccessSnackBar(context, "Authenticating Please wait...");
        // EasyLoading.show(status: 'Loading...');
        AuthData.regFullName = googleUser.displayName!;
        AuthData.Googleemail = googleUser.email;
        // AuthData.GoogleReg(googleUser.email,googleUser.displayName,"Google",context);
        if (AuthData.regFullName != " " && AuthData.Googleemail != " ") {
          AuthData.GoogleReg(
              googleUser.email, googleUser.displayName, "Google", context);
          // EasyLoading.dismiss();
        }
        EasyLoading.show(status: 'Loading...');
        final GoogleSignInAuthentication? googleAuth = await googleUser
            .authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,

        );
        // EasyLoading.dismiss();
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        if (userCredential.user != null) {}

        return userCredential;
      } else {
        EasyLoading.dismiss();
        return null;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      Snacksbar.showErrorSnackBar(
          context, 'Something Went Wrong please Try again later');
      EasyLoading.dismiss();
      return null;
    }
  }

  static Future <void> GoogleReg(username, fullname, login_source,
      context) async {
    {
      Map<String, String> headers = {
        'api_key': apiKey,
        'Content-Type': 'application/json',};
      Map<String, dynamic> data = {
        "username": username,
        "full_name": fullname,
        "login_source": login_source,
      };
      try {
        final response = await http.post(
          Uri.parse(AuthData.userRegister),
          headers: headers,
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          // EasyLoading.show(status: 'Loading...');
          AuthData.regMobileNumber = username;
          AuthData.regFullName = fullname;
          final Map<String, dynamic> responseBody = json.decode(response.body);
          final String message = responseBody['message'];
          final String Status = responseBody['status'];
          if (Status == 'failure' && message ==
              'Username/Mobile already exists. Kindly try different') {
            AuthData.Googleauthenticate(username, "Google", context);
          }
          else if (Status == 'success' && message ==
              'Blinq Mobile App user Successfully Registered') {
            AuthData.Googleauthenticate(username, "Google", context);
            // EasyLoading.dismiss();
            // Navigator.pushReplacementNamed(
            //     context, '/dashboard');
            // await AuthData.saveLoginStatus(true);
          }
        }
      } catch (e) {
        print('Error during API call: $e');
        Snacksbar.showErrorSnackBar(
            context, 'Something Went Wrong please Try again later');
        EasyLoading.dismiss();
      }
    }
  }

  static Future<void> Googleauthenticate(username, login_source,
      context) async {
    Map<String, String> headers = {
      'api_key': apiKey,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
      "login_source": login_source,
    };
    AuthData.regMobileNumber = username;
    try {
      final response = await http.post(
        Uri.parse(AuthData.userAuthenticate),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        // EasyLoading.show(status: 'Loading...');
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (status == 'failure') {
          print("something went wrong");
          Snacksbar.showErrorSnackBar(
              context, 'Something Went Wrong please Try again later');
          EasyLoading.dismiss();
        } else {
          if (responseBody.containsKey('token')) {
            String token = responseBody['token'];
            print('usertoken$token');
            AuthData.token = token;
            print('Received token: $token');
            await _saveToken(
                token,
                regMobileNumber,
                regFullName,
                username,
                regemail,
                username,
                "");
            EasyLoading.dismiss();
          }
          await addFirebaseDevice();
          await AuthData.saveLoginStatus(true);
          EasyLoading.dismiss();
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        EasyLoading.dismiss();
        print('API call failed with status code: ${response.statusCode}');
        Snacksbar.showErrorSnackBar(
            context, 'Something Went Wrong please Try again later');
      }
    } catch (e) {
      Snacksbar.showErrorSnackBar(
          context, 'Something Went Wrong please Try again later');
      EasyLoading.dismiss();
      print('Error during API call: $e');
    }
  }


  static Future<String> userBiometricAuthenticate({
    required String username,
    required String pin,
    required BuildContext context,
    bool useBiometric = false,
  }) async {
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
          if (responseBody.containsKey('token') &&
              responseBody.containsKey('full_name')) {
            String token = responseBody['token'];
            String name = responseBody['full_name'];
            String email = responseBody['email'];
            AuthData.token = token;
            AuthData.regFullName = name;
            AuthData.regemail = email;
            print('Received token: $token');
            await _saveToken(
                token,
                regMobileNumber,
                regFullName,
                username,
                pin,
                regemail,
                0);
          }
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        }
        return status;
      } else {
        print('API call failed with status code: ${response.statusCode}');
        return 'failure';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during API call: $e');
      }
      return 'failure';
    }
  }


  static Future<List<Map<String, dynamic>>> fetchFAQData() async {
    try {
      final response = await http.post(
        Uri.parse(AuthData.FAQs),
        headers: {
          'token': AuthData.token,
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
      throw("Error Fetching paid Bill Api!");
    }
  }


  static Future<List<dynamic>> RemoveBenificary(username,
      full_consumer_code) async {
    var headers = {
      'token': AuthData.token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AuthData.removeBenificary));

    request.body = json.encode({
      "username": username,
      "full_consumer_code": full_consumer_code
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


  /// ***** ***** ***** ***** ***** ***** ***** *****
  /// Firebase Notification - Save Device Info - Begin
  /// ***** ***** ***** ***** ***** ***** ***** *****
  static Future<void> addFirebaseDevice() async {
    // get FCM Token
    const storage = FlutterSecureStorage();
    String? mobileDeviceId = await storage.read(key: 'fcmToken');

    // get Device Name
    final deviceNames = DeviceMarketingNames();
    final singleDeviceName = await deviceNames.getSingleName();

    var deviceType = "";
    var deviceOS = "";
    var deviceSerial = "...";

    // get Device Type
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceType = '${androidInfo.manufacturer} ${androidInfo.model}';
      deviceOS = androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceType = iosDeviceInfo.systemVersion;
      deviceOS = iosDeviceInfo.systemName;
    }

    Map<String, String> headers = {
      'token': token,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "mobile_device_id": mobileDeviceId,
      "device_name": singleDeviceName,
      "device_type": deviceType,
      "device_os": deviceOS,
      "device_serial_number": deviceSerial
    };

    print(headers);
    print(data);

    try {
      final response = await http.post(
        Uri.parse(AuthData.fcmDeviceRegister),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String status = responseBody['status'];
        final String message = responseBody['message'];
        if (kDebugMode) {
          print(status);
          print(message);
        }

        if (status == 'failure') {

        } else {

        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error during API call: $error');
      }
    }
  }

  /// ***** ***** ***** ***** ***** ***** ***** *****
  /// Firebase Notification - Save Device Info - End
  /// ***** ***** ***** ***** ***** ***** ***** *****

  static Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    biousername = prefs.getString('username') ?? '';
    biopin = prefs.getString('pin') ?? '';
  }

  static Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final response = await http.post(
        Uri.parse(AuthData.Notification),
        headers: {
          'token': AuthData.token,
        },
      );
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user_notification')) {
          unreadCount = 0;
          return List<Map<String, dynamic>>.from(
              responseData['user_notification'].map((item) {
                if (!(item['is_read'] ?? false)) {
                  unreadCount++;
                }
                return {
                  'type': item['type'].toString() ?? '',
                  'message': item['message'].toString() ?? '',
                  'timestamp': item['timestamp'].toString() ?? '',
                  'type': item['type'].toString() ?? '',
                  'is_read': item['is_read'] ?? false,
                  'id': item['id'].toString() ?? '',
                };
              }));
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception('Error fetching notifications. Status code: ${response
            .statusCode}');
      }
    } catch (error) {
      print('Error fetching notifications: $error');rethrow;
    }
  }

  static Future<List<dynamic>> Markread(id) async {
    var headers = {
      'token': AuthData.token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(AuthData.Markasread));
    request.body = json.encode({
      "id": id
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

  // static Future<void>notification1(BuildContext context) async {
  //    Navigator.pushReplacementNamed(context, '/pay');
  //  }

  static void getAppSignature() async {
    String? signature = await SmsAutoFill().getAppSignature;
    signature_id = signature;
    if (kDebugMode) {
      print("App Signature: $signature");
    }
  }

  static Future<void> profilecodeverify(search, code, context) async {
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
        }
        if (status == 'success' && search.contains('@')){
          val=search;
          if (email1.isEmpty) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              mobile1,
              mobile2,
              mobile3,
              search,
              email2,
              email3,
              context,

            );
            // Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");
            val=search;

          }
          if (email1.isNotEmpty && email2.isEmpty) {
            val=search;
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              mobile2,
              mobile3,
              email1,
              search,
              email3,
              context,
            );

            Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");
          }
          if (email1.isNotEmpty && email2.isNotEmpty && email3.isEmpty) {
            val=search;
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              AuthData.mobile2,
              mobile3,
              email1,
              email2,
              search,
              context,
            );

            Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");
          }

        }else if (status == 'success' && !search.contains('@')) {
          if (mobile1.isEmpty) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              search,
              mobile2,
              mobile3,
              email1,
              email2,
              email3,
              context,

            );
            val=search;
            Snacksbar.showCustomSucessSnackbar(context,"Mobile edit Sucessfully");
          }
          if (mobile1.isNotEmpty && mobile2.isEmpty) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              search,
              mobile3,
              email1,
              email2,
              email3,
              context,
            );
            val=search;
            Snacksbar.showCustomSucessSnackbar(context,"Mobile edit Sucessfully");
          }
          if (mobile1.isNotEmpty && mobile2.isNotEmpty && mobile3.isEmpty) {
            val=search;
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              AuthData.mobile2,
              search,
              email1,
              email2,
              email3,
              context,
            );

            Snacksbar.showCustomSucessSnackbar(context,"Mobile edit Sucessfully");
          }
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

  static Future<void> editprofilecodeverify(search, code,value, context) async {
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
          // Snacksbar.(context, message);
        } else if (status == 'success') {

          if (value=="value" && search.contains('@')) {
            val=search;
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              mobile1,
              AuthData.mobile2,
              AuthData.mobile3,
              search,
              email2,
              email3,
              context,

            );
            // Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");


            Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");


          } if (value=="value1"&& search.contains('@')) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              mobile2,
              AuthData.mobile3,
              email1,
              search,
              email3,
              context,

            );
            val=search;

            // Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");

          } if (value=="value2"&& search.contains('@')) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              AuthData.mobile2,
              mobile3,
              email1,
              email2,
              search,
              context,

            );
            // Snacksbar.showCustomSucessSnackbar(context,"Email edit Sucessfully");

            val=search;


          } if (value=="value" && !search.contains('@')) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              search,
              AuthData.mobile2,
              AuthData.mobile3,
              email1,
              email2,
              email3,
              context,

            );
            // Snacksbar.showCustomSucessSnackbar(context,"Mobile edit Sucessfully");
            val=search;



          } if (value=="value1"&& !search.contains('@')) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              search,
              AuthData.mobile3,
              email1,
              email2,
              email3,
              context,

            );
            // Snacksbar.showCustomSucessSnackbar(context,"Mobile edit Sucessfully");
            val=search;


          } if (value=="value2"&& !search.contains('@')) {
            UpdateProfile(
              AuthData.regMobileNumber,
              AuthData.regFullName,
              AuthData.mobile1,
              AuthData.mobile2,
              search,
              email1,
              email2,
              email3,
              context,

            );
            // Snacksbar.showCustomSucessSnackbar(context,"Mobile edit Sucessfully");
            val=search;


          }

        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

  static Future<void> UpdateProfile(username, full_name, mobile1, mobile2,
      mobile3, email1, email2, email3, context) async {
    Map<String, String> headers = {
      'token': AuthData.token,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> data = {
      "username": username,
      "full_name": full_name,
      "mobile1": mobile1,
      "mobile2": mobile2,
      "mobile3": mobile3,
      "email1": email1,
      "email2": email2,
      "email3": email3,
    };
    final response = await http.post(
      Uri.parse(AuthData.Updateprofileapi),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String status = responseBody['status'];
      final String message = responseBody['message'];
      if (status == 'success') {
        print("Mobile add sucessfully");
        Snacksbar.showCustomSucessSnackbar(context,"Sucessfully Add");
      }
      if (status == 'failure') {
        print("something went wrong");
        Snacksbar.showErrorSnackBar(context, message);
        EasyLoading.dismiss();
      }
    }
  }


  static Future<void>fetchUserProfile() async {
    var headers = {
      'token': token,
      'Content-Type': 'application/json'
    };

    var uri = Uri.parse(AuthData.GetprofileData);

    var request = http.Request('GET', uri);
    request.body = json.encode({
      'username': AuthData.regMobileNumber
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonData = json.decode(responseBody);
        print(jsonData);
        if (jsonData is Map<String, dynamic>) {
          mobile1 = jsonData['mobile1'] ?? '';
          mobile2 = jsonData['mobile2'] ?? '';
          mobile3 = jsonData['mobile3'] ?? '';
          email1 = jsonData['email'] ?? '';
          email2 = jsonData['email2'] ?? '';
          email3 = jsonData['email3'] ?? '';
          print("mobile 1 data :$mobile1");print("mobile 2 data :$mobile2");
          print("mobile 3 data :$mobile3");print("email 1 data :$email1");print("email 2 data :$email2");
          print("email 3 data :$email3");
          print("Success");
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       final String status = responseBody['status'];
//       final String message = responseBody['message'];
//       print('Status: $status');
//       print('Message: $message');
//
//       if (status == 'failure') {
//         print("Something went wrong");
//       } else {
//         if (responseBody.containsKey('token')) {
//           mobile1 = responseBody['mobile1'];
//           mobile2 = responseBody['mobile2'];
//           mobile3 = responseBody['mobile3'];
//           email1 = responseBody['email1'];
//           email2 = responseBody['email2'];
//           email3 = responseBody['email3'];
//           print("Success");
//         }
//       }
//     } else {
//       print("Failed to fetch profile data. Status code: ${response.statusCode}");
//     }
//   } catch (error) {
//     print("An error occurred: $error");
//   }
// }
}
