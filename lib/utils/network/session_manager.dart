import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

class SessionManager extends DioForNative {
  static final String contentTypeForm =
      ContentType.parse("application/x-www-form-urlencoded").toString();

  // 工厂模式
  factory SessionManager() => _getInstance();

  static SessionManager get instance => _getInstance();
  static SessionManager _instance;

  SessionManager._internal() {
    // 初始化
  }

  static SessionManager _getInstance() {
    if (_instance == null) {
      _instance = SessionManager._internal();
      BaseOptions options = BaseOptions(
          //连接服务器超时时间，单位是毫秒-10秒
          connectTimeout: 10000,
          //响应流上前后两次接受到数据的间隔，单位为毫秒。
          receiveTimeout: 10000,
          //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
          responseType: ResponseType.json,
          //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded"),Headers.jsonContentType
          contentType: Headers.formUrlEncodedContentType);
      _instance.options = options;
    }
    return _instance;
  }
}
