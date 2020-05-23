import 'dart:convert';

import 'package:fastcash/notifications.dart';
import 'package:flutter/material.dart';
import 'package:fastcash/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fastcash/home.dart';
import 'package:fastcash/registerFirstPage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'locator.dart';

class LoginScreen extends StatelessWidget {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  //0((11)|(10)|(12)|(15))\d{8}

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: 'enter a valid email address'),
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //final AuthenticationService auth = locator<AuthenticationService>();
  final AuthenticationService auth = new AuthenticationService();
  final storage = new FlutterSecureStorage();

  final url =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/information';

  final tokenUrl =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/notifications';

  final _formKey = GlobalKey<FormState>();

  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  getInformation() async {
    var body = new Map<String, dynamic>();
    body["email"] = await storage.read(key: 'email');
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var user = jsonDecode(response.body)["data"];
    print(user);
    await storage.write(key: "firstName", value: user["firstName"]);
    await storage.write(key: "lastName", value: user["lastName"]);
    await storage.write(key: "phone", value: user["phone"]);
  }

  authenticate() async {
    var result = await auth.loginWithEmail(
        email: nameController.text, password: passwordController.text);

    //print("Firebase result: " + result.toString());
    if (result != null) {
      print("Saving credintials in storage...");
      await storage.write(key: "email", value: nameController.text);
      await storage.write(key: "password", value: passwordController.text);
      //var email = await storage.readAll();
      //print(email);
      await getInformation();
      return true;
    }
    return false;
  }

  getToken() async {
    print("Getting token...");
    await _pushNotificationService.initialise();
    var token = await _pushNotificationService.getToken();
    print(token);
    var body = new Map<String, dynamic>();
    body["token"] = token;
    body["email"] = await storage.read(key: 'email');
    var response = await http.post(tokenUrl, body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/loginPage.png"), fit: BoxFit.cover),
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(80),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: emailValidator,
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    validator: passwordValidator,
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          var result = await authenticate();
                          if (result) {
                            var token = await getToken();
                            if (token) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                          } else {
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "ERROR",
                              desc: "Wrong email/password.",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Color.fromRGBO(50, 205, 50, 1),
                                ),
                              ],
                            ).show();
                          }
                        }
                      },
                    )),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Don\'t have account?',
                        style: TextStyle(color: Colors.white70)),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterFirstPage()),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
