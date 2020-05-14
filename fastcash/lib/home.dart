import 'package:fastcash/login.dart';
import 'package:flutter/material.dart';
import 'package:fastcash/sendPayment.dart';
import 'package:fastcash/receivePayment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatelessWidget {
  final storage = new FlutterSecureStorage();

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
            child: Text('Log Out'),
            onPressed: () async {
              await storage.deleteAll();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
