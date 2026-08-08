// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // جهت قفل بودن افقی صفحه
import 'presentation/pages/splash_page.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // قفل کردن صفحه در حالت عمودی (جهت حفظ چیدمان UI)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
// lib/main.dart
// داخل تابع main یا قبل از runApp:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // -- تنظیمات ویژه انتقال --
  await Future.delayed(Duration(milliseconds: 100)); // کوچنترین وقفه برای اعمال سیتم کروم
  
  runApp(const MyApp());
}

// داخل State<MyApp> در متد initState:
@override
void initState() {
  super.initState();
  // بعد از فریم اول، صفحه را کاملاً fullScreen کن
  WidgetsBinding.instance.addPostFrameCallback((_) {
     FullScreenUtils.enableFullScreen();
  });
  
  // گوش دادن به تغییرات Lifecycle اپ (مثلاً اگر کاربر از اپ خارج شد و دوباره برگشت)
  WidgetsBindingObserver? observer;
  // نکته: پیاده‌سازی کامل Lifecycle نیاز به AppLifecycleState دارد، 
  // اما برای سادگی همین متد enableFullScreen کافیست.
}
  runApp(const ProviderScope(child: MyApp())); 
}
// اگر Riverpod را در main.dart ایمپورت کرده‌اید ProviderScope لازم است، 
// اما در مثال قبلی.Provider> را جدا نوشتم. برای سادگی در اینجا بدون ProviderScope گذاشتم اگر کل پروژه Riverpod نیست 
// ولی بهتر است وجود داشته باشد. فرض را بر این می‌گذاریم که شما ProviderScope را اضافه کردید.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'کارتونیا - دنیای شاد کودکان',
      
      // اعمال تم فارسی و رنگ‌بندی منحصر به فرد
      theme: AppTheme.lightTheme,
      
      // صفحه نخست: اسپلش
      home: SplashPage(),
    );
  }
}
