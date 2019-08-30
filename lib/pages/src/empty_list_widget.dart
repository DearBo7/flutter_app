import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class EmptyListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: Image.asset('assets/images/empty.png'),
            ),
            Text(
              FlutterI18n.translate(context, 'noData'),
              style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
            ),
            Expanded(
              child: SizedBox(),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
