import 'package:flutter/material.dart';

/// 对话框的显示参数
class ShowParam {
  bool show; // 默认显示对话框-true
  bool showBackground; // 显示背景-true
  bool barrierDismissible; // 空白区域/返回键 点击后是否消失-false
  bool dispose = false;
  String text;
  BuildContext context;

  ShowParam(
      {this.show: true,
      this.showBackground: true,
      this.barrierDismissible: false,
      this.text,
      this.context}); //ShowParam({this.show = true, this.barrierDismissible, this.context, this.text});

  void pop() {
    if (context != null && !dispose) {
      Navigator.of(context).pop();
    } else {
      print("ShowParam===>pop():dispose:$dispose");
    }
  }
}
