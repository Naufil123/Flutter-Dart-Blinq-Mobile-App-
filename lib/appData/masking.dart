import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
var  maskPhone= MaskTextInputFormatter(

    mask: '###########',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
);


 var maskAlphabet = MaskTextInputFormatter(
mask: '#####################################################',
filter: {"#": RegExp(r'[A-Za-z ]')},
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
    return email;
  } else {
    String firstChar = email.substring(0, 6);
    String lastChar = email.substring(email.length - 4);
    String middlePart = '*' * (email.length - 2);
    return '$firstChar$middlePart$lastChar';
  }
}


String obscureNumber(String number) {
  if (number.length <= 4) {
    return number;
  } else {

    String firstTwoDigits = number.substring(0, 2);
    String lastTwoDigits = number.substring(number.length - 2);
    String middlePart = '*' * (number.length - 4);
    return '$firstTwoDigits$middlePart$lastTwoDigits';
  }
}

bool isValidEmail(String email) {
  // Basic email validation
  return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
}
String getInitials(String fullName) {
  List<String> nameParts = fullName.split(' ');
  String initials = '';

  for (var i = 0; i < nameParts.length; i++) {
    if (i == 2) {
      break;
    }
    String part = nameParts[i];
    if (part.isNotEmpty) {
      initials += part[0].toUpperCase();
    }
  }

  return initials;
}

String insertSpaces(String code) {
  String formattedCode = '';
  for (int i = 0; i < code.length; i++) {
    if (i > 0 && i % 4 == 0) {
      formattedCode += ' ';
    }
    formattedCode += code[i];
  }
  return formattedCode;
}

var  Account = MaskTextInputFormatter(

    mask: '########################',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
);

var  CNIC = MaskTextInputFormatter(

    mask: '#############',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
);