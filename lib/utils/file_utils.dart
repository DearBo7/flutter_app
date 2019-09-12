import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  //获取orc文件
  static Future<String> getOrcFilePath() async {
    return await getOrcDirectoryPath() + "/orc.jpg";
  }

  //获取orc储存目录
  static Future<String> getOrcDirectoryPath() {
    return getApplicationDocumentsDirectoryPath(childPath: "orc-images");
  }

  //文件写入到指定目录
  static Future<bool> writeToFile(File file, String newPath) async {
    _getFilePathAndCreate(newPath);
    File file1 = await file.writeAsString(newPath);
    return file1.existsSync();
  }

  //获取应用文档目录
  static Future<String> getApplicationDocumentsDirectoryPath(
      {String childPath: "", bool suffixFlag: false}) async {
    if (_checkIsNotNull(childPath) &&
        !childPath.startsWith("/") &&
        !childPath.startsWith("\\")) {
      childPath = "/" + childPath;
    }
    Directory documentsPath = await getApplicationDocumentsDirectory();
    return _getDirectoryPathAndCreate(documentsPath.path + childPath,
        suffixFlag: suffixFlag);
  }

  //获取应用-file目录
  static Future<String> getApplicationSupportDirectoryPath(
      {String childPath, bool suffixFlag: false}) async {
    if (_checkIsNotNull(childPath) &&
        !childPath.startsWith("/") &&
        !childPath.startsWith("\\")) {
      childPath = "/" + childPath;
    }
    Directory documentsPath = await getApplicationSupportDirectory();
    return _getDirectoryPathAndCreate(documentsPath.path + childPath,
        suffixFlag: suffixFlag);
  }

  //获取获取临时目录
  static Future<String> getTemporaryDirectoryPath(
      {String childPath, bool suffixFlag: false}) async {
    if (_checkIsNotNull(childPath) &&
        !childPath.startsWith("/") &&
        !childPath.startsWith("\\")) {
      childPath = "/" + childPath;
    }
    Directory documentsPath = await getTemporaryDirectory();
    return _getDirectoryPathAndCreate(documentsPath.path + childPath,
        suffixFlag: suffixFlag);
  }

  //获取外部存储目录
  static Future<String> getExternalStorageDirectoryPath(
      {String childPath, bool suffixFlag: false}) async {
    if (_checkIsNotNull(childPath) &&
        !childPath.startsWith("/") &&
        !childPath.startsWith("\\")) {
      childPath = "/" + childPath;
    }
    Directory documentsPath = await getExternalStorageDirectory();
    return _getDirectoryPathAndCreate(documentsPath.path + childPath,
        suffixFlag: suffixFlag);
  }

  //获取并创建目录
  static String _getDirectoryPathAndCreate(String path,
      {bool suffixFlag: false}) {
    if (_checkIsNull(path)) {
      return path;
    }
    Directory directory = new Directory(path);
    //如果不存在就创建一个
    if (!directory.existsSync()) {
      directory.createSync();
    }
    return suffixFlag ? directory.path + "/" : directory.path;
  }

  //获取并创建文件
  static String _getFilePathAndCreate(String path) {
    if (_checkIsNull(path)) {
      return path;
    }
    File file = new File(path);
    //如果不存在就创建一个
    if (!file.existsSync()) {
      file.createSync();
    }
    return file.path;
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];

  /// 返回文件大小字符串
  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }

  static bool _checkIsNotNull(String str) {
    return str != null && str.trim().length > 0;
  }

  static bool _checkIsNull(String str) {
    return !_checkIsNotNull(str);
  }
}
