// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import '../../appData/AppData.dart';
// import '../../appData/masking.dart';
//
// class Verification1 extends StatefulWidget {
//   double screenWidth = 0.0;
//   double screenHeight = 0.0;
//   late String mobileNumber;
//   late String emailAddress;
//   late String otp;
//   bool isSelectedSMS = false;
//   bool isSelectedEmail = false;
//   String? authToken;
//
//   @override
//   State<Verification1> createState() => _Verification1State();
//
//   Verification1({
//     Key? key,
//     required this.mobileNumber,
//     required this.emailAddress,
//     required this.otp,
//     required this.isSelectedSMS,
//     required this.isSelectedEmail,
//     this.authToken,
//   }) : super(key: key);
// }
//
// class _Verification1State extends State<Verification1> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       setState(() {
//         widget.screenWidth = MediaQuery.of(context).size.width;
//         widget.screenHeight = MediaQuery.of(context).size.height;
//       });
//     });
//   }
//   Future<void> logErrorToStoreProcedure({
//     required String title,
//     required String errorMessage,
//     String severity = LoggerSeverity.critical,
//     String section = LoggerSection.register,
//     String? errorDetails, // Change the parameter type to String?
//     String? userEmail,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.100.149:84/log-error'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'section': section,
//           'severity': severity,
//           'title': title,
//           'errorMessage': errorMessage,
//           'errorDetails': errorDetails, // Include the error details
//           'userEmail': userEmail,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         print('Log inserted successfully!');
//       } else {
//         print('Failed to log error to store procedure: ${response.reasonPhrase}');
//       }
//     } catch (error) {
//       logErrorToStoreProcedure(
//         title: ' log error',
//         errorMessage: 'Failed to log error to store procedure',
//         severity: LoggerSeverity.moderate,
//         section: LoggerSection.register,
//         errorDetails:error.toString(),
//         userEmail: emailAddress,
//       );
//       print('Error making HTTP request: $error');
//       // Handle the error as needed
//     }
//   }
//
//   Future<void> sendAuthenticationRequest() async {
//     try {
//       var authHeaders = {'Content-Type': 'application/json'};
//       var authRequest = http.Request(
//         'POST',
//         Uri.parse(AppConfig.authapiUrl),
//       );
//
//       authRequest.body = json.encode({
//         "ClientID": AppConfig.clientId,
//         "ClientSecret": AppConfig.clientSecret,
//       });
//
//
//       authRequest.headers.addAll(authHeaders);
//
//       http.StreamedResponse authResponse = await authRequest.send();
//
//       print('Auth Request: ${authRequest.url}');
//       print('Auth Request Body: ${authRequest.body}');
//       print('Auth Request Headers: ${authRequest.headers}');
//
//       if (authResponse.statusCode == 200) {
//         String responseBody = await authResponse.stream.bytesToString();
//         print('Auth Response Body: $responseBody');
//
//         // Iterate through headers
//         authResponse.headers.forEach((name, value) {
//           print('Header: $name, Value: $value');
//
//           // Check if the header is the "Token" you are looking for
//           if (name.toLowerCase() == 'token') {
//             authToken = value;
//             print("Received Token: $authToken");
//           }
//         });
//
//         if (authToken == null) {
//           print('Token not found in headers');
//         }
//       } else {
//         print('Failed to authenticate: ${authResponse.reasonPhrase}');
//         logErrorToStoreProcedure(
//           title: 'Authentication request',
//           errorMessage: 'Failed to authenticate',
//           severity: LoggerSeverity.critical,
//           section: LoggerSection.register,
//           errorDetails: 'Authentication failed with status code ${authResponse.statusCode}',
//           userEmail: emailAddress,
//         );
//       }
//     } catch (error) {
//       print('Error sending authentication request: $error');
//       logErrorToStoreProcedure(
//         title: 'Authentication request',
//         errorMessage: 'Error sending authentication request',
//         severity: LoggerSeverity.critical,
//         section: LoggerSection.register,
//         errorDetails: error.toString(),
//         userEmail: emailAddress,
//       );
//     }
//   }
//
//
//
//   Future<void> sendEmailWithParams(String email, String emailSubject, String emailBody) async {
//     try {
//       if (authToken == null || authToken!.isEmpty) {
//         print('Authentication token is missing or empty');
//         return;
//       }
//
//       print('Auth Token (sendEmail): $authToken'); // Debugging line
//
//       var emailHeaders = {
//         'token': '$authToken', // Remove the space here
//         'Content-Type': 'application/json',
//       };
//
//       var emailRequest = http.Request(
//         'POST',
//         Uri.parse('https://staging-mobileapi.blinq.pk/api/mobile/send/email'),
//       );
//       emailRequest.body = json.encode({
//         "CustomerEmail": email,
//         "EmailSubject": emailSubject,
//         "EmailContent": emailBody,
//       });
//       emailRequest.headers.addAll(emailHeaders);
//
//       print('Email Request: ${emailRequest.url}');
//       print('Email Request Body: ${emailRequest.body}');
//       print('Email Request Headers: ${emailRequest.headers}');
//
//       http.StreamedResponse emailResponse = await emailRequest.send();
//
//       if (emailResponse.statusCode == 200) {
//         print('Email sent successfully');
//         print(await emailResponse.stream.bytesToString());
//       } else {
//         print('Failed to send email: ${emailResponse.reasonPhrase}');
//         print(await emailResponse.stream.bytesToString());
//
//         if (emailResponse.statusCode == 401) {
//           // Unauthorized, handle accordingly (e.g., refresh token or reauthenticate)
//           print('Unauthorized access. Token may be expired or invalid.');
//         }
//       }
//
//     } catch (error) {
//       print('Error sending email: $error');
//       logErrorToStoreProcedure(
//         title: 'sending email',
//         errorMessage: 'Error sending email',
//         severity: LoggerSeverity.moderate,
//         section: LoggerSection.register,
//         errorDetails: error.toString(), // Provide the error message
//         userEmail: emailAddress,
//       );
//     }
//   }
//
//
//
//
//   Future<String> getAuthToken() async {
//     var authHeaders = {'Content-Type': 'application/json'};
//     var authRequest =
//     http.Request('POST', Uri.parse(AppConfig.authapiUrl));
//     authRequest.body =
//         json.encode({"ClientID": AppConfig.clientId, "ClientSecret": AppConfig.clientSecret});
//     authRequest.headers.addAll(authHeaders);
//
//     try {
//       http.StreamedResponse authResponse = await authRequest.send();
//
//       if (authResponse.statusCode == 200) {
//         // Check if the response is a JSON object
//         var responseBody = await authResponse.stream.bytesToString();
//         try {
//           Map<String, dynamic> authData = json.decode(responseBody);
//           return authData['Token'];
//         } catch (error) {
//           logErrorToStoreProcedure(
//             title: 'Token',
//             errorMessage: 'Auth Token not generating',
//             severity: LoggerSeverity.critical,
//             section: LoggerSection.register,
//             errorDetails: error.toString(), // Provide the error message
//             userEmail: emailAddress,
//           );
//           // Handle the case where the response is not a JSON object
//           // Assuming the response is a simple string, return it as is
//           return responseBody;
//         }
//       } else {
//         throw Exception('Failed to authenticate: ${authResponse.reasonPhrase}');
//       }
//     } catch (error) {
//       logErrorToStoreProcedure(
//         title: 'Token',
//         errorMessage: 'Error during authentication',
//         severity: LoggerSeverity.critical,
//         section: LoggerSection.register,
//         errorDetails: error.toString(),
//         userEmail: emailAddress,
//       );
//       rethrow; // Re-throw the exception after logging
//     }
//   }
//
//
//   Future<void> sendEmail(String token, String customerEmail,
//       String emailSubject, String emailContent) async {
//     var emailHeaders = {'Token': token, 'Content-Type': 'application/json'};
//     var emailRequest = http.Request(
//         'POST', Uri.parse(AppConfig.emailapiUrl));
//     emailRequest.body = json.encode({
//       "CustomerEmail": customerEmail,
//       "EmailSubject": emailSubject,
//       "EmailContent": emailContent
//     });
//     emailRequest.headers.addAll(emailHeaders);
//
//     http.StreamedResponse emailResponse = await emailRequest.send();
//
//     if (emailResponse.statusCode == 200) {
//       print(await emailResponse.stream.bytesToString());
//     } else {
//       print('Failed to send email: ${emailResponse.reasonPhrase}');
//     }
//   }
//   void generateAndStoreOTP(String email, String mobile, BuildContext context) async {
//     final url = 'http://192.168.100.149:84/generate_and_store_otp';
//     EasyLoading.show(status: 'Sending...');
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'mobile': mobile}),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseBody = jsonDecode(response.body);
//
//         if (responseBody.containsKey('status') && responseBody['status'] == 'success') {
//           print('OTP generated and stored successfully.');
//           String otp = responseBody['message'];
//
//           // Update the UI or show a message if needed
//           print('Received OTP: $otp');
//
//           // Replace [Code] placeholder in your email sending logic
//           await sendAuthenticationRequest();
//           if (authToken == null || authToken!.isEmpty) {
//             // _showErrorSnackBar('Authentication failed');
//             EasyLoading.dismiss();
//             return; // Stop the function here
//           }
//           print('Token after authentication: $authToken');
//
//           // Step 5: Send email using the obtained token and dynamic content
//           String emailSubjectResponse = await fetchEmailSubject("generate_and_store_otp");
//           String emailBodyResponse = await fetchEmailBody('generate_and_store_otp');
//
//           // Directly extract values without specifying keys
//           String emailSubject = jsonDecode(emailSubjectResponse).values.first;
//           String emailBody = jsonDecode(emailBodyResponse).values.first;
//
//           // Replace placeholders in the email body with user-specific values
//           emailBody = emailBody.replaceAll("[FullName]", emailAddress);
//           emailBody = emailBody.replaceAll("[Email]", emailAddress);
//           emailBody = emailBody.replaceAll("[Code]", otp);
//
//           // Step 5: Send email using the obtained token and dynamic content
//           await sendEmailWithParams(
//             emailAddress,
//             emailSubject,
//             emailBody,
//           );
//           // Map<String, String> arguments = {};
//           //
//           // if (email.isNotEmpty) {
//           //   arguments['emailAddress'] = email;
//           // }
//           //
//           // if (mobile.isNotEmpty) {
//           //   arguments['mobileNumber'] = mobile;
//           // }
//
//           Navigator.pushReplacementNamed(
//             context,
//             '/otpPage',
//             arguments: {
//               'mobileNumber': mobile,
//               'emailAddress': email,
//             },
//           );
//           EasyLoading.dismiss();
//         } else {
//           print('Failed to generate and store OTP.');
//         }
//       }
//     } catch (error) {
//       print('Error: $error');
//       // Handle network errors or other exceptions
//       EasyLoading.showError('Error: $error');
//     }
//   }
//
//   Future<String> fetchEmailSubject(request_source) async {
//     try {
//       String parameterName = "request_source";
//       String urlWithParams = "http://192.168.100.149:84/fetch-email-subject?request_source=$request_source";
//
//       final response = await http.get(
//         Uri.parse(urlWithParams),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         String emailSubject = response.body;
//
//         if (!isJson(emailSubject)) {
//           print('Invalid JSON format for email subject');
//           logErrorToStoreProcedure(
//             title: 'fetch email',
//             errorMessage: 'Invalid JSON format for email subject',
//             severity: LoggerSeverity.critical,
//             section: LoggerSection.register,
//             errorDetails: 'Invalid JSON format for email subject',
//             userEmail: emailAddress,
//           );
//           return "Default Email Subject"; // Provide a default subject in case of failure
//         }
//
//         return emailSubject;
//       } else {
//         print('Failed to fetch email subject: ${response.reasonPhrase}');
//         logErrorToStoreProcedure(
//           title: 'fetch email',
//           errorMessage: 'Failed to fetch email subject',
//           severity: LoggerSeverity.critical,
//           section: LoggerSection.register,
//           errorDetails: 'Failed to fetch email subject: ${response.reasonPhrase}',
//           userEmail: emailAddress,
//         );
//         return "Default Email Subject"; // Provide a default subject in case of failure
//       }
//     } catch (error) {
//       print('Error fetching email subject: $error');
//       logErrorToStoreProcedure(
//         title: 'fetch email',
//         errorMessage: 'Failed to fetch email subject',
//         severity: LoggerSeverity.critical,
//         section: LoggerSection.register,
//         errorDetails: error.toString(),
//         userEmail: emailAddress,
//       );
//       return "Default Email Subject"; // Provide a default subject in case of an error
//     }
//   }
//
//   Future<String> fetchEmailBody(request_source_body) async {
//     try {
//       String parameterName = "request_source_body";
//       String urlWithParams = "http://192.168.100.149:84/fetch-email-body?request_source_body=$request_source_body";
//
//       final response = await http.get(
//         Uri.parse(urlWithParams),
//         // Uri.parse('http://192.168.100.149:84/fetch-email-body'),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200) {
//         String emailBody = response.body;
//
//
//         if (!isJson(emailBody)) {
//           print('Invalid JSON format for email body');
//           logErrorToStoreProcedure(
//             title: 'fetch email',
//             errorMessage: 'Invalid JSON format for email body',
//             severity: LoggerSeverity.critical,
//             section: LoggerSection.register,
//             errorDetails: 'Invalid JSON format for email body',
//             userEmail: emailAddress,
//           );
//           return "Default Email Body"; // Provide a default body in case of failure
//         }
//
//         return emailBody;
//       } else {
//         print('Failed to fetch email body: ${response.reasonPhrase}');
//         logErrorToStoreProcedure(
//           title: 'fetch email',
//           errorMessage: 'Failed to fetch email body',
//           severity: LoggerSeverity.critical,
//           section: LoggerSection.register,
//           errorDetails: 'Failed to fetch email body: ${response.reasonPhrase}',
//           userEmail:emailAddress,
//         );
//         return "Default Email Body"; // Provide a default body in case of failure
//       }
//     } catch (error) {
//       print('Error fetching email body: $error');
//       logErrorToStoreProcedure(
//         title: 'fetch email',
//         errorMessage: 'Failed to fetch email body',
//         severity: LoggerSeverity.critical,
//         section: LoggerSection.register,
//         errorDetails: error.toString(),
//         userEmail: emailAddress,
//       );
//       return "Default Email Body"; // Provide a default body in case of an error
//     }
//   }
//   bool isJson(String str) {
//     try {
//       json.decode(str);
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//
// }
