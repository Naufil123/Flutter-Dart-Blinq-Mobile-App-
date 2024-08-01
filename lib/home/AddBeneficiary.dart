
import '../appData/ApiData.dart';
import '../appData/dailogbox.dart';
import 'package:flutter/material.dart';
import '../appData/ThemeStyle.dart';
import 'NotificationScreen.dart';

class AddBeneficiary extends StatefulWidget {
  const AddBeneficiary({super.key});
  @override
  _AddBeneficiaryState createState() => _AddBeneficiaryState();
}
class _AddBeneficiaryState extends State<AddBeneficiary> {
  bool notification = true;
   String imgNotifyUrl = "assets/images/Notification.png";
  Map<String, dynamic> searchedInvoices = [] as Map<String, dynamic>;
  final SearchController searchController = SearchController();
  Future<Map<String, dynamic>> fetchSearchInvoice() async {
    String searchId = searchController.text;
    var data = await ApiData.getAllSearchedInvoices(searchId);
    searchedInvoices = data;
    print(searchedInvoices['transaction_charges'].length);
    return searchedInvoices;
  }
  Widget InvoiceDataWidget(i, width){
    String message = searchedInvoices['message'].toString();
    if(searchedInvoices.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
      child: SizedBox(
        width: width,
        height: 50,

        child: TextFormField(
          controller: null,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: searchedInvoices['invoice_data']['customer_mobile1'],
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: GeneralThemeStyle.button, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: GeneralThemeStyle.output, width: 1.0),
            ),
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
  }

  void _showDialog3(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    FAQ.showAlertDialog(
      context,
      'Successful!',
      'Your ID has been verified \nsuccessfully!',
      screenWidth,
    );
  }
  @override
  void didUpdateWidget(covariant AddBeneficiary oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget: notification = $notification");
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    print("didUpdateWidget: notification = $notification");
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, screenHeight * 0.01, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                'assets/images/Ellipse3.png',
                                width: screenWidth / 6,
                                height: screenHeight * 0.1,
                              ),
                              Positioned(
                                top: screenHeight * 0.04,
                                left: 0,
                                right: 0,
                                child: const Center(
                                  child: Text(
                                    'NN',
                                    style: ThemeTextStyle.roboto,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: screenHeight * 0.004),
                                child: Text(
                                  'Good Morning',
                                  style: ThemeTextStyle.good1.copyWith(fontSize: 12),
                                ),
                              ),


                              const Text('Assalam Walaikum',
                                style: ThemeTextStyle.good2,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showDialog3(context);
                            },
                            icon: Image.asset(
                              'assets/images/help.png',
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                            ),
                          ),

                          IconButton(
                            onPressed: () {

                                setState(() {
                                  notification = !notification;

                                });

                            },

                            icon: Builder(
                              builder: (context) {
                                if (notification) {
                                  return Image.asset(
                                    "assets/images/Notification.png",
                                    width: screenWidth/8,
                                    height: 40.0,
                                  );
                                } else {
                                  return Image.asset(
                                    "assets/images/NoNotification.png",
                                    width: screenWidth/10,
                                    height: 40.0,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Profile Section
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        child: Image.asset(
                          'assets/images/Rectangle.png',
                          width: screenWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Registered Mobile',
                                style: ThemeTextStyle.Good.apply(color: Colors.white),
                              ),
                              SizedBox(width: screenWidth /8),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '03361223839',
                                style: ThemeTextStyle.Good.apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(130,0,0,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: ThemeTextStyle.Good.apply(color: Colors.white),
                          ),

                          Text(
                            'Naufil Siddiqui',
                            style: ThemeTextStyle.Good.apply(color: Colors.white),
                          ),
                        ],
                      ),
                    ),


                    Positioned(
                      top: screenHeight * 0.15,
                      right: screenWidth * 0.02,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth / 2 - screenWidth * 0.03,
                            height: screenHeight * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(screenWidth * 0.0375),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: screenWidth * 0.0025,
                                  blurRadius: screenWidth * 0.005,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            // Add your content for the fourth sub-container here
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Feature Section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/unpaid');
                        },
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.075), // Adjust the border radius for a square shape
                          ),
                          color: Colors.transparent, // Set the color to transparent to avoid the default splash color
                          child: SizedBox(
                            height: 90,
                            width: screenWidth / 5,
                            child: Image.asset(
                              'assets/images/unpaidbill.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/paid');
                        },
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.075), // Adjust the border radius for a square shape
                          ),
                          color: Colors.transparent, // Set the color to transparent to avoid the default splash color
                          child: SizedBox(
                            height: 90,
                            width: screenWidth / 5,
                            child: Image.asset(
                              'assets/images/paidbill.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("unpaid bill");
                        },
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.075), // Adjust the border radius for a square shape
                          ),
                          color: Colors.transparent, // Set the color to transparent to avoid the default splash color
                          child: SizedBox(
                            height: 90,
                            width: screenWidth / 5,
                            child: Image.asset(
                              'assets/images/Benificary.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(
                              width: screenWidth,
                              height: 50,
                              //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                              child: TextFormField(
                                controller: searchController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Search Invoices',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: GeneralThemeStyle.button, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(0)
                                    ),
                                    borderSide: BorderSide(
                                        color: GeneralThemeStyle.output, width: 1.0),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(
                              height: 50,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  backgroundColor: Colors.orange,
                                  textStyle: const TextStyle(
                                      fontSize: 17,
                                      color: Color(0xff000000)),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(0)
                                      )),
                                ),
                                onPressed: () {
                                  fetchSearchInvoice();
                                },
                                child: const Icon(Icons.search, color: Color(0xffffffff),)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                  child: Text("Details",style: TextStyle(
                    fontSize: 16,
                  ),),
                ),
                for(var i = 0;i<=searchedInvoices.length;i++)
                  InvoiceDataWidget(i, screenWidth),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                  child: SizedBox(
                    width: screenWidth,
                    height: 50,
                    //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                    child: TextFormField(
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: '1Bill Invoice Id',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.button, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.output, width: 1.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                  child: SizedBox(
                    width: screenWidth,
                    height: 50,
                    //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                    child: TextFormField(
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Due Date',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.button, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.output, width: 1.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                  child: SizedBox(
                    width: screenWidth,
                    height: 50,
                    //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                    child: TextFormField(
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.button, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.output, width: 1.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                  child: SizedBox(
                    width: screenWidth,
                    height: 50,
                    //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                    child: TextFormField(
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Invoice Amount',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.button, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.output, width: 1.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                  child: SizedBox(
                    width: screenWidth,
                    height: 50,
                    //margin: const EdgeInsets.fromLTRB(0, 210, 0, 0),
                    child: TextFormField(
                      controller: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Biller Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.button, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: GeneralThemeStyle.output, width: 1.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
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
//
// void initState(){
//   super.initState();
// }