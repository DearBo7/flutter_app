import 'package:flutter/material.dart';

/// 对话框的显示参数
class ShowParam {
  bool show; // 默认显示对话框-true
  bool showBackground; // 显示背景-true
  bool barrierDismissible; // 空白区域/返回键 点击后是否消失-false
  //bool dispose = false;
  String text;

  // dialog 的 context
  BuildContext context;

  ShowParam(
      {this.show: true,
      this.showBackground: true,
      this.barrierDismissible: false,
      this.text}); //ShowParam({this.show = true, this.barrierDismissible, this.context, this.text});

  void pop() {
    //context != null && !dispose
    if (context != null) {
      Navigator.of(context).pop();
    } else {
      print("ShowParam===>pop():dispose:");
    }
  }
}
