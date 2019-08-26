library basicnetservice;

import 'dart:io';

import 'package:flutter/widgets.dart';

import '../utils/network/net_service.dart';
import '../widget/dialog_param.dart';
import '../widget/loading_dialog.dart';

export '../utils/network/net_service.dart';

class BasicNetService extends NetService {
  BasicNetService();

  @override
  request(String url,
      {Method method,
      Map<String, dynamic> params,
      Map<String, dynamic> headers,
      var file,
      String fileName,
      String fileSavePath,
      BuildContext context,
      bool showLoad = false}) async {
    /// 传参进行统一处理, 加上基本参数
    //Map<String, dynamic> basicParam = await getBasicParam();
    //basicParam["timeStamp"] = (new DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    //if (params != null) {
    //  basicParam.addAll(params);
    //}
    ShowParam showParam;
    if (showLoad) {
      showParam = new ShowParam(
          show: showLoad, barrierDismissible: false, showBackground: false);
      LoadingDialogUtil.showLoadingDialog(context, showParam);
    }

    ResultData resultData = await super.request(url,
        method: method,
        params: params,
        headers: headers,
        file: file,
        fileName: fileName,
        fileSavePath: fileSavePath);
    if (showParam != null) {
      showParam.pop();
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