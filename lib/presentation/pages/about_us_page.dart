import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// صفحهٔ رسمی Parsa Apps با هالهٔ طلایی سبک و بدون asset سنگین.
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _openTelegram() async {
    const uri = 'https://t.me/Parsaappsadmin';
    final opened = await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('باز کردن تلگرام ممکن نشد.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دربارهٔ ما')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 34),
              child: Column(
                children: [
                  _GoldenGlowFrame(
                    animation: _glowController,
                    circular: true,
                    child: Container(
                      width: 146,
                      height: 146,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.goldDark,
                            size: 38,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Parsa',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primaryDark,
                                ),
                          ),
                          Text(
                            'APPS',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: context.secondaryTextColor,
                                  letterSpacing: 2,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('گروه برنامه‌نویسی Parsa Apps', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _GoldenGlowFrame(
                    animation: _glowController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                      child: Text(
                        'فرشاد پارسا',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.goldDark,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'سازندهٔ کارتونیا',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.secondaryTextColor,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _openTelegram();
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFF229ED9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send_rounded, color: Colors.white),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('پشتیبانی تلگرام', style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 3),
                                  const Text('@Parsaappsadmin'),
                                ],
                              ),
                            ),
                            Icon(Icons.open_in_new_rounded, color: context.secondaryTextColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      boxShadow: AppTheme.softShadow(context),
                    ),
                    child: Column(
                      children: [
                        const Text('🎬', style: TextStyle(fontSize: 42)),
                        const SizedBox(height: 10),
                        Text('دربارهٔ کارتونیا', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'کارتونیا محیطی گرم، ساده و مناسب خانواده برای پیدا کردن و تماشای محتوای کودک است. تنظیمات و فهرست علاقه‌مندی‌ها به‌صورت محلی روی دستگاه نگه‌داری می‌شوند.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: context.secondaryTextColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'نسخهٔ ۱.۱.۰',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.secondaryTextColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldenGlowFrame extends StatelessWidget {
  const _GoldenGlowFrame({
    required this.animation,
    required this.child,
    this.circular = false,
  });

  final Animation<double> animation;
  final Widget child;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final value = Curves.easeInOut.transform(animation.value);
        final radius = circular ? 999.0 : AppTheme.radiusLarge;
        return Transform.scale(
          scale: 1 + (value * .018),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: SweepGradient(
                transform: GradientRotation(value * 6.28),
                colors: const [
                  AppColors.goldDark,
                  AppColors.gold,
                  Colors.white,
                  AppColors.goldDark,
                ],
              ),
              shape: circular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: circular ? null : BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(.22 + (value * .30)),
                  blurRadius: 18 + (value * 15),
                  spreadRadius: 1 + (value * 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
