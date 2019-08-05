import 'package:flutter/material.dart';

import 'page_index.dart';
import 'splash_screen_page.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Store.setStoreCtx(context); // 初始化数据层
  }

  @override
  Widget build(BuildContext context) {
    Store.value<ConfigModel>(context)
      ..$getTheme()
      ..$getLocal();

    return Store.connect<ConfigModel>(builder: (context, child, model) {
      return MaterialApp(
        /// 任务管理器显示的标题
        title: "Flutter App",

        /// 您可以通过配置ThemeData类轻松更改应用程序的主题
        theme: AppTheme.getThemeData(model.theme),

        /// 右上角显示一个debug的图标
        debugShowCheckedModeBanner: false,

        /// 主页
        home: SplashScreenPage(),
      );
    });
  }
}
