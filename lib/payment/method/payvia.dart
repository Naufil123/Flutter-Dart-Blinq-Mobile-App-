import 'package:flutter/material.dart';

import '../../appData/ThemeStyle.dart';
import '../../appData/masking.dart';

// List<String> list = ['Please Select Your bank', 'Option 2', 'Option 3'];

class Payvia extends StatefulWidget {
  const Payvia({Key? key}) : super(key: key);

  @override
  State<Payvia> createState() => _PayviaState();
}

class _PayviaState extends State<Payvia> {


  double screenWidth = 0;
  double screenHeight = 0;
  TextEditingController customerController = TextEditingController();
  TextEditingController registerController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController yyController = TextEditingController();
  TextEditingController cvController = TextEditingController();
  // String dropdownValue = list.first;


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
                      padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 50),
                      child: Align(
                        alignment: const Alignment(-3.0, 0.0),
                        child: Text(
                          "Pay Via Credit/Debit Card",
                          style: ThemeTextStyle.good1.copyWith(fontSize: 18),
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
                                'Card Number',
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
                                labelText: 'Card Number',
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
                  // Form(
                  //   child: Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 12.0),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               'Please Select Your bank',
                  //               style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  //         child: SizedBox(
                  //           width: screenWidth, // Set the width to the screen width
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(8.0),
                  //               border: Border.all(color: GeneralThemeStyle.output, width: 1.0),
                  //             ),
                  //             child: DropdownMenu<String>(
                  //               initialSelection: list.first,
                  //               onSelected: (String? value) {
                  //                 setState(() {
                  //                   dropdownValue = value!;
                  //                 });
                  //               },
                  //               dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                  //                 return DropdownMenuEntry<String>(value: value, label: value);
                  //               }).toList(),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Column(
                    children: [
                      Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MM',
                                    style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:73.0),
                                    child: Text(
                                      'YY',
                                      // textAlign: TextAlign.center,
                                      style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal:0.0),
                                  Text(
                                    'CVV/CVC',
                                    // textAlign: TextAlign.center,
                                    style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                                  ),

                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'YY',
                            //         style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 100, 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 52.0,
                                      child: TextFormField(
                                        controller: mmController,
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [maskAlphabet],
                                        decoration: InputDecoration(
                                          labelText: 'MM',
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
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 52.0,
                                      child: TextFormField(
                                        controller: yyController,
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [maskAlphabet],
                                        decoration: InputDecoration(
                                          labelText: 'YY',
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
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 52.0,
                                      child: TextFormField(
                                        controller: cvController,
                                        keyboardType: TextInputType.number,
                                        // inputFormatters: [maskAlphabet],
                                        decoration: InputDecoration(
                                          labelText: 'CVV/CVC',
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
                                  controller: registerController,
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
                                  controller: cnicController,
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
