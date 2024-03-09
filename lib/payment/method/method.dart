import 'package:flutter/material.dart';

class method extends StatelessWidget {
  const method({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Method  page'),
      ),
      body: const Center(
        child: Text(
          'Hello This is Method   page ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
