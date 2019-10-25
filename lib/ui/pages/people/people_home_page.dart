import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/wrap_keep_state.dart';
import '../src/app_bar_preferred.dart';
import 'tab/people_cart_page.dart';
import 'tab/people_category_page.dart';
import 'tab/people_index_page.dart';
import 'tab/people_personal_page.dart';

class PeopleHomePage extends StatefulWidget {
  final int childIndex;

  PeopleHomePage({Key key, this.childIndex: 0}) : super(key: key);

  @override
  _PeopleHomePageState createState() => _PeopleHomePageState(childIndex);
}

class _PeopleHomePageState extends State<PeopleHomePage> {
  int _childIndex;

  _PeopleHomePageState(int childIndex) {
    this._childIndex = childIndex;
  }

  List<Widget> _childWidgetList;
  List<BottomNavigationBarItem> _bottomNavigationList;

  var _pageController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _pageController = PageController();
    _childWidgetList = List()
      ..add((WrapKeepState(PeopleIndexPage())))
      ..add(WrapKeepState(PeopleCategoryPage()))
      ..add(WrapKeepState(PeopleCartPage()))
      ..add(WrapKeepState(PeoplePersonalPage()));
    _bottomNavigationList = List()
      ..add(BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")))
      ..add(BottomNavigationBarItem(
          icon: Icon(Icons.category), title: Text("分类")))
      ..add(BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), title: Text("购物车")))
      ..add(BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), title: Text("会员中心")));
  }

  @override
  Widget build(BuildContext context) {
    //屏幕适配初始化
    ScreenUtil.getInstance().init(context);
    return AppBackPressed(
      backFlag: true,
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
}
