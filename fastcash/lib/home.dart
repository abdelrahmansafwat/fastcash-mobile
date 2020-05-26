import 'dart:convert';
import 'package:fastcash/history.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fastcash/locator.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/notifications.dart';
import 'package:flutter/material.dart';
import 'package:fastcash/sendPayment.dart';
import 'package:fastcash/receivePayment.dart';
import 'package:fastcash/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'modal.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final storage = new FlutterSecureStorage();
  //final PushNotificationService _pushNotificationService = locator<PushNotificationService>();
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  final url =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/notifications';

  final walletUrl =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/wallet';

  var name = " ";
  var userEmail = " ";
  var wallet = "";

  getInformation() async {
    var firstName = await storage.read(key: 'firstName');
    var lastName = await storage.read(key: 'lastName');
    var email = await storage.read(key: 'email');

    var body = new Map<String, dynamic>();
    body["email"] = email;
    var response = await http.post(walletUrl, body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var data = jsonDecode(response.body)["data"];

    setState(() {
      name = firstName + " " + lastName;
      userEmail = email;
      wallet = data["wallet"].toString();
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInformation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Cash',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          height: 45,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                color: Color.fromRGBO(30, 50, 250, 1),
                child: ListTile(
                  title: Text(
                    "Recent Transactions",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await getInformation();
                    showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context, scrollController) =>
                          ModalInsideModal(scrollController: scrollController),
                    );
                  },
                ),
              )),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/ART.png"), fit: BoxFit.cover),
                  color: Color.fromRGBO(30, 50, 250, 1),
                ),
                child: ListView(children: <Widget>[
                  Center(
                    child: Text(name,
                        style: TextStyle(color: Colors.white, fontSize: 40)),
                  ),
                  Center(
                    child: Text(userEmail,
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )
                ]),
              ),
              ListTile(
                title: Text("Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                title: Text("Transactions History"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => History()),
                  );
                },
              ),
              ListTile(
                title: Text("Log Out"),
                onTap: () async {
                  await storage.deleteAll();
                  //await getToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Fast Cash'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Text(
                  "Balance",
                  style: TextStyle(fontSize: 30),
                ),
                Text(wallet + " EGP",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ButtonTheme(
                        height: 80,
                        minWidth: 140,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          textColor: Colors.white,
                          color: Color.fromRGBO(30, 50, 250, 1),
                          child: Text('Send', style: TextStyle(fontSize: 25),),
                          onPressed: () async {
                            //await storage.deleteAll();
                            //await getToken();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendPayment()),
                            );
                          },
                        ),
                      ),
                      ButtonTheme(
                        height: 80,
                        minWidth: 140,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Receive', style: TextStyle(fontSize: 25),),
                          onPressed: () async {
                            //await storage.deleteAll();
                            //await getToken();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReceivePayment()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
