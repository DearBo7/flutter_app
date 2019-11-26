import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../global/config.dart';

//网络请求框架工具类
class DioHttpUtils {
  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static DioHttpUtils instance;
  Dio _dio;
  BaseOptions options;

  CancelToken cancelToken = CancelToken();

  Dio get dio => _dio;

  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  static DioHttpUtils getInstance() {
    if (null == instance) {
      instance = new DioHttpUtils();
    }
    return instance;
  }

  DioHttpUtils() {
    options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: "http://www.google.com",
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: Headers.formUrlEncodedContentType,
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    _dio = new Dio(options);
    //Cookie管理
    //dio.interceptors.add(CookieManager(CookieJar()));

    /// 添加拦截器
    if (Config.NetDebug) {
      _dio.interceptors
        ..add(InterceptorsWrapper(onRequest: (RequestOptions options) {
          debugPrint("\n================== 请求数据 ==========================");
          debugPrint("url = ${options.uri.toString()}");
          debugPrint("headers = ${options.headers}");
          debugPrint("params = ${options.data}");
        }, onResponse: (Response response) {
          debugPrint("\n================== 响应数据 ==========================");
          debugPrint("code = ${response.statusCode}");
          debugPrint("data = ${response.data}");
          debugPrint("\n");
        }, onError: (DioError e) {
          debugPrint("\n================== 错误响应数据 ======================");
          debugPrint("type = ${e.type}");
          debugPrint("message = ${e.message}");
          debugPrint("\n");
        }))

        /// 添加 LogInterceptor 拦截器来自动打印请求、响应日志
        ..add(LogInterceptor());
    }
  }

  /*
   * get请求
   */
  get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码

    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await dio.post(url, queryParameters: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
