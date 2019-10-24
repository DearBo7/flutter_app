import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/i18n.dart';
import 'global/router_config.dart';
import 'public_index.dart';
import 'ui/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  MyApp({Key key, this.future}) : super(key: key);

  /// 在App运行之前,需要初始化的异步操作
  /// 如果存在多个,可以使用[Future.wait(futures)]来合并future后传入
  final Future future;

  /*@override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          /// 在异步操作时,显示的页面
          if (snapshot.connectionState != ConnectionState.done) {
            return SplashImage();
          }
          return Store.init(child: Store.connect<ConfigModel>(
              builder: (BuildContext context, ConfigModel model, Widget child) {
            return MaterialApp(
              /// 任务管理器显示的标题
              title: "Flutter Dome App",
              //指定简体中文
              locale: Locale('zh', 'CN'),

              /// 您可以通过配置ThemeData类轻松更改应用程序的主题
              theme: model.themeData,
              darkTheme: model.darkTheme,

              /// 右上角显示一个debug的图标
              debugShowCheckedModeBanner: false,

              //路由配置
              onGenerateRoute: Router.generateRoute,

              /// 主页
              *//*home: Builder(builder: (context) {
                  return SplashPage();
                }),*//*

              /// localizationsDelegates 列表中的元素时生成本地化集合的工厂
              localizationsDelegates: [
                // 为Material Components库提供本地化的字符串和其他值
                GlobalMaterialLocalizations.delegate,

                // 定义widget默认的文本方向，从左往右或从右往左
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                S.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              initialRoute: RouteName.splash,
            );
          }));
        });
  }*/
  @override
  Widget build(BuildContext context) {
    return Store.init(child: Store.connect<ConfigModel>(
        builder: (BuildContext context, ConfigModel model, Widget child) {
          return MaterialApp(
            /// 任务管理器显示的标题
            title: "Flutter Dome",
            //指定简体中文
            locale: Locale('zh', 'CN'),
            //locale: Locale('en'),

            /// 您可以通过配置ThemeData类轻松更改应用程序的主题
            theme: model.themeData,
            darkTheme: model.darkTheme,

            /// 右上角显示一个debug的图标
            debugShowCheckedModeBanner: false,

            //路由配置
            onGenerateRoute: Router.generateRoute,

            /// 主页
            /*home: Builder(builder: (context) {
                  return SplashPage();
                }),*/

            /// localizationsDelegates 列表中的元素时生成本地化集合的工厂
            localizationsDelegates: [
              // 为Material Components库提供本地化的字符串和其他值
              GlobalMaterialLocalizations.delegate,

              // 定义widget默认的文本方向，从左往右或从右往左
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: RouteName.splash,
          );
        }));
  }
}

