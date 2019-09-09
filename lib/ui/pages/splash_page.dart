import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/route_util.dart';
import 'login_page.dart';

/// 用于项目初始化之前显示的页面
class SplashImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/splash.png", fit: BoxFit.fill),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
    pushAndRemovePage(context, LoginPage());
  }
}
