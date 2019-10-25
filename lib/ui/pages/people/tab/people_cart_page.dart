import 'package:flutter/material.dart';

class PeopleCartPage extends StatefulWidget {
  @override
  _PeopleCartPageState createState() => _PeopleCartPageState();
}

class _PeopleCartPageState extends State<PeopleCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
      ),
    );
  }
}
