import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/pages/dome/login_page.dart';

import '../ui/pages/dome/page_index.dart';
import '../ui/pages/dome/setting_page.dart';

class RouteName {
  static const String login = 'login';

  static const String splash = 'splash';
  static const String setting = 'setting';

  static const String home = '/';
  static const String material = 'material';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.login:
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case RouteName.setting:
        return CupertinoPageRoute(builder: (_) => SettingPage());
      case RouteName.home:
        return CupertinoPageRoute(builder: (_) => HomePage());
      case RouteName.material:
        return CupertinoPageRoute(
            builder: (_) => MaterialPage(storeIn: settings.arguments));
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

class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;

  NoAnimRouteBuilder(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}
