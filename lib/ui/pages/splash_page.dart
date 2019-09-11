import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/route_util.dart';

/// 用于项目初始化之前显示的页面
class SplashImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,//背景色
      child: Image.asset("assets/images/splash_bg.png", fit: BoxFit.fill),
    );
  }
}

class SplashPage extends StatefulWidget{
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
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
    /*return Container(
      child: Image.asset("assets/images/splash_bg.png", fit: BoxFit.fill),
    );*/
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()=>Future.value(false),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset("assets/images/splash_bg.png", fit: BoxFit.fill)
          ],
        ),
      ),
    );
  }

  startTime() async {
    //设置启动图生效时间
    return new Timer(Duration(milliseconds: 500), navigationPage);
  }

  void navigationPage() {
    RouteUtils.pushRouteNameAndRemovePage(context, RouteName.login);
    //pushAndRemovePage(context, LoginPage());
  }
}
