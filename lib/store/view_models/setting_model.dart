import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:flutter_app/store/enums/matched_pattern_enum.dart';

import '../../public_index.dart';

class SettingModel extends ChangeNotifier {
  /// 图片质量
  static const kImgQuality = 'img_quality_key';

  /// 匹配相似度
  static const KSimilarity = 'orc_similarity_key';

  /// 匹配模式
  static const kMatchedPattern = 'orc_matched_pattern_key';

  /// 批次规则是否显示
  static const kMaterialBatchShow = 'material_batch_Show_key';

  /// 识别是否区分大小写
  static const kMaterialOrcCase = 'material_orc_case_key';

  /// 图片质量
  int _quality;

  double get quality => _quality.toDouble();

  /// 匹配相似度-匹配时/100
  int _similarity;

  double get similarity => _similarity.toDouble();

  /// 匹配模式
  int _matchedPattern;

  int get matchedPattern => _matchedPattern;

  /// 批次规则是否显示-默认不显示[false]
  bool _materialBatchShowFlag;

  bool get materialBatchShowFlag => _materialBatchShowFlag;

  /// 识别是否区分大小写-默认不区分[false]
  bool _materialOrcCaseFlag;

  bool get materialOrcCaseFlag => _materialOrcCaseFlag;

  SettingModel() {
    _quality = SpUtil.getInt(kImgQuality, defValue: 80);
    _similarity = SpUtil.getInt(KSimilarity, defValue: 50);
    _matchedPattern = SpUtil.getInt(kMatchedPattern, defValue: MatchedPatternEnum.ONE.index);
    _materialBatchShowFlag =
        SpUtil.getBool(kMaterialBatchShow, defValue: false);
    _materialOrcCaseFlag = SpUtil.getBool(kMaterialOrcCase, defValue: false);
  }

  void setQuality(int quality) {
    SpUtil.setInt(kImgQuality, quality);
    this._quality = quality;
    notifyListeners();
  }

  void setSimilarity(int similarity) {
    SpUtil.setInt(KSimilarity, similarity);
    this._similarity = similarity;
    notifyListeners();
  }

  void setMatchedPattern(int matchedPattern) {
    SpUtil.setInt(kMatchedPattern, matchedPattern);
    this._matchedPattern = matchedPattern;
    notifyListeners();
  }

  void setMaterialBatchShowFlag(bool batchShowFlag) {
    SpUtil.setBool(kMaterialBatchShow, batchShowFlag);
    this._materialBatchShowFlag = batchShowFlag;
    notifyListeners();
  }

  void setMaterialOrcCaseFlag(bool orcCaseFlag) {
    SpUtil.setBool(kMaterialOrcCase, orcCaseFlag);
    this._materialOrcCaseFlag = orcCaseFlag;
    notifyListeners();
  }
}
