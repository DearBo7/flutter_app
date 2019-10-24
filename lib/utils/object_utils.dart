import 'dart:collection';
import 'dart:convert';

class ObjectUtils {
  /// 传递中文参数前，先转换，不支持中文传递
  static String stringCnParamsEncode(String originalCn) {
    return jsonEncode(Utf8Encoder().convert(originalCn));
  }

  /// 传递后取出参数，解析
  static String stringCnParamsDecode(String encodeCn) {
    var list = List<int>();

    ///字符串解码
    jsonDecode(encodeCn).forEach(list.add);
    String value = Utf8Decoder().convert(list);
    return value;
  }

  /// object 转为 string json
  static String objectToJson<T>(T t) {
    return stringCnParamsEncode(jsonEncode(t));
  }

  /// string json 转为 map
  static Map<String, dynamic> jsonToMap(String strJson) {
    return json.decode(stringCnParamsDecode(strJson));
  }

  /// string 转为 bool
  static bool stringToBool(String str) {
    if (isBlank(str)) {
      return null;
    }
    if (str.toLowerCase() == 'true') {
      return true;
    } else {
      return false;
    }
  }

  ///StringUtils.isEmpty(null)      = true
  /// StringUtils.isEmpty("")        = true
  /// StringUtils.isEmpty(" ")       = false
  /// StringUtils.isEmpty("bob")     = false
  /// StringUtils.isEmpty("  bob  ") = false
  static bool isEmptyString(String str) {
    return str == null || str.isEmpty;
  }

  static bool isNotEmptyString(String str) {
    return !isEmptyString(str);
  }

  ///StringUtils.isEmpty(null)      = true
  /// StringUtils.isEmpty("")        = true
  /// StringUtils.isEmpty(" ")       = true
  /// StringUtils.isEmpty("bob")     = false
  /// StringUtils.isEmpty("  bob  ") = false
  static bool isBlank(String str) {
    return isEmptyString(str) || str.trim().isEmpty;
  }

  static bool isNotBlank(String str) {
    return !isBlank(str);
  }

  static bool isEmpty(Object object) {
    if (object == null) {
      return true;
    }
    if (object is String && isEmptyString(object)) {
      return true;
    } else if (object is List && object.length < 1) {
      return true;
    } else if (object is Map && object.length < 1) {
      return true;
    } else if (object is LinkedHashMap && object.length < 1) {
      return true;
    } else if (object is HashMap && object.length < 1) {
      return true;
    } else if (object is SplayTreeMap && object.length < 1) {
      return true;
    }
    return false;
  }

  static bool isMap(dynamic object) {
    if (object is Map ||
        object is LinkedHashMap ||
        object is HashMap ||
        object is SplayTreeMap) {
      return true;
    }
    return false;
  }

  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  static String removeStart(String str, String remove) {
    if (isEmptyString(str) || isEmptyString(remove)) {
      return str;
    }
    if (str.startsWith(remove)) {
      return str.substring(remove.length);
    }
    return str;
  }

  static String removeEnd(final String str, final String remove) {
    if (isEmptyString(str) || isEmptyString(remove)) {
      return str;
    }
    if (str.endsWith(remove)) {
      return str.substring(0, str.length - remove.length);
    }
    return str;
  }
}
