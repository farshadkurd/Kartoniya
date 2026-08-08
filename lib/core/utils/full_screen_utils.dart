// lib/core/utils/full_screen_utils.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class FullScreenUtils {
  // فعال کردن حالت تمام صفحه (مخفی کردن نوار بالا و پایین)
  static void enableFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [], // یعنی هیچ چیزی نمایش داده نشود (نه ساعت، نه دکمه‌ها)
    );
    
    // اگر بخواهید جهت افقی هم قفل کنید (برای فیلم‌ها خوب است):
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // برای عمودی ماندن (که ما انتخاب کردیم):
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  // برگرداندن سیستم به حالت طبیعی (فقط برای صفحات خاص مثل تنظیمات)
  static void disableFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge, 
      overlays: SystemUiOverlay.values, // نمایش دوباره همه چیز
    );
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}
