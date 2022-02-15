//import 'dart:ui';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isVisible = false;

  final htmlData = """
<p><font color=#ffffff>By signing in , I Agree the </font> <b><a style="color: #de363a" href="https://e2m.live/terms-of-use">Terms of Conditions</a></b> <font color=#ffffff> and <u></font> <b><a style="color: #de363a" href="https://e2m.live/privacy-policy">Privacy Policy</a></b>
""";
  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  _launchURLBrowser(String url) async {
    const url1 = 'https://flutterdevs.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                    obscureText: _isVisible ? true : false,
                    cursorColor: Colors.white,
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
                            onPressed: () => {},
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )))),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Html(
                      data: htmlData,
                      onLinkTap: (url, context, attributes, element) =>
                          _launchURLBrowser(url.toString()),
                    ))
              ],
            )));
  }
}
