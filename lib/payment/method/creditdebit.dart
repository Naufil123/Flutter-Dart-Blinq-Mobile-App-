import 'package:flutter/material.dart';

import '../../appData/ThemeStyle.dart';
import '../../appData/dailogbox.dart';
import '../../appData/masking.dart';

List<String> list = ['Please Select Your bank', 'Option 2', 'Option 3'];

class CreditDebit extends StatefulWidget {
  const CreditDebit({Key? key}) : super(key: key);

  @override
  State<CreditDebit> createState() => _CreditDebitState();
}

class _CreditDebitState extends State<CreditDebit> {
  double accountTextOffset = 0.0;
  bool isChecked = false;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  double screenWidth = 0;
  double screenHeight = 0;
  TextEditingController customerController = TextEditingController();
  TextEditingController AccountController = TextEditingController();
  TextEditingController RegisterController = TextEditingController();
  TextEditingController CnicController = TextEditingController();
  String dropdownValue = list.first;
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: GeneralThemeStyle.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: GeneralThemeStyle.primary,
        automaticallyImplyLeading: false,
        bottomOpacity: 300.0,
        elevation: 0.0,
        toolbarHeight: 60,
        actions: [
          SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: const Alignment(-1.0, 1.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/pay');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Align(
                        alignment: const Alignment(-1.0, 0.5),
                        child: Text(
                          "Direct Account Debit",
                          style: ThemeTextStyle.good1.copyWith(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Container(
            width: screenWidth,
            height: screenHeight * 2, // Set the desired height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x10000000),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: screenWidth * 0.125,
                  spreadRadius: screenWidth * 0.0115,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nick Name',
                                style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: SizedBox(
                            width: screenWidth,
                            height: 52.0,
                            child: TextFormField(
                              controller: customerController,
                              keyboardType: TextInputType.text,
                              inputFormatters: [maskAlphabet],
                              decoration: InputDecoration(
                                labelText: 'Nick Name',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please Select Your bank',
                                style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            child: SizedBox(
                              width: screenWidth,
                              child: DropdownMenu<String>(
                                initialSelection: list.first,
                                width: screenWidth/1.11,
                                onSelected: (String? value) {
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                },
                                dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(value: value, label: value);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Number',
                                    style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: SizedBox(
                                width: screenWidth,
                                height: 52.0,
                                child: TextFormField(
                                  controller: AccountController,
                                  keyboardType: TextInputType.number,
                                  // inputFormatters: [maskAlphabet],
                                  decoration: InputDecoration(
                                    labelText: 'Account Number',
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Registered Account',
                                    style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: SizedBox(
                                width: screenWidth,
                                height: 52.0,
                                child: TextFormField(
                                  controller: RegisterController,
                                  keyboardType: TextInputType.number,
                                  // inputFormatters: [maskAlphabet],
                                  decoration: InputDecoration(
                                    labelText: 'Registered Account',
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CNIC',
                                    style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: SizedBox(
                                width: screenWidth,
                                height: 52.0,
                                child: TextFormField(
                                  controller: CnicController,
                                  keyboardType: TextInputType.number,
                                  // inputFormatters: [maskAlphabet],
                                  decoration: InputDecoration(
                                    labelText: 'CNIC',
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: GeneralThemeStyle.button, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(color: GeneralThemeStyle.output, width: 1.0),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, screenHeight * 0.01, 0, screenHeight * 0.01),
                        child: Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                              activeColor: GeneralThemeStyle.button,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'To add this account as ',
                                style: ThemeTextStyle.generalSubHeading3.apply(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Registered Account',
                                    style: ThemeTextStyle.generalSubHeading3.apply(color: Colors.orange[900]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextButton(
                onPressed: () {
                  paymentSucess.showCustomDialog(
                    context,
                    '',
                    '',// Replace with the actual content
                    screenWidth,
                  );
                },

                style: TextButton.styleFrom(
                  backgroundColor: GeneralThemeStyle.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Send OTP',
                    style: ThemeTextStyle.detailPara.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
