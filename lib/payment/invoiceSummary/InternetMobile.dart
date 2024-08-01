import 'package:flutter/material.dart';

class InternetMobileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Mobile'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Internet Mobile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Image.asset(
            //   'assets/mobile_internet.png', // Replace 'mobile_internet.png' with your actual image asset path
            //   width: 200,
            // ),
          ],
        ),
      ),
    );
  }
}
