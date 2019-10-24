import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';

import '../../../public_index.dart';

class PrintModel extends ChangeNotifier {
  /// 是否打印
  static const kPrintAuto = 'print_auto_key';

  /// 蓝牙默认名称
  static const KBluetoothName = 'bluetooth_name_key';

  /// 是否打印
  bool _printAutoFlag;

  bool get printAutoFlag => _printAutoFlag;

  /// 蓝牙默认名称
  String _bluetoothName;

  String get bluetoothName => _bluetoothName;

  /// 标签宽度
  int pageWidth = 600;

  /// 标签高度
  int pageHeight = 320;

  /// 间距高度
  int spacingHeight = 24;

  /// 打印速度,没秒多少mm
  double printSpeed = 48.0;

  /// 标签间距
  int height = 42;

  /// 蓝牙地址-[根据蓝牙名称获取]
  String bluetoothAddress;

  PrintModel() {
    _printAutoFlag = SpUtil.getBool(kPrintAuto, defValue: false);
    _bluetoothName = SpUtil.getString(KBluetoothName, defValue: "XT423");
  }

  void setPrintAutoFlag(bool printAutoFlag) {
    SpUtil.setBool(kPrintAuto, printAutoFlag);
    this._printAutoFlag = printAutoFlag;
    notifyListeners();
  }
}
