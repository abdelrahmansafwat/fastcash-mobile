import 'package:fastcash/locator.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/notifications.dart';
import 'package:flutter/material.dart';
import 'package:fastcash/sendPayment.dart';
import 'package:fastcash/receivePayment.dart';
import 'package:fastcash/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  //final PushNotificationService _pushNotificationService = locator<PushNotificationService>();
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  final url =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/notifications';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Receive'),
                onPressed: () async {
                  //await storage.deleteAll();
                  //await getToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReceivePayment()),
                  );
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Send'),
                onPressed: () async {
                  //await storage.deleteAll();
                  //await getToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendPayment()),
                  );
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Logout'),
                onPressed: () async {
                  await storage.deleteAll();
                  //await getToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
