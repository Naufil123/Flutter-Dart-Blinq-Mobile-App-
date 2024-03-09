import 'package:flutter/material.dart';

class invoiceSummary extends StatelessWidget {
  const invoiceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Summary  page'),
      ),
      body: const Center(
        child: Text(
          'Hello This is Invoice Summary   page ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
