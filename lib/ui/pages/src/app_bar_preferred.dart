import 'package:flutter/material.dart';

import '../../../utils/toast_utils.dart';

/// AppBar 通用-去掉标题
class AppBarPreferred {
  static PreferredSize getPreferredSize(BuildContext context, {Color color}) {
    return PreferredSize(
        child: Container(
          color: color ?? Theme.of(context).primaryColor,
        ),
        preferredSize: Size(double.infinity, 0.0));
  }
}

// ignore: must_be_immutable
class AppBackPressed extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final String showMsg;
  final bool backFlag;

  AppBackPressed(
      {Key key,
      this.child,
      this.duration: const Duration(seconds: 1),
      this.showMsg: "再按一次退出",
      this.backFlag: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: child,
    );
  }

  /// 上次点击时间
  DateTime _lastPressedAt;

  /// 监听返回键，点击两下退出程序
  Future<bool> _onBackPressed() async {
    print("AppBackPressed===>_onBackPressed:_lastPressedAt:$_lastPressedAt");
    if (backFlag) {
      return backFlag;
    }
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > duration) {
      //两次点击间隔超过1秒则重新计时-默认
      _lastPressedAt = DateTime.now();
      ToastUtil.show(showMsg);
      return false;
    }
    return true;
  }
}
