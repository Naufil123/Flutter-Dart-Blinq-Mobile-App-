import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
var  maskPhone= MaskTextInputFormatter(

    mask: '###########',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
);

 var maskAlphabet = MaskTextInputFormatter(
mask: '#####################################################',
filter: {"#": RegExp(r'[A-Za-z ]')}, // Allows letters and spaces
type: MaskAutoCompletionType.lazy,
);

String maskedEmail = '';

String? validateEmail(String? value) {
  if (value == null) {
    return 'Email is required';
  }
  if (value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}
var maskPin = MaskTextInputFormatter(
  mask: '####',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
var maskDate = MaskTextInputFormatter(
  mask: '##/##/####',
  filter: {'#': RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);



String obscureEmail(String email) {
  if (email.length <= 2) {
    // Return the full email if it has two or fewer characters
    return email;
  } else {
    // Extract the first and last characters of the email
    String firstChar = email.substring(0, 6);
    String lastChar = email.substring(email.length - 4);

    // Create a masked string for the middle part
    String middlePart = '*' * (email.length - 2);

    // Combine the first, middle, and last parts
    return '$firstChar$middlePart$lastChar';
  }
}


String obscureNumber(String number) {
  if (number.length <= 4) {
    // Return the full number if it has four or fewer digits
    return number;
  } else {
    // Extract the first two and last two digits of the number
    String firstTwoDigits = number.substring(0, 2);
    String lastTwoDigits = number.substring(number.length - 2);

    // Create a masked string for the middle part
    String middlePart = '*' * (number.length - 4);

    // Combine the first, middle, and last parts
    return '$firstTwoDigits$middlePart$lastTwoDigits';
  }
}

bool isValidEmail(String email) {
  // Basic email validation
  return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
}

