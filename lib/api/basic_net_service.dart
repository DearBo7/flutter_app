import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../ui/widget/loading/loading_dialog.dart';
import '../utils/network/net_log_utils.dart';
import '../utils/network/net_service.dart';

export '../utils/network/result_data.dart';

class BasicNetService extends NetService {
  static const String _TAG = "BasicNetService";

  BasicNetService();

  @override
  request(String url,
      {Method method,
        Map<String, dynamic> params,
        Map<String, dynamic> headers,
        String contentType,
        var file,
        String fileName,
        String fileSavePath,
        BuildContext context,
        String loadingText,
        Duration delay: const Duration(milliseconds: 120),
        bool showLoad: false}) async {
    /// 传参进行统一处理, 加上基本参数
    //Map<String, dynamic> basicParam = await getBasicParam();
    //basicParam["timeStamp"] = (new DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    //if (params != null) {
    //  basicParam.addAll(params);
    //}
    if (context == null) {
      showLoad = false;
    }
    CustomizeLoadingDialog loadingDialog;
    if (showLoad) {
      loadingDialog = CustomizeLoadingDialog(context)
          .show(isShowText: true, contentText: loadingText, delay: delay);
    }
    int startTime = DateTime.now().millisecondsSinceEpoch;
    ResultData resultData = await super.request(url,
        method: method,
        params: params,
        headers: headers,
        contentType: contentType,
        file: file,
        fileName: fileName,
        fileSavePath: fileSavePath);
    NetLogUtils.printLog(
        " 耗时:${DateTime.now().millisecondsSinceEpoch - startTime} 毫秒",
        tag: _TAG);
    if (loadingDialog != null) {
      await loadingDialog.hide();
    }

    /// 当apiToken 过期或者错误时的提示码
    //if (0 == resultData.code && context != null) {
    // 退出登录并跳转到登录界面
    //App.navigateTo(context, QuRoutes.ROUTE_MINE_LOGIN, clearStack: true);
    //}

    return resultData;
  }

  @override
  getBasicUrl() {
    return null;
  }

  @override
  getHeaders() async {
    //Map<String, dynamic> headers;
    return null;
  }

  Future<Map<String, dynamic>> getBasicParam() async {
    Map<String, dynamic> basicParam = {};
    basicParam["agent"] = Platform.isAndroid ? "android" : "ios";
    return basicParam;
  }
}
