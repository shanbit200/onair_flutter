//import 'dart:ui';

//import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class LoginModel {
  final String customtoken;
  final int status;

  const LoginModel({required this.customtoken, required this.status});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(customtoken: json['customToken'], status: json['status']);
  }
}

class _LoginState extends State<Login> {
  bool _isVisible = false;
  bool _isLoading = false;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  //Future<Login>? _logintask;
  //Future<LoginModel>? _loginresponse;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String customtoken = "";

  final htmlData = """
<p><font color=#ffffff>By signing in , I Agree the </font> <b><a style="color: #de363a" href="https://e2m.live/terms-of-use">Terms of Conditions</a></b> <font color=#ffffff> and <u></font> <b><a style="color: #de363a" href="https://e2m.live/privacy-policy">Privacy Policy</a></b>
""";
  FirebaseAuth auth = FirebaseAuth.instance;

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Future<LoginModel> login(String email, String password) async {
    final SharedPreferences prefs = await _prefs as SharedPreferences;
    final response = await http.post(
      Uri.parse(
          'https://us-central1-uate2monair.cloudfunctions.net/e2monair-uat-get-auth-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailId': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      //log(response.body.toString());

      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //return Album.fromJson(jsonDecode(response.body));
      Map<String, dynamic> json = jsonDecode(response.body);
      prefs.setString("LOGGED_IN_CUSTOM_TOKEN", json['customToken']);
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create Login.');
    }
  }

  _launchURLBrowser(String url) async {
    const url1 = 'https://flutterdevs.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  setFirebaseAuth() async {
    final SharedPreferences prefs = await _prefs as SharedPreferences;

    log(prefs.getString("LOGGED_IN_CUSTOM_TOKEN").toString());
    String token = prefs.getString("LOGGED_IN_CUSTOM_TOKEN").toString();

    auth.signInWithCustomToken(token).then((value) {
      auth.currentUser?.getIdToken(true).then((value) {
        log("getIdToken:" + value.toString());
        prefs.setString("FIREBASE_AUTH_TOKEN", value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(20),
                    child: Image.asset('assets/images/login_logo_dark.png',
                        fit: BoxFit.fill),
                  ),
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
                const Text(
                  "Please enter your email and password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    obscureText: false,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        hintText: "Enter your Email",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        )),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    obscureText: _isVisible ? false : true,
                    cursorColor: Colors.white,
                    controller: _controller2,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        hintText: "Enter your Password",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(_isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.white,
                            onPressed: () => updateStatus())),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              login(_controller.text, _controller2.text)
                                  .then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (value.status == 0) {
                                  setFirebaseAuth();
                                  Navigator.pushNamed(context, '/evenlist');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Your login or password was incorrect. Please try again or click here to reset your password")));
                                }
                              });
                            },
                            child: (_isLoading)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )))),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Html(
                      data: htmlData,
                      onLinkTap: (url, context, attributes, element) =>
                          _launchURLBrowser(url.toString()),
                    ))
              ],
            ))));
  }
}
