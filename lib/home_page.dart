import 'package:flutter/material.dart';

import 'navigation/bubble_bottom_bar.dart';
import 'pages/learn_screen.dart';
import 'pages/my_screen.dart';
import 'pages/storage_screen.dart';
import 'utils/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex;

  List<Widget> childrenWidgetList = [];

  /// 上次点击时间
  DateTime _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    childrenWidgetList
      ..add(StorageScreen())
      ..add(LearnScreen())
      ..add(MyScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          //body: childrenWidgetList[_currentIndex],
          //IndexedStack 能保留当前不被销毁
          body: IndexedStack(
            index: _currentIndex,
            children: childrenWidgetList,
          ),
          bottomNavigationBar: BubbleBottomBar(
            opacity: 0.2,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8,
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                  backgroundColor: Colors.red,
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.home,
                    color: Colors.red,
                  ),
                  title: Text("入库")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.deepPurple,
                  icon: Icon(
                    Icons.book,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.book,
                    color: Colors.deepPurple,
                  ),
                  title: Text("学习")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.indigo,
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.account_circle,
                    color: Colors.indigo,
                  ),
                  title: Text("我的")),
            ],
          ),
        ));
  }

  /// 监听返回键，点击两下退出程序
  Future<bool> _onBackPressed() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
      print("点击时间");
      //两次点击间隔超过2秒则重新计时
      _lastPressedAt = DateTime.now();
      Toast.show(context, "再按一次退出",
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return false;
    }
    return true;
  }
}
