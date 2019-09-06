import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

import '../utils/sp_util.dart';

class StorageManager {
  /// app全局配置 eg:theme
  //static SharedPreferences sharedPreferences;
  static SpUtil spUtil;

  /// 临时目录 eg: cookie
  static Directory temporaryDirectory;

  /// 初始化必备操作 eg:user数据
  static LocalStorage localStorage;

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    debugPrint('StorageManager--init');
    // async 异步操作
    // sync 同步操作
    temporaryDirectory = await getTemporaryDirectory();
    spUtil = await SpUtil.getInstance();
    localStorage = LocalStorage('LocalStorage');
    await localStorage.ready;
    debugPrint('StorageManager--end');
  }
}
