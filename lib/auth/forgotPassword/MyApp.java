import 'auth/forgotPassword/forgotPassword.dart';
import 'auth/forgotPassword/otp.dart';
import 'auth/login/login.dart';
import 'auth/register/register.dart';
import 'home/Unpaidbill.dart';
import 'payment/invoiceSummary/TransactionScreen.dart';
import 'payment/invoiceSummary/paybill.dart';
import 'payment/method/creditdebit.dart';
import 'payment/method/payvia.dart';
import 'payment/method/wallet.dart';
import 'splashScreen/splashPage1.dart';
import 'splashScreen/splashPage2.dart';
import 'splashScreen/splashPage3.dart';
import 'splashScreen/splashPage4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'auth/forgotPassword/otpVerification.dart';
import 'auth/forgotPassword/verification.dart';
import 'home/Paidbill.dart';
import 'home/dashBoard.dart';
import 'home/AddBeneficiary.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLoading.init();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Blinq Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
       scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/splashPage1': (context) => const Screen1(),
        '/splashPage2': (context) => const SplashScreen2(),
        '/splashPage3': (context) => const SplashScreen3(),
        '/splashPage4': (context) => const SplashScreen4(),
        '/login': (context) => const Login(),
        '/register': (context) => const register(),
        '/Verification': (context) => const Verification(),
        '/otpPage': (context) => const OtpPage(),
        '/forgotPassword': (context) => const forgotPassword(),
        '/otpVerification': (context) => const otpVerification(),
        '/dashBoard': (context) => const Dashboard(),
        '/unpaid': (context) => const Unpaid(),
        '/paid': (context) => const Paidbill(),
        '/pay': (context) => const PayBill(),
        '/dashboard': (context) => const Dashboard(),
        '/creditdebit': (context) => const CreditDebit(),
        '/wallet': (context) => const Wallet(),
        '/payvia': (context) => const Payvia(),


        '/add-beneficiary': (context) => const AddBeneficiary(),

      },
      home: const Screen1(),
    );
  }
}
