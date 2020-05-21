import 'package:fastcash/notifications.dart';
import 'package:flutter/material.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  TextEditingController Phone = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();
  bool acceptTerm = false;
  AuthenticationService auth = new AuthenticationService();
  final storage = new FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  final PushNotificationService _pushNotificationService =
      PushNotificationService();

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

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'phone number is required'),
    //MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
    PatternValidator(r'\b0((11)|(10)|(12)|(15))(\d){7}\w\b', errorText: 'enter a valid phone number')
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

      if (response.statusCode == 200) {
        return true;
      }
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
    var response = await http.post(url, body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Terms & Conditions Error"),
      content: Text("You must accept Terms & Conditions to register."),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                    '< BACK',
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
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
                    validator: phoneValidator,
                    style: TextStyle(color: Colors.white),
                    controller: Phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: passwordValidator,
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
                        'Terms & Conditions',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.info,
                          title: "TERMS & CONDITIONS",
                          desc:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  acceptTerm = !acceptTerm;
                                });
                              },
                              color: Color.fromRGBO(50, 205, 50, 1),
                            ),
                          ],
                        ).show();
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
                              await getToken();
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
