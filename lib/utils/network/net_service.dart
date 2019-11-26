import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'http_status_code.dart';
import 'net_log_utils.dart';
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
        String contentType,
        BuildContext context,
        String loadingText,
        Duration delay,
        bool showLoad: true}) async {
    return await request(url,
        method: Method.GET,
        params: params,
        headers: headers,
        contentType: contentType,
        context: context,
        loadingText: loadingText,
        delay: delay,
        showLoad: showLoad);
  }

  /// post请求
  post(String url,
      {Map<String, dynamic> params,
        Map<String, dynamic> headers,
        String contentType,
        BuildContext context,
        String loadingText,
        Duration delay,
        bool showLoad: true}) async {
    return await request(url,
        method: Method.POST,
        params: params,
        headers: headers,
        contentType: contentType,
        context: context,
        loadingText: loadingText,
        delay: delay,
        showLoad: showLoad);
  }

  /// 附件上传
  upLoad(var file, String fileName, String url,
      {Map<String, dynamic> params,
        Map<String, dynamic> headers,
        String contentType}) async {
    return await request(url,
        method: Method.UPLOAD,
        params: params,
        headers: headers,
        contentType: contentType,
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
        String contentType,
        BuildContext context,
        String loadingText,
        Duration delay,
        bool showLoad: false}) async {
    try {
      Response response;

      SessionManager sessionManager = SessionManager();
      if (headers != null) {
        sessionManager.options.headers.addAll(headers);
      } else if (sessionManager.options.headers != null &&
          sessionManager.options.headers.isNotEmpty) {
        sessionManager.options.headers.clear();
      }
      if (contentType != null) {
        sessionManager.options.contentType = contentType;
      } else if (sessionManager.options.contentType == null ||
          sessionManager.options.contentType !=
              Headers.formUrlEncodedContentType) {
        sessionManager.options.contentType = Headers.formUrlEncodedContentType;
      }
      var baseUrl = await getBasicUrl();
      if (baseUrl != null) {
        sessionManager.options.baseUrl = baseUrl;
      } else if (sessionManager.options.baseUrl != null) {
        sessionManager.options.baseUrl = null;
      }

      // 打印网络日志
      NetLogUtils.printLog("baseUrl：$baseUrl,method:【$method】", tag: _TAG);
      NetLogUtils.printLog("Url: $url ,params:${json.encode(params)}",
          tag: _TAG);
      switch (method) {
        case Method.GET:
          response = await sessionManager.get(url, queryParameters: params);
          break;
        case Method.POST:
          response = await sessionManager.post(url, data: params);
          break;
        case Method.UPLOAD:
          {
            FormData formData;
            if (params != null) {
              formData = FormData.fromMap(params);
            } else {
              formData = new FormData();
            }
            if (file != null) {
              formData.files.add(MapEntry("files",
                  MultipartFile.fromFileSync(file, filename: fileName)));
            }
            response = await sessionManager.post(url, data: formData);
            break;
          }
        case Method.DOWNLOAD:
          response = await sessionManager.download(url, fileSavePath);
          break;
      }
      return await handleDataSource(response, method, url: url);
    } on DioError catch (exception) {
      NetLogUtils.printLog("net exception= ${exception.toString()}", tag: _TAG);
      //服务器响应时，但状态不正确
      if (exception.type == DioErrorType.RESPONSE) {
        int statusCode = exception.response.statusCode;
        String errorMsg = HttpStatusCode.getHttpStatusMsg(statusCode);
        return ResultData(errorMsg, false, statusCode, url: url);
      }
      String msg = formatError(exception);
      return ResultData(msg, false, null, url: url);
    }
  }

  /// 数据处理
  static handleDataSource(Response response, Method method, {String url = ""}) {
    ResultData resultData;
    String errorMsg = "";
    int statusCode;
    statusCode = response.statusCode;
    NetLogUtils.printLog("statusCode:【${statusCode.toString()}】", tag: _TAG);
    if (method == Method.DOWNLOAD) {
      if (statusCode == 200) {
        /// 下载成功
        resultData = ResultData('下载成功', true, statusCode);
      } else {
        /// 下载失败
        resultData = ResultData('下载失败', false, statusCode);
      }
    } else {
      Map<String, dynamic> data;
      if (response.data is Map) {
        data = response.data;
      } else {
        data = json.decode(response.data);
      }
      if (NetLogUtils.isPrint()) {
        NetLogUtils.printLog("data: ${json.encode(data)}", tag: _TAG);
        //NetLogUtils.printBigLog(_TAG, "data: ${json.encode(data)}");
      }

      //处理错误部分
      if (statusCode != 200) {
        errorMsg = HttpStatusCode.getHttpStatusMsg(statusCode);
        //errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        resultData = ResultData(errorMsg, false, statusCode, url: url);
      } else {
        try {
          resultData = ResultData.response(data);
        } catch (exception) {
          resultData =
              ResultData(exception.toString(), true, statusCode, url: url);
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
      return "连接服务器超时";
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      return "请求超时";
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      return "响应超时";
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      return "请求取消";
    } else if (e.type == DioErrorType.DEFAULT) {
      return "连接服务器异常";
    }
    return "未知错误";
  }
}
