import 'package:flutter/material.dart';

import '../../../res/colors.dart';
import '../../../utils/utils.dart';

enum ButtonEnum {
  //默认-RaisedButton原样式
  Default,
  //添加-#3E99D0
  Add,
  //取消-#909399
  Cancel,
  //确认/确定/保存-#118EEA
  Confirm,
  //删除/警告-#F15C56
  Delete,
  //修改-#E6A23C
  Update
}

List<Color> _buttonColors = [
  Colors.grey[400],
  Utils.hexToColor("#3E99D0"),
  Utils.hexToColor("#909399"),
  Utils.hexToColor("#118EEA"),
  Utils.hexToColor("#F15C56"),
  Utils.hexToColor("#E6A23C")
];

class RaisedButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final ButtonEnum type;
  final Color color;
  final Widget child;

  const RaisedButtons(
      {Key key,
      this.onPressed,
      this.type: ButtonEnum.Default,
      this.child,
      this.color})
      : super(key: key);

  Widget build(BuildContext context) {
    //按钮颜色
    Color _thisColor = color ?? _buttonColors[type.index];

    return RaisedButton(
      onPressed: onPressed,
      color: _thisColor,
      textColor: Colors.white,
      child: child,
    );
  }
}

/// 朴素按钮,可以设置边框,背景(透明),字体颜色
class PlainButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final ButtonEnum type;
  final Color color;
  final Color textColor;
  final Color bgColor;
  final Widget child;
  final bool bgFlag;
  final double borderWidth;
  final EdgeInsetsGeometry margin;

  PlainButtons(
      {Key key,
      this.onPressed,
      this.type,
      this.color,
      this.child,
      this.textColor,
      this.bgColor,
      this.bgFlag: true,
      this.borderWidth: 1.0,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _thisColor = color ?? _buttonColors[type.index];
    //按钮边框颜色
    Color _thisBorderColor = _thisColor.withOpacity(0.5);
    //字体颜色
    Color _thisTextColor = textColor ?? _thisColor;
    //背景颜色
    Color _thisBgColor = bgColor ?? _thisColor;
    //是否显示背景-不显示默认白色
    if (!bgFlag) {
      _thisBgColor = ColorUtils.getThemeModeColor(context);
    }
    return Container(
      margin: margin,
      child: FlatButton(
        color: _thisBgColor.withOpacity(0.15),
        highlightColor: _thisBgColor.withOpacity(0.1),
        textColor: _thisTextColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: _thisBorderColor, width: borderWidth),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
