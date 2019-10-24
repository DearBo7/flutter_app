import 'package:flutter/material.dart';
class DialogTransparent extends Dialog {
  final Widget child;

  DialogTransparent({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: child,
    );
  }
}
