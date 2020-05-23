import 'dart:convert';
import 'package:fastcash/auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'home.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final url =
      'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/update';
  var information = new Map<String, dynamic>();
  final storage = new FlutterSecureStorage();

  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'phone number is required'),
    //MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    PatternValidator(r'\b0((11)|(10)|(12)|(15))(\d){7}\w\b',
        errorText: 'enter a valid phone number')
  ]);

  AuthenticationService auth = new AuthenticationService();

  final _formKey = GlobalKey<FormState>();

  getInformation() async {
    var email = await storage.read(key: 'email');
    var firstName = await storage.read(key: 'firstName');
    var lastName = await storage.read(key: 'lastName');
    var phone = await storage.read(key: 'phone');

    setState(() {
      FirstName.text = firstName;
      LastName.text = lastName;
      Email.text = email;
      Phone.text = phone;
    });
  }

  updateUser() async {
    if (Password.text != "Password") {
      var password = await storage.read(key: 'password');
      var user =
          (await auth.loginWithEmail(email: Email.text, password: password))
              .user;
      if (user != null) {
        user.updatePassword(Password.text).then((_) {
          print("Succesfully changed password");
        }).catchError((error) {
          print("Password can't be changed " + error.toString());
        });
      }
      else {
        return false;
      }
    }

    var body = new Map<String, dynamic>();
      body["firstname"] = FirstName.text;
      body["lastname"] = LastName.text;
      body["email"] = Email.text;
      body["phone"] = Phone.text;
      var response = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      }
      else {
        return false;
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInformation();
    Password.text = "Password";
    ConfirmPassword.text = "Password";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
        body: Form(
      key: _formKey,
      child: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 50.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      FlatButton(
                  padding: EdgeInsets.fromLTRB(0, 10, 250, 0),
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
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    //enabled: !_status,
                                    //initialValue: information["firstName"],
                                    readOnly: !_status,
                                    controller: FirstName,
                                    validator: RequiredValidator(
                                        errorText: 'first name is required'),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'First Name',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    //enabled: !_status,
                                    readOnly: _status,
                                    controller: LastName,
                                    //initialValue: information["lastName"],
                                    validator: RequiredValidator(
                                        errorText: 'last name is required'),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Last Name',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    //enabled: !_status,
                                    readOnly: true,
                                    //initialValue: information["email"],
                                    controller: Email,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    //enabled: !_status,
                                    readOnly: _status,
                                    initialValue: information["phone"],
                                    validator: phoneValidator,
                                    controller: Phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: new TextFormField(
                                    //enabled: !_status,
                                    readOnly: _status,
                                    //initialValue: "Password",
                                    controller: Password,
                                    validator: passwordValidator,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                    ),
                                    obscureText: true,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: new TextFormField(
                                      //enabled: !_status,
                                      readOnly: _status,
                                      controller: ConfirmPassword,
                                      validator: (val) => MatchValidator(
                                              errorText:
                                                  'passwords do not match')
                                          .validateMatch(val, Password.text),
                                      //initialValue: "Password",
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Confirm Password',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      obscureText: true,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                  if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      var update = await updateUser();

                      if(update){
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "SUCCESS",
                          desc:
                              "User information updated successfully.",
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
                      else {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "ERROR",
                          desc:
                              "An error occured. Please try again later.",
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
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
