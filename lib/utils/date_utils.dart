import 'package:flustars/flustars.dart' show DateUtil, DataFormats;

class DateUtils {
  static int dayInYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays;
  }

  static bool isToday(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    String today =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    return date == today;
  }

  /// 判断某日期是否为闰年
  ///
  /// Example:
  ///     isLeapYear("2019")
  ///     // => false
  static bool isLeapYear({String dateStr: ''}) {
    int _year = DateTime.now().year;
    if (dateStr.isNotEmpty) {
      _year = DateTime.parse(dateStr)?.year;
      if (_year == null) {
        _year = DateTime.now().year;
      }
    }
    return (_year % 4 == 0 && _year % 100 != 0) || _year % 400 == 0;
  }

  /// 友好式时间展示
  /// [datetime]
  ///
  static String friendlyDateTime(String datetime) {
    String friendly = '';
    String agoOrAfter = '之前';

    int _dateTime = DateTime.parse(datetime).millisecondsSinceEpoch;
    int _now = DateTime.now().millisecondsSinceEpoch;

    if (_now < _dateTime) {
      agoOrAfter = '之后';
    }

    int elapsed = (_now - _dateTime).abs();

    final int seconds = elapsed ~/ 1000;
    final int minutes = seconds ~/ 60;
    final int hours = minutes ~/ 60;
    final int days = hours ~/ 24;
    final int weeks = days ~/ 7;
    final int mounts = days ~/ 30;

    if (seconds < 60) {
      friendly = agoOrAfter == '之后' ? '马上' : '刚刚';
    } else if (seconds >= 60 && seconds < 60 * 60) {
      friendly = '$minutes分钟$agoOrAfter';
    } else if (seconds >= 60 * 60 && seconds < 60 * 60 * 24) {
      friendly = '$hours小时$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 && seconds < 60 * 60 * 24 * 2) {
      friendly = agoOrAfter == '之后' ? '明天' : '昨天';
    } else if (seconds >= 60 * 60 * 24 * 2 && seconds < 60 * 60 * 24 * 3) {
      friendly = agoOrAfter == '之后' ? '后天' : '前天';
    } else if (seconds >= 60 * 60 * 24 * 3 && seconds < 60 * 60 * 24 * 7) {
      friendly = '$days天$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 * 7 && seconds < 60 * 60 * 24 * 30) {
      friendly = '$weeks周$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 * 30 &&
        seconds < 60 * 60 * 24 * 30 * 6) {
      friendly = '$mounts月$agoOrAfter';
    } else if (seconds >= 60 * 60 * 24 * 30 * 6 &&
        seconds < 60 * 60 * 24 * 30 * 12) {
      friendly = '半年$agoOrAfter';
    } else {
      friendly = DateUtil.formatDateMs(_dateTime, format: DataFormats.y_mo_d);
    }
    return friendly;
  }

  /// 返回当前时间戳-毫秒
  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  /// 返回当前秒
  static int currentTimeSecond() {
    return new DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  ///返回两个日期相差的天数
  static int dateDifferenceDay(DateTime startDate, DateTime endDate,
      [bool ignoreTime = false]) {
    return millisecondDifferenceDay(startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch, ignoreTime);
  }

  /// 返回两个毫秒相差天数
  static int millisecondDifferenceDay(int startMillisecond, int endMillisecond,
      [bool ignoreTime = false]) {
    if (ignoreTime) {
      int v = endMillisecond ~/ 86400000 - startMillisecond ~/ 86400000;
      if (v < 0) {
        return -v;
      }
      return v;
    } else {
      int v = endMillisecond - startMillisecond;
      if (v < 0) {
        v = -v;
      }
      return v ~/ 86400000;
    }
  }
}
