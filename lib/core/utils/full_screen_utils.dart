// lib/core/utils/full_screen_utils.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// 🔧 ابزارهای تمام‌صفحه و مدیریت System UI
class FullScreenUtils {
  FullScreenUtils._();

  /// فعال کردن حالت تمام‌صفحه (Immersive Sticky)
  /// مناسب برای صفحه پخش ویدیو
  static void enableFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  /// غیرفعال کردن حالت تمام‌صفحه
  /// بازگرداندن نوار وضعیت و ناوبری
  static void disableFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  /// تنظیم نوار وضعیت شفاف با آیکون‌های تیره
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// تنظیم نوار وضعیت شفاف با آیکون‌های روشن
  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
}
