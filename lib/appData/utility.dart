import 'dart:convert';
import 'dart:js';
// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/otp_file_auth.dart';
import 'AppData.dart';
class Utility {
  static String? authToken;

  static String? get authHeader => authToken;

  static Future<String?> sendAuthenticationRequest() async {
    try {
      String? foundToken;
      var authHeaders = {'Content-Type': 'application/json'};
      var authRequest = http.Request(
        'POST',
        Uri.parse(AppConfig.authapiUrl),
      );

      authRequest.body = json.encode({
        "ClientID": AppConfig.clientId,
        "ClientSecret": AppConfig.clientSecret,
      });

      authRequest.headers.addAll(authHeaders);

      http.StreamedResponse authResponse = await authRequest.send();

      if (authResponse.statusCode == 200) {
        String responseBody = await authResponse.stream.bytesToString();
        print('Auth Response Body: $responseBody');

        // Iterate through headers
        authResponse.headers.forEach((name, value) {
          print('Header: $name, Value: $value');

          if (name.toLowerCase() == 'token') {
            authToken = value;
            foundToken = authToken;
            print("Received Token: $authToken");
          }
        });

        return foundToken; // Return the authToken
      } else {
        print('Failed to authenticate: ${authResponse.reasonPhrase}');
        return null; // Return null if authentication fails
      }
    } catch (error) {
      print('Error sending authentication request: $error');
      return null; // Return null in case of an error
    }
  }
}

class EmailBody {
  static Future<String?> fetchEmailBody(String configName, String otp, Map<String, String> placeholders, String? foundToken) async {
    try {
      String apiUrl = 'https://staging-mobileapi.blinq.pk/api/mobile/appconfig/get/by/config/name';

      String? token = foundToken;

      if (token == null) {
        print('Authentication token is null');
        return '';
      }

      var headers = {
        'token': token,
        'Content-Type': 'application/json',
      };

      var requestBody = {
        'config_name': configName,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('config_value')) {
          String emailBody = responseBody['config_value'] ?? '';

          try {
            // Replace placeholders with actual values
            placeholders.forEach((key, value) {
              emailBody = emailBody.replaceAll('[$key]', value);
            });

            print('Updated Email Body: $emailBody');
          } catch (error) {
            print('Error updating email body: $error');
          }

          return emailBody;
        } else {
          print('Failed to fetch email body: ${responseBody['message']}');
        }
      } else {
        print('Failed to fetch email body: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching email body: $error');
    }

    return '';
  }



  static Future<String> fetchEmailSubject(String configName, Map<String, String> placeholders,  String? foundToken) async {
    try {
      String apiUrl = 'https://staging-mobileapi.blinq.pk/api/mobile/appconfig/get/by/config/name';
      String? token = foundToken;

      if (token == null) {
        print('Authentication token is null');
        return '';
      }

      var headers = {
        'token': token,
        'Content-Type': 'application/json',
      };

      var requestBody = {
        'config_name': configName,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('config_value')) {
          String emailSubject = responseBody['config_value']?.toString() ?? '';

          // Replace placeholders with actual values
          placeholders.forEach((key, value) {
            emailSubject = emailSubject.replaceAll('[$key]', value);
          });

          return emailSubject;
        } else {
          print('Failed to fetch email subject: ${responseBody['message']}');
        }
      } else {
        print('Failed to fetch email subject: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching email subject: $error');
    }

    return '';
  }

  static Future<void> sendEmailWithParams(String email, String emailSubject, String emailBody,  String? foundToken) async {
    try {
      if ( foundToken == null || foundToken.isEmpty) {
        print('Authentication token is missing or empty');
        return;
      }

      print('Auth Token (sendEmail): $foundToken'); // Debugging line

      var emailHeaders = {
        'token': foundToken, // Remove the space here
        'Content-Type': 'application/json',
      };

      var emailRequest = http.Request(
        'POST',
        Uri.parse(AppConfig.emailapiUrl),
      );
      emailRequest.body = json.encode({
        "Email": email,
        "Subject": emailSubject,
        "Content": emailBody,
      });
      emailRequest.headers.addAll(emailHeaders);

      print('Email Request: ${emailRequest.url}');
      print('Email Request Body: ${emailRequest.body}');
      print('Email Request Headers: ${emailRequest.headers}');

      http.StreamedResponse emailResponse = await emailRequest.send();

      if (emailResponse.statusCode == 200) {
        print('Email sent successfully');
        print(await emailResponse.stream.bytesToString());
      } else {
        print('Failed to send email: ${emailResponse.reasonPhrase}');
        print(await emailResponse.stream.bytesToString());

        if (emailResponse.statusCode == 401) {
          // Unauthorized, handle accordingly (e.g., refresh token or reauthenticate)
          print('Unauthorized access. Token may be expired or invalid.');
        }
      }
    } catch (error) {
      print('Error sending email: $error');
    }
  }
}

class OTP {
  static Future<void> verifyUserCodeInsert(String email, String mobile,
      String code, String? foundToken) async {
    final String apiUrl = 'https://staging-mobileapi.blinq.pk/api/mobile/user/code/verification/insert';

    final Map<String, dynamic> requestBody = {
      'email': email,
      'mobile': mobile,
      'code': code,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (foundToken != null) 'token': foundToken,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('Verification successful');
        print('Response: ${response.body}');
        // Authotppage.getCodeVerification(email, code, token);
        // You can handle the response data as needed
      } else {
        // Request failed
        print('Verification failed. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        // Handle errors or show appropriate messages
      }
    } catch (error) {
      // Exception during the HTTP request
      print('Error during verification request: $error');
      // Handle the error
    }
  }

  static Future<void> getCodeVerification(String email, String code,
      String? foundToken) async {
    try {
      final url = 'https://staging-mobileapi.blinq.pk/api/mobile/user/code/verification/get/code';

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        if (foundToken != null) 'token': foundToken,
      };

      final requestBody = {
        'search_by': email,
        'code': code,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Access the "code" field
        dynamic codeFromResponse = responseBody['code'];

        // Convert code to String if it's an integer
        if (codeFromResponse is int) {
          codeFromResponse = codeFromResponse.toString();
        }

        // Print or use the "code" value
        print('Code from Response: $codeFromResponse');
      } else {
        // Handle the error or provide feedback based on the response
        print('Failed to get code verification. Status code: ${response
            .statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      // Handle any other errors that might occur during the request
      print('Error during code verification request: $error');
    }
  }

  static Future<void> verifyCodeCheck(
      String email, String code, String? foundToken, void Function(String, String) showSnackBar) async {
    try {
      final url = 'https://staging-mobileapi.blinq.pk/api/mobile/user/code/verification/verifycode';

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        if (foundToken != null) 'token': foundToken,
      };

      final requestBody = {
        'search_by': email,
        'code': code,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      String message = 'N/A';
      String status = 'N/A';

      if (response.statusCode == 200) {
        // Handle the successful verification, if needed
        print('Code verification successful');
        print('Response Body: ${response.body}');
        status = 'Success';
        message = response.body;
      } else {
        // Handle the error or provide feedback based on the response
        print('Failed to verify code. Status code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        status = 'Failure';
        message = response.body;
      }

      // Use the callback to show the message in the SnackBar
      showSnackBar(status, message);
    } catch (error) {
      // Handle any other errors that might occur during the request
      print('Error during code verification request: $error');
    }
  }

}

// class Register {
//   Future<void> User(
//       BuildContext context,
//       String email,
//       String saltKey,
//       String hashpin,
//       String mobile,
//       String Fullname,
//       String? foundToken,
//       void Function(String, String) showSnackBarError,
//       void Function(String, String) showSnackBarSuccess,
//       ) async {
//     // final dio = Dio();
//     // dio.options.headers['Content-Type'] = 'application/json';
//     // dio.options.headers['token'] = Utility.authToken;
//
//     // try {
//     //   // final response = await dio.post(
//     //     'https://staging-mobileapi.blinq.pk/api/mobile/user/create',
//     //     data: {
//     //       'email': email,
//     //       'saltkey': saltKey,
//     //       'hash_pin': hashpin,
//     //       'mobile': mobile,
//     //       'full_name': Fullname,
//     //     },
//       );
//
//       final responseBody = response.data;
//
//       if (responseBody != null) {
//         if (responseBody.containsKey('user_id')) {
//           print('User ID: ${responseBody['user_id']}');
//         }
//
//         String message = responseBody['message'] ?? 'N/A';
//         String status = responseBody['status'] ?? 'N/A';
//
//         print('Message: $message');
//         print('Status: $status');
//
//         if (responseBody.containsKey('status') &&
//             responseBody['status'] == 'failure' &&
//             responseBody.containsKey('message') &&
//             responseBody['message'] != null &&
//             responseBody['message'] is String) {
//           if (responseBody['message'].contains(
//               'Email already exists. Kindly try different')) {
//             showSnackBarError('Email already exists in the database','error');
//           } else {
//             showSnackBarError(
//                 'Registration failed: ${responseBody['message']}','error');
//           }
//           print('Registration result: $responseBody');
//           // EasyLoading.dismiss();
//         }
//
//         showSnackBarSuccess('Register Successful','sucess');
//       }
//     } finally {
//       await Future.delayed(const Duration(milliseconds: 500));
//
//     }
//   }
// }


//
//
// // Step 4: Register the user
// final dio = Dio();
// dio.options.headers['Content-Type'] = 'application/json';
// dio.options.headers['token'] = authToken;
//
// // Generate a random saltkey
// final random = Random();
// final saltkey = random.nextInt(999999).toString().padLeft(6, '0');
//
// // Create a hash using saltkey and password
// final hashPin = generateHash(passwordController.text, saltkey);
//
// final response = await dio.post(
// 'https://staging-mobileapi.blinq.pk/api/mobile/user/create',
// data: {
// 'email': emailController.text,
// 'saltkey': saltkey,
// 'hash_pin': hashPin,
// 'mobile': mobileController.text,
// 'full_name': fullNameController.text,
// },
// );
//
// final responseBody = response.data;
//
// if (responseBody != null) {
// if (responseBody.containsKey('user_id')) {
// print('User ID: ${responseBody['user_id']}');
// }
//
// String message = responseBody['message'] ?? 'N/A';
// String status = responseBody['status'] ?? 'N/A';
//
// print('Message: $message');
// print('Status: $status');
//
// if (responseBody.containsKey('status') &&
// responseBody['status'] == 'failure' &&
// responseBody.containsKey('message') &&
// responseBody['message'] != null &&
// responseBody['message'] is String) {
// if (responseBody['message'].contains(
// 'Email already exists. Kindly try different')) {
// _showErrorSnackBar('Email already exists in the database');
// } else {
// _showErrorSnackBar(
// 'Registration failed: ${responseBody['message']}');
// }
// print('Registration result: $responseBody');
// EasyLoading.dismiss();
// }
//
//
// // sendAuditLog(
// //     '${responseBody['user_id']}',
// //     LoggerSection.register,
// //     'Registered Sucessful',
// //     'User Registered Successfully');
// _showSuccessSnackBar('Register Sucessfull');
// }
// } finally {
//
// await Future.delayed(const Duration(milliseconds: 500));
// EasyLoading.dismiss();
// }
// }












// final apiUrl = "http://staging-mobileapi.blinq.pk/api/mobile/user/create";
// final Map<String, dynamic> userData = {
//   "email": email,
//   "saltkey": saltKey,
//   "hash_pin": hashpin,
//   "mobile": mobile,
//   "full_name": Fullname,
// };

// final String jsonBody = jsonEncode(userData);
//
// final response = await http.post(
// Uri.parse(apiUrl),
// headers: {
// 'Content-Type': 'application/json',
// 'token': foundToken ?? '',
// },
// body: jsonBody,
// );
//
// print('Response Status Code: ${response.statusCode}');
//
// final responseBody = jsonDecode(response.body);
// print('Response Body: $responseBody');
//
// if (responseBody.containsKey('user_id')) {
// print('User ID: ${responseBody['user_id']}');
// }
//
// String message = responseBody['message'] ?? 'N/A';
// String status = responseBody['status'] ?? 'N/A';
//
// print('Message: $message');
// print('Status: $status');
//
// if (responseBody.containsKey('status') &&
// responseBody['status'] == 'failure' &&
// responseBody.containsKey('message') &&
// responseBody['message'] != null &&
// responseBody['message'] is String) {
// if (responseBody['message'].contains(
// 'Email already exists. Kindly try different')) {
// showSnackBarError('Email already exists in the database', 'error');
// } else {
// showSnackBarError(
// 'Registration failed: ${responseBody['message']}', 'error');
// }
// showSnackBarSuccess('Registration Successful', 'message');
//
// Navigator.pushReplacementNamed(context, '/login');
// }
// } catch (e) {
// print("Error during registration: $e");
// }
// }
// }

//
// void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }