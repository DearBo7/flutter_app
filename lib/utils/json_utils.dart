import 'network/net_log_utils.dart';
import 'object_utils.dart';

class JsonUtils {
  static List<T> parseList<T>(dynamic value, T Function(dynamic) itemAnalysis) {
    //todo value is List<Map> 不知道为什么为false? value is List<LinkedHashMap>,value is List<HashMap> 等都为true
    if (ObjectUtils.isEmpty(value) || value is! List) {
      return [];
    }
    List<T> result = [];
    try {
      result = (value as List).map((d) => itemAnalysis(d)).toList();
    } catch (e) {
      NetLogUtils.printLog("[parseList]:value:$value,error:$e",
          tag: "JsonUtils");
    }
    return result;
  }
}
