import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static show(String msg,
      {Toast toastLength,
      double fontSize = 16.0,
      ToastGravity gravity,
      Color backgroundColor,
      Color textColor}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        fontSize: fontSize,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor);
  }

  static Future<bool> cancel() {
    return Fluttertoast.cancel();
  }
}
