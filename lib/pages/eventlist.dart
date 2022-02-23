import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Eventlistpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventlistState();
}

class EventlistState extends State<Eventlistpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Event List"),
    );
  }
}
