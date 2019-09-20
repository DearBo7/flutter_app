import '../../global/config.dart';
import 'package:flutter/material.dart';
class NetLogUtils{
  static void printLog(String log, {tag}) {
    if (isPrint()) {
      String tagLog;
      if (tag != null) {
        tagLog = "【$tag】=> $log";
      } else {
        tagLog = log;
      }
      debugPrint(tagLog);
    }
  }

  static void printBigLog(String tag, String log) {
    //log = TEST_POEM;
    bool print = isPrint();
    const MAX_COUNT = 3000;
    if (print) {
      if (log != null && log.length > MAX_COUNT) {
        // 超过 MAX_COUNT 就分次打印
        int len = log.length;
        int paragraphCount = ((len / MAX_COUNT) + 1).toInt();
        for (int i = 0; i < paragraphCount; i++) {
          int printCount = MAX_COUNT;
          if (i == paragraphCount - 1) {
            printCount = len - (MAX_COUNT * (paragraphCount - 1));
          }
          printLog(
              log.substring(i * MAX_COUNT, i * MAX_COUNT + printCount),
              tag: tag);
        }
      } else {
        printLog(log, tag: tag);
      }
    }
  }

  static bool isPrint() {
    return Config.NET_DEBUG;
  }
}