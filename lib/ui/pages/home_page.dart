import 'package:flutter/material.dart';

import '../../utils/toast.dart';
import '../widget/navigation/bubble_bottom_bar.dart';
import '../widget/wrap_keep_state.dart';
import 'learn_page.dart';
import 'my_page.dart';
import 'storage_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _childIndex;

  List<Widget> childWidgetList = [];

  var _pageController = PageController();

  /// 上次点击时间
  DateTime _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _childIndex = 0;
    childWidgetList
      ..add(WrapKeepState(StorageScreen()))
      ..add(WrapKeepState(LearnPage()))
      ..add(WrapKeepState(MyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          //IndexedStack 能保留当前不被销毁(初始会全部加载)
          /*body: IndexedStack(
            index: _childIndex,
            children: childWidgetList,
          ),*/
          //能保留当前不被销毁,PageView + with AutomaticKeepAliveClientMixin,然后重写：bool get wantKeepAlive => true(初始只会加载当前页)
          body: PageView.builder(
            itemBuilder: (ctx, index) => childWidgetList[index],
            itemCount: childWidgetList.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(), // 禁止滑动
            onPageChanged: (index) {
              setState(() {
                _childIndex = index;
              });
            },
          ),
          bottomNavigationBar: BubbleBottomBar(
            opacity: 0.2,
            currentIndex: _childIndex,
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
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
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
      //两次点击间隔超过1秒则重新计时
      _lastPressedAt = DateTime.now();
      Toast.show(context, "再按一次退出",
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return false;
    }
    return true;
  }
}
