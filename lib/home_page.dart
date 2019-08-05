import 'package:flutter/material.dart';

import 'navigation/bubble_bottom_bar.dart';
import 'pages/learn_screen.dart';
import 'pages/my_screen.dart';
import 'pages/storage_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex;

  List<Widget> childrenWidgetList = [];

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
    return Scaffold(
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
    );
  }
}
