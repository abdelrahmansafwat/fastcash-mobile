import 'package:flutter/material.dart';
import 'package:fastcash/sendPayment.dart';
import 'package:fastcash/receivePayment.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Text('Send'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendPayment()),
              );
            },
          ),
        ),
      ),
    );
  }
}
