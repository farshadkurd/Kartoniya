// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// 🎨 تم اصلی اپلیکیشن کارتونیا
/// شامل تم روشن و تاریک با تمام تنظیمات Material 3
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════
  // ثابت‌های طراحی (Design Tokens)
  // ═══════════════════════════════════════
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;
  static const double radiusCircular = 100.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ═══════════════════════════════════════
  // سایه‌های استاندارد
  // ═══════════════════════════════════════
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.12),
      blurRadius: 25,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.2),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
  ];

  // ═══════════════════════════════════════
  // تم روشن (Light Theme)
  // ═══════════════════════════════════════
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.vazirmatnTextTheme(base.textTheme);

    return base.copyWith(
      // رنگ‌بندی اصلی Material 3
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.accent1,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        outline: AppColors.textHint,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: AppColors.background,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),

      // کارت‌ها
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.surface,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        margin: EdgeInsets.zero,
      ),

      // تایپوگرافی
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),

      // دکمه‌های برجسته (Elevated)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.textOnPrimary,
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          elevation: elevationMedium,
          shadowColor: AppColors.primary.withOpacity(0.3),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.vazirmatn().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // دکمه‌های شناور (FAB)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),

      // نوار پیمایش پایین
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        elevation: elevationHigh,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
          fontSize: 11,
        ),
      ),

      // چیپ‌ها
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primarySoft,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCircular),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // فیلد ورودی
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: AppColors.textHint.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
          color: AppColors.textHint,
          fontSize: 14,
        ),
        prefixIconColor: AppColors.textHint,
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primary.withOpacity(0.2),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.1),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        elevation: elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
          color: AppColors.textOnDark,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.textHint.withOpacity(0.2),
        thickness: 1,
        space: 0,
      ),

      // Scrollbar (سازگار با Flutter 3.19 و بالاتر)
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.4)),
        radius: const Radius.circular(10),
        thickness: MaterialStateProperty.all(5),
      ),
    );
  }
}
