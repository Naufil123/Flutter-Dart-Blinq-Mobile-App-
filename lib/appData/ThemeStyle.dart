import 'package:flutter/material.dart';

abstract class ThemeTextStyle {

  static const TextStyle generalHeading = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.green,
      fontSize: 40,
      height: 0.5,
      fontWeight: FontWeight.w600
  );

  static const TextStyle generalSubHeading = TextStyle(
      fontFamily: 'Inter',
      color: Colors.black,
      fontSize: 32,
      height: 1.3,
      fontWeight: FontWeight.w600,

  );

  static const TextStyle searchInvoiceListInfo = TextStyle(
    fontFamily: 'Inter',
    color:  Color(0xFF000000),
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle generalSubHeading3 = TextStyle(
      fontFamily: 'Inter',
      color:  Color(0xFFEE6724),
      fontSize: 14,
      height: 0.5,
      fontWeight: FontWeight.w500

  );
  static const TextStyle generalSubHeading4 = TextStyle(
    fontFamily: 'Inter',
    color:  Color(0xFF000000),
    fontSize: 38,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle detailPara = TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 20,
      height: 1.2,
      fontWeight: FontWeight.w600
  );
  static const TextStyle control = TextStyle(
      fontFamily: 'Urbanist-VariableFont_wght',
      color: Colors.black,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w600
  );
  static const TextStyle control1 = TextStyle(
      fontFamily: 'Urbanist-Italic',
      color: Colors.black,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w600
  );
  static const TextStyle generalSubHeading5 = TextStyle(
      fontFamily: 'Manrope',
      color:  Colors.grey,
       fontSize: 12,
      height: 1.0,
      fontWeight: FontWeight.w400

  );
  static const TextStyle Good = TextStyle(
  fontFamily: 'Poppins',
  color: Colors.black,
  fontSize: 16,
  height: 1.2,
  fontWeight: FontWeight.w600

  );
  static const TextStyle good1 = TextStyle(
      fontFamily: 'Poppins-Medium',
      color: Colors.black,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w600

  );
  static const TextStyle good2 = TextStyle(
      fontFamily: 'Poppins-SemiBold',
      color: Colors.black,
      fontSize: 17,
      height: 1.1,
      fontWeight: FontWeight.w600
  );
  static const TextStyle sF = TextStyle(
  fontFamily: 'SF Pro Display ',
  color: Colors.grey,
  fontSize: 12.5,
  height: 1.3,
  fontWeight: FontWeight.w500
  );
  static const TextStyle sF1 = TextStyle(
      fontFamily: 'SF Pro Display ',
      color: Colors.black,
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w600
  );

static const TextStyle roboto = TextStyle(
fontFamily: 'Roboto',
color: Colors.orange,
fontSize: 16,
height: 1.2,
fontWeight: FontWeight.w600
);
  static const TextStyle robotored = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.red,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w600
  );
  static const TextStyle robotogreen = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.green,
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.w600
  );
}

abstract class GeneralThemeStyle {

  static const primary = Colors.white;
  static const secondary = Colors.red;
  static const button = Color(0xFFEE6724);//orange
  static const input = Colors.green;
  static const output = Color(0x30000000);//light gray
  static const dull = Colors.black;
  static const full = Color(0xFFF9F9F9);
  static const niull = Color(0xFFE1F5E9);
  static const nuull = Color(0x5FEE6724);


}

class Snacksbar {
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}