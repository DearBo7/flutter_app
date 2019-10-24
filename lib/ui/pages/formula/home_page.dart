import 'dart:async';

import 'package:flutter/material.dart';

import '../../../public_index.dart';
import '../../../utils/toast_utils.dart';
import '../../widget/wrap_keep_state.dart';
import 'learn_page.dart';
import 'my_page.dart';
import 'storage_page.dart';
import 'test_page.dart';

class HomePage extends StatefulWidget {
  final int childIndex;

  HomePage({Key key, this.childIndex: 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(childIndex);
}

class _HomePageState extends State<HomePage> {
  int _childIndex;

  _HomePageState(int childIndex) {
    this._childIndex = childIndex;
  }

  List<Widget> _childWidgetList;
  List<BottomNavigationBarItem> _bottomNavigationList;

  var _pageController;
  bool testFlag = true;

  @override
  void initState() {
    super.initState();
    _init();
    Timer.run(() {
      Store.value<OrcCameraModel>(context).initToken();
    });
  }

  void _init() {
    _pageController = PageController();
    _childWidgetList = List()
      ..add((WrapKeepState(StoragePage())))
      ..add(WrapKeepState(LearnPage()))
      ..add(WrapKeepState(MyPage()));
    _bottomNavigationList = List()
      ..add(BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("入库")))
      ..add(BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("学习")))
      ..add(BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), title: Text("我的")));
    if (testFlag) {
      _childWidgetList.add(TestPage());
      _bottomNavigationList.add(BottomNavigationBarItem(
          icon: Icon(Icons.tag_faces), title: Text("测试")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: PageView.builder(
          itemBuilder: (context, index) => _childWidgetList[index],
          itemCount: _childWidgetList.length,
          controller: _pageController,
          // 禁止滑动
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _childIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          //fixedColor 选中的颜色
          //fixedColor: Colors.red,
          //超出3个后不显示颜色问题
          type: BottomNavigationBarType.fixed,
          currentIndex: _childIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          items: _bottomNavigationList,
        ),
      ),
    );
  }

  /// 上次点击时间
  DateTime _lastPressedAt;

  /// 监听返回键，点击两下退出程序
  Future<bool> _onBackPressed() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
      //两次点击间隔超过1秒则重新计时
      _lastPressedAt = DateTime.now();
      ToastUtil.show("再按一次退出");
      return false;
    }
    return true;
  }
}
