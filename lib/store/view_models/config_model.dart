import 'dart:math';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';

import '../../public_index.dart';

class ConfigModel extends ChangeNotifier {
  int _localIndex = 0;

  static const kThemeColorIndex = 'kThemeColorIndex';
  static const kThemeBrightnessIndex = 'kThemeBrightnessIndex';
  static const kLocalIndex = 'kLocaleIndex';

  ThemeData _themeData;

  /// 明暗模式
  Brightness _brightness;

  /// 当前主题颜色
  MaterialColor _themeColor;

  ConfigModel() {
    /// 获取主题色
    _themeColor =
        Colors.primaries[SpUtil.getInt(kThemeColorIndex, defValue: 5)];

    /// 明暗模式
    _brightness =
        Brightness.values[SpUtil.getInt(kThemeBrightnessIndex, defValue: 1)];

    _themeData = AppTheme.getThemeData(_brightness, _themeColor);
  }

  ThemeData get themeData => _themeData;

  ThemeData get darkTheme => _themeData.copyWith(brightness: Brightness.dark);

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme({Brightness brightness, MaterialColor themeColor}) {
    _brightness = brightness ?? _brightness;
    _themeColor = themeColor ?? _themeColor;

    _themeData = AppTheme.getThemeData(_brightness, _themeColor);

    notifyListeners();
    // 模式
    SpUtil.setInt(kThemeBrightnessIndex, _brightness.index);

    //主题颜色
    int index = Colors.primaries.indexOf(_themeColor);
    SpUtil.setInt(kThemeColorIndex, index);
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,不指定则保持不变
  void switchRandomTheme({Brightness brightness}) {
    brightness ??= (Random().nextBool() ? Brightness.dark : Brightness.light);
    int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
        brightness: brightness, themeColor: Colors.primaries[colorIndex]);
  }

  ///语言
  void getLocal() {
    _localIndex = SpUtil.getInt('key_support_locale', defValue: 0);
    debugPrint('config get Local $_localIndex');
    notifyListeners();
  }

  int get localIndex => _localIndex;

  void setLocal(local) async {
    _localIndex = local;
    SpUtil.setInt('key_support_locale', local);
    notifyListeners();
  }
}
