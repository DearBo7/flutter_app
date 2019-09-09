import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void pushAndRemovePage(BuildContext context, Widget routePage) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => routePage),
    (route) => route == null,
  );
}

void pushNewPage(BuildContext context, Widget routePage, {Function callBack}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => routePage))
      .then((value) {
    if (value != null) {
      callBack(value);
    }
  });
}

void pushNewPageBack(BuildContext context, Widget routePage,
    {Function callBack}) {
  Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => routePage))
      .then((data) {
    if (data != null) {
      callBack(data);
    }
  });
}

void popNewPage(BuildContext context, String routeName) {
  Navigator.pushNamed(context, routeName);
}

/*void popAndPushNewPage(BuildContext context, String routeName) {
  Navigator.popAndPushNamed(context, routeName);
}*/

void pushReplacement(BuildContext context, Widget routePage) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => routePage));
}

/// 跳转后不能返回
void pushReplacementName(BuildContext context, String routeName) {
  Navigator.pushReplacementNamed(context, routeName);
}
