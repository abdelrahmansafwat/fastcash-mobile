import 'package:fastcash/intro.dart';
import 'package:fastcash/login.dart';
import 'package:fastcash/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  final storage = new FlutterSecureStorage();

  Future<bool> skipIntro() async {
    print("Skipping intro...");
    var data = await storage.readAll();
    print("User data: " + data.toString());
    var intro = await storage.read(key: 'intro');
    return intro != null;
  }

  Future<bool> loggedIn() async {
    print("Logging in...");
    var email = await storage.read(key: 'email');
    var password = await storage.read(key: 'password');
    print("Email: " + email + " Password: " + password);
    return ((email != null) && (password != null));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Center(
            //child: IntroScreen(),
            //child: LoginScreen(),
            //child: await skipIntro() ? (loggedIn() ? Home() : LoginScreen()) : IntroScreen(),
            child: FutureBuilder<bool>(
              future: skipIntro(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return FutureBuilder<bool>(
                      future: loggedIn(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data) {
                            return Home();
                          } else {
                            return LoginScreen();
                          }
                        }
                        else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return IntroScreen();
                  }
                }
                else {
                  return CircularProgressIndicator();
                }
              },
            ),
            //child: ReceivePayment(),
          ),
        ),
      ),
    );
  }
}
