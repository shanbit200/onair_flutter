import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Eventlistpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
      ),
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Event List")],
      ),
    );
  }
}
