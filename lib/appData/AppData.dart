import 'package:flutter/material.dart';

abstract class AppData {
  static const TextStyle progressHeader = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 40,
      height: 0.5,
      fontWeight: FontWeight.w600
  );

  static const TextStyle progressBody = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 10,
      height: 0.5,
      fontWeight: FontWeight.w400
  );

  static const TextStyle progressFooter = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w600
  );
}
class LoggerSection {
  static const String register = 'RegisterScreen';
  static const String login = 'LoginScreen';
  static const String unpaid = 'UnPaidScreen';
  static const String paid = 'PaidScreen';
  static const String paybill = 'PayBillScreen';
}

class LoggerSeverity {
  static const String critical = 'Critical';
  static const String major = 'Major';
  static const String moderate = 'Moderate';
  static const String minor = 'Minor';

}
class AppConfig {
  static const String authapiUrl = 'https://staging-api.blinq.pk/api/auth';
  static const String clientId = 'PbrnYUCLjtziLSs';
  static const String clientSecret = '4OIuks1Dwrl2S6U';
  static const String emailapiUrl = 'https://staging-mobileapi.blinq.pk/api/mobile/send/email';
  static const String pythonapiurl = 'http://192.168.100.149:84';

}

