import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/pages/page_index.dart';
import '../ui/pages/setting_page.dart';

class RouteName {
  //static const String login = 'login';
  //static const String register = 'register';
  static const String splash = 'splash';
  static const String setting = 'setting';

  //static const String home = '/';
  //static const String homePage = 'homePage';
  //static const String learnPage = 'learnPage';
  //static const String myPage = 'myPage';
//static const String setting = 'setting';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return CupertinoPageRoute(builder: (_) => SplashPage());
      case RouteName.setting:
        return CupertinoPageRoute(builder: (_) => SettingPage());
      /*case RouteName.homePage:
        return CupertinoPageRoute(builder: (_) => HomePage());
      case RouteName.learnPage:
        return CupertinoPageRoute(builder: (_) => LearnPage());
      case RouteName.myPage:
        return CupertinoPageRoute(builder: (_) => MyPage());*/

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}