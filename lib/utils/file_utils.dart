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

  static bool _checkIsNotNull(String str) {
    return str != null && str.trim().length > 0;
  }

  static bool _checkIsNull(String str) {
    return !_checkIsNotNull(str);
  }
}
