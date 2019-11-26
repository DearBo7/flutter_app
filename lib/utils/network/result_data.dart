import 'package:flutter/material.dart';

import '../../global/config.dart';
import '../object_utils.dart';
import '../toast_utils.dart';

class ResultData {
  Map<String, dynamic> response; // 所有返回值
  dynamic data; // 请求回来的data, 可能是list也可能是map
  String code; // 服务器的状态码
  String msg; // 服务器给的提示信息
  /// true 请求成功 false 请求失败
  bool result = true; // 客户端是否请求成功false: HTTP错误
  //服务器返回状态码
  int responseStatus;
  String url = "";
  dynamic _resultData;

  ResultData(this.msg, this.result, this.responseStatus, {this.url = ""});

  ResultData.response(this.response, {this.url = ""}) {
    var codeTemp = this.response["code"];
    this.code = codeTemp == null ? "" : codeTemp.toString();
    this.msg = this.response["msg"] ?? null;
    this.data = this.response["data"] ?? null;
  }

  void setResultData<T>(T resultData) {
    _resultData = resultData;
  }

  T getResultData<T>() {
    return _resultData;
  }

  bool isFail({String successCode: "1"}) {
    bool success = result && code == successCode;
    if (!success) {
      mDebugPrint(
          "ResultData-[isFail]->Not error for $url:$result,code:$code,msg:$msg");
    }
    return !success;
  }

  bool isSuccess({String successCode: "1"}) {
    bool success = result && code == successCode;
    if (!success) {
      mDebugPrint(
          "ResultData-[isSuccess]->Not success for $url:$result,code:$code,msg:$msg");
    }
    return success;
  }

  /// 百度识别,如果请求成功,并且返回结果不为null就为成功
  bool isBaiDuSuccess() {
    bool success = result && response != null;
    if (!success) {
      mDebugPrint(
          "ResultData-[isBaiDuSuccess]->Not success for $url:$result,code:$code,msg:$msg");
    }
    return success;
  }

  /// 百度识别错误提示.
  void toastBaiDuError({String errorMsg}) {
    //如果请求成功
    if (result &&
        response != null &&
        (response.containsKey("error_code") ||
            response.containsKey("error_msg"))) {
      msg =
          "识别失败[${response['error_code'] ?? ''}],${response['error_msg'] ?? ''}";
      mDebugPrint(
          "ResultData-[toastBaiDuError]->Not error for $url:$result,responseStatus:$responseStatus,msg:$msg");
    }
    _toast(errorMsg: errorMsg);
  }

  /// 失败情况下弹提示
  bool toast({String errorMsg, String successCode: "1"}) {
    if (isFail(successCode: successCode)) {
      _toast(errorMsg: errorMsg);
      return false;
    }
    return isSuccess(successCode: successCode);
  }

  //弹框
  _toast({String errorMsg}) {
    errorMsg = ObjectUtils.isNotBlank(msg)
        ? msg
        : ObjectUtils.isNotBlank(errorMsg) ? errorMsg : "服务端返回结果错误.";
    ToastUtil.show(errorMsg);
  }

  mDebugPrint(String log) {
    if (Config.NetDebug) {
      debugPrint(log);
    }
  }
}
