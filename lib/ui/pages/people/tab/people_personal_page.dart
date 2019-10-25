import 'package:flutter/material.dart';

class PeoplePersonalPage extends StatefulWidget {
  @override
  _PeoplePersonalPageState createState() => _PeoplePersonalPageState();
}

class _PeoplePersonalPageState extends State<PeoplePersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("会员中心"),
      ),
    );
  }
}
