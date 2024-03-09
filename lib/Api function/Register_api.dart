// Future<void> registerUser() async {
//   final String apiUrl = 'http://192.168.18.218:82/register';
//
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'email': emailController.text,
//       'pin': pinController.text,
//       'mobile_number': mobileController.text,
//       'full_name': fullNameController.text,
//     }),
//   );
//
//   if (response.statusCode == 200) {
//     // Registration successful
//     print('Registration successful!');
//   } else {
//     // Registration failed
//     print('Registration failed: ${response.body}');
//   }
// }
