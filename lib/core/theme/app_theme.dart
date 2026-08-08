// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // --- رنگ‌های اصلی برند (Brand Colors) ---
  static const Color primaryLight = Color(0xFFffecd2); // پس‌زمینه ملایم
  static const Color primary = Color(0xFFffc078);      // نارنجی پاستلی
  static const Color primaryDark = Color(0xFFf09819);  // پررنگ برای دکمه‌ها
  static const Color secondary = Color(0xFF4facfe);    // آبی شفاف
  static const Color secondaryDark = Color(0xFF00f2fe);
  
  // --- رنگ‌های خنثی (Neutral) ---
  static const Color background = Color(0xFFfff9f0);    // کرم بسیار کم‌رنگ چشم را خسته نمی‌کند
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF2d3436);
  static const Color textSub = Color(0xFF636e72);
  
  // --- رنگ‌های ویژه (Special) ---
  static const Color goldGlow = Color(0xFFFFD700);
  static const Color success = Color(0xFF00b894);

  // --- تم روشن (Light Theme) ---
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSurface: textMain,
        brightness: Brightness.light,
      ),
      
      // اسکرول بار سفارشی (نه آن آبی تند پیش فرض)
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(primary.withOpacity(0.5)),
        radius: Radius.circular(10),
        thickness: WidgetStateProperty.all(6),
      ),

      // صفحه کلید راست به چپ و رنگ‌بندی شده
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: textMain),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain, 
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.vazirmatn().fontFamily,
        ),
      ),

      // تنظیمات کارت‌ها و لیست‌ها
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: surface,
        margin: EdgeInsets.zero,
      ),

      // --- تایپوگرافی ---
      textTheme: GoogleFonts.vazirmatnTextTheme(base.textTheme).copyWith(
        displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: textMain, height: 1.2),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textMain),
        bodyLarge: TextStyle(fontSize: 16, color: textSub, height: 1.5),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),

      // دکمه‌های گرد و بزرگ (Candy Style Buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryDark,
          minimumSize: Size(double.infinity, 56), // ارتفاع استاندارد لمس
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        prefixIconColor: textSub,
      ),
    );
  }
}
