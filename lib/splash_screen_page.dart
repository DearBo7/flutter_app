import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/route_util.dart';

import 'home_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    /*Timer.run(() {
      navigationPage();
    });*/
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/splash.png", fit: BoxFit.fill),
    );
  }

  startTime() async {
    //设置启动图生效时间
    return new Timer(Duration(milliseconds: 500), navigationPage);
  }

  void navigationPage() {
    pushAndRemovePage(context, HomePage());
  }
}
