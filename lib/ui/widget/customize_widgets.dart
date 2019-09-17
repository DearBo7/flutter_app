import 'package:flutter/material.dart';

class RowLabelToWidgetOne extends StatelessWidget {
  final Text labelText;
  final Widget rightWidget;

  const RowLabelToWidgetOne(this.labelText, {Key key, this.rightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        labelText,
        Expanded(
          child: rightWidget ?? Container(),
        )
      ],
    );
  }
}
