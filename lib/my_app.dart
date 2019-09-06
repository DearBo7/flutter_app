import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/i18n.dart';
import 'public_index.dart';
import 'ui/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Store.connect<ConfigModel>(
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
        //onGenerateRoute: Router.generateRoute,

        /// 主页
        home: Builder(builder: (context) {
          return SplashPage();
        }),

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
      );
    });
  }
}

/*class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return Store.connect<ConfigModel>(builder: (BuildContext context, ConfigModel model, Widget child) {
      return MaterialApp(
        /// 任务管理器显示的标题
        title: "Flutter Dome App",
        locale: Locale('zh', 'CN'), //指定简体中文

        /// 您可以通过配置ThemeData类轻松更改应用程序的主题
        theme: AppTheme.getThemeData(model.theme),

        /// 右上角显示一个debug的图标
        debugShowCheckedModeBanner: false,

        /// 主页
        home: Builder(builder: (context){
          return SplashScreenPage();
        }),
        localizationsDelegates: [
          FlutterI18nDelegate(
              useCountryCode: true,
              fallbackFile: 'zn_CN',
              path: 'assets/locale'),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      );
    });
  }
}*/
