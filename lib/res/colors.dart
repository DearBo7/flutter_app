import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorUtils {
  static const Color accentColor = Color(0xFFF08F8F);
  static const Color lightAccentColor = Color(0xFFFfaFaF);
  static const Color darkAccentColor = Color(0xFFd06F6F);
  static const Color readerMainColor = Color(0xFF33C3A5);
  static const Color readerMainDisColor = Color(0xFFE0FFFF);
  static const Color colorGreyA = Color(0xFFAAAAAA);
  static const Color colorNavajoWhite = Color(0xFFFFDEAD);
  static const Color colorPapayaWhip = Color(0xFFFFEFD5);
  static const Color colorPeachPuff = Color(0xFFFFDAB9);
  static const Color colorMoccasin = Color(0xFFFFE4B5);
  static const Color colorLemonChiffon = Color(0xFFFFFACD);
  static const Color colorHoneydew = Color(0xFFF0FFF0);
  static const Color colorMintCream = Color(0xFFF5FFFA);
  static const Color colorMistyRose = Color(0xFFFFE4E1);
  static const Color colorLightBlue2 = Color(0xFFB2DFEE);
  static const Color colorLightCyan1 = Color(0xFFE0FFFF);
  static const Color colorPink1 = Color(0xFFFFB5C5);
  static const Color colorDarkGoldenrod3 = Color(0xFFCD950C);
  static const Color colorSnow = Color(0xFFFFFAFA);
  static const Color starColor = Color(0xFFFACE41);
  static const Color greyCColor = Color(0xFFCCCCCC);
  static const Color grey3Color = Color(0xFF333333);
  static const Color grey6Color = Color(0xFF666666);
  static const Color grey9Color = Color(0xFF999999);

  static bool getThemeLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  //light:黑色,dark:白色
  static Color getThemeModeColor(BuildContext context,
      {Color light: Colors.black, Color dark: Colors.white, double opacity}) {
    Color _thisColor = getThemeLight(context) ? light : dark;
    return opacity != null && opacity > 0 && opacity < 1
        ? _thisColor.withOpacity(opacity)
        : _thisColor;
  }
}
