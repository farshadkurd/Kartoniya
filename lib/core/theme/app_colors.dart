import 'package:flutter/material.dart';

/// رنگ‌های برند کارتونیا. رنگ‌های خنثی از [ThemeData] خوانده می‌شوند تا
/// حالت روشن و تاریک در تمام صفحه‌ها یکپارچه بماند.
abstract final class AppColors {
  static const primary = Color(0xFFFF8A50);
  static const primaryLight = Color(0xFFFFB48C);
  static const primaryDark = Color(0xFFD95F2B);
  static const primarySoft = Color(0xFFFFF0E7);

  static const secondary = Color(0xFF4DB9EE);
  static const secondaryLight = Color(0xFF9BDFFC);
  static const secondaryDark = Color(0xFF208DC3);
  static const secondarySoft = Color(0xFFE9F8FF);

  static const pink = Color(0xFFFF6B9D);
  static const purple = Color(0xFF9B7CEB);
  static const green = Color(0xFF53B86A);
  static const yellow = Color(0xFFFFC83D);
  static const red = Color(0xFFF06A70);

  static const success = Color(0xFF2EAD65);
  static const warning = Color(0xFFFFA502);
  static const error = Color(0xFFE65057);
  static const gold = Color(0xFFFFD56A);
  static const goldDark = Color(0xFFC68A1B);

  static const lightBackground = Color(0xFFFFF9F5);
  static const darkBackground = Color(0xFF161624);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF24243A);

  static const primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const sunsetGradient = LinearGradient(
    colors: [yellow, primary],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const coolGradient = LinearGradient(
    colors: [secondary, purple],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const warmGradient = LinearGradient(
    colors: [pink, primary],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static Color categoryColor(String category) {
    switch (category) {
      case 'ماجراجویی':
        return red;
      case 'آموزشی':
        return secondary;
      case 'سرگرمی':
        return pink;
      case 'هنری':
        return purple;
      case 'علمی':
        return green;
      case 'موسیقی':
        return yellow;
      default:
        return primary;
    }
  }

  static LinearGradient categoryGradient(String category) {
    final color = categoryColor(category);
    return LinearGradient(
      colors: [color, Color.lerp(color, Colors.white, .28)!],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );
  }
}
