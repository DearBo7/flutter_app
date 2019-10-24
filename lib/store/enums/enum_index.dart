import 'matched_pattern_enum.dart';
import '../../api/bean/key_entity.dart';
export 'matched_pattern_enum.dart';
export '../../api/bean/key_entity.dart';
class EnumEntity extends KeyEntity<int, String>{
  EnumEntity(int code, String label) : super(code: code, label: label);

  static List<EnumEntity> toMatchedPatternList() {
    //bool flag = matchedPatternList[0].index == MatchedPatternEnum.ONE.index;
    return [
      EnumEntity(MatchedPatternEnum.ONE.index, "关键字匹配"),
      EnumEntity(MatchedPatternEnum.TWO.index, "相似度匹配"),
      EnumEntity(MatchedPatternEnum.THREE.index, "混合匹配")
    ];
  }
}
