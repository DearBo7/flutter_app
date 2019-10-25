import 'package:flutter/material.dart';

import '../../public_index.dart';
import 'src/app_bar_preferred.dart';

class HomeIndexPage extends StatefulWidget {
  @override
  _HomeIndexPageState createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPreferred.getPreferredSize(context),
      body: AppBackPressed(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: <Widget>[
                  RowButton(
                    onPressed: () => RouteUtils.pushRouteNameNewPage(
                        context, RouteName.formulaHome),
                    child: Text("Formula-Dome", style: TextStyles.listTitle),
                  ),
                  RowButton(
                    onPressed: () => RouteUtils.pushRouteNameNewPage(
                        context, RouteName.peopleHome),
                    child: Text("其他", style: TextStyles.listTitle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RowButton extends StatelessWidget {
  final ButtonEnum type;
  final VoidCallback onPressed;
  final Widget child;

  const RowButton(
      {Key key, this.type: ButtonEnum.Add, this.onPressed, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButtons(
            type: type,
            onPressed: onPressed,
            child: child,
          ),
        )
      ],
    );
  }
}
