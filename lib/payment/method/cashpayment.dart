import 'package:flutter/material.dart';

import '../../appData/ThemeStyle.dart';

List<String> list = ['Please Select Your bank', 'Option 2', 'Option 3'];

class Cashpayment extends StatefulWidget {
  const Cashpayment({Key? key}) : super(key: key);

  @override
  State<Cashpayment> createState() => _CashpaymentState();
}

class _CashpaymentState extends State<Cashpayment> {
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
    TextEditingController AccountController = TextEditingController();
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
                          "Cash Payment",
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
            child:Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 22.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(
                                'Ammount Payable',
                                style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: SizedBox(
                          width: screenWidth/1.1,
                          height: 52.0,
                          child: TextFormField(
                            controller: AccountController,
                            // keyboardType: TextInputType.number,
                            // inputFormatters: [maskAlphabet],
                            decoration: InputDecoration(
                              labelText: 'Ammount Payable',
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                elevation: 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(color: Colors.black26, width: 1.0),
                                    color: Colors.white,
                                  ),
                                  width: screenWidth / 1.11,
                                  height: 60,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle Unpaid button press
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: GeneralThemeStyle.button,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Internet',
                                          style: ThemeTextStyle.good2.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: TextButton(
                                          onPressed: () {
                                            // Handle Download Invoice button press
                                          },
                                          child: const Text(
                                            'Mobile Banking',
                                            style: ThemeTextStyle.generalSubHeading3,
                                          ),
                                        ),
                                      ),
                                    ],
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






          ),
        ),
      ),
    );
  }
}
