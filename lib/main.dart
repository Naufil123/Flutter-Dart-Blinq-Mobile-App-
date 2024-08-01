import 'package:blinq_sol/payment/invoiceSummary/TransactionScreenWallet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:blinq_sol/appData/firebase_api.dart';
import 'package:blinq_sol/firebase_options.dart';
import 'package:blinq_sol/notification_screen.dart';
import 'package:blinq_sol/payment/invoiceSummary/InternetMobile.dart';
import 'package:blinq_sol/payment/invoiceSummary/Transactionscreenpayincash.dart';
import 'package:blinq_sol/auth/forgotPassword/forgotPassword.dart';
import 'package:blinq_sol/auth/forgotPassword/otp.dart';
import 'package:blinq_sol/auth/login/login.dart';
import 'package:blinq_sol/auth/otp_file_auth.dart';
import 'package:blinq_sol/auth/register/register.dart';
import 'package:blinq_sol/home/Unpaidbill.dart';
import 'package:blinq_sol/payment/invoiceSummary/paybill.dart';
import 'package:blinq_sol/payment/method/creditdebit.dart';
import 'package:blinq_sol/payment/method/payvia.dart';
import 'package:blinq_sol/payment/method/wallet.dart';
import 'package:blinq_sol/splashScreen/splashPage1.dart';
import 'package:blinq_sol/splashScreen/splashPage2.dart';
import 'package:blinq_sol/splashScreen/splashPage3.dart';
import 'package:blinq_sol/splashScreen/splashPage4.dart';
import 'package:upgrader/upgrader.dart';
import 'Controller/Network_Conectivity.dart';
import 'appData/dependency_injection.dart';
import 'appData/update_package.dart';
import 'auth/forgotPassword/otpVerification.dart';
import 'auth/forgotPassword/verification.dart';
import 'home/AddBeneficiary.dart';
import 'home/Paidbill.dart';
import 'home/dashBoard.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
bool isMaterialAppInitialized = false;
BuildContext? appContext;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message codewaa: ${message.messageId}");
}

void main() async {
  DependencyInjection.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Upgrader.clearSavedSettings();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // NetworkController.updateConnectionStatus(ConnectivityResult as ConnectivityResult);
  EasyLoading.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool visitedSplash = prefs.getBool('visitedSplash') ?? false;

  runApp(MyApp(visitedSplash: visitedSplash));
  DependencyInjection.init();


  isMaterialAppInitialized = true;
}

class MyApp extends StatelessWidget {
  final bool visitedSplash;

  const MyApp({required this.visitedSplash, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    appContext = context;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Firebase.initializeApp();

      final FirebaseApi firebaseApi = FirebaseApi();
      firebaseApi.initNotifications();

// UpdateChecker.checkForUpdate(context);
    });

    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Blinq Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        useMaterial3: true,
      ),
      initialRoute: visitedSplash ? '/login' : '/splashPage1',
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
        '/dashboard': (context) => UpgradeAlert(showIgnore:false,
          onIgnore: null,cupertinoButtonTextStyle:const TextStyle(color: Colors.orange),
          child: const Dashboard(),),
        '/unpaid': (context) => const Unpaid(),
        '/paid': (context) => const Paidbill(),
        '/pay': (context) => const PayBill(),
        '/creditdebit': (context) => const CreditDebit(),
        '/wallet': (context) => const Wallet(),
        '/payvia': (context) => const Payvia(),
        '/add-beneficiary': (context) => const AddBeneficiary(),
        '/reg_otp': (context) => const Authotppage(),
        '/notification-screen': (context) => const NotificationScreen(),
        '/InternetMobileScreen': (context) => InternetMobileScreen(),
        '/payincash': (context) => Payincash(paramSearchedInvoices: const {},),
        '/Wallet': (context) =>TransactionScreenWallet(paramSearchedInvoices: {},),
      },
// home:const Authotppage()
      home:visitedSplash ? const Login() :const Screen1(),
    );
  }
}