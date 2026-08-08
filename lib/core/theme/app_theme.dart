import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // پالت رنگی اختصاصی کودکان
  static const Color primaryLight = Color(0xFFffecd2);
  static const Color primary = Color(0xFFffc078);
  static const Color primaryDark = Color(0xFFf09819);
  static const Color secondary = Color(0xFF4facfe);
  static const Color background = Color(0xFFFDF6E3); // رنگ چشم‌نواز
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF2d3436);
  static const Color textSub = Color(0xFF636e72);
  
  // رنگ‌های ویژه صفحه درباره ما
  static const Color goldGlow = Color(0xFFFFD700);
  static const Color amberAccent = Color(0xFFFFAB00);

  // تعریف تم روشن
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textMain,
      ),
      scaffoldBackgroundColor: background,
      
      // تنظیمات اسکرول بار
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(primary.withOpacity(0.5)),
        radius: const Radius.circular(10),
        thickness: WidgetStateProperty.all(6),
      ),
      
      // تنظیمات نوار بالای صفحه
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: textMain),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
        ),
      ),
      
      // شکل کارت‌ها
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: surface,
      ),

      // فونت وزیرمتن برای تمام متن‌ها
      textTheme: GoogleFonts.vazirmatnTextTheme(base.textTheme).copyWith(
        displayLarge: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: textMain, height: 1.2),
        headlineMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textMain),
        bodyLarge: const TextStyle(fontSize: 16, color: textSub, height: 1.5),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),

      // استایل دکمه‌ها
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryDark,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      
      // استایل ورودی متن
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: primary, width: 2)),
        prefixIconColor: textSub,
      ),
    );
  }
}
