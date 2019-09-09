import 'matched_pattern_enum.dart';

export 'matched_pattern_enum.dart';

class EnumEntity {
  int index;
  String label;

  EnumEntity(this.index, this.label);

  static List<EnumEntity> toMatchedPatternList() {
    //bool flag = matchedPatternList[0].index == MatchedPatternEnum.ONE.index;
    return [
      EnumEntity(MatchedPatternEnum.ONE.index, "关键字匹配"),
      EnumEntity(MatchedPatternEnum.TWO.index, "相似度匹配"),
      EnumEntity(MatchedPatternEnum.THREE.index, "混合匹配")
    ];
  }
}
