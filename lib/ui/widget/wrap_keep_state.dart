/*
 * @Description: page模块状态缓存-保留当前加载一次不被销毁(和PageView使用)
 * @Author: Bo
 * @Date: 2019-09-02 17:31:53
 */
import 'package:flutter/material.dart';

class WrapKeepState extends StatefulWidget {
  WrapKeepState(this.hocWidget);

  final Widget hocWidget;

  @override
  State<StatefulWidget> createState() {
    return _WrapKeepState();
  }
}

class _WrapKeepState extends State<WrapKeepState>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.hocWidget;
  }
}
