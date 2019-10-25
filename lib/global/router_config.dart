import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/pages/page_index.dart';

class RouteName {
  static const String login = 'login';
  static const String splash = 'splash';
  static const String homeIndex = '/';
  static const String formulaHome = 'formula';
  static const String formulaSetting = 'formula_setting';
  static const String formulaMaterial = 'formula_material';
  static const String peopleHome = 'people';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.login:
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case RouteName.homeIndex:
        return CupertinoPageRoute(builder: (_) => HomeIndexPage());
      case RouteName.formulaSetting:
        return CupertinoPageRoute(builder: (_) => FormulaSettingPage());
      case RouteName.formulaHome:
        return CupertinoPageRoute(builder: (_) => FormulaHomePage());
      case RouteName.formulaMaterial:
        return CupertinoPageRoute(
            builder: (_) => FormulaMaterialPage(storeIn: settings.arguments));
      case RouteName.peopleHome:
        return CupertinoPageRoute(builder: (_) => PeopleHomePage());
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
