import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cartoons_provider.dart';
import 'home_page.dart';
import 'onboarding_page.dart';

/// اسپلش سبک برنامه؛ فقط تصمیم مسیر اولیه را می‌گیرد و دادهٔ شبکه‌ای دریافت
/// نمی‌کند تا زمان شروع اپ کوتاه بماند.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    )..forward();
    unawaited(_openNextPage());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openNextPage() async {
    await Future<void>.delayed(const Duration(milliseconds: 1650));
    if (!mounted) return;
    final completedOnboarding = ref.read(onboardingProvider);
    final destination = completedOnboarding
        ? const HomePage()
        : const OnboardingPage();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => destination,
        transitionDuration: const Duration(milliseconds: 420),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(.15),
              context.pageBackground,
              AppColors.secondary.withOpacity(.10),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(top: 84, right: -42, child: _SplashBubble(size: 150)),
            const Positioned(bottom: 110, left: -50, child: _SplashBubble(size: 180)),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final value = Curves.easeOutBack.transform(_controller.value);
                  return Opacity(
                    opacity: _controller.value.clamp(0.0, 1.0).toDouble(),
                    child: Transform.scale(scale: value, child: child),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 126,
                      height: 126,
                      decoration: BoxDecoration(
                        gradient: AppColors.sunsetGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.32),
                            blurRadius: 34,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 68,
                        semanticLabel: 'لوگوی کارتونیا',
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'کارتونیا',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.primaryDark,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'دنیای شاد و امن کودکان',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: context.secondaryTextColor,
                          ),
                    ),
                    const SizedBox(height: 42),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBubble extends StatelessWidget {
  const _SplashBubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.10),
        shape: BoxShape.circle,
      ),
    );
  }
}
