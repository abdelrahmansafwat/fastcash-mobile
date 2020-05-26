import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;

class ModalInsideModal extends StatelessWidget {
  final ScrollController scrollController;

  const ModalInsideModal({Key key, this.scrollController}) : super(key: key);

  getRecentTransactions() async {
    final storage = new FlutterSecureStorage();
    final url =
        'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/payment/recent';

    var body = new Map<String, dynamic>();
    body["email"] = await storage.read(key: 'email');
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

    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Container(),
        middle: Text(
          'Recent Transactions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(30, 50, 250, 1),
      ),
      child: SafeArea(
        bottom: false,
        child: FutureBuilder(
          future: getRecentTransactions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //print(snapshot.toString());
              return ListView(
                shrinkWrap: true,
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                children: ListTile.divideTiles(
                    context: context,
                    tiles: List.generate(
                      snapshot.data[1].length,
                      (index) => ListTile(
                        title: Text("${snapshot.data[1][index]["paymentFrom"] == snapshot.data[0] ? "You" : snapshot.data[1][index]["paymentFromName"]} paid ${snapshot.data[1][index]["amount"]} EGP to ${snapshot.data[1][index]["paymentFor"] == snapshot.data[0] ? "you" : snapshot.data[1][index]["paymentForName"]}"),
                      ),
                    )).toList(),
              );
            }
            else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    ));
  }
}
