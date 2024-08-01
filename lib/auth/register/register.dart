// TODO Implement this library.import 'package:blinq_sol/appData/AppData.dart';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../appData/AuthData.dart';
import '../../appData/masking.dart';
import 'package:blinq_sol/appData/ThemeStyle.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);
  @override
  _registerState createState() => _registerState();
}
class _registerState extends State<register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  // final FocusNode focusNode2 = FocusNode();
  double accountTextOffset = 0.0;
  bool isChecked = false;
  bool _obscureText = true;
  bool isLoading= false;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }
 Future<void> regUserApi() async {
   setState(() {
     isLoading = true;
   });
     if (!_formKey.currentState!.validate() ||
         !_formKey1.currentState!.validate() ||
         !_formKey2.currentState!.validate() ||
         !_formKey3.currentState!.validate() ||
         !_formKey4.currentState!.validate()) {
       setState(() {
         isLoading = false;
       });
       return;
     }
     setState(() {
       isLoading = true;
     });
     if (passwordController.text.isEmpty ||
         repasswordController.text.isEmpty ||
         mobileController.text.isEmpty ||
         fullNameController.text.isEmpty) {
       Snacksbar.showErrorSnackBar(context,'Fill all the required fields');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     if (mobileController.text.length < 11) {
       Snacksbar.showErrorSnackBar(context,'Mobile number must have at least 11 digits');
       setState(() {
         isLoading = false;
       });
       return;
     }if (mobileController.text[0]!='0'){
       Snacksbar.showErrorSnackBar(context,'Invalid mobile number. Please enter a valid mobile number starting with 03');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });if (mobileController.text[1]!='3'){
       Snacksbar.showErrorSnackBar(context,'Invalid mobile number. Please enter a valid mobile number starting with 03');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     /*if (!emailController.text.contains('@') ||!emailController.text.contains('@') ||
         !emailController.text.contains('.')) {
       Snacksbar.showErrorSnackBar(context,'Invalid email format');
       setState(() {
         isLoading = false;
       });
       return;
     }*/
   setState(() {
     isLoading = true;
   });
     if (passwordController.text.length != 4 ||
         repasswordController.text.length != 4) {
       Snacksbar.showErrorSnackBar (context,'Pin must be 4 characters long');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
     if (passwordController.text != repasswordController.text) {
       Snacksbar.showErrorSnackBar(context,'Pin are not same');
       setState(() {
         isLoading = false;
       });
       return;
     }
   setState(() {
     isLoading = true;
   });
   if (isChecked==false) {
     Snacksbar.showErrorSnackBar(context,'You must agree the term of privacy policy to register');
     setState(() {
       isLoading = false;
     });
     return;
   }
   setState(() {
     isLoading = true;
   });
   Timer timer = Timer(Duration(seconds: AuthData.timer), () {
     if (isLoading) {
       setState(() {
         isLoading = false;
       });
       Snacksbar.showErrorSnackBar(context, 'No connection. Please try again.');
     }
   });
   try {

   await AuthData.regUser(mobileController.text,emailController.text,repasswordController.text,fullNameController.text,null,context);
     setState(() {
       isLoading = false;
     });
  }finally {
     if (timer.isActive) {
       timer.cancel();
     }
     setState(() {
       isLoading = false;
     });
   }
 }
  void initState() {
    super.initState();

    // focusNode2.addListener(() {
    //   if (focusNode2.hasFocus && mobileController.text.isEmpty) {
    //     mobileController.text = '03';
    //     mobileController.selection = TextSelection.fromPosition(
    //       const TextPosition(offset: 2),
    //     );
    //   }
    // });

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(

        onWillPop: () async {
      // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/login');
      return true; // Returning true prevents default back button behavior
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, screenHeight * 0.1, 10, 10),
                child: const Text(
                  'Create your new account.',
                  style: ThemeTextStyle.generalSubHeading,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, screenHeight * 0.02),
                child: Text(
                  'Create an account with us and start your journey to financial peace today!',
                  style: ThemeTextStyle.generalSubHeading.apply(
                    fontSizeDelta: -19,
                    color: Colors.black26,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Full Name', style: ThemeTextStyle.generalSubHeading.apply(fontSizeDelta: -18),
                    // ),
                    Padding(padding:
                      EdgeInsets.fromLTRB(0, 5, 0, screenHeight * 0.015),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: fullNameController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [maskAlphabet],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person, color: Colors.grey),
                            labelText: 'Enter Your Full Name',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
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
              Form(key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Mobile No',
                    //   style: ThemeTextStyle.generalSubHeading
                    //       .apply(fontSizeDelta: -18),
                    // ),
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(0, 5, 0, screenHeight * 0.015),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(

                          controller: mobileController,
                          // focusNode: focusNode2,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskPhone],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                            labelText: 'Enter Your Mobile Number',
                             // hintText: 'Mobile number must start with 03',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
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
                key: _formKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(0, 05, 0, screenHeight * 0.015),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: emailController,
                          // inputFormatters: [maskedEmail],
                          keyboardType: TextInputType.emailAddress,
                          // inputFormatters: [maskedEmail()],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email, color: Colors.grey),
                            labelText: 'Enter Your Email',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // validator: (value) => validateEmail(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 05),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          inputFormatters: [maskPin],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            labelText: 'Pin',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 05),
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.065,
                        child: TextFormField(
                          controller: repasswordController,
                          inputFormatters: [maskPin],
                          obscureText: _obscureText,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            labelText: 'Re-Enter Pin',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GeneralThemeStyle.button, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: GeneralThemeStyle.output, width: 1.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, screenHeight * 0.01, 0, screenHeight * 0.01),
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
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I Agree with ',
                              style: ThemeTextStyle.generalSubHeading3.copyWith(color: Colors.black,fontSize: 13),
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: ThemeTextStyle.generalSubHeading3.copyWith(color: Colors.orange[900],fontSize: 13),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Terms of Service"),
                                        content: const SingleChildScrollView(
                                          child: Text(
                                            '''


1. User and Business Partner Duties

•	Platform Usage Adherence
Users commit to using Blinq and/or Payment Schemes’ Platform in strict adherence to the terms and conditions stipulated by the platform. Any attempt to modify, translate, or reverse engineer the platform without explicit written consent is prohibited.

•	Acknowledgment of Regulatory Compliance
Users commit to refraining from utilizing the Platform provided by Blinq and/or Payment Schemes for any purpose that violates applicable laws, regulations, or may lead to fraudulent activities, investigations, or legal actions against Blinq.

•	Legal Compliance
Merchants are obligated to comply with all applicable laws, rules, and regulations relevant to their use of Blinq’s and/or Payment Schemes’ Platform.

•	Transaction Processing
Merchants are prohibited from processing or depositing transactions for other merchant establishments.

•	Non-Refinancing of Debts
Merchants shall not accept payments from customers to refinance existing debts.

•	Data Extraction Compliance
Merchants must ensure that data extraction from the Payment Instrument aligns with Blinq’s specified methods.

•	Transparent Transaction Handling
Merchants must deliver a digital or paper copy bill to customers for transactions via Blinq and/or Payment Schemes’ Platform.

•	Trademark Usage License
Merchants grant Blinq a limited license to use their trademarks for marketing purposes.

•	Inclusion in Directories
Merchants authorize Blinq to include their name in any directory or promotional material related to Blinq’s services.

•	Security Measures Adherence
Merchants must observe all security measures on their websites and/or mobile applications as prescribed by Payment Schemes, 1LINK, and/or Blinq.

•	Compliance with Payment Instructions
Merchants are obligated to comply with payment instructions provided by Blinq in writing.

•	Dispute Resolution and Fund Recovery
In cases of dispute, chargeback, or fraudulent activity, the Acquirer/Platform Provider reserves the right to refund the Accountholder/Cardholder using the merchant’s funds.

•	Ownership Verification
Merchants must provide accurate information during the ownership verification process, with penalties for falsified information.

2. General Commitments

•	Compliance with Applicable Laws
Merchants must comply with all applicable laws related to product and service sales.

•	Customer Payment Acceptance
Merchants may only accept payments for goods and services they have sold and are within the identified business scope.

•	Indemnification
Merchants indemnify Blinq for any liabilities toward customers.

•	Adherence to Policies
Users and merchants must comply with Scheme Rules, PSO/PSPs’ SOCs, Acquirer/Platform Provider’s Policies, and all applicable laws.

3. Transaction Management

•	Settlement Timing
Blinq ensures merchant settlement within specified timelines, with communication in case of delays.

•	Commission Calculation
The Acquirer/Platform Provider’s commission is calculated based on processed and accepted transactions.

•	Transaction Validity
Merchant must ensure that transaction information complies with the agreement.

•	Record Retention
Merchants are required to retain relevant transaction correspondence for a minimum of three years.

4. Payments Acceptance Policies

•	Notification of Changes
Merchants must notify Blinq before making changes to the nature of offered products and services.

•	Compliance with Authorization
Merchants should only accept payments for authorized transactions in accordance with relevant laws and agreements.

•	Reputation Preservation
Merchants must refrain from disreputable actions that may damage the reputation of Blinq.

•	Specific Product/Service Acceptance
Merchants are allowed to accept payments only for products and services within their identified business scope.

•	Indemnification for Merchant Obligations
Merchants indemnify Blinq for any consequences arising from obligations under the agreement.

5. Dispute Resolution, Refunds and Chargebacks

•	Merchant-User Disputes
In case of disputes between merchants and users, Blinq is not a party to litigation but must be indemnified.

•	No Refusal for Electronic Transaction Return
Merchants must not refuse returns or cancellations for goods originally purchased using electronic means.

•	Refund Process
In the event of goods return or service cancellation, merchants must electronically refund the Accountholder/Cardholder.

•	Chargeback Financial Service Charge
Merchants may incur a financial service charge for each chargeback, deducted from settlements.

•	Non-Refundable Amounts
Blinq is not liable to refund any amount, including subscription and setup fees, in case of chargebacks.

•	Prohibition on Wrongful Use of Settled Funds
The Merchant expressly agrees not to use any settled funds if such settlement is made wrongfully or in error, including but not limited to fraudulent transactions, chargebacks, violation of these terms, and over settlement.

•	Responsibilities of the Merchant in Wrongful Settlement
The Merchant agrees to promptly notify Blinq of any over-settlement and to fully cooperate with Blinq and/or Payment Scheme’s in their investigation and willingly agrees to return said funds to Payment Schemes.

•	Remedies for Over-settlement
In case of over-settlement, Blinq reserves the right to request the Payment Scheme’s to reverse the over-settled funds, or to withhold upcoming settlements.

6. Prohibited Items
•	Merchants warrant that certain products and services prohibited by law will not be offered, sold, or delivered through the website or mobile application.

7. Termination of Services

•	Blinq reserves the right to suspend or terminate Merchant’s account and access to payment services at its discretion, with or without cause.

•	Merchant must provide written notice to Blinq at least 30 days prior to the effective date of cancellation. The notice shall include the reasons for cancellation.

8. Indemnity

•	Information Confidentiality and Connectivity Maintenance
Protecting User Information Merchants have to keep the information that users provide safe and secure, and use appropriate encryption and security methods.  Preserving Link Quality Merchants have to make sure that the connection between the website/mobile application and Blinq’s Internet Payment Gateway is reliable and stable.

9. Confidentiality and Security

•	Indemnification of Blinq
Merchants indemnify Blinq for any consequences arising from their obligations under the agreement. Merchants acknowledge that Blinq is an intermediary and indemnify it for liabilities toward Payment Schemes.

10. Disclaimer

•	Blinq is not responsible for third-party businesses or individuals offering services through its site. Blinq disclaims any warranties regarding the website’s content and functionality, and users acknowledge that website use is at their own risk.


                        ''',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Close',style: ThemeTextStyle.detailPara.copyWith(fontSize:13,color: Colors.deepOrange )),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                            ),
                            const TextSpan(
                              text: ' and ',
                              style: TextStyle(color: Colors.black,fontSize: 13), // Apply black color style
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: ThemeTextStyle.generalSubHeading3.copyWith(color: Colors.orange[900],fontSize: 13),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Privacy Policy"),
                                        content: const SingleChildScrollView(
                                          child: Text(
                                            '''
Privacy Policy for Blinq Solutions Pvt.Ltd

At Blinq Solutions Pvt. Ltd, accessible from https://blinq.pk, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Blinq Solutions Pvt. Ltd and how we use it.

If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.
This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Blinq Solutions Pvt. Ltd. This policy is not applicable to any information collected offline or via channels other than this website.
Consent

By using our website, you hereby consent to our Privacy Policy and agree to its terms.
Information we collect
The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.
If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.
When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.

How we use your information
We use the information we collect in various ways, including to:

•	Provide, operate, and maintain our website
•	Improve, personalize, and expand our website
•	Understand and analyze how you use our website
•	Develop new products, services, features, and functionality
•	Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the website, and for marketing and promotional purposes
•	Send you emails
•	Find and prevent fraud

Log Files
Blinq Solutions Pvt. Ltd follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services’ analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users’ movement on the website, and gathering demographic information.
Advertising Partners Privacy Policies

You may consult this list to find the Privacy Policy for each of the advertising partners of Blinq Solutions Pvt. Ltd.

Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on Blinq Solutions Pvt. Ltd, which are sent directly to users’ browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.
Note that Blinq Solutions Pvt. Ltd has no access to or control over these cookies that are used by third-party advertisers.

Third Party Privacy Policies
Blinq Solutions Pvt. Ltd’s Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.
You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers’ respective websites.
GDPR Data Protection Rights

We would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:

The right to access – You have the right to request copies of your personal data. We may charge you a small fee for this service.
The right to rectification – You have the right to request that we correct any information you believe is inaccurate. You also have the right to request that we complete the information you believe is incomplete.
The right to erasure – You have the right to request that we erase your personal data, under certain conditions.
The right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions.
The right to object to processing – You have the right to object to our processing of your personal data, under certain conditions.
The right to data portability – You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.

If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.
Children’s Information

Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.
Blinq Solutions Pvt. Ltd does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.

                        ''',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Close',style: ThemeTextStyle.detailPara.copyWith(fontSize:13,color: Colors.deepOrange )),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: screenWidth,
                      height: screenHeight * 0.065,
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () {
                        FocusScope.of(context).unfocus();
                        regUserApi();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: GeneralThemeStyle.button,
                      ),
                      child: isLoading
                          ? const SpinKitWave(
                        color: Colors.white,
                        size: 25.0,
                      )
                          : Text(
                        'Register',
                        style: ThemeTextStyle.detailPara.apply(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.only(top: screenHeight * 0.03),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: Align(
              //           alignment: Alignment.centerRight,
              //           child: Image.asset(
              //             'assets/images/signin.png',
              //             width:
              //             screenWidth * 0.4, // Adjust the width as needed
              //             fit: BoxFit.contain,
              //             alignment: Alignment.centerRight,
              //           ),
              //         ),
              //       ),
              //       Text(
              //         '    or sign up with    ',
              //         style: ThemeTextStyle.generalSubHeading4.copyWith(
              //           color: Colors.grey,
              //           fontSize: 15,
              //         ),
              //       ),
              //       // Expanded(
              //       //   child: Align(
              //       //     alignment: Alignment.centerLeft,
              //       //     child: Image.asset(
              //       //       'assets/images/signin.png',
              //       //       width:
              //       //       screenWidth * 0.4, // Adjust the width as needed
              //       //       fit: BoxFit.contain,
              //       //       alignment: Alignment.centerLeft,
              //       //     ),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment:
              //   CrossAxisAlignment.start, // Align to the top
              //   children: [
              //     SizedBox(
              //       height: screenHeight / 14,
              //       width: screenWidth / 5,
              //       child: IconButton(
              //         icon: Image.asset('assets/images/google.png'),
              //         onPressed: () {
              //          /* print("Google login");*/
              //         },
              //       ),
              //     ),
              //     SizedBox(
              //       height: screenHeight / 14,
              //       width: screenWidth / 5,
              //       child: IconButton(
              //         icon: Image.asset('assets/images/facebook.png'),
              //         onPressed: () {
              //         /*  print("Google login");*/
              //         },
              //       ),
              //     ),
              //     SizedBox(
              //       height: screenHeight / 14,
              //       width: screenWidth / 5,
              //       child: IconButton(
              //         icon: Image.asset('assets/images/apple.png'),
              //         onPressed: () {
              //          /* print("Google login");*/
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 15),


            ],
          ),
        ),
      ),
        if (isLoading)
    Positioned(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black87,
        child: SpinKitWave(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.deepOrangeAccent : Colors.orange,
              ),
            );
          },
          size: 50.0,
        ),
      ),
    ),
]
    ),
    ),
    );
  }
  // @override
  // void dispose() {
  //   mobileController.dispose();
  //   focusNode2.dispose();
  //   super.dispose();
  // }
}


