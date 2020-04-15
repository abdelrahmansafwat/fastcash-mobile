import 'package:fastcash/intro.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/receivePayment.dart';
import 'package:fastcash/registerFirstPage.dart';
import 'package:fastcash/sendPayment.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
  
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            //child: IntroScreen(),
            //child: LoginScreen(),
            child: RegisterFirstPage(),
            //child: ReceivePayment(),
          ),
        ),
      ),
      
    );
  }
  
}