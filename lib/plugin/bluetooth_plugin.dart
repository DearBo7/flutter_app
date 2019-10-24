import 'package:flutter/services.dart';

import 'plugins.dart';

class BluetoothPlugin {
  final MethodChannel _channel = const MethodChannel('bo.flutter.io/bluetooth');

  BluetoothPlugin._();

  static BluetoothPlugin _instance = new BluetoothPlugin._();

  static BluetoothPlugin getInstance() => _instance;

  //当前设备是否支持蓝牙
  Future<bool> get isAvailable => _channel
      .invokeMethod(BluePluginMethodName.isAvailable)
      .then<bool>((d) => d);

  //当前设备是否打开蓝牙
  Future<bool> get isOpen =>
      _channel.invokeMethod(BluePluginMethodName.isOpen).then<bool>((d) => d);

  //打开蓝牙
  Future<bool> openBluetooth() {
    return _channel
        .invokeMethod(BluePluginMethodName.openBluetooth)
        .then<bool>((d) => d);
  }

  //获取蓝牙匹配列表
  Future<List<BluetoothEntity>> getPairDeviceList() {
    return _channel
        .invokeListMethod<Map>(BluePluginMethodName.getPairDeviceList)
        .then((d) => d.map((m) => BluetoothEntity.fromJson(m)).toList());
  }
}

class BluetoothEntity {
  String name;
  String address;

  BluetoothEntity.fromJson(Map json) {
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
