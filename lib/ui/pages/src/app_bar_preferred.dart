import 'package:flutter/material.dart';

/// AppBar 通用-去掉标题
class AppBarPreferred {
  static PreferredSize getPreferredSize(BuildContext context) {
    return PreferredSize(
        child: Container(
          color: Theme.of(context).primaryColor,
        ),
        preferredSize: Size(double.infinity, 0.0));
  }
}
