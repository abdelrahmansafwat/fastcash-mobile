import 'package:flutter/material.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'login.dart';
import 'package:fastcash/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RegisterFirstPage extends StatefulWidget {
  @override
  _RegisterFirstPage createState() {
    return new _RegisterFirstPage();
  }
}

class _RegisterFirstPage extends State<RegisterFirstPage> {
  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();
  bool acceptTerm = false;
  AuthenticationService auth = new AuthenticationService();
  final storage = new FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: 'enter a valid email address'),
    //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  final url =
    'https://cvgynkhgj8.execute-api.eu-central-1.amazonaws.com/dev/api/user/register';
  

  authenticate() async {
    var result =
        await auth.signUpWithEmail(email: Email.text, password: Password.text);
    if (result != null) {
      await storage.write(key: "email", value: Email.text);
      await storage.write(key: "password", value: Password.text);

      var body = new Map<String, dynamic>();
      body["firstname"] = FirstName.text;
      body["lastname"] = LastName.text;
      body["email"] = Email.text;
      var response = await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if(response.statusCode == 200){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = AlertDialog(
    title: Text("Terms & Conditions Error"),
    content: Text("You must accept Terms & Conditions to register."),
    actions: [
      FlatButton(
        child: Text("OK"),
        onPressed: () {Navigator.of(context).pop();},
      )
    ],
  );

    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: DecoratedBox(
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
                  child: TextFormField(
                    validator:
                        RequiredValidator(errorText: 'first name is required'),
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
                  child: TextFormField(
                    //obscureText: true,
                    validator:
                        RequiredValidator(errorText: 'first name is required'),
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
                  child: TextFormField(
                    validator: emailValidator,
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
                  child: TextFormField(
                    validator: passwordValidator,
                    obscureText: true,
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
                  child: TextFormField(
                    validator: (val) =>
                        MatchValidator(errorText: 'passwords do not match')
                            .validateMatch(val, Password.text),
                    controller: ConfirmPassword,
                    obscureText: true,
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
                      onChanged: (bool value) {
                        setState(() {
                          acceptTerm = !acceptTerm;
                        });
                      },
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
                      onPressed: () async {
                        if (acceptTerm) {
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            var result = await authenticate();
                            if (result) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}
