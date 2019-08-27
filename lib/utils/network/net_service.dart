library msnetservice;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../global/config.dart';
import 'http_status_code.dart';
import 'result_data.dart';
import 'session_manager.dart';

export 'result_data.dart';

enum Method {
  GET,
  POST,
  UPLOAD,
  DOWNLOAD,
}

class NetService {
  static const String _TAG = "NetService";

  /// get请求
  get(String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> headers,
      BuildContext context,
      bool showLoad: true}) async {
    return await request(url,
        method: Method.GET,
        params: params,
        headers: headers,
        showLoad: showLoad);
  }

  /// post请求
  post(String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> headers,
      BuildContext context,
      bool showLoad: true}) async {
    return await request(url,
        method: Method.POST,
        params: params,
        headers: headers,
        showLoad: showLoad);
  }

  /// 附件上传
  upLoad(var file, String fileName, String url,
      {Map<String, dynamic> params, Map<String, dynamic> headers}) async {
    return await request(url,
        method: Method.UPLOAD,
        params: params,
        headers: headers,
        file: file,
        fileName: fileName);
  }

  /// 附件下载
  download(String url, String savePath) async {
    return await request(url, method: Method.DOWNLOAD, fileSavePath: savePath);
  }

  ///  请求部分
  request(String url,
      {Method method,
      Map<String, dynamic> params,
      Map<String, dynamic> headers,
      var file,
      String fileName,
      String fileSavePath,
      BuildContext context,
      bool showLoad = false}) async {
    try {
      Response response;

      SessionManager sessionManager = SessionManager();
      if (headers != null) {
        sessionManager.options.headers = headers;
      }
      var baseUrl = await getBasicUrl();
      if (baseUrl != null) {
        sessionManager.options.baseUrl = baseUrl;
      }

      // 打印网络日志
      StringBuffer requestParam = new StringBuffer();
      requestParam.write("$_TAG ");
      requestParam.write("Url:${url}");
      requestParam.write("\n");
      requestParam.write("baseUrl:${baseUrl}");
      requestParam.write("\n");
      requestParam.write("$_TAG ");
      requestParam.write("params:");
      requestParam.write(json.encode(params));
      printLog(requestParam.toString());

      switch (method) {
        case Method.GET:
          response = await sessionManager.get(url, queryParameters: params);
          break;
        case Method.POST:
          response = await sessionManager.post(url, data: params);
          break;
        case Method.UPLOAD:
          {
            FormData formData = new FormData();
            if (params != null) {
              formData = FormData.from(params);
            }
            formData.add(fileName, UploadFileInfo.fromBytes(file, fileName));

            /// 第一个fileName是参数名, 必须和接口一致, 第二个fileName是文件的文件名
            response = await sessionManager.post(url, data: formData);
            break;
          }
        case Method.DOWNLOAD:
          response = await sessionManager.download(url, fileSavePath);
          break;
      }
      return await handleDataSource(response, method, url: url);
    } on DioError catch (exception) {
      printLog("$_TAG net exception= " + exception.toString());
      String msg = formatError(exception);
      return ResultData(msg, false, url: url);
    }
  }

  /// 数据处理
  static handleDataSource(Response response, Method method, {String url = ""}) {
    ResultData resultData;
    String errorMsg = "";
    int statusCode;
    statusCode = response.statusCode;
    printLog("$_TAG statusCode:" + statusCode.toString());
    if (method == Method.DOWNLOAD) {
      if (statusCode == 200) {
        /// 下载成功
        resultData = ResultData('下载成功', true);
      } else {
        /// 下载失败
        resultData = ResultData('下载失败', false);
      }
    } else {
      Map<String, dynamic> data;
      if (response.data is Map) {
        data = response.data;
      } else {
        data = json.decode(response.data);
      }
      if (isPrint()) {
        printBigLog("$_TAG data: ", json.encode(data));
      }

      //处理错误部分
      if (statusCode != 200) {
        errorMsg = HttpStatusCode.getHttpStatusMsg(statusCode);
        //errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        resultData = ResultData(errorMsg, false, url: url);
      } else {
        try {
          resultData = ResultData.response(data);
        } catch (exception) {
          resultData = ResultData(exception.toString(), true, url: url);
        }
      }
    }
    return resultData;
  }

  getHeaders() {
    return null;
  }

  getBasicUrl() {
    return null;
  }

  /*
   * error统一处理
   */
  String formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      return "连接超时";
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      return "请求超时";
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      return "响应超时";
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      return "连接出现异常";
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      return "请求取消";
    }
    return "未知错误";
  }

  static void printLog(String log, {tag}) {
    bool print = isPrint();
    if (print) {
      String tagLog;
      if (tag != null) {
        tagLog = tag + log;
      } else {
        tagLog = log;
      }
      debugPrint(tagLog);
    }
  }

  static void printBigLog(String tag, String log) {
    //log = TEST_POEM;
    bool print = isPrint();
    const MAX_COUNT = 800;
    if (print) {
      if (log != null && log.length > MAX_COUNT) {
        // 超过1000就分次打印
        int len = log.length;
        int paragraphCount = ((len / MAX_COUNT) + 1).toInt();
        for (int i = 0; i < paragraphCount; i++) {
          int printCount = MAX_COUNT;
          if (i == paragraphCount - 1) {
            printCount = len - (MAX_COUNT * (paragraphCount - 1));
          }
          String finalTag = "" + tag + "\n";
          printLog(
              log.substring(i * MAX_COUNT, i * MAX_COUNT + printCount) + "\n",
              tag: finalTag);
        }
      } else {
        String tagLog;
        if (tag == null) {
          tagLog = tag + log;
        } else {
          tagLog = log;
        }
        printLog(tagLog);
      }
    }
  }

  static bool isPrint() {
    return Config.NET_DEBUG;
  }
}
