import 'package:flutter/material.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/auth.dart';
import 'login.dart';
import 'package:fastcash/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterFirstPage extends StatelessWidget {
  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Country = TextEditingController();
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();
  bool acceptTerm = false;
  AuthenticationService auth = new AuthenticationService();
  final storage = new FlutterSecureStorage();

  authenticate() async {
    var result =
        auth.signUpWithEmail(email: Email.text, password: Password.text);
    if (result != null) {
      await storage.write(key: "email", value: Email.text);
      await storage.write(key: "password", value: Password.text);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            //image: DecorationImage(image: AssetImage("images/loginPage.png"), fit: BoxFit.cover),
            color: Color.fromRGBO(30, 50, 250, 1),
          ),
          child: ListView(
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.fromLTRB(0, 10, 260, 0),
                textColor: Colors.white,
                child: Text(
                  '< Back',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: FirstName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: LastName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: Email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: Password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: ConfirmPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                  child: Row(
                children: <Widget>[
                  Checkbox(
                    value: acceptTerm,
                    onChanged: (bool value) {},
                  ),
                  Text('I have accepted the',
                      style: TextStyle(color: Colors.white70)),
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Term & Condition',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      //signup screen
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Next'),
                    onPressed: () {
                      var result = authenticate();
                      if (result) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
