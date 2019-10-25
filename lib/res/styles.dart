import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'dimens.dart';

class AppTheme {
  static getThemeDataByColor(int color) {
    //print('getThemeData===================================$color');
    ThemeData themData = ThemeData(
        primaryColor: Color(color == 0 ? Colors.purpleAccent.value : color));
    return themData;
  }

  /// 根据主题 明暗 和 颜色 生成对应的主题
  static getThemeData(Brightness brightness, MaterialColor themeColor) {
    var isDark = Brightness.dark == brightness;
    var accentColor = isDark ? themeColor[700] : themeColor;
    var themeData = ThemeData(
        brightness: brightness,
        // 主题颜色属于亮色系还是属于暗色系(eg:dark时,AppBarTitle文字及状态栏文字的颜色为白色,反之为黑色)
        // 这里设置为dark目的是,不管App是明or暗,都将appBar的字体颜色的默认值设为白色.
        // 再AnnotatedRegion<SystemUiOverlayStyle>的方式,调整响应的状态栏颜色
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        primarySwatch: themeColor,
        accentColor: accentColor);

    themeData = themeData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      cursorColor: accentColor,
      textTheme: themeData.textTheme.copyWith(

          /// 解决中文hint不居中的问题 https://github.com/flutter/flutter/issues/40248
          subhead: themeData.textTheme.subhead
              .copyWith(textBaseline: TextBaseline.alphabetic)),
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
//          textTheme: CupertinoTextThemeData(brightness: Brightness.light)
      //inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
    );
    return themeData;
  }
}

class TextStyles {
  ///使用前ScreenUtil必须初始化
  static TextStyle textScreenStyle(
      {double fontSize: Dimens.font_sp14,
      Color color,
      TextDecoration decoration,
      Color decorationColor,
      FontWeight fontWeight}) {
    return textStyle(
      fontSize: ScreenUtil().setSp(fontSize),
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textStyleTheme(BuildContext context,
      {double fontSize, FontWeight fontWeight}) {
    return textStyle(
        color: ColorUtils.getThemeModeColor(context),
        fontSize: fontSize,
        fontWeight: fontWeight);
  }

  static TextStyle textStyle(
      {double fontSize: Dimens.font_sp14,
      Color color,
      TextDecoration decoration: TextDecoration.none,
      Color decorationColor,
      FontWeight fontWeight}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      fontWeight: fontWeight,
    );
  }

  //输入框前面的描述信息
  static const TextStyle errorStyle =
      TextStyle(fontSize: Dimens.font_sp14, color: Colors.red);

  //输入框前面的描述信息
  static const TextStyle labelTitle =
      TextStyle(fontSize: Dimens.font_sp18, color: Colors.grey);

  //描述-备注信息
  static const TextStyle labelRemark =
      TextStyle(fontSize: Dimens.font_sp16, color: Colors.grey);

  //列表主要内容显示
  static const TextStyle listTitle =
      TextStyle(fontSize: Dimens.font_sp18, color: Colors.black);

  //列表不是主要内容显示
  static const TextStyle listSubtitle =
      TextStyle(fontSize: Dimens.font_sp14, color: Colors.grey);

  //设置分组字体大小
  static const TextStyle settingGroupTitle =
      TextStyle(fontSize: Dimens.font_sp12);

  //设置标题大小
  static const TextStyle settingTitle = TextStyle(fontSize: Dimens.font_sp16);
}

class Borders {
  static Border borderGrey = Border.all(color: Colors.grey[400], width: 1);
  static BorderRadius borderAllRadius3 = BorderRadius.all(Radius.circular(3.0));
}

/// 间隔
class Gaps {
  /// 水平间隔
  static Widget wGap3 = SizedBox(width: Dimens.gap_dp3);
  static Widget wGap4 = SizedBox(width: Dimens.gap_dp4);
  static Widget wGap5 = SizedBox(width: Dimens.gap_dp5);
  static Widget wGap6 = SizedBox(width: Dimens.gap_dp6);
  static Widget wGap8 = SizedBox(width: Dimens.gap_dp8);
  static Widget wGap10 = SizedBox(width: Dimens.gap_dp10);
  static Widget wGap12 = SizedBox(width: Dimens.gap_dp12);
  static Widget wGap15 = SizedBox(width: Dimens.gap_dp15);
  static Widget wGap16 = SizedBox(width: Dimens.gap_dp16);
  static Widget wGap20 = SizedBox(width: Dimens.gap_dp20);
  static Widget wGap24 = SizedBox(width: Dimens.gap_dp24);
  static Widget wGap40 = SizedBox(width: Dimens.gap_dp40);

  /// 垂直间隔
  static Widget hGap3 = SizedBox(height: Dimens.gap_dp3);
  static Widget hGap4 = SizedBox(height: Dimens.gap_dp4);
  static Widget hGap5 = SizedBox(height: Dimens.gap_dp5);
  static Widget hGap6 = SizedBox(height: Dimens.gap_dp6);
  static Widget hGap8 = SizedBox(height: Dimens.gap_dp8);
  static Widget hGap10 = SizedBox(height: Dimens.gap_dp10);
  static Widget hGap12 = SizedBox(height: Dimens.gap_dp12);
  static Widget hGap15 = SizedBox(height: Dimens.gap_dp15);
  static Widget hGap16 = SizedBox(height: Dimens.gap_dp16);
  static Widget hGap20 = SizedBox(height: Dimens.gap_dp20);
  static Widget hGap24 = SizedBox(height: Dimens.gap_dp24);
  static Widget hGap25 = SizedBox(height: Dimens.gap_dp25);
  static Widget hGap40 = SizedBox(height: Dimens.gap_dp40);
  static Widget hGap48 = SizedBox(height: Dimens.gap_dp48);
  static Widget hGap60 = SizedBox(height: Dimens.gap_dp60);

  static Widget wGap(double w) {
    return SizedBox(width: w);
  }

  static Widget hGap(double h) {
    return SizedBox(height: h);
  }

  static Widget line = Container(height: 0.6, color: Color(0xFFEEEEEE));
}

//分割线
class Dividers {
  static Widget setDivider(
      {double height: 1, double dividerHeight: 1, double width}) {
    return SizedBox(
        height: height, width: width, child: Divider(height: dividerHeight));
  }
}

class ThemeHelper {
  static InputDecorationTheme inputDecorationTheme(ThemeData theme) {
    var primaryColor = theme.primaryColor;
    var dividerColor = theme.dividerColor;
    var errorColor = theme.errorColor;
    var disabledColor = theme.disabledColor;

    var width = 0.5;

    return InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 14),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: errorColor)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.7, color: errorColor)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: primaryColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: disabledColor)),
    );
  }
}
