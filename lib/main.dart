// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/full_screen_utils.dart';
import 'presentation/pages/splash_page.dart';

/// 🎬 کارتونیا - دنیای شاد کودکان
/// اپلیکیشن تماشای انیمیشن و کارتون مخصوص کودکان
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // قفل کردن صفحه در حالت عمودی
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // تنظیم نوار وضعیت
  FullScreenUtils.setLightStatusBar();

  runApp(const ProviderScope(child: KartoniyaApp()));
}

/// اپلیکیشن اصلی کارتونیا
class KartoniyaApp extends StatelessWidget {
  const KartoniyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'کارتونیا - دنیای شاد کودکان',
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
      // پشتیبانی از RTL
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
