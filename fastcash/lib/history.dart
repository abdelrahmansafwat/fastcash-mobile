import 'dart:convert';
import 'package:fastcash/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _History();
}

class _History extends State<History> {
  ScrollController scrollController;

  final storage = new FlutterSecureStorage();

  final url =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/payment/history';

  var name = " ";
  var userEmail = " ";
  var wallet = "";

  convertTime(time){
    var day = DateTime.parse(time).day;
    var month = DateTime.parse(time).month;
    var year = DateTime.parse(time).year;
    var hour = DateTime.parse(time).hour;
    var minute = DateTime.parse(time).minute;
    var ampm = hour >= 12 ? "PM" : "AM";

    if(hour > 12){
      hour -= 12;
    }

    if(hour == 0){
      hour = 12;
    }

    var converted = "$day/$month/$year $hour:$minute $ampm";

    return converted;
  }

  getHistory() async {
    var email = await storage.read(key: 'email');

    var body = new Map<String, dynamic>();
    body["email"] = email;
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var transactions = jsonDecode(response.body)["data"];

    var allData = new List();
    allData.add(body["email"]);
    allData.add(transactions);

    //print(allData[1][0]["paymentFromName"]);

    List cards = new List.generate(
        allData[1].length,
        (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                elevation: 30,
                //color: Color.fromRGBO(30, 50, 250, 1),
                child: Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                        Text(
                            "${allData[1][index]["paymentFrom"] == allData[0] ? "You" : allData[1][index]["paymentFromName"]} paid ${allData[1][index]["amount"]} EGP to ${allData[1][index]["paymentFor"] == allData[0] ? "you" : allData[1][index]["paymentForName"]}"),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                        Text(
                            "Description: ${allData[1][index]["description"]}"),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20)),
                        Text(
                            "Date: ${convertTime(allData[1][index]["date"])}"),
                      ],
                    ),
                  ],
                ),
              ),
            )).toList();

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Cash',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.fromLTRB(0, 10, 300, 0),
              textColor: Colors.black,
              child: Text(
                '< BACK',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            FutureBuilder(
              future: getHistory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //print(snapshot.toString());
                  return ListView(
                    shrinkWrap: true,
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    children: snapshot.data,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
