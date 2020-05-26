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
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/information';

    
    var body = new Map<String, dynamic>();
    body["email"] = await storage.read(key: 'email');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
  

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: Container(), middle: Text('Recent Transactions', style: TextStyle(color: Colors.white),), backgroundColor: Color.fromRGBO(30, 50, 250, 1),),
      child: SafeArea(
        bottom: false,
        child: ListView(
          shrinkWrap: true,
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                5,
                (index) => ListTile(
                    title: Text('Item'),
                ),
              )).toList(),
        ),
      ),
    ));
  }
}