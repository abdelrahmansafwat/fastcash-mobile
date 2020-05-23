import 'package:fastcash/home.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const checkUrl =
    'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/payment/check';

const sendUrl =
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
  var confirmPayment;

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
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    final storage = new FlutterSecureStorage();

    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      //var body = json.encode({'code': scanData, 'email': 'test2@test.com'});
      var body = new Map<String, dynamic>();
      body["code"] = scanData;
      body["email"] = await storage.read(key: 'email');
      print(body);
      var checkResponse = await http.post(checkUrl, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      print('Check response status: ${checkResponse.statusCode}');
      print('Check response body: ${checkResponse.body}');
      var data = jsonDecode(checkResponse.body)["data"];
      if (checkResponse.statusCode == 200) {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "CONFIRM",
          desc:
              "Are you sure you want to pay ${data["amount"]}EGP to ${data["paymentForName"]}?",
          buttons: [
            DialogButton(
              child: Text(
                "YES",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context);
                var firstName = await storage.read(key: 'firstName');
                var lastName = await storage.read(key: 'lastName');
                body["name"] = firstName + " " + lastName;
                var sendResponse =
                    await http.post(sendUrl, body: body, headers: {
                  "Accept": "application/json",
                  "Content-Type": "application/x-www-form-urlencoded"
                });
                print('Send response status: ${sendResponse.statusCode}');
                print('Send response body: ${sendResponse.body}');
                var responseBody = jsonDecode(sendResponse.body)["data"];
                print("Test body" + responseBody);
                if (sendResponse.statusCode == 200 && responseBody != null) {
                  Alert(
                    context: context,
                    type: AlertType.success,
                    title: "SUCCESS",
                    desc: "Payment sent successfuly.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                        color: Color.fromRGBO(50, 205, 50, 1),
                      ),
                    ],
                  ).show();
                } else {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "ERROR",
                    desc: "An error occurred. Please try again later.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          controller.resumeCamera();
                        },
                        color: Color.fromRGBO(50, 205, 50, 1),
                      ),
                    ],
                  ).show();
                }
              },
              color: Color.fromRGBO(50, 205, 50, 1),
            ),
            DialogButton(
              child: Text(
                "NO",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.resumeCamera();
              },
              color: Color.fromRGBO(139, 0, 0, 1.0),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "ERROR",
          desc: "An error occurred. Please try again later.",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                controller.resumeCamera();
              },
              color: Color.fromRGBO(50, 205, 50, 1),
            ),
          ],
        ).show();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
