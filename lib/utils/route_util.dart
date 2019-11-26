import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export '../global/router_config.dart' show RouteName;

class RouteUtils {
  ///pushAndRemoveUntil和pushNamedAndRemoveUntil效果一样，跳转页面并销毁当前页面，route == null 为销毁当前
  static void pushAndRemovePage(BuildContext context, Widget routePage) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => routePage),
      (route) => route == null,
    );
  }

  /// 跳转并删除之前的(不能返回),arguments传递的参数
  static void pushRouteNameAndRemovePage(BuildContext context, String routeName,
      {Object arguments}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => route == null,
        arguments: arguments);
  }

  /// 跳转并等待返回结果
  static Future<T> pushPageWaitResult<T extends Object>(
      BuildContext context, Widget routePage) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => routePage));
  }


  static void pushNewPage(BuildContext context, Widget routePage,
      {Function callBack}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => routePage))
        .then((result) {
      if (callBack != null) {
        callBack(result);
      }
    });
  }

  static void pushOfNewPage(BuildContext context, Widget routePage,
      {Function callBack}) {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => routePage))
        .then((result) {
      if (callBack != null) {
        callBack(result);
      }
    });
  }

  /// push和pushNamed运行效果相同
  static void pushRouteNameNewPage(BuildContext context, String routeName,
      {Object arguments, Function callBack}) {
    Navigator.pushNamed(context, routeName, arguments: arguments)
        .then((result) {
      if (callBack != null) {
        callBack(result);
      }
    });
  }

  /// 替换路由,返回到根路由,pushReplacement和pushReplacementNamed一样，调用方式不同
  static void pushReplacement(BuildContext context, Widget routePage) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => routePage));
  }

  static void pushRouteNameReplacementName(
      BuildContext context, String routeName,
      {Object arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }
}
