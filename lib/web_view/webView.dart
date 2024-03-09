import 'dart:async';
// import 'package:blinq/web_view/webView.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class webView extends StatefulWidget {
  Map<String, dynamic> paramSearchedInvoices;
  webView(
      {
        super.key,
        required this.paramSearchedInvoices,
      }
      );

  @override
  _webViewState createState() => _webViewState();
}

class _webViewState extends State<webView> {
  String currentURL = '';
  bool cancelTimer = false;
  bool webUrlAccess = false;
  static String parseURLDynamic = 'https://www.google.com.pk/';



  final WebController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState(){
    setState(() {
      parseURLDynamic = widget.paramSearchedInvoices["payment_rights"]["web_view_url"];

      WebController.loadRequest(Uri.parse(parseURLDynamic));
      Timer.periodic(
          Duration(seconds: 1), (Timer t) {
        checkUrl();
        if(cancelTimer==true){
          t.cancel();
        }
      }
      );
      print(widget.paramSearchedInvoices);
    });
    super.initState();
  }


  Future<void> checkUrl() async {
    currentURL = (await WebController.currentUrl())!;
    print(currentURL + " is current webview url;");
    print("In Progress...");

    final queryStringData =  Uri.parse(currentURL);
    print(queryStringData.queryParameters);

    if(queryStringData.queryParameters["status"] == "Success"){
      print("Transaction success");
      print("Status Code: "+queryStringData.queryParameters["status"]!);
      _showMyDialog(queryStringData.queryParameters["status"]);
      setState(() {
        cancelTimer=true;
      });
    }else {
      print("Transaction Failed");
      print("Status Code: "+queryStringData.queryParameters["status"]!);
      _showMyDialog(queryStringData.queryParameters["status"]);
      setState(() {
        cancelTimer=true;
      });
    }
    // if(currentURL!=parseURLDynamic){
    //   print("Transaction success");
    //   // _showMyDialog();
    //   setState(() {
    //     cancelTimer=true;
    //   });
    // }
    print(parseURLDynamic + " is Dynamic webview url;");
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer=true;
  }

  Future<void> _showMyDialog(String? queryParameter) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        print(queryParameter! + "****** Query parameter");
        return AlertDialog(
          title: Column(
            children: [
              queryParameter=="Success" ? Icon(Icons.check_circle,color: Colors.green,size: 50,) :  Icon(Icons.sms_failed,color: Colors.red,size: 50,),
              Container(height: 15,),
              queryParameter=="Success" ? Text('Transaction Successful!') : Text('Transaction Failed!'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                queryParameter=="Success" ?
                Text('We have received your transaction. Your payment status will be updated soon.') :
                Text('We are sorry as your transaction can not be processed.'),
              ],
            ),
          ),
          actions: <Widget>[
            queryParameter=="Success" ?
            TextButton(
              child: const Text('View Paid Invoices'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/paid');
              },
            )
                : TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pay');
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      appBar: AppBar(
        title: Text("Credit/Debit Transaction"),
        actions: [

        ],
      ),

      body: webUrlAccess==true ? Text("Loading Data") : WebViewWidget(
        controller: WebController,
      ),
    );

  }

}
