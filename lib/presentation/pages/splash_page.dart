// lib/presentation/pages/splash_page.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/full_screen_utils.dart';
import 'home_page.dart';

/// 🌟 صفحه اسپلش کارتونیا
/// با انیمیشن ورودی زیبا و حس Premium
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _bgController;
  late AnimationController _particleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    FullScreenUtils.setLightStatusBar();

    // کنترلر لوگو
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // کنترلر متن
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    // کنترلر پس‌زمینه
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // کنترلر ذرات
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // شروع انیمیشن
    _logoController.forward();

    // رفتن به صفحه اصلی
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.background,
                  AppColors.secondary.withOpacity(0.05),
                ],
                stops: [
                  0.0,
                  0.5 + (math.sin(_bgController.value * math.pi * 2) * 0.1),
                  1.0,
                ],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ذرات شناور
            ...List.generate(12, (index) => _buildParticle(index)),

            // محتوای اصلی
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // لوگو با انیمیشن
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: AppColors.sunsetGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 70,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // نام اپ با انیمیشن
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _textSlide.value),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'کارتونیا',
                          style: TextStyle(
                            fontFamily: GoogleFonts.vazirmatn().fontFamily,
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0, 0, 200, 70),
                              ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '🌟 دنیای شاد کودکان 🌟',
                          style: TextStyle(
                            fontFamily: GoogleFonts.vazirmatn().fontFamily,
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // لودینگ انیمیشن
                  AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final value =
                              (_particleController.value + delay) % 1.0;
                          final scale = 0.5 +
                              (math.sin(value * math.pi) * 0.5);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.3 + (scale * 0.7)),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ذرات شناور تزئینی
  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = 4.0 + random.nextDouble() * 8.0;
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final speed = 0.5 + random.nextDouble() * 1.5;

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent1,
      AppColors.accent2,
      AppColors.accent4,
    ];
    final color = colors[index % colors.length];

    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final y = (startY + _particleController.value * speed) % 1.0;
        final x = startX +
            (math.sin(_particleController.value * math.pi * 2 + index) * 0.02);
        return Positioned(
          left: MediaQuery.of(context).size.width * x,
          top: MediaQuery.of(context).size.height * y,
          child: Opacity(
            opacity: 0.15 + (math.sin(y * math.pi) * 0.15),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
