import 'package:flutter/material.dart'; 

class LoginScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage("images/loginPage.png"), fit: BoxFit.cover),
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
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
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
                      onPressed: () {
                        print(nameController.text);
                        print(passwordController.text);
                      },
                    )),
                    FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password',style: TextStyle(color: Colors.white),),
                  
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text('Does not have account?' , style: TextStyle(color: Colors.white70)),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          //signup screen
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            ));
  }
} 