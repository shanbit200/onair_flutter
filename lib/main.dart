import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onair_flutter/firebase_options.dart';
import 'package:onair_flutter/pages/eventlist.dart';
import 'package:onair_flutter/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/evenlist': (context) => Eventlistpage()
      },
      //home: Login(),
    );
  }
}
