// lib/presentation/pages/splash_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'home_page.dart'; // بعداً می‌سازیم

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    // رفتن به صفحه اصلی بعد از ۳ ثانیه
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_fill_rounded, size: 80, color: AppTheme.primaryDark),
                SizedBox(height: 10),
                Text("کارتونیا", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: AppTheme.primaryDark))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
