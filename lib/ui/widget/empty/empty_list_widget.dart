import 'package:flutter/material.dart';
import '../../../generated/i18n.dart';

class EmptyListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 160.0,
              height: 150.0,
              child: Image.asset('assets/images/empty.png'),
            ),
            Text(
              S.of(context).noData,
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
