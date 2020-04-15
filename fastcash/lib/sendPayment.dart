import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const url =
    'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/payment/send';

class SendPayment extends StatefulWidget {
  const SendPayment({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SendPaymentState();
}

class _SendPaymentState extends State<SendPayment> {
  var qrText = "";
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
            flex: 4,
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Result: $qrText"),
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      //var body = json.encode({'code': scanData, 'email': 'test2@test.com'});
      var body = new Map<String, dynamic>();
      body["code"] = scanData;
      body["email"] = "test2@test.com";
      var response = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      setState(() {
        qrText = body.toString();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
