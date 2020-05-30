import 'dart:convert';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_form/Home/homeScreen.dart';
//import 'package:tutorial_project/SignUp/signUpScreen.dart';
import 'package:login_form/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState> (); //This uniquely identifies the Form, and allows validaton of the form in the later step.
  var username;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {

        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height * 2,
        color: Colors.red,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
                        child: RichText(
                          text: TextSpan(
                            text: 'Blood ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                )
                              ),
                              TextSpan(
                                text: 'System',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                )
                              )
                            ]
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4.0,
                        color: Colors.indigo,
                        margin: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal
                                    ),

                                  ),
                                  validator: (emailValue) {
                                    if (emailValue.isEmpty) {
                                      return 'Please Enter your email address.';
                                    }
                                    username=emailValue;
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  validator: (passwordValue) {
                                    if (passwordValue.isEmpty) {
                                      return 'Please enter your password.';
                                    }
                                    password = passwordValue;
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: RaisedButton(
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                      child: Text(
                                        _isLoading? 'Processing...': 'Login',
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    color: Colors.white,
                                    disabledColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _login();
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'username': username,
      'password': password
    };

    var res = await CallApi().postData(data, '/login/');

    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => Home()));
    }

    else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
