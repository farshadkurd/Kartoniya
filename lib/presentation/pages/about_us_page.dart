// lib/presentation/pages/about_us_page.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// ℹ️ صفحه درباره ما با افکت طلایی
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _rotateController;
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();

    // افکت پالس طلایی (Breathing)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // چرخش حلقه درخشان
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // انیمیشن ورودی
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _rotateController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // دکمه بازگشت
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // لوگو با افکت طلایی
                _buildGoldenLogo(),

                const SizedBox(height: 40),

                // نام سازنده با گرادیان
                _buildAnimatedEntry(
                  delay: 0.3,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFDAA520),
                        AppColors.goldGlow,
                        Color(0xFFDAA520),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'فرشاد پارسا',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                _buildAnimatedEntry(
                  delay: 0.4,
                  child: Text(
                    'توسعه‌دهنده ارشد',
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // کارت‌های تماس
                _buildAnimatedEntry(
                  delay: 0.5,
                  child: _buildContactTile(
                    icon: Icons.send_rounded,
                    iconBgColor: const Color(0xFF0088CC),
                    title: 'پشتیبانی تلگرام',
                    subtitle: '@Parsaappsadmin',
                    onTap: () async {
                      final uri = Uri.parse('https://t.me/Parsaappsadmin');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),

                _buildAnimatedEntry(
                  delay: 0.6,
                  child: _buildContactTile(
                    icon: Icons.language_rounded,
                    iconBgColor: AppColors.accent2,
                    title: 'وب‌سایت',
                    subtitle: 'www.parsa-apps.com',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 16),

                _buildAnimatedEntry(
                  delay: 0.7,
                  child: _buildContactTile(
                    icon: Icons.email_rounded,
                    iconBgColor: AppColors.accent5,
                    title: 'ایمیل',
                    subtitle: 'support@parsa-apps.com',
                    onTap: () {},
                  ),
                ),

                const SizedBox(height: 40),

                // درباره اپ
                _buildAnimatedEntry(
                  delay: 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusLarge,
                      ),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Column(
                      children: [
                        const Text('🎬', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(
                          'درباره کارتونیا',
                          style: TextStyle(
                            fontFamily: GoogleFonts.vazirmatn().fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'کارتونیا یه اپلیکیشن تماشای انیمیشن و کارتون مخصوص بچه‌هاست که با عشق و مراقبت ساخته شده. هدف ما ایجاد یه محیط امن و شاد برای کوچولوهاست.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: GoogleFonts.vazirmatn().fontFamily,
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // نسخه
                _buildAnimatedEntry(
                  delay: 0.9,
                  child: Text(
                    'نسخه ۱.۰.۰',
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// لوگو با افکت طلایی متحرک
  Widget _buildGoldenLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _rotateController]),
      builder: (context, child) {
        final glowValue = _glowController.value;
        final rotateValue = _rotateController.value;

        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              // هاله طلایی بزرگ
              BoxShadow(
                color: AppColors.goldGlow.withOpacity(0.2 + (glowValue * 0.2)),
                blurRadius: 40 + (20 * glowValue),
                spreadRadius: 8 + (5 * glowValue),
              ),
              // هاله کوچک‌تر
              BoxShadow(
                color: AppColors.amberAccent.withOpacity(0.3 + (glowValue * 0.2)),
                blurRadius: 20,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // حلقه درخشان چرخان
              CustomPaint(
                size: const Size(170, 170),
                painter: GoldenRingPainter(
                  rotationValue: rotateValue,
                  glowValue: glowValue,
                ),
              ),

              // محتوای مرکزی
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 44,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Parsa',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Apps',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// انیمیشن ورودی
  Widget _buildAnimatedEntry({
    required double delay,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: (800 + (delay * 500)).round()),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// کارت تماس
  Widget _buildContactTile({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: AppColors.textHint.withOpacity(0.1),
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

/// 🎨 نقاش حلقه طلایی چرخان
class GoldenRingPainter extends CustomPainter {
  final double rotationValue;
  final double glowValue;

  GoldenRingPainter({
    required this.rotationValue,
    required this.glowValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // حلقه درخشان چرخان
    final paint = Paint()
      ..strokeWidth = 3 + (glowValue * 2)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2 + (rotationValue * 2 * math.pi),
        endAngle: 3 * math.pi / 2 + (rotationValue * 2 * math.pi),
        colors: [
          Colors.transparent,
          AppColors.goldGlow.withOpacity(0.8),
          Colors.transparent,
          AppColors.amberAccent.withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        tileMode: TileMode.repeated,
      ).createShader(rect);

    canvas.drawCircle(center, radius, paint);

    // نقاط درخشان کوچک
    final dotPaint = Paint()
      ..color = AppColors.goldGlow.withOpacity(0.6 + (glowValue * 0.4))
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) + (rotationValue * 2 * math.pi);
      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(dotCenter, 2 + glowValue, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GoldenRingPainter oldDelegate) => true;
}
