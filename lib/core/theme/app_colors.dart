// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// 🎨 سیستم رنگ‌بندی کارتونیا
/// الهام‌گرفته از پالت‌های گرم و شاد برای کودکان
/// با حفظ خوانایی و کنتراست مناسب
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════
  // رنگ‌های اصلی برند (Brand Primary)
  // ═══════════════════════════════════════
  static const Color primary = Color(0xFFFF8A50);        // نارنجی گرم و شاد
  static const Color primaryLight = Color(0xFFFFAB76);   // نارنجی روشن
  static const Color primaryDark = Color(0xFFE86F3A);    // نارنجی تیره
  static const Color primarySoft = Color(0xFFFFF0E5);    // نارنجی خیلی روشن (پس‌زمینه)

  // ═══════════════════════════════════════
  // رنگ‌های ثانویه (Secondary)
  // ═══════════════════════════════════════
  static const Color secondary = Color(0xFF5AC8FA);       // آبی آسمانی شاد
  static const Color secondaryLight = Color(0xFF8AD8FD);  // آبی روشن
  static const Color secondaryDark = Color(0xFF3AAEE8);   // آبی تیره
  static const Color secondarySoft = Color(0xFFE8F6FF);   // آبی خیلی روشن

  // ═══════════════════════════════════════
  // رنگ‌های تزئینی (Accent)
  // ═══════════════════════════════════════
  static const Color accent1 = Color(0xFFFF6B9D);         // صورتی شاد
  static const Color accent2 = Color(0xFFC9A0FF);         // بنفش روشن
  static const Color accent3 = Color(0xFF7DD956);         // سبز شاد
  static const Color accent4 = Color(0xFFFFD93D);         // زرد درخشان
  static const Color accent5 = Color(0xFFFF6B6B);         // قرمز ملایم

  // ═══════════════════════════════════════
  // رنگ‌های خنثی (Neutrals)
  // ═══════════════════════════════════════
  static const Color background = Color(0xFFFFF8F2);       // کرم گرم
  static const Color backgroundDark = Color(0xFF1A1A2E);   // پس‌زمینه تاریک
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF25253E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A2A45);

  // ═══════════════════════════════════════
  // رنگ‌های متن (Text)
  // ═══════════════════════════════════════
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textOnDark = Color(0xFFF8F8F8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════
  // رنگ‌های وضعیت (Status)
  // ═══════════════════════════════════════
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF70A1FF);

  // ═══════════════════════════════════════
  // رنگ‌های ویژه (Special Effects)
  // ═══════════════════════════════════════
  static const Color goldGlow = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFDAA520);
  static const Color amberAccent = Color(0xFFFFBF00);
  static const Color starYellow = Color(0xFFFFD93D);

  // ═══════════════════════════════════════
  // گرادیان‌های آماده
  // ═══════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF9A76), Color(0xFFFF6B9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [Color(0xFF5AC8FA), Color(0xFFC9A0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFFD93D), Color(0xFFFF8A50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nightGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ═══════════════════════════════════════
  // رنگ‌بندی دسته‌بندی‌ها
  // ═══════════════════════════════════════
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'ماجراجویی':
        return accent5;
      case 'آموزشی':
        return secondary;
      case 'سرگرمی':
        return accent1;
      case 'هنری':
        return accent2;
      case 'علمی':
        return accent3;
      case 'موسیقی':
        return accent4;
      default:
        return primary;
    }
  }

  static LinearGradient getCategoryGradient(String category) {
    final color = getCategoryColor(category);
    return LinearGradient(
      colors: [color, color.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
