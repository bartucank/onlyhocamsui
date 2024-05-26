import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Center(
        child: Text('This is the Note Page'),
      ),
    );
  }
}
