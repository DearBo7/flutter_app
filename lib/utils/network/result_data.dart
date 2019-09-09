import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/config.dart';

class ResultData {
  Map<String, dynamic> response; // 所有返回值
  dynamic data; // 请求回来的data, 可能是list也可能是map
  int code; // 服务器的状态码
  String msg; // 服务器给的提示信息
  /// true 请求成功 false 请求失败
  bool result = true; // 客户端是否请求成功false: HTTP错误
  String url = "";
  dynamic _resultData;

  ResultData(this.msg, this.result, {this.url = ""});

  ResultData.response(this.response, {this.url = ""}) {
    this.code = this.response["code"];
    this.msg = this.response["msg"];
    this.data = this.response["data"];
  }

  void setResultData<T>(T resultData) {
    _resultData = resultData;
  }

  T getResultData<T>() {
    return _resultData;
  }

  bool isFail() {
    bool success = result && code == 1;
    if (!success) {
      mDebugPrint(
          "ResultData-[isFail]->Not error for $url:$result,code:$code,msg:$msg");
    }
    return !success;
  }

  bool isSuccess() {
    bool success = result && code == 1;
    if (!success) {
      mDebugPrint(
          "ResultData-[isSuccess]->Not success for $url:$result,code:$code,msg:$msg");
    }
    return success;
  }

  /// 失败情况下弹提示
  bool toast() {
    if (isFail()) {
      Fluttertoast.showToast(msg: msg ?? "请求失败,未返回错误提示.");
      return false;
    }
    return isSuccess();
  }

  mDebugPrint(String log) {
    if (Config.NET_DEBUG) {
      debugPrint(log);
    }
  }
}
