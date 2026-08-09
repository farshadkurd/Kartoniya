import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// توکن‌های طراحی و تم Material 3 کارتونیا.
abstract final class AppTheme {
  static const radiusSmall = 12.0;
  static const radiusMedium = 18.0;
  static const radiusLarge = 24.0;
  static const radiusXLarge = 32.0;
  static const radiusCircular = 100.0;

  static const spacingXs = 4.0;
  static const spacingSm = 8.0;
  static const spacingMd = 16.0;
  static const spacingLg = 24.0;
  static const spacingXl = 32.0;

  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    final scheme = baseScheme.copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: isDark ? const Color(0xFF713519) : AppColors.primarySoft,
      onPrimaryContainer: isDark ? const Color(0xFFFFD8C4) : AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer:
          isDark ? const Color(0xFF123D50) : AppColors.secondarySoft,
      onSecondaryContainer:
          isDark ? const Color(0xFFB8EBFF) : AppColors.secondaryDark,
      tertiary: AppColors.purple,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      onSurface: isDark ? const Color(0xFFF4F0F7) : const Color(0xFF282432),
      surfaceVariant: isDark ? const Color(0xFF33334A) : const Color(0xFFF5EEE9),
      onSurfaceVariant: isDark ? const Color(0xFFD1CAD8) : const Color(0xFF625B68),
      outline: isDark ? const Color(0xFF9A929F) : const Color(0xFF7A727E),
      error: AppColors.error,
      onError: Colors.white,
    );
    final rawTextTheme = GoogleFonts.vazirmatnTextTheme(
      ThemeData(brightness: brightness, useMaterial3: true).textTheme,
    );
    final textTheme = rawTextTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ).copyWith(
      displaySmall: rawTextTheme.displaySmall?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        height: 1.25,
      ),
      headlineMedium: rawTextTheme.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.35,
      ),
      headlineSmall: rawTextTheme.headlineSmall?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.4,
      ),
      titleLarge: rawTextTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        height: 1.45,
      ),
      titleMedium: rawTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.45,
      ),
      bodyLarge: rawTextTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.7),
      bodyMedium: rawTextTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.65),
      labelLarge: rawTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      fontFamily: GoogleFonts.vazirmatn().fontFamily,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: scheme.outline.withOpacity(.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.outline.withOpacity(.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 74,
        backgroundColor: scheme.surface,
        indicatorColor: AppColors.primary.withOpacity(isDark ? .3 : .16),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          return textTheme.labelLarge?.copyWith(
            color: states.contains(MaterialState.selected)
                ? AppColors.primary
                : scheme.onSurfaceVariant,
            fontSize: 11,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        labelStyle: textTheme.labelLarge?.copyWith(fontSize: 13),
        side: BorderSide(color: scheme.outline.withOpacity(.16)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCircular),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFFF4F0F7) : const Color(0xFF282432),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? const Color(0xFF282432) : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withOpacity(.14),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static List<BoxShadow> softShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withOpacity(
            Theme.of(context).brightness == Brightness.dark ? .20 : .07,
          ),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> mediumShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withOpacity(
            Theme.of(context).brightness == Brightness.dark ? .28 : .12,
          ),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];
}

extension KartoniyaThemeContext on BuildContext {
  Color get pageBackground => Theme.of(this).scaffoldBackgroundColor;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get primaryTextColor => Theme.of(this).colorScheme.onSurface;
  Color get secondaryTextColor => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get softBorderColor => Theme.of(this).colorScheme.outline.withOpacity(.16);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
