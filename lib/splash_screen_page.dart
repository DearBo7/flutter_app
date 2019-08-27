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
    startTime();
    //checkFirstSeen(context); //报错
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("images/splash.png", fit: BoxFit.fill),
    );
  }

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    pushAndRemovePage(context, HomePage());
  }

  Future checkFirstSeen(context) async {
    //Navigator.of(context).pushReplacementNamed('/home');
    /*SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool _seen = _prefs.getBool("first_open") ?? false;
    bool isLogin = _prefs.getBool("isLogin") ?? false;

    if (_seen) {
      if (isLogin) {
        pushAndRemovePage(context, HomePage());
      } else {
        pushAndRemovePage(context, LoginPage());
      }
    } else {
      _prefs.setBool("first_open", true);
      pushAndRemovePage(context, IntroSlidePage());
    }*/
  }
}
