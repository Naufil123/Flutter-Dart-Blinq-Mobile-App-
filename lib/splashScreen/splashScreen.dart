import 'package:flutter/material.dart';

class splashSCreen extends StatelessWidget {
  const splashSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('splashScreen  page'),
      ),
      body: const Center(
        child: Text(
          'Hello This is splashScreen  page ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
