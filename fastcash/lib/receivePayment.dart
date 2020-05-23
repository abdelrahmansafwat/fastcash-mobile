import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const url =
    'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/payment/receive';

class ReceivePayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReceivePayment();
}

class _ReceivePayment extends State<ReceivePayment> {
  var qrCode = "";
  var amount = "";
  var description = "";
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: <Widget>[
              Expanded(
                child: QrImage(
        data: qrCode,
        version: QrVersions.auto,
        size: 300.0,
        padding: EdgeInsets.only(top: 40),
                ),
                flex: 4,
              ),
              Expanded(
                child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (text) {
                  setState(() {
                    amount = text;
                  });
                },
              ),
            ),
            Container(
              width: 300,
              padding: EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (text) {
                  setState(() {
                    description = text;
                  });
                },
              ),
            ),
            Container(
              width: 250,
              child: RaisedButton(
                color: Color.fromRGBO(30, 50, 250, 1),
                //textColor: styleOBJ ? Color(0xffffffff) : Color(0xff1F32FA),
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Color(0xff4B5AFB),
                //onHighlightChanged: (boolValue) => changeStyle(boolValue),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                onPressed: () async {
                  var body = new Map<String, dynamic>();
                  /*
                  var body = json.encode({
                    'amount': double.parse(amount),
                    'email': 'test@test.com'
                  });
                  */
                  //var email = await storage.read(key: 'email');
                  //print(email);
                  var firstName = await storage.read(key: 'firstName');
                  var lastName = await storage.read(key: 'lastName');
                  body["email"] = await storage.read(key: 'email');
                  body["amount"] = amount;
                  body["description"] = description;
                  body["paymentForName"] = firstName + " " + lastName;
                  print(body.toString());
                  var response =
                      await http.post(url, body: body, headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded"
                  });
                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  setState(() {
                    qrCode = jsonDecode(response.body)["code"];
                  });
                },
                child: Text(
                  "Generate QR Code",
                  //style: TextStyle(fontSize: 20.0, color: highlightTextColor),
                ),
              ),
            ),
          ],
        ),
                ),
                flex: 4,
              )
            ],
          ),
      ),
    );
  }
}
