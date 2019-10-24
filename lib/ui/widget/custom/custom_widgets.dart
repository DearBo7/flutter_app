import 'package:flutter/material.dart';

/// label+其他组件
class RowLabelToWidgetOne extends StatelessWidget {
  final Text labelText;
  final Widget rightWidget;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const RowLabelToWidgetOne(this.labelText,
      {Key key, this.rightWidget, this.padding, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Row(
        children: <Widget>[
          labelText,
          Expanded(
            child: rightWidget ?? SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}

/// Text 加背景颜色,边框
class TextContainer extends StatelessWidget {
  TextContainer({this.child, this.backgroundColor, this.padding, this.margin});

  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey[400], width: 0.5),
          borderRadius: new BorderRadius.all(Radius.circular(3.0)),
        ),
        child: child);
  }
}
