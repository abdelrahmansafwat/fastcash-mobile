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
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: QrImage(
              data: qrCode,
              version: QrVersions.auto,
              size: 200.0,
            ),
            flex: 4,
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Amount"),
                  Container(
                    width: 100,
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          amount = text;
                        });
                      },
                    ),
                  ),
                  RaisedButton(
                    color: Color(0xffffffff),
                    //textColor: styleOBJ ? Color(0xffffffff) : Color(0xff1F32FA),
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
                      body["email"] = await storage.read(key: 'email');
                      body["amount"] = amount;
                      print(body.toString());
                      var response = await http.post(url, body: body, headers: {
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
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
